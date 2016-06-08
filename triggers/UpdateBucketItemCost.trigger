trigger UpdateBucketItemCost on Media_Product__c (after update) {

	UpdateBucketItemCostTriggerHandler.process(Trigger.new, Trigger.oldMap);

}