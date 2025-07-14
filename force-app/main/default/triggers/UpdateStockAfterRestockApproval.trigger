trigger UpdateStockAfterRestockApproval on Re_Plastic_Innovations_Restock_Request__c (after update) {
    List<Re_Plastic_Innovations_Restock_Request__c> approved = new List<Re_Plastic_Innovations_Restock_Request__c>();
    for (Re_Plastic_Innovations_Restock_Request__c restock : Trigger.new) {
        if (restock.Status__c == 'Approved' && Trigger.oldMap.get(restock.Id).Status__c != 'Approved') {
            approved.add(restock);
        }
    }

    if (!approved.isEmpty()) {
        InventoryManager.processRestockApproval(approved);
    }
}