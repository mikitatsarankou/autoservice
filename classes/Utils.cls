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

    public static Datetime formDatetimeFromStringGTM3(String dateToForm) {
        if (!String.isBlank(dateToForm)) {
            String correctDate = dateToForm.replace('T', ' ').substringBefore('.');
            return Datetime.valueOf(correctDate).addHours(6);
        }
        return null;
    }
}