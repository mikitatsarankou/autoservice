public class Utils {

    public static List<ID> getFieldIds(List<SObject> objects, String fieldName) {
        Set<ID> result = new Set<ID>();
        for (SObject obj : objects) {
            result.add((ID) obj.get(fieldName));
        }
        return new List<ID>(result);
    }

    public static Map<ID, SObject> mapByIdField(List<SObject> objects, String fieldName) {
        Map<ID, SObject> result = new Map<ID, SObject>();
        for (SObject obj : objects) {
            result.put((ID) obj.get(fieldName), obj);
        }
        return result;
    }

    public static Map<String, SObject> mapByStringField(List<SObject> objects, String fieldName) {
        Map<String, SObject> result = new Map<String, SObject>();
        for (SObject obj : objects) {
            result.put((String) obj.get(fieldName), obj);
        }
        return result;
    }

    public static Datetime formDatetimeFromStringGTM(String dateToForm) {
        if (!String.isBlank(dateToForm)) {
            String correctDate = dateToForm.replace('T', ' ').substringBefore('.');
            return Datetime.valueOf(correctDate).addHours(6);
        }
        return null;
    }

    public static List<SObject> mergeListsIntoOne(List<SObject> firstList, List<SObject> secondList) {
        Map<Id, SObject> sObjectByRecordId = new Map<Id, SObject>();
        for (SObject sObj : firstList) {
            sObjectByRecordId.put((Id)sObj.get('Id'), sObj);
        }

        for (SObject sObj : secondList) {
            Id sObjId = (Id) sObj.get('Id');
            if (!sObjectByRecordId.containsKey(sObjId)) {
                sObjectByRecordId.put(sObjId, sObj);
            } else {
                SObject sObjToFill = sObjectByRecordId.get(sObjId);
                for (String fieldName : sObj.getPopulatedFieldsAsMap().keySet()) {
                    if (sObjToFill.getPopulatedFieldsAsMap().get(fieldName) == null) {
                        sObjToFill.put(fieldName, sObj.getPopulatedFieldsAsMap().get(fieldName));
                    }
                }
                sObjectByRecordId.put(sObjId, sObjToFill);
            }
        }
        if (!sObjectByRecordId.values().isEmpty()) {
            return sObjectByRecordId.values();
        }
        return new List<SObject>();
    }
}