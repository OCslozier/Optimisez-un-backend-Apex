public class BatchService {

    public static void processAccounts(List<Account> scope) {
        List<OrderItem> orderItems = RecordsSelection.getOrderItemsForAccounts(scope);

        // Initialisation d'une map pour ordonner les résultats de requête
        Map<Id, List<OrderItem>> accountIdToOrderItems = new Map<Id, List<OrderItem>>();

        // Alimentation de la map
        for (OrderItem oi : orderItems) {
            // Si la clé n'est pas dans la map on l'ajoute avec comme valeur une liste d'orderItem
            if (!accountIdToOrderItems.containsKey(oi.Order.AccountId)) {
                List<OrderItem> orderItemList = new List<OrderItem>();
                orderItemList.add(oi);
                accountIdToOrderItems.put(oi.Order.AccountId, orderItemList);
            } else {
                // Si la clé est présente dans la map on ajoute l'orderItem a la liste associée
                accountIdToOrderItems.get(oi.Order.AccountId).add(oi);
            }
        }

        // On initialise une liste des comptes à mettre à jour
        List<Account> accountsToUpdate = new List<Account>();
        // On traite tous les Id de compte qui correspondent à une clé de la map
        for (Id accountId : accountIdToOrderItems.keySet()) {
            Decimal newAmount = 0;
            // On traite tous les orderItem lié à un compte de la map et on calcul newAmount
            for (OrderItem oi : accountIdToOrderItems.get(accountId)) {
                newAmount += oi.PricebookEntry.UnitPrice * oi.Quantity;
            }
            // On alimente la liste de comptes qui seront mis à jour
            Account accountToUpdate = new Account(Id = accountId, Chiffre_d_affaire__c = newAmount);
            accountsToUpdate.add(accountToUpdate);
        }

        update accountsToUpdate;
    }
}