public class ContactIntegrationService {
    private String contactId;

    @future(callout=true)
    public static void sendContactCreationEvent(String contactId) {
        Contact contact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :contactId];
        String contactJson = JSON.serialize(contact);
        
        String webhookUrl = 'https://8167-222-112-192-42.ngrok-free.app/webhook/contact';

        HttpRequest request = new HttpRequest();
        request.setEndpoint(webhookUrl);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(contactJson);

        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('http.send(request); ' + http.send(request));
        if (response.getStatusCode() != 200) {
            System.debug('Webhook request failed with status code: ' + response.getStatusCode() + ' and message: ' + response.getStatus());
        }else{
            System.debug('Webhook response: ' + response.getBody());
        }
    }
}
