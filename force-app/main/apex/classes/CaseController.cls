public class CaseController {

    @AuraEnabled
    public static List<Case> getCases() {
        return [SELECT Id, CaseNumber FROM Case LIMIT 5];
    }
}