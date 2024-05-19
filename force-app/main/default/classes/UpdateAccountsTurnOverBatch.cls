global class UpdateAccountsTurnOverBatch implements Database.Batchable<sObject> {
    
    List<Account> updatedAccounts = new List<Account>();
    
    public Database.QueryLocator start(Database.BatchableContext batchContext) {
        return Database.getQueryLocator([
            SELECT Id, Name, Chiffre_d_affaire__c, (SELECT Id, TotalAmount FROM Orders WHERE Status = 'Ordered')
            FROM Account
            WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')
        ]);
    }
    
    global void execute(Database.BatchableContext info, List<Account> scope) {   
        // Traitement de tous les comptes récupérés
        for (Account acc : scope) {
            Decimal totalAmount = 0;
            // Traitement de toutes les commandes des comptes récupérés 
            for (Order ord : acc.Orders) {
                totalAmount += ord.TotalAmount;
            }
            if (acc.Chiffre_d_affaire__c != totalAmount) {
                acc.Chiffre_d_affaire__c = totalAmount;
                updatedAccounts.add(acc);
                System.debug('Compte mis à jour : ' + acc.Name + ' --> Nouveau Chiffre d\'affaire : ' + acc.Chiffre_d_affaire__c);
            }
        }
        
        // Mise à jour des comptes concernés par une commande modifiée
        if (!updatedAccounts.isEmpty()) {
            update updatedAccounts;
        }
    }

    global void finish(Database.BatchableContext info) {
       
    } 
}