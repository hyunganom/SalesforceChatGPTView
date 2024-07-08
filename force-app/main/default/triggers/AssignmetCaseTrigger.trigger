trigger AssignmetCaseTrigger on AssignmentCase__c (after insert, after update) {
    Set<Id> updatedAssignmentManagerIds = new Set<Id>(); 
    List<AssignmentCase__c> assignmentCasesWithCases = [SELECT Id, Case__r.CaseNumber FROM AssignmentCase__c WHERE Id IN :Trigger.new];
    


    for (AssignmentCase__c assignmentCase : Trigger.new) {
        if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                if (assignmentCase.AssignmentManager__c != null) {
                    System.debug('String.valueOf(assignmentCase.Case__c)'+ assignmentCase.Case__c);
                    System.debug('assignmentCase'+ assignmentCase);
                    //---------------------------------------------권한-----------------------------------------------------------------
                    AssignmentCaseSharingSettings.setAssignmentCaseSharingSettings(assignmentCase.Id, assignmentCase.AssignmentManager__c);

                    //---------------------------------------------메일-----------------------------------------------------------------
                    // 할당된 담당자에게 메일 발송
                    EmailHandler.sendEmailToManager(assignmentCase.Case__c, assignmentCase.AssignmentManager__c);

                    //---------------------------------------------알림-----------------------------------------------------------------
                    // 할당된 담당자에게 알림 등록
                    NotificationHandler.notiToManager(assignmentCase.Case__c, assignmentCase.Id, assignmentCase.AssignmentManager__c);

                    //---------------------------------------------채터-----------------------------------------------------------------
                    // 할당된 담당자에게 채터 등록
                    ChatterHandler.postToManager(assignmentCase.Case__c, assignmentCase.Id, assignmentCase.AssignmentManager__c);
                }
            }
            if (Trigger.isUpdate) {
                System.debug('String.valueOf(assignmentCase.Case__c)'+ assignmentCase.Case__c);
                if (assignmentCase.StatusAssignment__c != null && assignmentCase.StatusAssignment__c == 'Refuse') {
                    //---------------------------------------------메일-----------------------------------------------------------------
                    // 최초 등록자에게 메일 발송
                    EmailHandler.sendEmailToOwner(assignmentCase.Case__c, assignmentCase.AssignmentManager__c, assignmentCase.OwnerId);
                    // 할당 담당자 상위 담당자에게 메일 발송
                    Id parentRoleId = FindParentRole.getTopRole(assignmentCase.AssignmentManager__c);
                    EmailHandler.sendEmailToParentRole(assignmentCase.Case__c, assignmentCase.AssignmentManager__c, parentRoleId);
                    
                    //---------------------------------------------알림-----------------------------------------------------------------
                    // 최초등록자에게 알림 등록
                    NotificationHandler.notiToOwner(assignmentCase.Case__c, assignmentCase.Id, assignmentCase.OwnerId);
                    // 할당 담당자 상위 담당자에게 알림 등록
                    NotificationHandler.notiToOwner(assignmentCase.Case__c, assignmentCase.Id, parentRoleId);

                    //---------------------------------------------채터-----------------------------------------------------------------
                    // 최초 등록자에게 채터 등록
                    ChatterHandler.postToOwner(assignmentCase.Case__c, assignmentCase.Id, assignmentCase.OwnerId);
                    // 할당 담당자 상위 담당자에게 채터 등록
                    ChatterHandler.postToParentRole(assignmentCase.Case__c, assignmentCase.Id, parentRoleId);
                }
                //---------------------------------------------메일-----------------------------------------------------------------
                // AssignmentManager__c가 변경되었을 때 할당 담당자에게 메일 발송
                // if (updatedAssignmentManagerIds.contains(assignmentCase.AssignmentManager__c)) {
                //     EmailHandler.sendEmailToManager(assignmentCase.AssignmentManager__c);
                // }
                //---------------------------------------------채터-----------------------------------------------------------------
                // AssignmentManager__c가 변경되었을 때 할당 담당자에게 채터 등록
                // if (updatedAssignmentManagerIds.contains(assignmentCase.AssignmentManager__c)) {
                //     ChatterHandler.postToManager(assignmentCase.Id, assignmentCase.AssignmentManager__c);
                // }
            }
        }
    }

}
