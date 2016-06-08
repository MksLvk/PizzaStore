public with sharing class MediaStoreController {
	
	

	public List<ProductWrapper> productWrapperList { get; set; }
	private Id currentContactId { get; set; }

	public Integer getBucketSize() {
		return [SELECT COUNT() FROM Media_Bucket_Item__c WHERE Media_Bucket__r.Contact__c = :currentContactId];
	}

	public MediaStoreController() {
	    Integer pageSize = Integer.valueOf(Media_Store_Setting__c.getInstance().Product_Page_Size__c);
		List<Media_Product__c> products = [
			SELECT Id,
				Name,
				Description__c,
				Price__c,
				Rating__c,
				Type__c,
				Access_Link__c,
				(SELECT Id, Name FROM Attachments ORDER BY LastModifiedDate DESC LIMIT 1)
			FROM Media_Product__c
			ORDER BY CreatedDate DESC
			LIMIT :pageSize
		];

		productWrapperList = new List<ProductWrapper>();

		User currentUser = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
		currentContactId = currentUser.ContactId;

		List<Media_Bucket_Item__c> bucketItemList = [
			SELECT Id,
				Media_Product__c
			FROM Media_Bucket_Item__c
			WHERE Media_Bucket__r.Contact__c = :currentContactId
		];

		Map<Id, Id> bucketMap = new Map<Id, Id>();
		for (Media_Bucket_Item__c item : bucketItemList) {
			bucketMap.put(item.Media_Product__c, item.Id);
		}

		List<Media_Order_Item__c> orderItemList = [
			SELECT Id,
			Media_Product__c
			FROM Media_Order_Item__c
			WHERE Media_Order__r.Media_Bucket__r.Contact__c = :currentContactId
		];

		Set<Id> checkProductInOrder = new Set<Id>();
		for (Media_Order_Item__c item : orderItemList) {
			checkProductInOrder.add(item.Media_Product__c);
		}

		for (Media_Product__c product : products) {
			productWrapperList.add(
				new ProductWrapper(
					product,
					bucketMap.containsKey(product.Id),
					checkProductInOrder.contains(product.Id),
					bucketMap.containsKey(product.Id) ? bucketMap.get(product.Id) : null
				)
			);
		}
	}

}