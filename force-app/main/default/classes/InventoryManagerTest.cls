@isTest
public class InventoryManagerTest {
    @testSetup
    static void setupData() {
        Re_Plastic_Innovations_Recycled_Product__c prod = new Re_Plastic_Innovations_Recycled_Product__c(
            Stock_Level__c = 50,
            Threshold__c = 100
        );
        insert prod;

        List<Re_Plastic_Innovations_Order__c> orders = new List<Re_Plastic_Innovations_Order__c>{
            new Re_Plastic_Innovations_Order__c(Recycled_Product__c = prod.Id, Quantity__c = 20),
            new Re_Plastic_Innovations_Order__c(Recycled_Product__c = prod.Id, Quantity__c = 60)
        };
        insert orders;
    }

    @isTest
    static void testOrderProcessing() {
        List<Re_Plastic_Innovations_Order__c> orders = [SELECT Id, Recycled_Product__c, Quantity__c FROM Re_Plastic_Innovations_Order__c];

        Test.startTest();
        InventoryManager.processOrderStock(orders);
        Test.stopTest();

        Re_Plastic_Innovations_Recycled_Product__c prod = [SELECT Stock_Level__c FROM Re_Plastic_Innovations_Recycled_Product__c LIMIT 1];
        System.assertEquals(50 - 20, prod.Stock_Level__c);

        List<Re_Plastic_Innovations_Restock_Request__c> restocks = [SELECT Id FROM Re_Plastic_Innovations_Restock_Request__c];
        System.assertEquals(1, restocks.size());
    }

    @isTest
    static void testRestockApproval() {
        List<Re_Plastic_Innovations_Restock_Request__c> restocks = [SELECT Id, Product__c, Requested_Quantity__c FROM Re_Plastic_Innovations_Restock_Request__c];
        for (Re_Plastic_Innovations_Restock_Request__c req : restocks) {
            req.Status__c = 'Approved';
        }
        update restocks;

        Test.startTest();
        InventoryManager.processRestockApproval(restocks);
        Test.stopTest();

        Re_Plastic_Innovations_Recycled_Product__c prod = [SELECT Stock_Level__c FROM Re_Plastic_Innovations_Recycled_Product__c LIMIT 1];
        System.assert(prod.Stock_Level__c > 0);
    }
}