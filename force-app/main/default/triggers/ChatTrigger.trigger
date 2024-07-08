trigger ChatTrigger on Chat__c (after insert, after update) {
    // for (Chat__c chat : Trigger.new) {
    //     String message = chat.Test__c;
    //     RabbitMQPublisher.publishMessage(message);
    // }
}
