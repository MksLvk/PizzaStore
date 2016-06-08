public class PizzaIngredientWrapper {

	public Id detailId { get; set; }
	public String name { get; set; }
	public Boolean isChecked { get; set; }
	
	public PizzaIngredientWrapper() {

	}

	public PizzaIngredientWrapper(Pizza_Ingredient__c item ) {
		detailId = item.Id;
		isChecked = false;
		name = item.Name;
	}
}