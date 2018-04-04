trigger Account on Account (after insert, after update) {
	LambdaService.upsertRecords(Trigger.new);
}