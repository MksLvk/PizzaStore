public class UpdateIngredientCostTriggerHandler {
    public static void process(List<Pizza_Ingredient__c> records,Map<Id,Pizza_Ingredient__c> oldMap) {
        for(Pizza_Ingredient__c item : records)
        {
            List<Pizza_Ingredient_Item__c> temp = [SELECT Id, Pizza__c FROM Pizza_Ingredient_Item__c WHERE Pizza_Ingredient__c = :item.Id];
            for(Pizza_Ingredient_Item__c ingItem : temp)
            {
                Pizza__c pizza = [SELECT Id,Cost__c FROM Pizza__c WHERE Id = :ingItem.Pizza__c];
                pizza.Cost__c -= oldMap.get(item.Id).Cost__c;
                pizza.Cost__c += item.Cost__c;
                update pizza;
            }
        }
    }
}