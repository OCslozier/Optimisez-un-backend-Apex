public without sharing class MyTeamOrdersController {
    
    public decimal SumOrders {
        get {
            AggregateResult groupedResults = [SELECT SUM(TotalAmount) total 
                                              FROM Order 
                                              WHERE Status = 'ordered' 
                                              AND CreatedBy.UserRoleId = :RecordsSelection.currentUser.UserRoleId];
            return (decimal) groupedResults.get('total');
        }
        set;
    }
    
    public List<AggregateResult> aggregateResultList { get; set; }
    
    public MyTeamOrdersController () {
        
        aggregateResultList = new List<AggregateResult>();
        
        aggregateResultList = [
            SELECT CreatedBy.Name name, SUM(TotalAmount) sum, COUNT(Id) numOrders
            FROM Order 
            WHERE Status = 'ordered' 
            AND CreatedBy.UserRoleId = :RecordsSelection.currentUser.UserRoleId 
            GROUP BY CreatedBy.Name
        ];
    }
}