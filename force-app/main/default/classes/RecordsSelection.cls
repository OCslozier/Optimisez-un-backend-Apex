public class RecordsSelection {
    
    // Méthode pour récupérer la liste des commandes par compte 
    public static List<Order> getOrderedOrders(Set<Id> accountsIds) {
        return [SELECT Id, TotalAmount, AccountId, Status FROM Order WHERE AccountId IN :accountsIds AND Status = 'ordered'];
    }
    
    // Méthode pour récupérer la liste des comptes 
    public static List<Account> getAccounts(Set<Id> accountsIds) {
        return [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountsIds];
    }
    
    // Méthode pour récupérer les lignes de commandes associées aux commandes elles mêmes associées aux comptes
    public static List<OrderItem> getOrderItemsForAccounts(List<Account> accounts) {
        return [SELECT Id, Order.AccountId, PricebookEntryId, PricebookEntry.UnitPrice, Quantity FROM OrderItem WHERE Order.AccountId IN :accounts];
    }
       
    // Méthode pour définir le rôle de l'utilisateur courant 
    public static User currentUser {
        get {
            currentUser = [SELECT UserRoleID FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            return currentUser;
        }
        private set;
    }
  
}