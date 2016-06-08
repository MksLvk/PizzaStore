@isTest
private class PizzaWrapperTest {

	@isTest static void test_method_one() {
		Contact customer = new Contact(
			FirstName = 'Test',
			LastName = 'Test'
		);
		insert customer;

		Pizza_Ingredient__c ingr1 = new Pizza_Ingredient__c(
            Cost__c = 5,
			Name = 'Test ing1'
		);
		insert ingr1;
		
		Pizza_Ingredient__c ingr2 = new Pizza_Ingredient__c(
            Cost__c = 10,
			Name = 'Test ing2'
		);
		insert ingr2;

        Pizza__c pizza = new Pizza__c(
			Name = 'Test pizza'
		);
		insert pizza;
		
		Pizza_Ingredient_Item__c item1 = new Pizza_Ingredient_Item__c(
			Pizza_Ingredient__c = ingr1.Id,
			Pizza__c = pizza.Id
		);
		insert item1;
		
		Pizza_Ingredient_Item__c item2 = new Pizza_Ingredient_Item__c(
			Pizza_Ingredient__c = ingr2.Id,
			Pizza__c = pizza.Id
		);
		insert item2;
        
        
		Test.startTest();
        
        PizzaWrapper wrapper = new PizzaWrapper(pizza);
		System.assert(pizza.Cost__c == wrapper.cost);
        System.assert(pizza.Is_Custom__c == wrapper.isCustom);
        System.assert(pizza.Id == wrapper.detailId);
        System.assert('Test ing1 Test ing2 ' == wrapper.ingredients);
        System.assertNotEquals(wrapper,null);
		Test.stopTest();
	}

}