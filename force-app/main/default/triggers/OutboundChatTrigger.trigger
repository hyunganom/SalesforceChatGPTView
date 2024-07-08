trigger OutboundChatTrigger on OutboundChat__c (after insert) {
    for (OutboundChat__c chat : Trigger.new) {
        OutboundService.sendToSpringBoot(chat.Id);
    }
}