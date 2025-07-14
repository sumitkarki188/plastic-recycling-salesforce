# RePlastic Salesforce CRM

## 🚀 Overview

RePlastic CRM is a custom Salesforce application designed to manage plastic waste collection, recycling processes, stock handling, restock alerts, and order management. Built with custom Apex classes, triggers, flows, and automation, this CRM enables efficient plastic recycling lifecycle tracking.

---

## 🌐 Architecture Diagram

```
+---------------------+         +----------------------------+
|  Plastic Waste      |<------->|  Recycling Center         |
|  (Custom Object)    |         |  (Custom Object)          |
+---------------------+         +----------------------------+
          |                                 |
          v                                 v
+---------------------+         +----------------------------+
|  Recycled Product   |<------->|  Restock Request          |
|  (Custom Object)    |         |  (Custom Object)          |
+---------------------+         +----------------------------+
          |
          v
+---------------------+
|  Order              |
|  (Custom Object)    |
+---------------------+
```

---

## 📁 Project Structure

```
replastic-salesforce-crm/
├── force-app/
│   └── main/
│       └── default/
│           ├── apex/
│           │   ├── InventoryManager.cls
│           │   ├── InventoryManager.cls-meta.xml
│           │   ├── EmailNotificationHelper.cls
│           │   └── EmailNotificationHelper.cls-meta.xml
│           ├── triggers/
│           │   ├── UpdateStockAfterOrder.trigger
│           │   └── UpdateStockAfterRestockApproval.trigger
│           ├── objects/
│           │   ├── Re_Plastic_Innovations_Order__c/
│           │   ├── Re_Plastic_Innovations_Recycled_Product__c/
│           │   ├── Re_Plastic_Innovations_Plastic_Waste__c/
│           │   └── Re_Plastic_Innovations_Restock_Request__c/
│           └── flows/
│               └── StockLevelFlow.flow-meta.xml
├── sfdx-project.json
└── manifest/
    └── package.xml
```

---

## 🌫️ Custom Objects & Fields

### ✂️ 1. Re\_Plastic\_Innovations\_Plastic\_Waste\_\_c

* `Weight__c`, `Type__c`, `Collection_Date__c`, `Status__c`
* Lookup: `Recycling_Center__c`

### 🏢 2. Re\_Plastic\_Innovations\_Recycling\_Center\_\_c

* `Location__c`, `Capacity__c`

### 🌀 3. Re\_Plastic\_Innovations\_Recycled\_Product\_\_c

* `Stock_Level__c`, `Threshold__c`, `Price__c`
* Formula Field: `Stock_Low_On_Product` (checks if stock < threshold)

### 📦 4. Re\_Plastic\_Innovations\_Order\_\_c

* `Customer__c`, `Recycled_Product__c`, `Quantity__c`, `Delivery_Date__c`

### 🛂 5. Re\_Plastic\_Innovations\_Restock\_Request\_\_c

* `Product__c`, `Requested_Quantity__c`, `Status__c`

---

## 🤖 Apex Classes & Triggers

### 📊 InventoryManager.cls

* `processOrderStock()` → Reduces stock on order placement
* `processRestockApproval()` → Updates stock when restock approved

### ✉️ EmailNotificationHelper.cls

* Sends email to warehouse manager after restock approval

### ⚡ Triggers

* `UpdateStockAfterOrder.trigger` → calls `processOrderStock()`
* `UpdateStockAfterRestockApproval.trigger` → calls `processRestockApproval()` and sends email

---

## 🚀 Automation

### 🔄 Flow: Stock Level Flow

* Type: Scheduled Flow (runs daily at 6 AM)
* If `Stock_Level__c < Threshold__c`, create Task:

  * Subject: "Please Look in this Stock Is Low\..."
  * Priority: High

### ⚠ Validation Rules

* `Check_Quantity_Not_Zero` (on Order)
* `Future_Date_Collection` (on Plastic Waste)

---

## 👥 Roles & Profiles

* **Roles**:

  * CEO
  * Sales Representative → Reports to CEO
  * Warehouse Supervisor → Reports to Sales Rep

* **Profiles**:

  * Platform 1: Plastic Waste (Read/Create), Restock (Read-Only)
  * Platform 2: Order & Account (Read/Create), Product & Waste (Read-Only)
  * Platform 3: Full CRUD on all objects

---

## 🔒 Sharing Rules

* Plastic Waste visible only to Recycling Manager
* CEO ➜ Sales Rep (Read Recycled Products)
* Sales Rep ➜ Warehouse Supervisor (Read Restock Requests)

---

## 🚀 How It Works

1. **Create Recycled Product** with stock below threshold
2. **Place Order** exceeding stock
3. **Trigger Fires**: Reduces stock & creates Restock Request
4. **Approve Restock Request**
5. **Trigger Fires**: Increases stock & Sends Email
6. **Flow Runs Daily**: Alerts task when stock is low

---

## 🔄 Version Control

This project uses Git & GitHub for version control. To sync:

```bash
git add .
git commit -m "Updated triggers and classes"
git push origin main
```

---

## 🎯 Testing

* Test Class: `InventoryManagerTest`
* Covers order placement, stock updates, restock approval, email logic

---

## 🚧 Deployment

* Use SFDX CLI or Change Sets to deploy to sandbox or production.
* Authenticate org:

```bash
sfdx auth:web:login -a replastic-prod
```

---

## 🚋 Contributors

* Sumit Karki

---

## 🙏 Support

If you face issues, raise them under GitHub Issues or contact: `sumitkarki1114@gmail.com`
