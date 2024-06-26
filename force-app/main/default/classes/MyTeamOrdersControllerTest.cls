@isTest
private class MyTeamOrdersControllerTest {

    @isTest
    static void testSumOrders() {
        
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
        
        // Création des entrées de catalogue de prix
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod, pricebookUnitPrice);
        
        // Création des commandes
        Id standardPricebookId = Test.getStandardPricebookId();
        List<Order> ordList = TestDataFactory.createOrder(accList, totalTestRecords, standardPricebookId);
        
        // Création des lignes de commande
        List<OrderItem> oiList = TestDataFactory.createOrderItems(ordList, pbe, unitPrice);
        
        List<Order> orders = [SELECT Id, Status FROM Order];
        
        // Mise à jour des commandes
        TestDataFactory.updateOrderToOrdered(ordList);

        Test.startTest();
        
        MyTeamOrdersController controller = new MyTeamOrdersController();
        Decimal sumOrders = controller.SumOrders;
        
        Test.stopTest();
        
        // Vérification que la somme des commandes est correcte
        Decimal expectedSum = 1 * 100.00;
        Assert.AreEqual(expectedSum, sumOrders, 'La somme des commandes est incorrecte.');
    }
    
    @isTest
    static void testBulkSumOrders() {
        
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
        
        // Création des entrées de catalogue de prix
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod, pricebookUnitPrice);
        
        // Création des commandes
        Id standardPricebookId = Test.getStandardPricebookId();
        List<Order> ordList = TestDataFactory.createOrder(accList, totalTestRecords, standardPricebookId);
        
        // Création des lignes de commande
        List<OrderItem> oiList = TestDataFactory.createOrderItems(ordList, pbe, unitPrice);
        
        List<Order> orders = [SELECT Id, Status FROM Order];
        
        // Mise à jour des commandes
        TestDataFactory.updateOrderToOrdered(ordList);

        Test.startTest();

        MyTeamOrdersController controller = new MyTeamOrdersController();
        Decimal sumOrders = controller.SumOrders;
        
        Test.stopTest();
        
        // Vérification que la somme des commandes est correcte
        Decimal expectedSum = 300 * 100.00;
        Assert.AreEqual(expectedSum, sumOrders, 'La somme des commandes est incorrecte.');
    }

    @isTest
    static void MyTeamOrdersAggregateResult() {
        
        // Génération des données de test
        Integer totalTestRecords = 200;
        Decimal unitPrice = 300;
        Decimal pricebookUnitPrice = 100;
        
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
        
        // Création des lignes de commande
        List<OrderItem> oiList = TestDataFactory.createOrderItems(ordList, pbe, unitPrice);
        
        TestDataFactory.updateOrderToOrdered(ordList);
        
        Test.startTest();
        
        MyTeamOrdersController controller = new MyTeamOrdersController();
        
        Test.stopTest();
        
        // Vérification des résultats agrégés
        List<AggregateResult> aggregateResults = controller.aggregateResultList;
        Decimal expectedTotalAmount = totalTestRecords * unitPrice;
        Integer expectedNumOrders = totalTestRecords;
        
        // Vérification que la liste de résultats agrégés n'est pas vide
        Assert.areNotEqual(0, controller.aggregateResultList.size(), 'La liste de résultats agrégés est vide.');

        for (AggregateResult result : aggregateResults) {
            Decimal sumTotalAmount = (Decimal) result.get('sum');
            Integer numOrders = (Integer) result.get('numOrders');
            Assert.AreEqual(expectedTotalAmount, sumTotalAmount, 'La somme des montants totaux des commandes devrait être ' + expectedTotalAmount);
            Assert.AreEqual(expectedNumOrders, numOrders, 'Le nombre de commandes devrait être ' + expectedNumOrders);
        }
    }
}