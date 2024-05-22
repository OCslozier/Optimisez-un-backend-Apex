@isTest
public class UdpdateAccountTariffIncreaseBatchTest {
    
    // Test en masse (200 enregistrements)
     @isTest 
    static void testBulkUpdateAccountsWithTariffIncrease() {
        
        // Génération des données de test
        Integer totalTestRecords = 200;
        Decimal unitPrice = 100;
        Decimal pricebookUnitPrice = 100;
        Decimal newPriceBookUnitPrice = 700;
               
        // Création des comptes
        List<Account> accList = TestDataFactory.createAccount(totalTestRecords);
        
        // Création des contrats
        List<Contract> conList = TestDataFactory.createContract(accList);
        
        // Mise à jour des contrats
        TestDataFactory.updateContractsToActivated(conList);
        
        // Création des produits
        Product2 prod = TestDataFactory.createProduct();
        
        // Création des entrées de catalogue de prix
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod, pricebookUnitPrice);
        
        // Création des commandes
        Id standardPricebookId = Test.getStandardPricebookId();
        List<Order> ordList = TestDataFactory.createOrder(accList, totalTestRecords, standardPricebookId);
        
        // Création des lignes de commandes
        List<OrderItem> oiList = TestDataFactory.createOrderItems(ordList, pbe, unitPrice);
        
        List<Order> orders = [SELECT Id, Status FROM Order];
        
    // Mise à jour des commandes et du prix des lignes de commandes        
    TestDataFactory.updateOrderToOrdered(ordList);
        
        // Mise à jour de l'entrée au catalogue de prix
        TestDataFactory.updatePricebookEntryUnitPrice(pbe, newPriceBookUnitPrice);
        
        Test.startTest();
        
        UdpdateAccountTariffIncreaseBatch bulkUpdateAccountTariffObj=new UdpdateAccountTariffIncreaseBatch();
    Database.executeBatch(bulkUpdateAccountTariffObj);
        
        Test.stopTest();
        
        // Récupération des comptes mis à jour
        List<Account> updatedAccounts = [SELECT Name, Chiffre_d_affaire__c FROM Account];

        // Vérification du chiffre d affaire sur les comptes mis à jour
        for (Account acc : updatedAccounts) {
            Decimal expectedChiffreAffaire = 700;
            Assert.AreEqual(expectedChiffreAffaire, acc.Chiffre_d_affaire__c);
        }
    }
        
}