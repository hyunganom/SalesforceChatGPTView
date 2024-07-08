public with sharing class FindParentRole {
    public FindParentRole() {}

    public static Id getTopRole(String userId) {
        Id userParentRoleId = [SELECT Id, UserRole.ParentRoleId FROM User WHERE Id = :userId].UserRole.ParentRoleId;
        System.debug('userParentRoleId: ' + userParentRoleId);
        Id ParentId = [SELECT Id FROM User WHERE UserRoleId = :userParentRoleId Limit 1].Id;

        return ParentId;
    }
}