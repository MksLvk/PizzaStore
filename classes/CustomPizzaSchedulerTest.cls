@isTest
private class CustomPizzaSchedulerTest {

    public static String CRON_EXP = '0 0 0 * * ?';

	private static testMethod void test() {
	    /*Test.startTest();
        String jobId = System.schedule('CustomPizzaScheduler', CRON_EXP, new CustomPizzaScheduler());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        DateTime now = DateTime.now();
        String testDate = now.format('yyyy-MM-dd');
        //String testDate = String.valueOf(now.date());
        //testDate += '-';
        //testDate += String.valueOf(now.monthGMT());
        //testDate += '-';
        //testDate += String.valueOf(now.dayGmt());
        testDate += ' 00:00:00';
        System.assertEquals(testDate, String.valueOf(ct.NextFireTime));
        Pizza__c[] ml = [SELECT Id FROM Pizza__c WHERE Is_Custom__c = true];
        System.assertEquals(ml.size(),0);
        Test.stopTest();
        */
	}

}