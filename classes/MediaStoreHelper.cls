public class MediaStoreHelper {
	public MediaStoreHelper () {}
	
	public static void updateMediaBucketItemPrice(List<Media_Bucket_Item__c> bucketItems) {
		for (Media_Bucket_Item__c record : bucketItems) {
			if (record.Media_Discount__c != null) {
				if (record.Media_Discount__r.Percent__c != null) {
					record.Cost__c = record.Media_Product__r.Price__c * (1 - record.Media_Discount__r.Percent__c / 100);
				}
				else if (record.Media_Discount__r.Value__c != null) {
					record.Cost__c = record.Media_Product__r.Price__c - record.Media_Discount__r.Value__c;
				}
			}
			else {
				record.Cost__c = record.Media_Product__r.Price__c;
			}
		}
		update bucketItems;
	}
	
	public static List<Media_Bucket_Item__c> getMediaBucketItemList(Set<Id> itemIds, Set<Id> productsIds) {
		List<Media_Bucket_Item__c> bucketItems = [
			SELECT Id,
				Media_Discount__c,
				Media_Discount__r.Value__c,
				Media_Discount__r.Percent__c,
				Media_Product__c,
				Media_Product__r.Price__c,
				Cost__c
			FROM Media_Bucket_Item__c
			WHERE Id IN :itemIds
				OR Media_Product__c IN :productsIds
		];
		return bucketItems;
	}

	public static Id getCurrentBucketId() {
		User currentUser = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
		String contactId = currentUser.ContactId;
		Media_Bucket__c bucket = [SELECT Id FROM Media_Bucket__c WHERE Contact__c = :contactId];
		return bucket != null ? bucket.Id : null;
	}
}