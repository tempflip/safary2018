public with sharing class IntegrationService implements Queueable, Database.AllowsCallouts{

    public class IntegrationException extends System.Exception {}
    public static final Integer TIMEOUT = 120000;

    private String endpoint;
    private String method;
    private String body;
    private Map<String, String> headers;

    public IntegrationService(String endpoint, String method, String body, Map<String, String> headers) {
    	this.endpoint = endpoint;
    	this.method = method;
    	this.body = body;
    	this.headers = headers;
    }

    public void execute(QueueableContext context) {
    	if (method == 'POST') {
    		POSTCall(this.endpoint, this.body, this.headers);
    	}
    }

    public static HttpResponse POSTCall(String endpoint, String body, Map<String, String> headers) {
        system.debug('+++ This is a POST call. URL: ' + endpoint);
        HttpRequest req = new HttpRequest();
        req.setTimeout(TIMEOUT);
        req.setEndpoint(endpoint);
        req.setMethod('POST');

        if (headers != null) {
	        for (String k : headers.keySet()) {
	            req.setHeader(k, headers.get(k));
	        }
    	}

        system.debug('+++ body :' + body);
        req.setBody(body);

        return doCallout(endpoint, req);
    }

    public static HttpResponse doCallout(String endpoint, HttpRequest req) {

        system.debug('+++ endpoint ' + endpoint);
        system.debug('+++ req ' + req);

        Http http = new Http();
        HttpResponse res = http.send(req);
        system.debug('+++ RESPONSE : ' + res.getBody() );

        for(String hkey : res.getHeaderKeys()){
            system.debug('+++ hkey :' + hkey + ' : ' + res.getHeader(hkey));  
        }

        if (res.getStatusCode() == 200) {
            return res;
        } else {
            system.debug('+++ http error \n' + res.getBody());
            throw new IntegrationException(res.getBody());
        }
        return null;
    }


}