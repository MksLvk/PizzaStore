trigger CalculateOrderItemCost on Pizza_Order_Item__c (before insert) {

    CalculateOrderItemCostTriggerHandler.process(Trigger.new);

}