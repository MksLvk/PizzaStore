public with sharing class MediaShopCartController {

	public List<Media_Bucket_Item__c> items { get; set; }
	
	public Id detailId { get; set; }
	public String detailType { get; set; }
	public String couponCode { get; set; }

	private Id currentContactId { get; set; }
	public String typeFilter { get; set; }
	public String sortKey { get; set; }
	public Boolean sortDesc { get; set; }
	
	public Integer getBucketSize() {
		return [SELECT COUNT() FROM Media_Bucket_Item__c WHERE Media_Bucket__r.Contact__c = :currentContactId];
	}
	
	public List<SelectOption> getTypeOptions() {
		List<SelectOption> options = new List<SelectOption>{ new SelectOption('', 'All') };
		List<Schema.PicklistEntry> ple = Media_Product__c.Type__c.getDescribe().getPicklistValues();
		for (Schema.PicklistEntry f : ple) {
			options.add(new SelectOption(f.getValue(), f.getLabel()));
		}
		return options;
	}
	public List<SelectOption> getSortOptions() {
		List<SelectOption> options = new List<SelectOption>{ new SelectOption('', 'None') };
		for(Schema.FieldSetMember fld : getFields()){
		    options.add(new SelectOption(fld.getFieldPath(),fld.getFieldPath()));// fld.getLabel()));
		}
		return options;
	}
	
	public List<Schema.FieldSetMember> getFields(){
	    return SObjectType.Media_Bucket_Item__c.FieldSets.Bucket_View.getFields();
	}
	
	public MediaShopCartController() {

		User currentUser = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
		currentContactId = currentUser.ContactId;
		
		sortDesc = false;

		retrieveBucketData();
	}

	public void retrieveBucketData() {
		
		String query = 'SELECT ';
		for(Schema.FieldSetMember fld : getFields()){
		    query += fld.getFieldPath() + ', ';
		}
		
		query += 'Id FROM Media_Bucket_Item__c WHERE Media_Bucket__r.Contact__c = :currentContactId';
		
		if(String.isNotBlank(typeFilter)){
		    query += ' AND Media_Product__r.Type__c = :typeFilter';
		}
		
		if(String.isNotBlank(sortKey)){
		    query += ' ORDER BY ';
		    query += sortKey;
		}
		if(sortDesc){
		    query += ' DESC';
		}
		items = Database.query(query);
		sortDesc = !sortDesc;
	}

	public void remove() {
		if (detailId != null) {
			delete [SELECT Id FROM Media_Bucket_Item__c WHERE Id = :detailId];
		}
		retrieveBucketData();
	}

	public void coupon() {
		System.debug(detailId + ' '+ detailType + ' ' + couponCode);

		List<Media_Discount__c> discounts = [
			SELECT Id FROM Media_Discount__c WHERE Code__c = :couponCode AND Type__c = :detailType LIMIT 1];

		if (!discounts.isEmpty()) {
			Media_Bucket_Item__c item = [SELECT Id, Media_Discount__c FROM Media_Bucket_Item__c WHERE Id = :detailId];
			item.Media_Discount__c = discounts[0].Id;
			update item;
		}

		retrieveBucketData();
	}

}