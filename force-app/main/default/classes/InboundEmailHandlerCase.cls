public inherited sharing class InboundEmailHandlerCase implements Messaging.InboundEmailHandler{

    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        try {

            case caseToAtachEmail = getCase(email.fromAddress);
            createrecord(caseToAtachEmail, email);
            responseRecord(caseToAtachEmail, email);

        } catch (Exception ex) {
           result.success = false;
           result.message = ex.getMessage(); 
        }
        // Get the order Number in the subject by a metadata object with a regular expresion to get the number

        // Search the order number related with a case, and see if exist a case, 

            //if doesnt exit create a new case, related to the "Pink Connect" contact

            //if exit the case, update with the info in the body

            

        return result;
        // Atach the email to the case related email list
    }
    
    private Case getCase(String email){

        list<Case> caseList = [
            SELECT SuppliedEmail 
            FROM Case
            WHERE SuppliedEmail =: email
            LIMIT 1
        ];

        System.debug(caseList);

        return caseList.size() > 0 ? caseList[0]: new Case(SuppliedEmail = email);
    } 

    private EmailMessage getEmailSend(string caseId){

        List<EmailMessage> emailRecived = [
            SELECT MessageDate, FromName, Subject 
            FROM EmailMessage
            WHERE RelatedToId =: caseId
            ORDER BY MessageDate DESC
            LIMIT 1
        ];

        return emailRecived [0];
    }

    private void createrecord (Case caso, Messaging.InboundEmail email){

        EmailMessage msg = new EmailMessage(
            textBody = email.plainTextBody,
            Headers = email.headers.toString(),
            FromName = email.fromName,
            Subject = email.subject,
            RelatedToId = caso.Id
        );

        try {
            insert msg;
        } catch (DmlException dml) {
            system.debug(dml);
        }{

        }
    }
        
        private void responseRecord (Case caso, Messaging.InboundEmail email){

            EmailMessage messagerecived = getEmailSend(caso.Id);

            EmailMessage msg2 = new EmailMessage(
                textBody = 'Estamos mirandolo',
                Headers = email.headers.toString(),
                FromName = email.fromName,
                Subject = 'RE:' + messagerecived.Subject,
                Incoming = false,
                RelatedToId = caso.Id
            );
    
            try {
    
                insert msg2;
    
            } catch (DmlException dml) {
                system.debug(dml);
            }{
    
            }
    }

}