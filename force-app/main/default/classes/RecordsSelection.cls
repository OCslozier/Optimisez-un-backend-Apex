public class RecordsSelection {
    
    // Méthode pour récupérer la liste des commandes par compte 
    public static List<Order> getOrderedOrders(Set<Id> accountsIds) {
        return [SELECT Id, TotalAmount, AccountId, Status FROM Order WHERE AccountId IN :accountsIds AND Status = 'ordered'];
    }
    
    // Méthode pour récupérer la liste des comptes 
    public static List<Account> getAccounts(Set<Id> accountsIds) {
        return [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountsIds];
    }
    
    // Méthode pour récupérer les comptes avec au moins une commande au statut "ordered"
    public static Database.QueryLocator getAccountsWithOrderedStatus() {
        return Database.getQueryLocator([
            SELECT Id, Name FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')
        ]);
    }
    
    // Méthode pour récupérer les lignes de commandes associées aux commandes elles mêmes associées aux comptes
    public static List<OrderItem> getOrderItemsForAccounts(List<Account> accounts) {
        return [SELECT Id, Order.AccountId, PricebookEntryId, PricebookEntry.UnitPrice, Quantity FROM OrderItem WHERE Order.AccountId IN :accounts];
    }
    
    // Méthode pour récupérer le montant total des commandes Ordered pour le rôle de l'utilisateur courant
    public static Decimal getSumOrders() {
        AggregateResult groupedResults = [
            SELECT SUM(TotalAmount) total
            FROM Order
            WHERE Status = 'ordered'
            AND CreatedBy.UserRoleId = :currentUser.UserRoleId
        ];
        return (Decimal)groupedResults.get('total');
    }

    // Méthode pour récupérer le montant total des commandes Ordered, le nombre total de commandes ordered le tout groupé par commercial pour le rôle de l'utilisateur courant
    public static List<AggregateResult> getAggregateResultList() {
        return [
            SELECT CreatedBy.Name name, SUM(TotalAmount) sum, COUNT(Id) numOrders
            FROM Order
            WHERE Status = 'ordered'
            AND CreatedBy.UserRoleId = :currentUser.UserRoleId
            GROUP BY CreatedBy.Name
        ];
    }
     
    // Méthode pour définir le rôle de l'utilisateur courant 
    public static User currentUser {
        get {
            return [SELECT Id, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()];
        }
    }
  
}