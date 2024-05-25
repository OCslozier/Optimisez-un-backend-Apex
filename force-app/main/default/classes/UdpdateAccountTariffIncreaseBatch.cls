global class UdpdateAccountTariffIncreaseBatch implements Database.Batchable<sObject>{

    public Database.QueryLocator start(Database.BatchableContext batchContext) {
        return RecordsSelection.getAccountsWithOrderedStatus();
    }

    global void execute(Database.BatchableContext info, List<Account> scope) {
        BatchService.processAccounts(scope);
    }

    global void finish(Database.BatchableContext info){

    }
}