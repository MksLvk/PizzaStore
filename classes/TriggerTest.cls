@isTest
private class TriggerTest {

	private static testMethod void test() 
	{
        Contact customer = new Contact
        (
            FirstName = 'Test',
            LastName = 'Test'
        );
        insert customer;
            
        Media_Bucket__c bucket = new Media_Bucket__c
        (
            Contact__c = customer.Id,
            Name = 'Test Bucket'
        );
        insert bucket;
        
        Media_Product__c product = new Media_Product__c
        (
            Price__c = 100,
            Description__c = 'blabla',
            Name = 'Test Product'
        );
        insert product;
        
        Media_Discount__c percentDiscount = new Media_Discount__c
        (
            Percent__c = 10,
            Name = 'Test pd'
        );
        insert percentDiscount;
        
        Media_Discount__c valueDiscount = new Media_Discount__c
        (
            Value__c = 2,
            Name = 'Test vd'
        );
        insert valueDiscount;
                
        Test.startTest();
        
        Media_Bucket_Item__c bi = new Media_Bucket_Item__c
        (
            Media_Product__c = product.Id,
            Media_Discount__c = percentDiscount.Id,
            Media_Bucket__c = bucket.Id
        );
        insert bi;
        
        bi = [SELECT Id,Media_Discount__c, Cost__c FROM Media_Bucket_Item__c WHERE Id = : bi.Id];
        System.assert(bi.Cost__c == 90);
        
        Test.stopTest();
	}

}