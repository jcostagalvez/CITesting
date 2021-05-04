trigger OrderEventTrigger on Order_Event__e (after insert) {
    
    list<Task> taskList = new list<Task>();

    for(Order_Event__e e: trigger.new){
        if(e.Has_Shipped__c == true){

            Task t = new Task(
                Priority = 'Medium',
                Subject = 'Follow up on shipped order ' + e.Order_Number__c,
                OwnerId = e.CreatedById
            );

            taskList.add(t);

        }
    }

    try {

        insert taskList;

    } catch (DmlException dml) {

        System.debug(dml);

    }

}