public with sharing class MarketPlaceServiceHandeler {

    private List<Case> caseToUpdate;
    private String emailNumberOrder;
    private MARKET_PLACES_EMAIL_SERVICE__mdt caseSettings;
    
    public MarketPlaceServiceHandeler(Messaging.InboundEmail email) {

        setCaseSettings(email.toAddresses);

        if(this.caseSettings.DeveloperName != 'La redoute'){

            setCase(email);

            if(this.caseToUpdate.size() != 0){

                updateCase(email);

            }else{

                createCase(email);
            }

        }else{

        }
    }

    private void setCaseSettings (List<String> EmailAdress){

        MARKET_PLACES_EMAIL_SERVICE__mdt caseSetting = [SELECT DeveloperName, Canal_comercial__c, Estado_a_cambiar_el_caso__c, Lenguaje__c, locale__c, Nombre_de_la_cuenta__c, Nombre_de_la_lista__c, Nombre_del_contacto__c,
                                                        Origen_del_caso__c, Patron_de_busqueda_de_Number_order__c
                                                        FROM MARKET_PLACES_EMAIL_SERVICE__mdt
                                                        WHERE Direccion_de_email__c IN: EmailAdress
                                                        LIMIT 1];

        this.caseSettings = caseSetting;

    }

    private emailMessage convertEmailInMessage(Messaging.InboundEmail email, String Id){

        EmailMessage msg = new EmailMessage(
            textBody = email.plainTextBody,
            HtmlBody = email.htmlBody,
            Headers = email.headers.toString(),
            FromName = email.fromName,
            Subject = email.subject,
            RelatedToId = Id,
            Incoming = true
        );
        
        return msg;
    }
    
    private Group getMarketPlaceQueue(){

        return [SELECT Id FROM Group WHERE  Type = 'Queue' AND DeveloperName =: this.caseSettings.Nombre_de_la_lista__c];
    }

    private void setCase(Messaging.InboundEmail email){

		integer controller = 0;

		Matcher numOrderPattern = Pattern.compile(this.caseSettings.Patron_de_busqueda_de_Number_order__c).matcher(email.subject);

		while(numOrderPattern.find() && controller < 1) {
            controller += 1;
    		this.emailNumberOrder = numOrderPattern.group(0);
		}

        this.caseToUpdate = [SELECT Id, Status
                            FROM Case 
                            WHERE TXT_OrderNumber__c =:  this.emailNumberOrder LIMIT 1];

    }

    private void createCase(Messaging.InboundEmail email){

        Account cuentaPinkConect = [SELECT Id, MAIL_ExternalId__c, Name,
                                    (SELECT Id 
                                    FROM Contacts
                                    WHERE Name =: this.caseSettings.Nombre_del_contacto__c
                                    Limit 1)
                                    FROM Account
                                    WHERE Name =: this.caseSettings.Nombre_de_la_cuenta__c
                                    LIMIT 1];

        
        Contact contactoPinkConect = cuentaPinkConect.Contacts;
        Group marketPlaceQueue = getMarketPlaceQueue();

        Case  inboundCase = new Case(
            ContactId = contactoPinkConect.Id,
            AccountId = cuentaPinkConect.Id,
            TXT_OrderNumber__c = this.emailNumberOrder,
            MAIL_ClientEmail__c = cuentaPinkConect.MAIL_ExternalId__c,
            Origin = this.caseSettings.Origen_del_caso__c,
            PICK_Locale__c = this.caseSettings.locale__c,
            PICK_Language__c = this.caseSettings.Lenguaje__c,
            PICK_CommercialChannel__c = this.caseSettings.Canal_comercial__c,
            Subject = email.subject,
            Description = email.plainTextBody,
            OwnerId = marketPlaceQueue.Id
        );


        try {

            insert inboundCase;


        } catch (DmlException e) {

            System.debug('Ha habido un erro al insertar el caso ---->' + e);
        }

// HASTA QUE SE CLARIFIQUE SI ES NECESARIO RECOGER EL PRIMER EMAIL, ESTO SE VA A QUEDAR COMENTADO


/*
       emailMessage msg = convertEmailInMessage(email, inboundCase.Id);
   
       try {

           insert msg;

       } catch (Exception e) {

        System.debug('Ha habido un erro al insertar el message ---->' + e);

       }
       */
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
