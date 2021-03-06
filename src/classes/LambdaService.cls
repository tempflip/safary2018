public with sharing class LambdaService {

	public static final String DB_ENDPOINT = 'https://mcx7cl4p3l.execute-api.us-west-2.amazonaws.com/test/db_upsert';

	public static void upsertRecords(SObject[] sObjectList) {

		Map<String, Object> recordMap =  new Map<String, Object>();
		for (SObject so :sObjectList) {
			Map<String, Object> objectFieldMap = so.getPopulatedFieldsAsMap();
			Map<String, String> objectFieldMapInString = new Map<String, String>();
			for (String fieldNameKey : objectFieldMap.keySet()) {
				objectFieldMapInString.put(fieldNameKey, '' + objectFieldMap.get(fieldNameKey));
			}

			recordMap.put(so.Id, objectFieldMapInString);
		}

		Map<String, Object> body = new Map<String, Object>();
		body.put('sObjectType', sObjectList[0].getSObjectType().getDescribe().getName() );
		body.put('records', recordMap);

		IntegrationService calloutJob = new IntegrationService(DB_ENDPOINT, 'POST', JSON.serialize(body), null);
		Id jobId = System.enqueueJob(calloutJob);
	}
}