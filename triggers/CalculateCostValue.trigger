trigger CalculateCostValue on Media_Bucket_Item__c (after insert, after update) {

	CalculateCostValueTriggerHandler.process(Trigger.new, Trigger.oldMap, Trigger.isInsert);

}