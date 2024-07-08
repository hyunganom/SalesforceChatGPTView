public with sharing class ChatterHandler {
    public ChatterHandler() {}

    public static void postToManager(String caseNumber, Id AsssignmentId, Id managerId) {
        FeedItem feed = new FeedItem();
        feed.ParentId = AsssignmentId;
        feed.Body = findCaseNumber(caseNumber) + ' 사례의 담당자 배정 Post입니다.';
        feed.CreatedById = managerId;

        insert feed;        
    }

    public static void postToOwner(String caseNumber ,Id AsssignmentId, Id OwnerId) {
        FeedItem feed = new FeedItem();
        feed.ParentId = AsssignmentId;
        feed.Body = findCaseNumber(caseNumber) + '사례의 할당 거부 최초등록자 Post입니다.';
        feed.CreatedById = OwnerId;

        insert feed;        
    }

    public static void postToParentRole(String caseNumber, Id AsssignmentId, Id parentRoleId) {
        FeedItem feed = new FeedItem();
        feed.ParentId = AsssignmentId;
        feed.Body = findCaseNumber(caseNumber) + ' 사례의 할당 거부 parent Post입니다.';
        feed.CreatedById = parentRoleId;

        insert feed;        
    }

    private static String findCaseNumber(String caseNumber){
        String returnNumber = [SELECT Id, CaseNumber FROM Case WHERE Id = :caseNumber].CaseNumber;
        return returnNumber;

    }

}
