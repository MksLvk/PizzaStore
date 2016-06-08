trigger UpdatePizzaCost on Pizza_Ingredient_Item__c (after insert, after delete) {

  UpdatePizzaCostTriggerHandler.process(Trigger.new,Trigger.old,Trigger.isDelete);

}