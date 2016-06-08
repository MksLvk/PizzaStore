public class PizzaWrapper {

	public Id detailId { get; set; }
	public String name { get; set; }
	public String ingredients { get; set; }
	public Boolean isChecked { get; set; }
	public Id base { get; set; }
	public String amount { get; set; }
	public Boolean isCustom { get; set; }
	public Double cost { get; set; }
	public PizzaWrapper() {

	}

	public PizzaWrapper(Pizza__c pizza ) {
		detailId = pizza.Id;
		name = pizza.Name;
		isChecked = false;
		cost = pizza.Cost__c;
		isCustom = pizza.Customer__c == null ? false : true;
		ingredients = '';
		List<Pizza_Ingredient_Item__c> ingr = [SELECT Id, Name,Pizza_Ingredient__c FROM Pizza_Ingredient_Item__c WHERE Pizza__c =: pizza.Id ];
		for(Pizza_Ingredient_Item__c i : ingr)
		{
		    Pizza_Ingredient__c temp = [SELECT Id,Name FROM Pizza_Ingredient__c WHERE Id =: i.Pizza_Ingredient__c ];
		    ingredients += temp.Name;
		    ingredients += ' ';
		}
	}

	

}