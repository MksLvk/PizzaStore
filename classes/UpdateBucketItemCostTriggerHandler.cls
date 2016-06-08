public class UpdateBucketItemCostTriggerHandler {


	public static void process(List<Media_Product__c> records, Map<Id, Media_Product__c> oldMap) {
		Set<Id> productsIds = new Set<Id>();
		for (Media_Product__c record : records) {
			if (record.Price__c != oldMap.get(record.Id).Price__c) {
				productsIds.add(record.Id);
			}
		}

		List<Media_Bucket_Item__c> bucketItems = MediaStoreHelper.getMediaBucketItemList(null, productsIds);
		MediaStoreHelper.updateMediaBucketItemPrice(bucketItems);
	}
}