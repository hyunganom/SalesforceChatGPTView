public class ChatGPTController {
    @AuraEnabled(cacheable=true)
    public static List<InboundChat__c> getChatMessages() {
        return [SELECT Id, receive__c, send__c FROM InboundChat__c ORDER BY CreatedDate asc ];
    }
    
    @AuraEnabled
    public static void sendToChatGPT(String userInput) {
        InboundChat__c newChatMessage = new InboundChat__c();
        newChatMessage.send__c = userInput;
        
        insert newChatMessage;
        
        SendRabbitMq.sendToRabbitMq(userInput);
    }
}
