public class OutboundService {
    private String outboundChatId;

    @future(callout=true)
    public static void sendToSpringBoot(String outboundChatId) {
        OutboundChat__c outboundChat = [SELECT send__c  FROM OutboundChat__c WHERE Id = :outboundChatId];
        String sendJson = JSON.serialize(outboundChat);
        
        String webhookUrl = 'https://4d0e-121-65-140-124.ngrok-free.app/receive-chat';

        HttpRequest request = new HttpRequest();
        request.setEndpoint(webhookUrl);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(sendJson);

        Http http = new Http();
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() != 200) {
            System.debug('Webhook request failed with status code: ' + response.getStatusCode() + ' and message: ' + response.getStatus());
        }else{
            System.debug('Webhook response: ' + response.getBody());
        }
    }
}