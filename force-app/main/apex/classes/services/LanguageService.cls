public class LanguageService {
    private static final String defaultLanguage = 'ru';
    private static final String foreignLanguage = 'en_US';

    @AuraEnabled
    public static User getCurrentUser() {
        List<User> currentUsers = [SELECT Id, LocaleSidKey, LanguageLocaleKey FROM User where Id = :UserInfo.getUserId()];
        if (!currentUsers.isEmpty()) {
            return currentUsers[0];
        }
        return null;
    }

    @AuraEnabled
    public static Boolean isForeignLanguage() {
        User user = getCurrentUser();
        if (user != null) {
            if (user.LanguageLocaleKey == foreignLanguage) {
                return true;
            }
        }
        return false;
    }

    @AuraEnabled
    public static Boolean changeLanguage() {
        Boolean result = false;
        User user = getCurrentUser();
        if (user != null) {
            if (user.LanguageLocaleKey == defaultLanguage) {
                user.LanguageLocaleKey = foreignLanguage;
                update user;
                result = true;
            } else {
                user.LanguageLocaleKey = defaultLanguage;
                update user;
                result = true;
            }
        }
        return result;
    }
}