public with sharing class NotificationHandler {
    public NotificationHandler() {}

    static Messaging.CustomNotification notification = new Messaging.CustomNotification();

    static CustomNotificationType assignmnetNotification = [SELECT Id, 
                                                        DeveloperName  
                                                        FROM CustomNotificationType  
                                                        WHERE DeveloperName='Assignmnet_Case_Noti' 
                                                        LIMIT 1]; 

    public static void notiToManager (String caseNumber, Id acId, Id ManagerId){
        User user = lookingForUserInfo(ManagerId);
        System.debug('user.Id : ' + user.Id);
        System.debug('assignmnetNotification.id : ' + assignmnetNotification.id);
        String body = findCaseNumber(caseNumber) + '의 ' + user.name + '님의 Case 배정';
        notification.setNotificationTypeId(assignmnetNotification.id);
        notification.setSenderId(Userinfo.getUserId());
        notification.setBody(body);
        notification.setTitle(findCaseNumber(caseNumber) + '의 ' + 'Case 배정');
        notification.setTargetId(acId);
        try {
            notification.send(new Set<String> {user.Id});
        } catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        
        
    }

    public static void notiToOwner (String caseNumber, Id acId, Id ManagerId){
        User user = lookingForUserInfo(ManagerId);
        String body = findCaseNumber(caseNumber) + '의 ' + user.name + '님의 Case 거절';
        notification.setNotificationTypeId(assignmnetNotification.id);
        notification.setSenderId(Userinfo.getUserId());
        notification.setBody(body);
        notification.setTitle(findCaseNumber(caseNumber) + '의 ' + 'Case 거절');
        notification.setTargetId(acId);
        notification.send(new Set<String> {user.Id});
    }

    public static void notiToParent (String caseNumber, Id acId, Id ManagerId){
        User user = lookingForUserInfo(ManagerId);
        String body = findCaseNumber(caseNumber) + '의 ' + user.name + '님의 Case 거절';
        notification.setNotificationTypeId(assignmnetNotification.id);
        notification.setSenderId(Userinfo.getUserId());
        notification.setBody(body);
        notification.setTitle(findCaseNumber(caseNumber) + '의 ' + 'Case 거절');
        notification.setTargetId(acId);
        notification.send(new Set<String> {user.Id});
    }

    private static User lookingForUserInfo(Id userId){
        User user = [SELECT Id, Name FROM User WHERE Id = :userId];
        return user;

    }

    private static String findCaseNumber(String caseNumber){
        String returnNumber = [SELECT Id, CaseNumber FROM Case WHERE Id = :caseNumber].CaseNumber;
        return returnNumber;

    }

}

