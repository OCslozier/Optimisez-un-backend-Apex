@isTest
public class UpdateAccountsTurnOverBatchTest {

    // Test en masse (200 enregistrements)
    @isTest 
    static void testBulkUpdateAccountsTurnOverBatch() {
        
        // Génération des données de test
        Integer sizeTest = 200;
        Decimal unitPrice = 100;
        Decimal pricebookUnitPrice = 100;
        Decimal newUnitPrice = 900;
        
        // Création des comptes
        List<Account> accList = TestDataFactory.createAccount(sizeTest);
        
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
        List<Order> ordList = TestDataFactory.createOrder(accList, sizeTest, standardPricebookId);
        
        // Création des lignes de commandes
        List<OrderItem> oiList = TestDataFactory.createOrderItems(ordList, pbe, unitPrice);
        
        List<Order> orders = [SELECT Id, Status FROM Order];
        
        // Mise à jour des commandes et du prix des lignes de commandes        
        TestDataFactory.updateOrderToOrdered(ordList);
        TestDataFactory.updateOrderItemToNewUnitPrice(oiList, newUnitPrice);
    
        Test.startTest();
        
        UpdateAccountsTurnOverBatch bulkUpdateAccountObj = new UpdateAccountsTurnOverBatch();
        Database.executeBatch(bulkUpdateAccountObj);
        
        Test.stopTest();
        
        // Récupération des comptes mis à jour
        List<Account> updatedAccounts = [SELECT Name, Chiffre_d_affaire__c FROM Account];

        // Vérification du chiffre d'affaire sur les comptes mis à jour
        for (Account acc : updatedAccounts) {
            Decimal expectedChiffreAffaire = 900;
            Assert.AreEqual(expectedChiffreAffaire, acc.Chiffre_d_affaire__c);
        }
    }
}