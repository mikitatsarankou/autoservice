trigger ContentDistributionTrigger on ContentDistribution (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new ContentDistributionTriggerHandler().run();
}