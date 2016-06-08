global class CustomPizzaScheduler implements Schedulable {

	public static final String SCHEDULER_NAME = 'CustomPizzaScheduler';
	public static final Integer DEFAULT_MINUTES_INTERVAL = 5;

	Integer minutes;

	public CustomPizzaScheduler() {
		//minutes = minutesInterval;
	}

	global void execute(SchedulableContext sc) {
		// Re-schedule ourself to run again in "minutes" time
		String name = getSchedulerName();
		String cron = getCronExpression();
		CustomPizzaScheduler scheduler = new CustomPizzaScheduler();

		System.schedule(name, cron, scheduler);
		String query = 'SELECT Id FROM Pizza_c WHERE Last_Ordered_Date__c + ';
		query += Pizza_Store_Setting__c.getInstance().Custom_Pizza_Expiration_Time__c;
		query += ' < TODAY';
		CustomPizzaBatch.invoke(query);

		// Abort the current job
		Id jobId = sc.getTriggerId();
		System.abortJob(jobId);
	}

	public static void invoke() {
		String name = getSchedulerName();
		String cron = getCronExpression();
		CustomPizzaScheduler scheduler = new CustomPizzaScheduler();

		System.schedule(name, cron, scheduler);
	}

	public static String getCronExpression() {

		return '0 0 0 * * ?';
	}

	public static String getSchedulerName() {
		return SCHEDULER_NAME + ' - ' + Datetime.now().format();
	}

}