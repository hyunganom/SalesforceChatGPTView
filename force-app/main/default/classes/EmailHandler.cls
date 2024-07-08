public with sharing class EmailHandler {
    public EmailHandler() {}

    // 이메일 발송에 필요한 라이브러리를 가져옴
    static Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    public static void sendEmailToManager(String caseNumber, Id ManagerId){
        User user = lookingForUserInfo(ManagerId);

        // 이메일 제목 설정
        mail.setSubject(user.Name + '님 확인 부탁드립니다.');
        // 이메일 본문 설정
        mail.setPlainTextBody(findCaseNumber(caseNumber) +' Case 에서 '
                            + user.Name + '님이 Case가 담당자로 지정 되었습니다. 수락 / 거절 버튼 눌러주세요.');
        // 수신자 이메일 주소 설정
        mail.setToAddresses(new String[] {user.Email});
        //이메일 발신자 설정 (이메일 발신자는 Salesforce에서 설정한 이메일이어야 합니다.)
        mail.setReplyTo('dlguswo0504@naver.com');
        // 이메일 발신자 이름 설정 (선택 사항)
        mail.setSenderDisplayName('테스트 이름');

        // 이메일 발송
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        System.debug('이메일 발송 완료');
        System.debug('mail' + mail);

    }

    public static void sendEmailToOwner(String caseNumber ,Id ManagerId, Id OwnerId){
        User manager = lookingForUserInfo(ManagerId);
        User ownerUser = lookingForUserInfo(OwnerId);

        // 이메일 제목 설정
        mail.setSubject('Case를 거절 (최초 등록자 보고 메일)');
        // 이메일 본문 설정
        mail.setPlainTextBody(findCaseNumber(caseNumber) +' Case 에서 ' + manager.name + '님 께서 Case를 거절하셨습니다.');
        // 수신자 이메일 주소 설정
        mail.setToAddresses(new String[] {ownerUser.Email});
        //이메일 발신자 설정 (이메일 발신자는 Salesforce에서 설정한 이메일이어야 합니다.)
        mail.setReplyTo('dlguswo0504@naver.com');
        // 이메일 발신자 이름 설정 (선택 사항)
        mail.setSenderDisplayName('테스트 이름');

        // 이메일 발송
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        System.debug('이메일 발송 완료');
        System.debug('mail' + mail);

    }

    public static void sendEmailToParentRole(String caseNumber, Id ManagerId, Id ParentRoleId){
        User manager = lookingForUserInfo(ManagerId);
        User parentRole = lookingForUserInfo(ParentRoleId);

        // 이메일 제목 설정
        mail.setSubject('Case를 거절 (상위자 보고 메일)');
        // 이메일 본문 설정
        mail.setPlainTextBody(findCaseNumber(caseNumber) +' Case 에서 ' + manager.Name + '님 께서 Case를 거절하셨습니다.');
        // 수신자 이메일 주소 설정
        mail.setToAddresses(new String[] {parentRole.Email});
        //이메일 발신자 설정 (이메일 발신자는 Salesforce에서 설정한 이메일이어야 합니다.)
        mail.setReplyTo('dlguswo0504@naver.com');
        // 이메일 발신자 이름 설정 (선택 사항)
        mail.setSenderDisplayName('테스트 이름');

        // 이메일 발송
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        System.debug('이메일 발송 완료');
        System.debug('mail' + mail);

    }

    private static User lookingForUserInfo(Id userId){
        User user = [SELECT Id, Name, Email FROM User WHERE Id = :userId];
        return user;

    }
    private static String findCaseNumber(String caseNumber){
        String returnNumber = [SELECT Id, CaseNumber FROM Case WHERE Id = :caseNumber].CaseNumber;
        return returnNumber;

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