public with sharing class EventRunningSheetController {
  @AuraEnabled(cacheable=true)
    public static Event_Plan__c getEventDetails(Id recordId) {
        try {
            return [
                SELECT CapstoneProject__Event_Name__c, CapstoneProject__Event_Date__c 
                FROM CapstoneProject__Event_Plan__c 
                WHERE Id = :recordId 
                LIMIT 1
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching event details: ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Event_Task__c> getTasks(Id recordId) {
        try {
            return [
                SELECT Name, CapstoneProject__Task_Name__c, CapstoneProject__Due_Date__c, CapstoneProject__Assigned_To__r.Name
                FROM CapstoneProject__Event_Task__c 
                WHERE CapstoneProject__Event_Plan__c = :recordId 
                ORDER BY CapstoneProject__Due_Date__c
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching tasks: ' + e.getMessage());
        }
    }
}