public class GetMostExpensiveExpense {
    @InvocableMethod(label='Get Most Expensive Expense' description='Returns the most expensive expense for an event')
    public static List<Event_Expense__c> getMostExpensiveExpense(List<Id> eventPlanIds) {
        return [
            SELECT Id, Name, CapstoneProject__Amount__c
            FROM CapstoneProject__Event_Expense__c
            WHERE CapstoneProject__Event_Plan__c =:eventPlanIds
            ORDER BY CapstoneProject__Amount__c DESC
            LIMIT 1
        ];
    }
}