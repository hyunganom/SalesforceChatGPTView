public class RabbitMQPublisher {
    public static void publishMessage(String message) {
        // RabbitMQ 호스트 및 포트 설정
        String host = '192.168.0.67';
        Integer port = 15672; // RabbitMQ 관리자 포트

        // 사용자 인증 정보
        String username = 'test1357';
        String password = 'test1357'; // 사용자의 실제 비밀번호로 대체하세요.

        // 가상 호스트 및 Queue 설정
        String virtualHost = '/';
        String queueName = 'sfdctest2';

        // 메시지 내용
        String messageContent = message;

        // RabbitMQ에 메시지 게시하는 요청 생성
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://' + host + ':' + port + '/api/exchanges/' + EncodingUtil.urlEncode(virtualHost, 'UTF-8') + '/' + queueName + '/publish');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password)));

        // 메시지 맵 구성
        Map<String, Object> messageMap = new Map<String, Object>();
        messageMap.put('properties', new Map<String, Object>());
        messageMap.put('routing_key', queueName);
        messageMap.put('payload', messageContent);
        messageMap.put('payload_encoding', 'string');

        // 메시지 맵을 JSON 문자열로 직렬화하여 요청 바디에 설정
        req.setBody(JSON.serialize(messageMap));

        // HTTP 요청 전송
        Http http = new Http();
        HttpResponse res = http.send(req);

        // 응답 처리
        if (res.getStatusCode() == 200) {
            System.debug('메시지가 성공적으로 게시되었습니다.');
        } else {
            System.debug('메시지 게시 중 오류가 발생했습니다. 응답 코드: ' + res.getStatusCode());
            System.debug('응답 내용: ' + res.getBody());
        }
    }
}
