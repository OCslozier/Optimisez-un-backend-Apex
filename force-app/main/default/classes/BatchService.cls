public class BatchService {

    public static void processAccounts(List<Account> scope) {
        List<OrderItem> orderItems = RecordsSelection.getOrderItemsForAccounts(scope);

        Map<Id, List<OrderItem>> accountIdToOrderItems = new Map<Id, List<OrderItem>>();

        // Remplir la map
        for (OrderItem oi : orderItems) {
            if (!accountIdToOrderItems.containsKey(oi.Order.AccountId)) {
                List<OrderItem> orderItemList = new List<OrderItem>();
                orderItemList.add(oi);
                accountIdToOrderItems.put(oi.Order.AccountId, orderItemList);
            } else {
                accountIdToOrderItems.get(oi.Order.AccountId).add(oi);
            }
        }

        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountIdToOrderItems.keySet()) {
            Decimal newAmount = 0;
            for (OrderItem oi : accountIdToOrderItems.get(accountId)) {
                newAmount += oi.PricebookEntry.UnitPrice * oi.Quantity;
            }
            Account accountToUpdate = new Account(Id = accountId, Chiffre_d_affaire__c = newAmount);
            accountsToUpdate.add(accountToUpdate);
        }

        update accountsToUpdate;
    }
}