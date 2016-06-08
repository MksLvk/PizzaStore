trigger UpdateIngredientCost on Pizza_Ingredient__c (after update) {

    UpdateIngredientCostTriggerHandler.process(Trigger.new, Trigger.oldMap);

}