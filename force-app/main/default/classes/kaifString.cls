public inherited sharing class kaifString {

    public static final String EMPTY = '';
    public static final String DASH = '-';
    public static final String COMMA = ',';
    public static final String SPACE = ' ';
    public static final String KEY_SEPARATOR = ':';
    public static final List<String> CHARS = new List<String> {
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
        'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
        'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D',
        'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
        'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
        'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7',
        '8', '9'
    };

    private static Integer fakeIdCount = 0;

    // generate random string of specified length based on CHARS array
    public static String getRandomString (Integer length) {

        if(length != null) {

        

        String res = '';
        Integer multiplier = CHARS.size() - 1;
        for (Integer i = 0; i < length; i++) {
            res += CHARS[Math.round(Math.random() * multiplier)];
        }

        return res;
    }
    return null;
    }

    //Use instead of String.left() if value might be null.
    public static String left(String value, Integer length) {
        if (value == null)
            return null;
        else
            return value.left(length);
    }

    //Get useful string value for object
    public static String valueOf(object value) {

        if (value == null || value instanceof String) {
            return (String)value;
        } else if (value instanceof Date) {
            return ((Date)value).format();
        } else if (value instanceof DateTime) {
            return ((DateTime)value).format();
        } else if (value instanceof SObjectType) {
            return ((SObjectType)value).getDescribe().getLabel();
        } else if (value instanceof SObjectField) {
            return ((SObjectField)value).getDescribe().getLabel();
        }

        return String.valueOf(value);
    }

    //Format supporting object arguments instead of just strings.
    public static String formatObjects(String stringToFormat, List<object> formattingArguments) {

        List<String> stringArguments = new List<String>();
        for (object formattingArgument : formattingArguments) {
            stringArguments.add(valueOf(formattingArgument));
        }

        return String.format(stringToFormat, stringArguments);
    }

    //Convenience with variable number of parameters
    public static String format(String stringToFormat, object arg1) {
        return formatObjects(stringToFormat, new List<object>{arg1});
    }
    public static String format(String stringToFormat, object arg1, object arg2) {
        return formatObjects(stringToFormat, new List<object>{arg1, arg2});
    }
    public static String format(String stringToFormat, object arg1, object arg2, object arg3) {
        return formatObjects(stringToFormat, new List<object>{arg1, arg2, arg3});
    }
    public static String format(String stringToFormat, object arg1, object arg2, object arg3, object arg4) {
        return formatObjects(stringToFormat, new List<object>{arg1, arg2, arg3, arg4});
    }
    public static String format(String stringToFormat, object arg1, object arg2, object arg3, object arg4, object arg5) {
        return formatObjects(stringToFormat, new List<object>{arg1, arg2, arg3, arg4, arg5});
    }

    //Outputs all values in set
    public static String formatSet(Set<object> objectSet) {
        return formatList(new List<object>(objectSet));
    }

    //Outputs all values in list
    public static String formatList(List<object> objectList) {

        String result = '';

        for (object value : objectList) {

            if (result != '') {
                result += ', ';
            }
            result += valueOf(value);
        }

        return result;
    }

    //Outputs all string values in set
    public static String formatSet(Set<String> stringSet) {
        return formatList(new List<String>(stringSet));
    }

    //Outputs all string values in list
    public static String formatList(List<String> stringList) {
        return String.join(stringList, ', ');
    }

    //Converts string value to ID or throws error if it's not an ID

    /**
    * Generate a fake Salesforce Id
    * @param sobjectType Given sobject type for fake id
    * @return fake id
    */
    public static Id generateFakeSalesforceId(Schema.SObjectType sobjectType)
    {
        Integer idLength = 15;
        String keyPrefix = sobjectType.getDescribe().getKeyPrefix();

        Integer fakeIdCountLength = String.valueOf(fakeIdCount).length();
        String fakeId = keyPrefix.rightPad(idLength - fakeIdCountLength, '0') + String.valueOf(fakeIdCount);
        fakeIdCount++;

        return Id.valueOf(fakeId);
    }
}