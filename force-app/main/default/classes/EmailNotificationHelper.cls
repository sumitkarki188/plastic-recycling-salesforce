public class EmailNotificationHelper {
    @future
    public static void sendRestockNotification(List<Id> restockIds) {
        List<Re_Plastic_Innovations_Restock_Request__c> restocks = [
            SELECT Id, Product__c
            FROM Re_Plastic_Innovations_Restock_Request__c
            WHERE Id IN :restockIds
        ];

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for (Re_Plastic_Innovations_Restock_Request__c restock : restocks) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Restock Request Approved');
            email.setToAddresses(new List<String>{'sumitkarki1114@gmail.com'}); // Replace with real email
            email.setPlainTextBody('The restock request for product ' + restock.Product__c + ' has been approved.');
            emails.add(email);
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}