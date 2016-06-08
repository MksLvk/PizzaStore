@isTest
private class PizzaControllerTest {

	@isTest static void test_method_one() {
		PizzaController controller = new PizzaController();
        
        Contact customer = new Contact(
			FirstName = 'Test',
			LastName = 'Test'
		);
		insert customer;
	
		Pizza_Base__c item1 = new Pizza_Base__c(
			Name = 'base1'
		);
		insert item1;
		
		Pizza_Base__c item2 = new Pizza_Base__c(
			Name = 'base2'
		);
		insert item2;
        
        List<SelectOption> baseOptions = new List<SelectOption>();
        baseOptions.add(new SelectOption(item1.Id, item1.Name));
        baseOptions.add(new SelectOption(item2.Id, item2.Name));
        
		Test.startTest();
        System.assertEquals(controller.getBaseOptions(), baseOptions);
        Test.stopTest();
	}
    @isTest static void test_method_two() {
        
		PizzaController controller = new PizzaController();
        
        List<SelectOption> aOptions = new List<SelectOption>();
        aOptions.add(new SelectOption('1','1'));
        aOptions.add(new SelectOption('2','2'));
        aOptions.add(new SelectOption('3','3'));
        aOptions.add(new SelectOption('4','4'));
        aOptions.add(new SelectOption('5','5'));
		
		Test.startTest();
        System.assertEquals(controller.getAmountOptions(), aOptions);
		Test.stopTest();

	}
	@isTest static void test_method_three() {
	    
	    Contact customer = new Contact(
			FirstName = 'Test',
			LastName = 'Test'
		);
		insert customer;
	
		PizzaController controller = new PizzaController();
        
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
		update testOrder;
		
		List<PizzaWrapper> pw = new List<PizzaWrapper>();
		pw.add(new PizzaWrapper(pizza));
		pw.add(new PizzaWrapper(pizza2));
		pw[0].base = base.Id;
		pw[1].base = base.Id;
		pw[0].isChecked = true;
		pw[1].isChecked = true;
		pw[0].amount = '1';
		pw[1].amount = '1';
		controller.pizzaWrapperList = pw;
		controller.currentContactId = customer.Id;
		controller.addToOrder();
		
		Pizza_Order__c temp = [SELECT Id,  Customer__c, Cost__c FROM Pizza_Order__c ORDER BY CreatedDate desc limit 1];
		System.assert(temp.Customer__c == testOrder.Customer__c);
        System.assert(temp.Cost__c == 17);
		
		Test.stopTest();
}
    @isTest static void test_method_four() {
	    
	    Contact customer = new Contact(
			FirstName = 'Test',
			LastName = 'Test'
		);
		insert customer;
		
		PizzaController controller = new PizzaController();
        
      
        Pizza__c pizza = new Pizza__c(
			Name = 'pizza',
			Customer__c = customer.Id,
			Is_Custom__c = true
			
		);
		insert pizza;
		
		Pizza_Ingredient__c ingr = new Pizza_Ingredient__c(
            Cost__c = 5,
			Name = 'Test ing1'
		);
		insert ingr;
		
		Pizza_Ingredient_Item__c ingrItem = new Pizza_Ingredient_Item__c(
            Pizza_Ingredient__c = ingr.Id,
            Pizza__c = pizza.Id
		);
		insert ingrItem;
        
        Pizza_Ingredient_Item__c ingrItem2 = new Pizza_Ingredient_Item__c(
            Pizza_Ingredient__c = ingr.Id,
            Pizza__c = pizza.Id
		);
		insert ingrItem2;
        
		Test.startTest();

		List<PizzaIngredientWrapper> pw = new List<PizzaIngredientWrapper>();
		pw.add(new PizzaIngredientWrapper(ingr));
		pw.add(new PizzaIngredientWrapper(ingr));
		pw[0].isChecked = true;
		pw[1].isChecked = true;

		controller.pizzaIngredientWrapperList = pw;
		controller.currentContactId = customer.Id;
		controller.addCustomPizza();
		controller.customPizzaName = 'pizza';
		
		Pizza__c temp = [SELECT Id, Customer__c, Cost__c, Is_Custom__c FROM Pizza__c ORDER BY CreatedDate desc limit 1];
		System.assert(temp.Customer__c == customer.Id);
        System.assert(temp.Cost__c == 10);
		System.assert(temp.Is_Custom__c == true);

		Test.stopTest();
    }
}