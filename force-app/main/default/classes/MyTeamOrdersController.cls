public with sharing class MyTeamOrdersController {

    public Decimal SumOrders {
        get {
            return RecordsSelection.getSumOrders();
        }
        set;
    }

    public List<AggregateResult> aggregateResultList { get; set; }

    public MyTeamOrdersController() {
        aggregateResultList = RecordsSelection.getAggregateResultList();
    }
}