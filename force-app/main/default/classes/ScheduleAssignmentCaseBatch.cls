public with sharing class ScheduleAssignmentCaseBatch implements Schedulable {
    public ScheduleAssignmentCaseBatch() {}

    public void execute(SchedulableContext ctx) {
        AssingmentCaseBatch batch = new AssingmentCaseBatch();
        Database.executeBatch(batch);
    }
}