public with sharing class AwesomeNotifyHelper {

	public static String NOTIFY_TO = '';
	public static final String NOTIFY_CC = '';
	public static final String NOTIFY_SENDER_NAME = 'Pizza Store Automation';
	public static final String NOTIFY_REPLY_TO = 'noreply@media-store.com';

	public static void notify(String eMail, String textMessage, String htmlMessage) {
		singleEmail(eMail, NOTIFY_CC, NOTIFY_SENDER_NAME, NOTIFY_REPLY_TO, 'PizzaStore', textMessage, htmlMessage);
	}

	public static void singleEmail(String to, String cc, String senderName, String replyTo, String subject, String textMessage, String htmlMessage) {

		Messaging.reserveSingleEmailCapacity(2);
		Messaging.SingleEmailMessage notify = new Messaging.SingleEmailMessage();
		
		String[] toAddresses = new String[] { to }; 
		notify.setToAddresses(toAddresses);
		
		if (String.isNotBlank(cc)) {
			String[] ccAddresses = new String[] { cc };
			notify.setCcAddresses(ccAddresses);
			notify.setBccSender(true);
		}

		notify.setReplyTo(replyTo);
		notify.setSenderDisplayName(senderName);
		notify.setSubject(subject);
		notify.setUseSignature(false);

		notify.setPlainTextBody(textMessage);

		if (String.isNotBlank(htmlMessage)) {
			notify.setHtmlBody(htmlMessage);
		}

		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { notify });
	}
}