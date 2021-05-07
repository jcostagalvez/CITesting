public with sharing class emailServiceMarketPlaceTrigger implements Messaging.InboundEmailHandler{

    private List<Case> caseToUpdate;
    private String emailNumberOrder;
    
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envolpe){

        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

        MarketPlaceServiceHandeler MarketPlaceService = new MarketPlaceServiceHandeler(email);

        return result;
    }

}