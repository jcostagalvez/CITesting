public with sharing class InboundEmailHandelerVeepee implements Messaging.InboundEmailHandler{

    private List<Case> caseToUpdate;
    private String emailNumberOrder;
	private String emailMessage;
    private String emailSubject;
    
    
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envolpe){

        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        System.debug('Paso 0 ----->> Entra en la clase');

        setCase(email);

        System.debug('Tamaño de lo que antes que se encuentra ' + this.caseToUpdate.size());            

        if(this.caseToUpdate.size() != 0){
            System.debug('Paso 4 ----->> Actualiza el caso');

            updateCase(email);
        }else{
            System.debug('Paso 2 ----->> Crea el caso');

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
		integer controller = 0;

		Matcher numOrderPattern = Pattern.compile('\\d\\w*').matcher(email.subject);

        
		while(numOrderPattern.find() && controller < 1) {
            controller += 1;
    		this.emailNumberOrder = numOrderPattern.group(0);
            System.debug('Paso 1 ----->> Se ha encontrado este email.subject ' + numOrderPattern.group(0));

		}

        System.debug('Paso 1 ----->> Se ha encontrado este email.subject ' + email.subject);
        System.debug('Paso 1 ----->> Se ha encontrado este numberOrder ' + this.emailNumberOrder);

        this.caseToUpdate = [SELECT Id, Status
                            FROM Case 
                            WHERE TXT_OrderNumber__c =:  this.emailNumberOrder LIMIT 1];

        System.debug('Tamaño de lo que antes que se encuentra ' + this.caseToUpdate.size());            
    }

    private void createCase(){

        Account cuentaPinkConect = [SELECT Id
                                    FROM Account
                                    LIMIT 1];
        System.debug('cuentaPinkConect ----->> cuentaPinkConect ' + cuentaPinkConect);
        Group marketPlaceQueue = getMarketPlaceQueue();
        System.debug('marketPlaceQueue ----->> marketPlaceQueue ' + marketPlaceQueue);

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