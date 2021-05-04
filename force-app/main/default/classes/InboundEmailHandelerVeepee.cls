public with sharing class InboundEmailHandelerVeepee implements Messaging.InboundEmailHandler{

    private List<Case> caseToUpdate;
    private String emailNumberOrder;
	private String emailMessage;
    private String emailSubject;
    
    
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envolpe){

        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        System.debug('Paso 0 ----->> Entra en la clase');

        setCase(email);

        if(this.caseToUpdate.size() > 0){

            updateCase(email);

        }else{
            createCase();
        }
        
  

        return result;
    }

    private Group getMarketPlaceQueue(){
        return [SELECT Id 
                FROM Group 
                WHERE  Type = 'Queue' AND name = 'Marketplace_Queue'];
    }

    private void setCase(Messaging.InboundEmail email){
		
		Matcher numOrderPattern = Pattern.compile('(?<=\\s)\\d\\w*').matcher(email.subject);
        Matcher messagePattern = Pattern.compile('(?<=Message:\\s)[\\w\\s\\W\\d]*').matcher(email.plainTextBody);

        
		while(numOrderPattern.find() && messagePattern.find()) {
    		this.emailNumberOrder = numOrderPattern.group(0);
            this.emailMessage = messagePattern.group(0);
		}

        System.debug('Paso 1 ----->> Se ha encontrado este email.subject ' + email.subject);
        System.debug('Paso 1 ----->> Se ha encontrado este numberOrder ' + this.emailNumberOrder);

        this.caseToUpdate= [SELECT Id, Status
                            FROM Case 
                            WHERE TXT_OrderNumber__c =:  this.emailNumberOrder LIMIT 1];

        System.debug('Paso 1 ----->> Se ha encontrado este caso ' + this.caseToUpdate);
    }

    private void createCase(){

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

            System.debug('Paso 2 ----->> Se ha creado este caso ' + inboundCase.Id);

        } catch (DmlException e) {

        }
    }

    private void UpdateCase(Messaging.InboundEmail email){
        
        this.CaseToUpdate[0].Status = 'Accepted';

        EmailMessage msg = new EmailMessage(
            textBody = email.plainTextBody,
            HtmlBody = email.htmlBody,
            Headers = email.headers.toString(),
            FromName = email.fromName,
            Subject = email.subject,
            RelatedToId = this.CaseToUpdate[0].Id
        );

        try {

            update CaseToUpdate;
            //insert msg;

        } catch (DmlException e) {

            System.debug('Ha sucedido este error al actualizar el caso o insertar el mensaje: ' + e);

        }

    }
}