public inherited sharing class KaifSoql {

    private static final String SECURITY_ENFORCED = 'WITH SECURITY_ENFORCED';

    private String sObjectTypeName;
    private Set<String> columns = new Set<String>();
    private String whereClause;
    private List<KaifSoql> subSelects;
    private Integer rowLimit;
    private List<String> orderBy;
    private boolean securityEnforced = true;
    
    private List<String> groupBy;

    public KaifSoql(SObjectType objType) {
        this.sObjectTypeName = objType.getDescribe().getName();
    }

    public KaifSoql(String objTypeName) {
        this.sObjectTypeName = objTypeName;
    }

    /**
     *  @param  lookupField a lookup SObjectField
     *
     *  Constructor for sub-select queries 
     *
    **/
    public KaifSoql(SObjectField lookupField) {
        if(lookupField != null) {
        String fieldName = lookupField.getDescribe().getName();
        List<SObjectType> sobjects = lookupField.getDescribe().getReferenceTo();
        String myObjectTypeName;
        if (!sobjects.isEmpty()) {
            SObjectType obj = sobjects[0];
            List<ChildRelationship> relations = obj.getDescribe().getChildRelationships();
            for (ChildRelationship cr : relations) {
                if (cr.getField().getDescribe().getName() == fieldName) {
                    myObjectTypeName = cr.getRelationshipName();
                    break;
                }
            }
        }
        this.sObjectTypeName = myObjectTypeName;
        }
        
    }

    public KaifSoql(KaifSoql soql) {
        this.sObjectTypeName = soql.sObjectTypeName;
        this.columns = soql.columns;
        this.whereClause = soql.whereClause;
        this.subSelects = soql.subSelects;
        this.rowLimit = soql.rowLimit;
        this.orderBy = soql.orderBy;
        this.securityEnforced = soql.securityEnforced;
    }

    public KaifSoql withColumns(List<String> cols) {
        this.columns.addAll(cols);
        return this;
    }

    public KaifSoql withGroupBy(List<String> gb) {
        this.groupBy = gb;
        this.columns.addAll(gb);
        return this;
    }

    public KaifSoql withWhere(String wc) {
        this.whereClause = wc;
        return this;
    }

    public KaifSoql withSubSelects(List<KaifSoql> ss) {
        this.subSelects = ss;
        return this;
    }

    public KaifSoql withRowLimit(Integer rl) {
        this.rowLimit = rl;
        return this;
    }

    public KaifSoql withOrderBy(List<String> ob) {
        this.orderBy = ob;
        return this;
    }

    public KaifSoql withoutSecurityEnforced() {
        this.securityEnforced = false;
        return this;
    }

    public String getQueryString() {

        List<String> columnsList = new List<String>(this.columns);
        if (!columnsList.isEmpty() && this.sObjectTypeName != null) {
            String soql = 'SELECT ' + String.join(columnsList, ',');

        // Any subselects
        if (this.subSelects != null) {
            for (KaifSoql subSelect : this.subSelects) {
                KaifSoql subSelectClone = new KaifSoql(subSelect);
                subSelectClone.withoutSecurityEnforced();
                soql += ', (' + subSelectClone.getQueryString() + ')';
            }
        }

        soql += ' FROM ' + this.sObjectTypeName;

        if (!String.isBlank(this.whereClause)) {
            soql += kaifString.format(' WHERE {0} ', this.whereClause);
        }

        if (this.securityEnforced) {
            soql += kaifString.format(' {0} ', SECURITY_ENFORCED);
        }

        if (this.orderBy != null && !this.orderBy.isEmpty()) {
            soql += kaifString.format(' ORDER BY {0} ', String.join(this.orderBy, ','));
        }

        if (this.rowLimit >= 0) {
            soql += kaifString.format(' LIMIT {0} ', rowLimit);
        }

        return soql;
        }
        return null;

    }

    public Integer countQuery() {
        String query = new KaifSoql(this)
            .withColumns(new List<String>{ 'COUNT()' })
            .getQueryString();

        return Database.countQuery(query);
    }

    public static String getBaseSoql(SObjectType objectType, Set<String> columns) {
		return getBaseSoql(objectType, new List<String>(columns), null);
    }

    public static String getBaseSoql(SObjectType objectType, List<String> columns, List<KaifSoql> subSelects) {

        return new KaifSoql(objectType)
            .withColumns(columns)
            .withSubSelects(subSelects)
            .getQueryString();
    }

}