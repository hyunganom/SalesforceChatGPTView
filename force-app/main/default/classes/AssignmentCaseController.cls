public with sharing class AssignmentCaseController {

    public AssignmentCaseController() {}

    @AuraEnabled(cacheable=true)
    public static List<AssignmentCase__c> getList(){
        List<AssignmentCase__c> listAssignmentCase = new List<AssignmentCase__c>();
        try {
            listAssignmentCase = [SELECT Id, Name, Case__c, StatusAssignment__c, ParentId__c, AssignmentManager__c, Case__r.CaseNumber, AssignmentManager__r.name, CreatedDate
                                    FROM AssignmentCase__c ORDER BY CreatedDate DESC];
            System.debug('listAssignmentCase: ' + listAssignmentCase);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return listAssignmentCase;
    }

    @AuraEnabled(cacheable=true)
    public static List<AssignmentCase__c> searchAssignmentCase(String option, String search){
        
        String opt = option;
        String sea = '%'+search+'%';

        List<AssignmentCase__c> listAssignmentCase = new List<AssignmentCase__c>();
        switch on option {
           
            when 'StatusAssignment__c' {
                listAssignmentCase = [SELECT Name, Case__c, StatusAssignment__c, ParentId__c, AssignmentManager__c, Case__r.CaseNumber, AssignmentManager__r.name, CreatedDate
                                        FROM AssignmentCase__c WHERE StatusAssignment__c LIKE :sea ORDER BY CreatedDate DESC];
            }
            when 'AssignmentManager__r.Name' {
                listAssignmentCase = [SELECT Name, Case__c, StatusAssignment__c, ParentId__c, AssignmentManager__c, Case__r.CaseNumber, AssignmentManager__r.name, CreatedDate
                                        FROM AssignmentCase__c WHERE AssignmentManager__r.Name LIKE :sea ORDER BY CreatedDate DESC];
            }
            when 'All' {
                listAssignmentCase = [SELECT Name, Case__c, StatusAssignment__c, ParentId__c, AssignmentManager__c, Case__r.CaseNumber, AssignmentManager__r.name, CreatedDate
                                        FROM AssignmentCase__c ORDER BY CreatedDate DESC];
            }
            
        }
        System.debug('listAssignmentCase: ' + listAssignmentCase);
        return listAssignmentCase;
    }

    @AuraEnabled
    public static void deleteAssignmentCase(List<Id> assignmentCaseId) {
        if(assignmentCaseId.size() > 0) {

            System.debug(assignmentCaseId);
            delete [SELECT Id FROM AssignmentCase__c WHERE Id IN: assignmentCaseId];
        }
    }

    @AuraEnabled
    public static void updateInline(Object data){
 
        Object k = data;
        String serial = JSON.serialize(data);
        List<AssignmentCase__c> upd = (List<AssignmentCase__c>)JSON.deserialize(serial, List<AssignmentCase__c>.class);
 
        try {
            update upd;
        } catch(Exception e) {
            System.debug(LoggingLevel.DEBUG, 'error');
        }
 
    }

    @AuraEnabled
    public static ReturnWP fetchFields(String recordId, String objectName, String fieldSetName) {
        ReturnWP res = new ReturnWP();
        try {
            // Querying Name Field
            if(String.isBlank(recordId)) {
                res.message = 'Invalid Id';
                return res;
            }
            List<AssignmentCase__c> objectList = [SELECT id, Name FROM AssignmentCase__c  WHERE Id =: recordId];
            res.nameField = String.valueof(objectList[0].get('Name'));
 
            // Fetching Highlight Panel Field Set
            if(String.isBlank(fieldSetName)) {
                res.message = 'Please provide a Field Set Name';
                return res;
            }
            Schema.FieldSet fieldSet = Schema.getGlobalDescribe().get(objectName).getDescribe().fieldSets.getMap().get(fieldSetName);
            if(fieldSet == null) {
                res.message = 'Field Set provided is not Valid';
                return res;
            }
            res.fieldsAPI = new List<String>();
            for(Schema.FieldSetMember fieldSetMem:fieldSet.getFields()){
                res.fieldsAPI.add(fieldSetMem.getFieldPath());
            }
            return res;
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
 
    public class ReturnWP {
        @AuraEnabled public String message;
        @AuraEnabled public String nameField;
        @AuraEnabled public List<String> fieldsAPI;
    }
}