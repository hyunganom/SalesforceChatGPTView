trigger ContactTrigger on Contact (after insert) {
    for (Contact newContact : Trigger.new) {
        ContactIntegrationService.sendContactCreationEvent(newContact.Id);
    }
}
