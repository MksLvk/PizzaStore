public with sharing class PizzaController {
    
    public Id currentContactId { get; set; }
    public List<PizzaWrapper> pizzaWrapperList { get; set; }
    public List<PizzaIngredientWrapper> pizzaIngredientWrapperList { get; set; }
    public String customPizzaName { get; set; }
    
    public List<SelectOption> getBaseOptions(){
        
        List<SelectOption> baseOptions = new List<SelectOption>();
        List<Pizza_Base__c> baseItems = [SELECT Id, Name, Cost__c FROM Pizza_Base__c];
        for(Pizza_Base__c base : baseItems)
        {
            baseOptions.add(new SelectOption(base.Id, base.Name));
        }
        return baseOptions;
    }
    
    public List<SelectOption> getAmountOptions(){
        
        List<SelectOption> amountOptions = new List<SelectOption>();
        for(Integer i = 1; i < 6; i++)
        {
            amountOptions.add(new SelectOption(string.valueof(i), string.valueof(i)));
        }
        return amountOptions;
    }
    
    public PizzaController() {
        
        User currentUser = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        currentContactId = currentUser.ContactId;
        
        pizzaIngredientWrapperList = new List<PizzaIngredientWrapper>();
        List<Pizza_Ingredient__c> pizzaIngredientItems = [SELECT Id, Name FROM Pizza_Ingredient__c];
        for(Pizza_Ingredient__c item : pizzaIngredientItems)
        {
            pizzaIngredientWrapperList.add( new pizzaIngredientWrapper(item));
        }
        retrievePizzaData();
        
        
        
    }
    
    public void addToOrder(){
        
        List<Pizza_Order_Item__c> temp = new List<Pizza_Order_Item__c>();
        for(PizzaWrapper pizza : pizzaWrapperList)
        {
            if(pizza.isChecked)
            {
                temp.add( new Pizza_Order_Item__c(
                    Pizza_Base__c = pizza.base,
                    Pizza__c = pizza.detailId,
                    Pizza_Order__c = null,
                    Count__c = Integer.valueOf(pizza.amount)
                ));
            }
        }
        if(!temp.isEmpty())
        {
            Pizza_Order__c newOrder = new Pizza_Order__c(
                Customer__c = currentContactId
                );
            insert newOrder;
            for(Pizza_Order_Item__c item : temp)
            {
                item.Pizza_Order__c = newOrder.Id;
            }
            insert temp;
            sendReport(newOrder);
            
        }
        
    }
    
    public void retrievePizzaData() {
		
	    pizzaWrapperList = new List<PizzaWrapper>();
        List <Pizza__c> pizzaItems = [SELECT Id, Name, Cost__c, Customer__c FROM Pizza__c WHERE Pizza__c.Customer__c = :currentContactId OR Pizza__c.Is_Custom__c = false ];
        for(Pizza__c pizza : pizzaItems)
        {
            pizzaWrapperList.add( new PizzaWrapper(pizza));
        }
		
	}
    
    public void addCustomPizza(){
        
        List<Pizza_Ingredient_Item__c> ingrList = new List<Pizza_Ingredient_Item__c>();
        for(PizzaIngredientWrapper ingr : pizzaIngredientWrapperList)
        {
            if(ingr.isChecked)
            {
                Pizza_Ingredient_Item__c temp = new Pizza_Ingredient_Item__c(
                    Pizza_Ingredient__c = ingr.detailId
                );
                ingrList.add(temp);
            }
            
        }
        if(!ingrList.isEmpty())
        {
            Pizza__c newPizza = new Pizza__c(
                Name = customPizzaName,
                Is_Custom__c = true,
                Customer__c = currentContactId
                );
            insert newPizza;
            for(Pizza_Ingredient_Item__c ingr : ingrList)
            {
                ingr.Pizza__c = newPizza.Id;
            }
            insert ingrList;
        }
        retrievePizzaData();
    }
    private void sendReport(Pizza_Order__c newOrder){
        User temp = [SELECT Id, ContactId, Email, FirstName, LastName FROM User WHERE Id = :UserInfo.getUserId()];
        //Contact temp = [SELECT Id, Email, FirstName, LastName FROM Contact WHERE Id = :currentContactId];
        Decimal sum = 0;
        String mailReport = 'Hello, ';
        mailReport += temp.FirstName;
        mailReport += ' ';
        mailReport += temp.LastName;
        mailReport += '!\nYour order:\n';
        List<Pizza_Order_Item__c> items = [SELECT Id, Pizza__c, Pizza__r.Name, Count__c, Pizza_Base__c, Pizza_Base__r.Name,Pizza_Order__c, Cost__c 
                                            FROM Pizza_Order_Item__c 
                                            WHERE Pizza_Order_Item__c.Pizza_Order__c = :newOrder.Id];
        for(Pizza_Order_Item__c item : items)
        {
            mailReport += item.Pizza__r.Name;
            mailReport += '  ';
            mailReport += item.Pizza_Base__r.Name;
            mailReport += '  x';
            mailReport += String.valueOf(item.Count__c);
            mailReport += '  ';
            mailReport += String.valueOf(item.Cost__c);
            mailReport += '$\n';
            sum += item.Cost__c;
        }
        mailReport += 'Summary: ';
        //mailReport += String.valueOf(newOrder.Cost__c);
        mailReport += String.valueOf(sum);
        mailReport += '$\n';
        AwesomeNotifyHelper.notify(/*'londonversusall@gmail.com'*/temp.Email, mailReport, null);
    }
}