trigger updPrice on Media_Product__c (after update)
{
    updPriceTriggerHandler.process(Trigger.new,Trigger.oldMap);
}