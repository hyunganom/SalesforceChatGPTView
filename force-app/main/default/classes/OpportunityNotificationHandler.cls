public class OpportunityNotificationHandler { 
    public static void SendNotification(List<opportunity> OppList){ 
        CustomNotificationType closedWonNotification = [SELECT Id, 
                                                        DeveloperName  
                                                        FROM CustomNotificationType  
                                                        WHERE DeveloperName='Opportunity_Custom_Notification' 
                                                        LIMIT 1]; 
        for(opportunity opp : OppList){ 
            if(opp.StageName == 'Closed Won'){ 
                String body = 'Opportunity ' +opp.Name +' is Closed Won.'; 
                Messaging.CustomNotification Notification = new Messaging.CustomNotification(); 
                Notification.setNotificationTypeId(closedWonNotification.id); 
                Notification.setSenderId(Userinfo.getUserId()); 
                Notification.setBody(body); 
                Notification.setTitle('Opportunity Closed Won'); 
                Notification.setTargetId(opp.Id); 
                Notification.send(new Set<String> {opp.OwnerId}); 
            } 
        } 
    } 
}