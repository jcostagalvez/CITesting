public with sharing class InboundEmailHandelerVeepee implements Messaging.InboundEmailHandler{

    private List<Case> caseToUpdate;
    private String emailNumberOrder;
	private String emailMessage;
    private String emailSubject;
    
    
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envolpe){

        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        setCase(email);
        if(this.caseToUpdate.size() != 0){
            updateCase(email);
        }else{
            createCase(email);

        }
        
  

        return result;
    }

    private emailMessage convertEmailInMessage(Messaging.InboundEmail email, String Id){

        EmailMessage msg = new EmailMessage(
            textBody = email.plainTextBody,
            HtmlBody = email.htmlBody,
            Headers = email.headers.toString(),
            FromName = email.fromName,
            Subject = email.subject,
            RelatedToId = Id
        );
        
        return msg;
    }
    private Group getMarketPlaceQueue(){
        return [SELECT Id 
                FROM Group 
                WHERE  Type = 'Queue' AND DeveloperName = 'Marketplace_Queue'];
    }

    private void setCase(Messaging.InboundEmail email){

		integer controller = 0;

		Matcher numOrderPattern = Pattern.compile('\\d\\w*').matcher(email.subject);

        
		while(numOrderPattern.find() && controller < 1) {
            controller += 1;
    		this.emailNumberOrder = numOrderPattern.group(0);
		}

        this.caseToUpdate = [SELECT Id, Status
                            FROM Case 
                            WHERE TXT_OrderNumber__c =:  this.emailNumberOrder LIMIT 1];

    }

    private void createCase(Messaging.InboundEmail email){

        Account cuentaPinkConect = [SELECT Id
                                    FROM Account
                                    LIMIT 1];

        Group marketPlaceQueue = getMarketPlaceQueue();

        Case  inboundCase = new Case(
            AccountId = cuentaPinkConect.Id,
            TXT_OrderNumber__c = this.emailNumberOrder,
            Origin = '',
            PICK_Locale__c ='fr_FR',
            PICK_Language__c = 'fr',
            PICK_CommercialChannel__c = '',
            Subject = this.emailSubject,
            Description = this.emailMessage,
            OwnerId = marketPlaceQueue.Id
        );


        try {

            insert inboundCase;


        } catch (DmlException e) {

            System.debug('Ha habido un erro al insertar el caso ---->' + e);
        }

       emailMessage msg = convertEmailInMessage(email, inboundCase.Id);

       try {

           insert msg;

       } catch (Exception e) {

        System.debug('Ha habido un erro al insertar el message ---->' + e);

       }
    }

    private void UpdateCase(Messaging.InboundEmail email){
        
        this.CaseToUpdate[0].Status = 'Accepted';
        emailMessage msg = convertEmailInMessage(email, this.CaseToUpdate[0].Id);

        try {

            update CaseToUpdate;
            insert msg;

        } catch (DmlException e) {

            System.debug('Ha sucedido este error al actualizar el caso o insertar el mensaje: ' + e);

        }

    }
}