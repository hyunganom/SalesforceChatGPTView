public class AssingmentCaseBatch implements Database.Batchable<sObject>{
    public AssingmentCaseBatch() {}

    public Database.QueryLocator start(Database.BatchableContext bc) {
    
        String query = ' SELECT Id, Name, LastModifiedDate, Case__c, AssignmentManager__c, ParentId__c, RefuseReason__c, StatusAssignment__c FROM AssignmentCase__c  WHERE StatusAssignment__c =  \'Waiting\' ';
                            //    + ' WHERE StatusAssignment__c =  NULL ';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<AssignmentCase__c> scope) {

        List<AssignmentCase__c> acList = new List<AssignmentCase__c>();
        List<AssignmentCase__c> updateList = new List<AssignmentCase__c>();

        for(AssignmentCase__c ac : scope){
            
            // if(ac.LastModifiedDate.addDays(3) < Date.today()){ 
            if(ac.LastModifiedDate.addMinutes(2) < DateTime.now()){ 

                

                acList.add(ac);
            }
        }

        for(AssignmentCase__c ac : acList){
            ac.StatusAssignment__c = 'Refuse';
            ac.RefuseReason__c = '기한 초과';
            updateList.add(ac);
        }

        update updateList;


        System.debug('acList: ' + acList);
    }

    public void finish(Database.BatchableContext bc) {}
}