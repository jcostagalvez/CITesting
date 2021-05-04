public inherited sharing class TestInboundEmailHandlerCase implements Messaging.InboundEmailHandler{

        private List<Case> caseToUpdate;

        public Messaging.InboundEmailHandler handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envolpe){

            setCase.size(); '(?<=@)((?![\\w]+\\.[\\w]+$)[\\w]+\\.)|(\\.[\\w]+$)';

            this.caseToUpdate > 0 ? UpdateCase(email) : createCase();
        }

        private void setCase(Messaging.InboundEmail email){

            Pattern numOrderPattern = Pattern.compile('(?<=\\W\\s)(.)(?<=\\d)(\\w+)');

            this.emailNumberOrder = numOrderPattern.matcher(email.subject);

            this.caseToUpdate= [SELECT Id 
                                FROM Case 
                                WHERE TXT_OrderNumber__c =:  emailNumberOrder LIMIT 1];
        }

        private createCase(){

            Account cuentaPinkConect = [SELECT Id
                                        FROM Account
                                        WHERE Name = 'Pink Connect' 
                                        LIMIT 1];

            Case  inboundCase = new Case(
                AccountId = cuentaPinkConect.Id,
                TXT_OrderNumber__c = this.emailNumberOrder
            );

            try {
                insert case;

            } catch (DmlException e) {
                System.debug('Ha sucedido este error al insertar el caso: ' + e);
            }
        }

        private UpdateCase(Messaging.InboundEmail email){
            
            CaseToUpdate.Status = 'Accepted';

            EmailMessage msg = new EmailMessage(
                CcAddress = email.ccAddresses,
                textBody = email.plainTextBody,
                HtmlBody = email.htmlBody,
                Headers = email.headers.toString(),
                FromName = email.fromName,
                Subject = email.subject,
                RelatedToId = caso.Id
            );

            try {

                update CaseToUpdate;
                insert msg;

            } catch (DmlException e) {

                System.debug('Ha sucedido este error al actualizar el caso o insertar el mensaje: ' + e);

            }

        }
}
