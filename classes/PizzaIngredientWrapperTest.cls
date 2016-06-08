@isTest
private class PizzaIngredientWrapperTest {

	@isTest static void test_method_one() {


		Pizza_Ingredient__c ingr = new Pizza_Ingredient__c(
            Cost__c = 5,
			Name = 'Test ing1'
		);
		insert ingr;
		
		
        
		Test.startTest();
        
        PizzaIngredientWrapper wrapper = new PizzaIngredientWrapper(ingr);
        PizzaIngredientWrapper wrapperNull = new PizzaIngredientWrapper();

        System.assert(false == wrapper.isChecked);
        System.assert(ingr.Id == wrapper.detailId);
        System.assert('Test ing1' == wrapper.name);
        System.assertNotEquals(wrapper,null);
        System.assert(wrapperNull.name == null);
		Test.stopTest();
	}

}