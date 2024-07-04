trigger ChatGPTEventTrigger on chatGPT__e (after insert) {
    for (chatGPT__e eventRecord : Trigger.new) {
        try {
            InboundChat__c chat = new InboundChat__c(
                receive__c = eventRecord.Receive__c
            );
            insert chat;
        } catch (Exception e) {
            System.debug('Error processing event: ' + e.getMessage());
        }
    }
}