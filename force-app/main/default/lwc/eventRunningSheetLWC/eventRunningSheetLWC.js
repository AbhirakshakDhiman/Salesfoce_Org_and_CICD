import { LightningElement, wire, api } from 'lwc';
import getEventDetails from '@salesforce/apex/EventRunningSheetController.getEventDetails';
import getTasks from '@salesforce/apex/EventRunningSheetController.getTasks';

export default class EventRunningSheetLWC extends LightningElement {
    @api recordId;
    eventName;
    eventDate;
    taskList = [];

    // Fetch Event Details
    @wire(getEventDetails, { recordId: '$recordId' })
    wiredEventDetails({ error, data }) {
        if (data) {
            this.eventName = data.CapstoneProject__Event_Name__c;
            this.eventDate = data.CapstoneProject__Event_Date__c;
        } else if (error) {
            console.error('Error fetching event details:', error);
        }
    }

    // Fetch Task List
    @wire(getTasks, { recordId: '$recordId' })
    wiredTasks({ error, data }) {
        if (data) {
            this.taskList = data;
        } else if (error) {
            console.error('Error fetching tasks:', error);
        }
    }
}