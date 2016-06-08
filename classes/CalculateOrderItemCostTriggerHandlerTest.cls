@isTest
private class CalculateOrderItemCostTriggerHandlerTest {

	@isTest static void test_method_one() {
		Contact customer = new Contact(
			FirstName = 'Test',
			LastName = 'Test'
		);
		insert customer;

		Pizza__c pizza = new Pizza__c(
			Cost__c = 5,
			Name = 'Test pizza'
		);
		insert pizza;
		
		Pizza__c pizza2 = new Pizza__c(
			Cost__c = 10,
			Name = 'Test pizza2'
		);
		insert pizza2;

		Pizza_Base__c base = new Pizza_Base__c(
			Cost__c = 1,
			Name = 'Test base'
		);
		insert base;

		Pizza_Order__c testOrder = new Pizza_Order__c(
			Customer__c = customer.Id
		);
		insert testOrder;
        
        
		Test.startTest();

		Pizza_Order_Item__c orderItem1 = new Pizza_Order_Item__c(
			Pizza__c = pizza.Id,
			Pizza_Base__c = base.Id,
			Pizza_Order__c = testOrder.Id,
			Count__c = 1
		);
		insert orderItem1;
		
		Pizza_Order_Item__c orderItem2 = new Pizza_Order_Item__c(
			Pizza__c = pizza2.Id,
			Pizza_Base__c = base.Id,
			Pizza_Order__c = testOrder.Id,
			Count__c = 1
		);
		insert orderItem2;
		Pizza_Order__c temp = [SELECT Id,  Cost__c FROM Pizza_Order__c WHERE Id = :testOrder.Id];
		System.assert(temp.Cost__c == 17);

		

		Test.stopTest();
	}

}