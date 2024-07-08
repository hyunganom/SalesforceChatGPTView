trigger TestTrigger on Contact (after insert) {
    String webhookUrl = 'http://localhost:8887/webhook/contact';

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(webhookUrl);
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json');
    request.setBody(JSON.serialize(Trigger.new));
    HttpResponse response = http.send(request);

    if (response.getStatusCode() != 200) {
        System.debug('Webhook request failed with status code: ' + response.getStatusCode() + ' and message: ' + response.getStatus());
    }
}