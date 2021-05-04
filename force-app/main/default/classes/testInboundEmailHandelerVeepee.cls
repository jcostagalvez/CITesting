@isTest
public with sharing class testInboundEmailHandelerVeepee {
    @isTest
    public static void testInboundEmail() {
        Account cuentaPinkConect = new Account(
            Name = 'Pink Connect'
        );

        insert cuentaPinkConect;

        Case caseToInsert = New Case( 
            TXT_OrderNumber__c = '210212V041776886',
            AccountId = cuentaPinkConect.Id
        );

        insert caseToInsert;

        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       	Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
      
      	email.subject = ' 210212V041776886 - [210212V041776886] - Je n=92ai pas encore re=E7=u ma commande';
      	email.fromAddress = 'pinkconnect+notification-6053c306f24eb736350e9cb2@qasho=ps.com';
      	email.htmlBody = 'DESIGUAL: You got a new message Order 6005211 Order Number: 210212V041776886 Subject: 210212V041776886 - [210212V041776886] - Je n=92ai pas encore re=E7=u ma commande Message: Bonjour,<br>Ma commande reste bloqu=E9e sur le statut " en cours d=e preparation" depuis le 12 f=E9vrier. <br>J ai tent=E9 de contacter le ven=deur sans r=E9ponse. Merci de bien vouloir proc=E9der =E0 mon remboursement=.<br><br>Cordialement<br>Carine Dequeker';
      	email.plainTextBody = 'DESIGUAL: You got a new message Order 6005211 Order Number: 210212V041776886 Subject: 210212V041776886 - [210212V041776886] - Je n=92ai pas encore re=E7=u ma commande Message: Bonjour,<br>Ma commande reste bloqu=E9e sur le statut " en cours d=e preparation" depuis le 12 f=E9vrier. <br>J ai tent=E9 de contacter le ven=deur sans r=E9ponse. Merci de bien vouloir proc=E9der =E0 mon remboursement=.<br><br>Cordialement<br>Carine Dequeker';
        Messaging.InboundEmail.Header hditem= new Messaging.InboundEmail.Header(); 
        email.headers=new Messaging.InboundEmail.Header[1]; 
        hditem.name='Date'; 
        hditem.value='Tue, 28 Apr 2009 14:08:37 -0700'; 
        email.headers[0]= hditem;
        
        Messaging.InboundEmail email2 = new Messaging.InboundEmail() ;
       	Messaging.InboundEnvelope env2 = new Messaging.InboundEnvelope();
      
      	email2.subject = ' 235658V5656565 - [210212V041776886] - Je n=92ai pas encore re=E7=u ma commande';
      	email2.fromAddress = 'pinkconnect+notification-6053c306f24eb736350e9cb2@qasho=ps.com';
      	email2.htmlBody = 'DESIGUAL: You got a new message Order 6005211 Order Number: 210212V041776886 Subject: 210212V041776886 - [210212V041776886] - Je n=92ai pas encore re=E7=u ma commande Message: Bonjour,<br>Ma commande reste bloqu=E9e sur le statut " en cours d=e preparation" depuis le 12 f=E9vrier. <br>J ai tent=E9 de contacter le ven=deur sans r=E9ponse. Merci de bien vouloir proc=E9der =E0 mon remboursement=.<br><br>Cordialement<br>Carine Dequeker';
        email2.plainTextBody = 'DESIGUAL: You got a new message Order 6005211 Order Number: 210212V041776886 Subject: 210212V041776886 - [210212V041776886] - Je n=92ai pas encore re=E7=u ma commande Message: Bonjour,<br>Ma commande reste bloqu=E9e sur le statut " en cours d=e preparation" depuis le 12 f=E9vrier. <br>J ai tent=E9 de contacter le ven=deur sans r=E9ponse. Merci de bien vouloir proc=E9der =E0 mon remboursement=.<br><br>Cordialement<br>Carine Dequeker';
        email2.headers=new Messaging.InboundEmail.Header[1]; 
        hditem.name='Date'; 
        hditem.value='Tue, 28 Apr 2009 14:08:37 -0700'; 
        email2.headers[0]= hditem;
        
      Test.startTest();
    
      env.fromAddress = 'test@test.com';
      InboundEmailHandelerVeepee obj= new InboundEmailHandelerVeepee();
       obj.handleInboundEmail(email, env );
       obj.handleInboundEmail(email2, env2 );
      Test.stopTest();
        
        
    }
}