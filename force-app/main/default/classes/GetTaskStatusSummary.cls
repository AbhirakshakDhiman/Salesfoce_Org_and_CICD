public class GetTaskStatusSummary {
    @InvocableMethod(label='Get Task Status Summary' description='Returns task count grouped by status')
    public static List<TaskStatusSummary> getTaskStatusSummary(List<Id> eventPlanIds) {
        List<TaskStatusSummary> summaryList = new List<TaskStatusSummary>();
        
        AggregateResult[] results = [
            SELECT Task_Status__c status, COUNT(Id) taskCount
            FROM Event_Task__c
            WHERE Event_Plan__c IN :eventPlanIds
            GROUP BY Task_Status__c
        ];
        
        for (AggregateResult ar : results) {
            summaryList.add(new TaskStatusSummary(
                String.valueOf(ar.get('status')),
                Integer.valueOf(ar.get('taskCount'))
            ));
        }
        
        return summaryList;
    }

    public class TaskStatusSummary {
        @InvocableVariable
        public String status;
        @InvocableVariable
        public Integer taskCount;

        public TaskStatusSummary(String status, Integer taskCount) {
            this.status = status;
            this.taskCount = taskCount;
        }
    }
}