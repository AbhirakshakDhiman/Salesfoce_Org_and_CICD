trigger EventTaskHealthCheckTrigger on Event_Task__c (after insert, after update, after delete) {
 if (Trigger.isAfter) {
 EventTaskHealthCheckTriggerHandler handler = new EventTaskHealthCheckTriggerHandler();
 if (Trigger.isInsert) {
 // Call the handlerAfterInsert method from the handler class// Pass Trigger.new as the parameter
 handler.handlerAfterInsert(trigger.new);
 } else if (Trigger.isUpdate) {
 // Call the handlerAfterUpdate method from the handler class// Pass Trigger.new and Trigger.oldMap as parameters
  handler.handlerAfterUpdate(trigger.new,trigger.oldMap);
 } else if (Trigger.isDelete) {
 // Call the handlerAfterDelete method from the handler class// Pass Trigger.old as the parameter
  handler.handlerAfterDelete(trigger.old);
 }
 }
}