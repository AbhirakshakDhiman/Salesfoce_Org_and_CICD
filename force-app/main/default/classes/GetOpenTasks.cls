public class GetOpenTasks {
    @InvocableMethod(label='Get Open Tasks' description='Returns open tasks ordered by due date descending')
    public static List<Event_Task__c> getOpenTasks(List<Id> eventPlanIds) {
        return [
            SELECT Id, Name, Task_Status__c, Due_Date__c
            FROM Event_Task__c
            WHERE Event_Plan__c =:eventPlanIds
            AND Task_Status__c = 'Not Started'
            ORDER BY Due_Date__c DESC
        ];
    }
}