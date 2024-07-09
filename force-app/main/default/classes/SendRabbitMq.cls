public with sharing class SendRabbitMq {
    private String outboundChatId;

    private static final String RABBITMQ_URL = 'http://3.34.191.102:8080/api/exchanges/%2f/x.api/publish';
    private static final String USERNAME = 'new_user';
    private static final String PASSWORD = '1234';

    @future(callout=true)
    public static void sendToRabbitMq(String payload) {
        try {
            HttpRequest request = createHttpRequest(payload);
            Http http = new Http();
            HttpResponse response = http.send(request);

            handleResponse(response);
        } catch (Exception e) {
            System.debug('Error sending message to RabbitMQ: ' + e.getMessage());
        }
    }

    private static HttpRequest createHttpRequest(String payload) {
        String jsonMessage = createJsonMessage(payload);

        HttpRequest request = new HttpRequest();
        request.setEndpoint(RABBITMQ_URL);
        request.setMethod('POST');
        request.setHeader('Authorization', createAuthHeader());
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jsonMessage);

        return request;
    }

    private static String createJsonMessage(String payload) {
        Map<String, Object> message = new Map<String, Object>();
        message.put('properties', new Map<String, Object>());
        message.put('routing_key', '');
        message.put('payload', payload);
        message.put('payload_encoding', 'string');
        return JSON.serialize(message);
    }

    private static String createAuthHeader() {
        return 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(USERNAME + ':' + PASSWORD));
    }

    private static void handleResponse(HttpResponse response) {
        if (response.getStatusCode() != 200) {
            System.debug('RabbitMQ request failed with status code: ' + response.getStatusCode() + ' and message: ' + response.getStatus());
        } else {
            System.debug('RabbitMQ response: ' + response.getBody());
        }
    }
}