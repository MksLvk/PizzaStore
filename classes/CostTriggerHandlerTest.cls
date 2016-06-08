@isTest
private class CostTriggerHandlerTest {
	
	@isTest static void test_method_one() {
		Contact customer = new Contact(
			FirstName = 'Test',
			LastName = 'Test'
		);
		insert customer;

		Media_Bucket__c bucket = new Media_Bucket__c(
			Contact__c = customer.Id,
			Name = 'Test Bucket'
		);
		insert bucket;
		
		Media_Product__c product = new Media_Product__c(
			Price__c = 100,
			Description__c = 'Test Description',
			Name = 'Test Product'
		);
		insert product;

		Media_Discount__c percentDiscount = new Media_Discount__c(
			Percent__c = 10,
			Name = 'Test Percent Discount'
		);
		insert percentDiscount;

		Media_Discount__c valueDiscount = new Media_Discount__c(
			Value__c = 2,
			Name = 'Test Value Discount'
		);
		insert valueDiscount;

		Test.startTest();

		Media_Bucket_Item__c bucketItem = new Media_Bucket_Item__c(
			Media_Product__c = product.Id,
			Media_Discount__c = percentDiscount.Id,
			Media_Bucket__c = bucket.Id
		);
		insert bucketItem;
		bucketItem = [SELECT Id, Media_Discount__c, Cost__c FROM Media_Bucket_Item__c WHERE Id = :bucketItem.Id];
		System.assert(bucketItem.Cost__c == 90);

		bucketItem.Media_Discount__c = valueDiscount.Id;
		update bucketItem;
		bucketItem = [SELECT Id, Media_Discount__c, Cost__c FROM Media_Bucket_Item__c WHERE Id = :bucketItem.Id];
		System.assert(bucketItem.Cost__c == 98);

		Test.stopTest();
	}
	
}