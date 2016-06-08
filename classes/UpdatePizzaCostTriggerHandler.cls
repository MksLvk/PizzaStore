public class UpdatePizzaCostTriggerHandler {
    public static void process(List<Pizza_Ingredient_Item__c> records, List<Pizza_Ingredient_Item__c> old, Boolean isDelete) {
        if(isDelete)
        {
            for(Pizza_Ingredient_Item__c item : old)
            {
                Pizza__c temp = [SELECT Id,Cost__c FROM Pizza__c WHERE Id = :item.Pizza__c];
                Pizza_Ingredient__c ing = [SELECT Id,Cost__c FROM Pizza_Ingredient__c WHERE Id = :item.Pizza_Ingredient__c];
                temp.Cost__c -= ing.Cost__c;
                update temp;
            }
        }
        else
        {
            for(Pizza_Ingredient_Item__c item : records)
            {
                Pizza__c temp = [SELECT Id,Cost__c FROM Pizza__c WHERE Id = :item.Pizza__c];
                Pizza_Ingredient__c ing = [SELECT Id,Cost__c FROM Pizza_Ingredient__c WHERE Id = :item.Pizza_Ingredient__c];
                if(temp.Cost__c == null) temp.Cost__c = 0;
                temp.Cost__c += ing.Cost__c;
                update temp;
            }
        }
    }
}