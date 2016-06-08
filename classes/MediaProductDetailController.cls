public with sharing class MediaProductDetailController {

	private Id currentContactId { get; set; }
	private Id detailId { get; set; }

	public ProductWrapper productWrapper { get; set; }

	public Integer getBucketSize() {
		return [SELECT COUNT() FROM Media_Bucket_Item__c WHERE Media_Bucket__r.Contact__c = :currentContactId];
	}

	public MediaProductDetailController() {
		String currentId = System.currentPageReference().getParameters().get('id');
		detailId = String.isNotBlank(currentId) ? String.escapeSingleQuotes(currentId) : '';

		User currentUser = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
		currentContactId = currentUser.ContactId;

		Media_Product__c mediaProduct = [
			SELECT Id,
				Name,
				Description__c,
				Price__c,
				Rating__c,
				Type__c,
				Access_Link__c,
				(SELECT Id, Name FROM Attachments ORDER BY LastModifiedDate DESC LIMIT 1)
			FROM Media_Product__c
			WHERE Id = :detailId
		];

		List<Media_Bucket_Item__c> bucketItemList = [
			SELECT Id,
				Media_Product__c
			FROM Media_Bucket_Item__c
			WHERE Media_Bucket__r.Contact__c = :currentContactId
				AND Media_Product__c = :detailId
		];

		Map<Id,Id> bucketMap = new Map<Id,Id>();
		for (Media_Bucket_Item__c item : bucketItemList) {
			bucketMap.put(item.Media_Product__c,item.Id);
		}
		
		List<Media_Order_Item__c> orderItemList = [
			SELECT Id,
				Media_Product__c
			FROM Media_Order_Item__c
			WHERE Media_Order__r.Media_Bucket__r.Contact__c = :currentContactId
				AND Media_Product__c = :detailId
		];

		Set<Id> checkProductInOrder = new Set<Id>();
		for (Media_Order_Item__c item : orderItemList) {
			checkProductInOrder.add(item.Media_Product__c);
		}

		productWrapper = new ProductWrapper(
			mediaProduct,
			bucketMap.containsKey(mediaProduct.Id),
			checkProductInOrder.contains(mediaProduct.Id),
			bucketMap.containsKey(mediaProduct.Id) ? bucketMap.get(mediaProduct.Id) : null
		);

	}
}