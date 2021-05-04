public with sharing class testToMockAchatConversation {


    public testToMockAchatConversation() {

    }

    private HttpResponse callTheService(String url, String method){
        
        Http httpObject = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('url');
        request.setMethod('GET');
        HttpResponse response = httpObject.send(request);
        String responseBody = response.getBody();

        return response;
    }
    
}
