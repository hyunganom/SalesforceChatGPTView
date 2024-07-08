trigger OpportunityNotificationTrigger on Opportunity (after update) { 
    if(Trigger.isAfter && Trigger.isUpdate){ 
        OpportunityNotificationHandler.SendNotification(trigger.new); 
    } 
}