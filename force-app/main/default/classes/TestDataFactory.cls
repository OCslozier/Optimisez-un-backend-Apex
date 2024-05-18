public class TestDataFactory {

    // Création de comptes
    public static List<Account> createAccount(Integer sizeTest) {
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < sizeTest; i++) {
            Account acc = new Account(
                Name = 'Test Account ' + i,
                Chiffre_d_affaire__c = 0
            );
            accList.add(acc);
        }
        insert accList;
        return accList;
    }

    // Création de contrats
    public static List<Contract> createContract(List<Account> accList) {
        List<Contract> conList = new List<Contract>();
        for (Account acc : accList) {
            Contract con = new Contract(
                AccountId = acc.Id,
                Status = 'Draft',
                StartDate = Date.valueOf('2024-04-29'),
                ContractTerm = 36
            );
            conList.add(con);
        }
        insert conList;
        return conList;
    }

    // Mise à jour des contrats
    public static void updateContractsToActivated(List<Contract> conList) {
        for (Contract con : conList) {
            con.Status = 'Activated';
        }
        update conList;
    }

    // Création de produit
    public static Product2 createProduct() {
        Product2 prod = new Product2(
            Name = 'TEST',
            IsActive = true
        );
        insert prod;
        return prod;
    }

    // Création d'entrée au catalogue de prix
    public static PricebookEntry createPricebookEntry(Product2 prod, Decimal pricebookUnitPrice) {
        Id standardPricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPricebookEntry = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = prod.Id,
            UnitPrice = pricebookUnitPrice,
            IsActive = true
        );
        insert standardPricebookEntry;
        return standardPricebookEntry;
    }

    // Mise à jour du prix d'une entrée de catalogue de prix
    public static void updatePricebookEntryUnitPrice(PricebookEntry pbe, Decimal newPriceBookUnitPrice) {
        pbe.UnitPrice = newPriceBookUnitPrice;
        update pbe;
    }

    // Création des commandes
    public static List<Order> createOrder(List<Account> accList, Integer sizeTest, Id standardPricebookId) {
        List<Order> ordList = new List<Order>();
        for (Integer i = 0; i < sizeTest; i++) {
            Order ord = new Order(
                AccountId = accList[i].Id,
                Status = 'Draft',
                EffectiveDate = Date.valueOf('2024-04-29'),
                Pricebook2Id = standardPricebookId
            );
            ordList.add(ord);
        }
        insert ordList;
        return ordList;
    }

    // Mise à jour des commandes
    public static void updateOrderToOrdered(List<Order> ordList) {
        for (Order ord : ordList) {
            ord.Status = 'Ordered';
        }
        update ordList;
    }

    // Création des lignes de commandes
    public static List<OrderItem> createOrderItems(List<Order> ordList, PricebookEntry standardPricebookEntry, Decimal unitPrice) {
        List<OrderItem> oiList = new List<OrderItem>();
        for (Order ord : ordList) {
            OrderItem oi = new OrderItem(
                OrderId = ord.Id,
                PricebookEntryId = standardPricebookEntry.Id,
                UnitPrice = unitPrice,
                Quantity = 1
            );
            oiList.add(oi);
        }
        insert oiList;
        return oiList;
    }

    // Mise à jour des lignes de commandes
    public static void updateOrderItemToNewUnitPrice(List<OrderItem> oiList, Decimal newUnitPrice) {
        for (OrderItem oi : oiList) {
            oi.UnitPrice = newUnitPrice;
        }
        update oiList;
    }
}