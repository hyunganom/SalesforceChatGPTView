public with sharing class SendRabbitMq {
    private String outboundChatId;

    private static final String RABBITMQ_URL = 'http://52.79.166.146:8080/api/exchanges/%2f/x.api/publish';
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
            System.debug('RabbitMQ 메시지 보내기 실패: ' + e.getMessage());
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
            System.debug('RabbitMQ request 실패 및 응답 코드: ' + response.getStatusCode() + ' 그리고 메시지: ' + response.getStatus());
        } else {
            System.debug('RabbitMQ 응답: ' + response.getBody());
        }
    }
}