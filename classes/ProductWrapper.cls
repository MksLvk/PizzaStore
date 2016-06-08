public class ProductWrapper {

	public Id detailId { get; set; }
	public Id bucketItemId { get; set; }
	public String name { get; set; }
	public String description { get; set; }
	public String type { get; set; }
	public Double price { get; set; }
	public Double rating { get; set; }
	public Id attachmentId { get; set; }
	public Boolean isPreOrdered { get; set; }
	public Boolean isOrdered { get; set; }
	public String accessLink { get; set; }
	

	public Boolean getIsShow() {
		return attachmentId != null;
	}

	public ProductWrapper() {

	}

	public ProductWrapper(Media_Product__c product, Boolean preOrdered, Boolean ordered, Id inBucketItemId) {
		detailId = product.Id;
		name = product.Name;
		description = product.Description__c;
		type = product.Type__c;
		price = product.Price__c;
		rating = product.Rating__c;
		attachmentId = product.Attachments.isEmpty() == false ? product.Attachments[0].Id : null;
		isPreOrdered = preOrdered;
		isOrdered = ordered;
		bucketItemId = inBucketItemId;
		accessLink = product.Access_Link__c;
	}

	public void add() {
		if (isPreOrdered == false && isOrdered == false) {
			User currentUser = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
			String contactId = currentUser.ContactId;
			Media_Bucket__c bucket = [SELECT Id FROM Media_Bucket__c WHERE Contact__c = :contactId LIMIT 1];
			if (bucket != null) {
				Media_Bucket_Item__c bucketItem = new Media_Bucket_Item__c(
					Media_Product__c = detailId,
					Media_Bucket__c = bucket.Id
				);
				insert bucketItem;
				isPreOrdered = true;
				bucketItemId = bucketItem.Id;
			}
		}
	}

	public void remove() {
		if (isPreOrdered && bucketItemId != null) {
			delete [SELECT Id FROM Media_Bucket_Item__c WHERE Id = :bucketItemId];
			isPreOrdered = false;
			bucketItemId = null;
		}
	}
}