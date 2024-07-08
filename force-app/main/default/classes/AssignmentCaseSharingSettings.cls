public with sharing class AssignmentCaseSharingSettings {
    public AssignmentCaseSharingSettings() {}

    public static void setAssignmentCaseSharingSettings(Id assignId ,Id managerId) {
        

        AssignmentCase__Share acShare = new AssignmentCase__Share();
        acShare.ParentId = assignId;
        acShare.UserOrGroupId = managerId;
        acShare.AccessLevel = 'Edit';
        acShare.RowCause = Schema.AssignmentCase__Share.RowCause.Manual;
        insert acShare;
        System.debug('AssignmentCase__Share: ' + acShare);
    }
}