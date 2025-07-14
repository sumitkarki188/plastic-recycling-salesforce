public class InventoryManager {
    public static void processOrderStock(List<Re_Plastic_Innovations_Order__c> orderList) {
        Set<Id> productIds = new Set<Id>();
        for (Re_Plastic_Innovations_Order__c order : orderList) {
            productIds.add(order.Recycled_Product__c);
        }

        Map<Id, Re_Plastic_Innovations_Recycled_Product__c> productMap = new Map<Id, Re_Plastic_Innovations_Recycled_Product__c>(
            [SELECT Id, Stock_Level__c, Threshold__c FROM Re_Plastic_Innovations_Recycled_Product__c WHERE Id IN :productIds]
        );

        List<Re_Plastic_Innovations_Recycled_Product__c> productsToUpdate = new List<Re_Plastic_Innovations_Recycled_Product__c>();
        List<Re_Plastic_Innovations_Restock_Request__c> restockRequests = new List<Re_Plastic_Innovations_Restock_Request__c>();

        for (Re_Plastic_Innovations_Order__c order : orderList) {
            Re_Plastic_Innovations_Recycled_Product__c product = productMap.get(order.Recycled_Product__c);
            if (product != null) {
                Decimal qty = order.Quantity__c;
                if (product.Stock_Level__c >= qty) {
                    product.Stock_Level__c -= qty;
                    productsToUpdate.add(product);
                } else {
                    Decimal shortage = qty - product.Stock_Level__c;
                    restockRequests.add(new Re_Plastic_Innovations_Restock_Request__c(
                        Product__c = product.Id,
                        Requested_Quantity__c = shortage,
                        Status__c = 'Pending'
                    ));
                }
            }
        }

        if (!productsToUpdate.isEmpty()) {
            update productsToUpdate;
        }

        if (!restockRequests.isEmpty()) {
            insert restockRequests;
        }
    }

    public static void processRestockApproval(List<Re_Plastic_Innovations_Restock_Request__c> restockList) {
        Set<Id> productIds = new Set<Id>();
        List<Id> approvedIdsToNotify = new List<Id>();

        for (Re_Plastic_Innovations_Restock_Request__c restock : restockList) {
            if (restock.Status__c == 'Approved') {
                productIds.add(restock.Product__c);
                approvedIdsToNotify.add(restock.Id);
            }
        }

        Map<Id, Re_Plastic_Innovations_Recycled_Product__c> productMap = new Map<Id, Re_Plastic_Innovations_Recycled_Product__c>(
            [SELECT Id, Stock_Level__c FROM Re_Plastic_Innovations_Recycled_Product__c WHERE Id IN :productIds]
        );

        List<Re_Plastic_Innovations_Recycled_Product__c> productsToUpdate = new List<Re_Plastic_Innovations_Recycled_Product__c>();

        for (Re_Plastic_Innovations_Restock_Request__c restock : restockList) {
            if (productMap.containsKey(restock.Product__c)) {
                Re_Plastic_Innovations_Recycled_Product__c product = productMap.get(restock.Product__c);
                product.Stock_Level__c += restock.Requested_Quantity__c;
                productsToUpdate.add(product);
            }
        }

        if (!productsToUpdate.isEmpty()) {
            update productsToUpdate;
        }

        if (!approvedIdsToNotify.isEmpty()) {
            EmailNotificationHelper.sendRestockNotification(approvedIdsToNotify);
        }
    }
}