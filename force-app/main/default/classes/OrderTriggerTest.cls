@isTest
private class OrderTriggerTest {
    
    // Test unitaire
    @isTest 
    static void testOrderTrigger() {
        // Génération des données de test
        Integer totalTestRecords = 1;
        Decimal unitPrice = 100;
        Decimal pricebookUnitPrice = 100;
        
        // Création des comptes
        List<Account> accList = TestDataFactory.createAccount(totalTestRecords);
        
        // Création des contrats
        List<Contract> conList = TestDataFactory.createContract(accList);
        
        // Mise à jour des contrats
        TestDataFactory.updateContractsToActivated(conList);
        
        // Création des produits
        Product2 prod = TestDataFactory.createProduct();
        
        // Création des entrées de pricebook
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod, pricebookUnitPrice);
        
        // Création des commandes
        Id standardPricebookId = Test.getStandardPricebookId();
        List<Order> ordList = TestDataFactory.createOrder(accList, totalTestRecords, standardPricebookId);
        
        // Création des articles de commande
        List<OrderItem> oiList = TestDataFactory.createOrderItems(ordList, pbe, unitPrice);
        
        List<Order> orders = [SELECT Id, Status FROM Order];

        Test.startTest();

        TestDataFactory.updateOrderToOrdered(ordList);
        
        Test.stopTest();
        
        // Récupération des comptes mis à jour
        List<Account> updatedAccounts = [SELECT Name, Chiffre_d_affaire__c FROM Account];

        // Vérification du chiffre d'affaire
        System.debug('Début du test unitaire ...');
        for (Account acc : updatedAccounts) {
            Decimal expectedChiffreAffaire = 100;
            System.debug('Compte ' + acc.Name + ' CA attendu: ' + expectedChiffreAffaire + ' CA actuel ' + acc.Chiffre_d_affaire__c);
            Assert.AreEqual(expectedChiffreAffaire, acc.Chiffre_d_affaire__c);
        }
        System.debug('Fin du test unitaire ...');
    }

    // Test en masse (300 enregistrements)
    @isTest 
    static void testBulkOrderTrigger() {
        // Génération des données de test
        Integer totalTestRecords = 300;
        Decimal unitPrice = 100;
        Decimal pricebookUnitPrice = 100;
        
        // Création des comptes
        List<Account> accList = TestDataFactory.createAccount(totalTestRecords);
        
        // Création des contrats
        List<Contract> conList = TestDataFactory.createContract(accList);
        
        // Mise à jour des contrats
        TestDataFactory.updateContractsToActivated(conList);
        
        // Création des produits
        Product2 prod = TestDataFactory.createProduct();
        
        // Création des entrées de pricebook
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod, pricebookUnitPrice);
        
        // Création des commandes
        Id standardPricebookId = Test.getStandardPricebookId();
        List<Order> ordList = TestDataFactory.createOrder(accList, totalTestRecords, standardPricebookId);
        
        // Création des articles de commande
        List<OrderItem> oiList = TestDataFactory.createOrderItems(ordList, pbe, unitPrice);

        List<Order> orders = [SELECT Id, Status FROM Order];

        Test.startTest();

        TestDataFactory.updateOrderToOrdered(ordList);

        Test.stopTest();
        
        // Récupération des comptes mis à jour
        List<Account> updatedAccounts = [SELECT Name, Chiffre_d_affaire__c FROM Account];

        // Vérification du chiffre d'affaire
        System.debug('Début du test en masse ...');
        for (Account acc : updatedAccounts) {
            Decimal expectedChiffreAffaire = 100;
            System.debug('Compte ' + acc.Name + ' CA attendu: ' + expectedChiffreAffaire + ' CA actuel ' + acc.Chiffre_d_affaire__c);
            Assert.AreEqual(expectedChiffreAffaire, acc.Chiffre_d_affaire__c);
        }
        System.debug('Fin du test en masse ...');
    }
    
    // Test sans enregistrements
    @isTest 
    static void testOrderTriggerWithoutRecords() {
        // Génération des données de test
        Integer totalTestRecords = 0;
        Decimal unitPrice = 100;
        Decimal pricebookUnitPrice = 100;
        
        // Création des comptes
        List<Account> accList = TestDataFactory.createAccount(totalTestRecords);
        
        // Création des contrats
        List<Contract> conList = TestDataFactory.createContract(accList);
        
        // Mise à jour des contrats
        TestDataFactory.updateContractsToActivated(conList);
        
        // Création des produits
        Product2 prod = TestDataFactory.createProduct();
        
        // Création des entrées de pricebook
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod, pricebookUnitPrice);
        
        // Création des commandes
        Id standardPricebookId = Test.getStandardPricebookId();
        List<Order> ordList = TestDataFactory.createOrder(accList, totalTestRecords, standardPricebookId);
        
        // Création des articles de commande
        List<OrderItem> oiList = TestDataFactory.createOrderItems(ordList, pbe, unitPrice);
        
        List<Order> orders = [SELECT Id, Status FROM Order];

        Test.startTest();

        TestDataFactory.updateOrderToOrdered(ordList);
        
        Test.stopTest();
        
        // Récupération des comptes mis à jour
        List<Account> updatedAccounts = [SELECT Name, Chiffre_d_affaire__c FROM Account];

        // Vérification du chiffre d'affaire
        System.debug('Début du test sans enregistrements ...');
        for (Account acc : updatedAccounts) {
            Decimal expectedChiffreAffaire = 0;
            System.debug('Compte ' + acc.Name + ' CA attendu: ' + expectedChiffreAffaire + ' CA actuel ' + acc.Chiffre_d_affaire__c);
            Assert.AreEqual(expectedChiffreAffaire, acc.Chiffre_d_affaire__c);
        }
        System.debug('Fin du test sans enregistrements ...');
    }
    
}