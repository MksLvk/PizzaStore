public class CalculateCostValueTriggerHandler {

	public static void process(List<Media_Bucket_Item__c> records, Map<Id, Media_Bucket_Item__c> oldMap, Boolean isInsert) {

		Set<Id> buketItemIds = new Set<Id>();
		for (Media_Bucket_Item__c record : records) {
			if (isInsert || record.Media_Discount__c != oldMap.get(record.Id).Media_Discount__c) {
				buketItemIds.add(record.Id);
			}
		}
		List<Media_Bucket_Item__c> bucketItems = MediaStoreHelper.getMediaBucketItemList(buketItemIds, null);
	
		MediaStoreHelper.updateMediaBucketItemPrice(bucketItems);
	}
}