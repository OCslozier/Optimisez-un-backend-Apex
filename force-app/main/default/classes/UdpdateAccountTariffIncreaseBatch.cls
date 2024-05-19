global class UdpdateAccountTariffIncreaseBatch implements Database.Batchable<sObject>{

    public Database.QueryLocator start(Database.BatchableContext batchContext) {
        // Récupérer les comptes qui ont au moins une commande associée au statut Ordered
        return Database.getQueryLocator([
            SELECT Id, Name FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')     
        ]);
    }

    global void execute(Database.BatchableContext info, List<Account> scope){

        List<OrderItem> orderItems = [SELECT Id, Order.AccountId, PricebookEntryId, PricebookEntry.UnitPrice, Quantity FROM OrderItem WHERE Order.AccountId IN : scope];

        Map<Id, List<OrderItem>> accountIdToOrderItems = new Map<Id, List<OrderItem>>();

        //Remplir la map
        for(OrderItem oi : orderItems){
            if(!accountIdToOrderItems.containsKey(oi.Order.AccountId)){
                List<OrderItem> orderItemList = new List<OrderItem>();
                orderItemList.add(oi);
                accountIdToOrderItems.put(oi.Order.AccountId, orderItemList);
            }else{
                accountIdToOrderItems.get(oi.Order.AccountId).add(oi);
            }
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        for(Id accountId : accountIdToOrderItems.keySet()){
            Decimal newAmount = 0;
            for(OrderItem oi : accountIdToOrderItems.get(accountId)){
                newAmount += oi.PricebookEntry.UnitPrice * oi.Quantity;               
            } 
            Account accountToUpdate = new Account(Id = accountId, Chiffre_d_affaire__c = newAmount);  
            accountsToUpdate.add(accountToUpdate);
        }

        update accountsToUpdate;
    }

    global void finish(Database.BatchableContext info){

    }
}