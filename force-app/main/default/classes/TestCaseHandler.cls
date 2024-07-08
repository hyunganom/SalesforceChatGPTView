public with sharing class TestCaseHandler {
    public TestCaseHandler() {}

    public static void handleCase (Case c) {
        try {
            FeedItem feed = new FeedItem();
            feed.ParentId =  c.Id;
            feed.Body = '이것은 테스트';
            insert feed;
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
    }
}
// // 이메일 발송에 필요한 라이브러리를 가져옵니다.
// Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

// // 이메일 제목 설정
// mail.setSubject('이메일 제목');

// // 이메일 본문 설정
// mail.setPlainTextBody('이메일 내용');

// // 수신자 이메일 주소 설정
// mail.setToAddresses(new String[] {'dlguswo0504@gmail.com'});

// // 이메일 발신자 설정 (이메일 발신자는 Salesforce에서 설정한 이메일이어야 합니다.)
// mail.setReplyTo('dlguswo0504@gmail.com');

// // 이메일 발신자 이름 설정 (선택 사항)
// mail.setSenderDisplayName('발신자 이름');

// // 이메일 발송
// Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

// // Apex 클래스 정의
// public class PushNotification {

//     // 푸시 알림을 보내는 메서드
//     public static void sendNotification(String message) {
//         // 푸시 알림 생성
//         Messaging.PushNotification pushNotification = new Messaging.PushNotification();
        
//         // 푸시 알림에 메시지 설정
//         pushNotification.setMessage(message);
        
//         // 푸시 알림 전송
//         Messaging.PushNotification.sendNotification(pushNotification);
//     }
// }

// // 메시지 정의
// String message = '새로운 알림이 있습니다. 확인해주세요!';

// // 푸시 알림 보내기
// PushNotification.sendNotification(message);
