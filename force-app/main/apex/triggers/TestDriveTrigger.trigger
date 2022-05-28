trigger TestDriveTrigger on Test_Drive__c (before insert, before update, before delete, after insert, after update, after delete) {
    new TestDriveTriggerHandler().run();
}