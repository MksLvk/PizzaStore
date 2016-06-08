public class CalculateOrderItemCostTriggerHandler {
    public static void process(List<Pizza_Order_Item__c> records) {
        for(Pizza_Order_Item__c item : records)
        {
            Pizza__c pizza = [SELECT Id, Cost__c FROM Pizza__c WHERE Id = :item.Pizza__c];
            Pizza_Base__c pizzaBase = [SELECT Id, Cost__c FROM Pizza_Base__c WHERE Id = :item.Pizza_Base__c];
            item.Cost__c = 0;
            item.Cost__c += pizza.Cost__c;
            item.Cost__c += pizzaBase.Cost__c;
            item.Cost__c *= item.Count__c;
        }
    }
}