global class UdpdateAccountTariffIncreaseBatch implements Database.Batchable<sObject>{

    public Database.QueryLocator start(Database.BatchableContext batchContext) {
        // Récupérer les comptes qui ont au moins une commande associée au statut Ordered
        return Database.getQueryLocator([
            SELECT Id, Name FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')     
        ]);
    }

    global void execute(Database.BatchableContext info, List<Account> scope) {
        BatchService.processAccounts(scope);
    }

    global void finish(Database.BatchableContext info){

    }
}