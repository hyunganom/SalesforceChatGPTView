public with sharing class SendRabbitMq {
    private String outboundChatId;

    @future(callout=true)
    public static void sendToRabbitMq(String payload) {
        String rabbitMqUrl = 'https://3c3f-115-92-191-108.ngrok-free.app/api/exchanges/%2f/x.api/publish';
        String username = 'guest';
        String password = 'guest';

        Map<String, Object> message = new Map<String, Object>();
        message.put('properties', new Map<String, Object>());
        message.put('routing_key', '');
        message.put('payload', payload);
        message.put('payload_encoding', 'string');
        String jsonMessage = JSON.serialize(message);

        HttpRequest request = new HttpRequest();
        request.setEndpoint(rabbitMqUrl);
        request.setMethod('POST');
        
        String authHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password));
        request.setHeader('Authorization', authHeader);
        
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jsonMessage);

        Http http = new Http();
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() != 200) {
            System.debug('RabbitMQ request failed with status code: ' + response.getStatusCode() + ' and message: ' + response.getStatus());
        } else {
            System.debug('RabbitMQ response: ' + response.getBody());
        }
    }
}
