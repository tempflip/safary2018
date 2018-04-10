trigger Property on Property__c (after insert, after update) {
	LambdaService.upsertRecords(Trigger.new);
}