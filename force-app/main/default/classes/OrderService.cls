public with sharing class OrderService {
    
    public static void updateAccountTurnOver(List<Order> orders) {
        
        Set<Id> accountsIds = new Set<Id>();

        for (Order order : orders) {
            accountsIds.add(order.AccountId);
        }

        List<Account> accounts = RecordsSelection.getAccounts(accountsIds);
        List<Order> orderedOrders = RecordsSelection.getOrderedOrders(accountsIds);

        for (Account account: accounts) {
            account.Chiffre_d_affaire__c = 0;
            for (integer i=0; i < orderedOrders.size(); i++) {
                if (orderedOrders[i].AccountId == account.Id) {
                    account.Chiffre_d_affaire__c += orderedOrders[i].TotalAmount;
                }
            }
        }

        update accounts;
    }
}