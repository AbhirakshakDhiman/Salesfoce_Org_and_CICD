public class EventTaskHealthCheckTriggerHandler {
   public void handlerAfterInsert(List<Event_Task__c> newEventTasks) {
   updateEventFlags(newEventTasks);
   }
   public void handlerAfterUpdate(List<Event_Task__c> newEventTasks, Map<Id, Event_Task__c> 
   oldEventTasks) {
   updateEventFlags(newEventTasks);
   }
   public void handlerAfterDelete(List<Event_Task__c> deletedEventTasks) {
   updateEventFlags(deletedEventTasks);
   }
   //Common method to update the flag used by all the methods
   private void updateEventFlags(List<Event_Task__c> eventTasks) {
     system.debug(eventTasks);
       //saving event plan ids associated with event Tasks
     set<Id> evPlanId=new set<Id>();
     for(Event_Task__c task : eventTasks ){
         if(task.Event_Plan__c !=null){
             evPlanId.add(task.Event_Plan__c);
         }
     }
     
     if(evPlanId.isEmpty())
         return;//program will stop here
     
     list<Event_Plan__c> evplans=new list<Event_Plan__c>();
     //SOQL to get event plan  object data
     evplans=[select id,Total_Tasks_Count__c,Pending_Tasks_Count__c ,Event_Date__c,Event_Flag__c from Event_Plan__c where id=:evPlanId AND Event_Date__c >= TODAY AND Event_Date__c <= NEXT_N_DAYS:7];
     system.debug(evplans);
     //Since it was showing old data and not showing the updated data so i am using aggregate functions to get the updated values
     //getting the updated pending task count
     map<id,integer> ptc=new map<id,integer>();
     for(AggregateResult res: [select Event_Plan__c Id,count(id) taskCount from Event_Task__c where Event_Plan__c=:evPlanId and Task_Status__c!='Completed' group by Event_Plan__c]){
         ptc.put((id) res.get('Id'),(integer) res.get('taskCount'));
     }
     
     //getting the updated total task count
       map<id,integer> ttc=new map<id,integer>();
     for(AggregateResult res: [select Event_Plan__c Id,count(id) ttaskCount from Event_Task__c where Event_Plan__c=:evPlanId group by Event_Plan__c]){
         ttc.put((id) res.get('Id'),(integer) res.get('ttaskCount'));
     }
     
      //system.debug([select Event_Plan__c id,count(id) taskCount from Event_Task__c where Event_Plan__c=:evPlanId  group by Event_Plan__c]);
     for(Event_Plan__c ev: evplans){
         Integer pt=ptc.get(ev.Id)!=null?ptc.get(ev.Id):0;
         Integer tt=ttc.get(ev.Id)!=null?ttc.get(ev.Id):0;
        //total task count should be greater than 0
     if(tt>0){
         decimal c=(pt*100/tt);// calculating percentage to change the event status 
          system.debug(c);
          system.debug(pt+' '+tt);
         if(c>=50){
            ev.Event_Flag__c='Critical';
         }
         else if(c==0){
            ev.Event_Flag__c='Completed'; 
         }
         else{
            ev.Event_Flag__c='On Track';
         }
      } else{
            ev.Event_Flag__c='On Track';
            }
      }
      //DML Operation to update the records
      update evplans;
 }
}