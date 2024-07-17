public with sharing class SendRabbitMq {
    private String outboundChatId;

    private static final String RABBITMQ_URL = 'http://52.79.166.146:8080/api/exchanges/%2f/x.api/publish';
    private static final String USERNAME = 'new_user';
    private static final String PASSWORD = '1234';

    @future(callout=true) // 비동기적으로 실행하며, 외부 서비스에 대한 callout을 허용
    public static void sendToRabbitMq(String payload) {
        try {
            HttpRequest request = createHttpRequest(payload); // 생성된 HTTP 요청을 보낸다.
            Http http = new Http(); // 인스턴스를 사용하여 요청
            HttpResponse response = http.send(request); //응답값 처리

            handleResponse(response);
        } catch (Exception e) {
            System.debug('RabbitMQ 메시지 보내기 실패: ' + e.getMessage());
        }
    }

    private static HttpRequest createHttpRequest(String payload) {
        String jsonMessage = createJsonMessage(payload); //payload를 JSON문자열로 형식화 한다.

        HttpRequest request = new HttpRequest(); //HTTP 요청 인스턴스화
        request.setEndpoint(RABBITMQ_URL); // Rabbit MQ의 엔드포인트로 URL 지정
        request.setMethod('POST'); //요청 메서드를 POST
        request.setHeader('Authorization', createAuthHeader()); //헤더 유형을 추가
        request.setHeader('Content-Type', 'application/json'); //요청 본문을 JSON 메세지로 설정 (JSON 말고 XML방법도 있음)
        request.setBody(jsonMessage);

        return request;
    }

    private static String createJsonMessage(String payload) {
        Map<String, Object> message = new Map<String, Object>();
        message.put('properties', new Map<String, Object>()); //키를 가진 맵을 구성
        message.put('routing_key', '');
        message.put('payload', payload);
        message.put('payload_encoding', 'string');
        return JSON.serialize(message);
    }

    private static String createAuthHeader() { //Base64로 인코딩된 인증 헤더
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