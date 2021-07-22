trigger Contact on Contact (before insert, after insert, before update, after update, before delete) {
 

    ContacttriggerHandler handler = new ContacttriggerHandler();

    switch on Trigger.OperationType {
        when BEFORE_INSERT 
        {
            handler.onBeforeInsert(Trigger.new);   
        }
        when BEFORE_UPDATE 
        {
            handler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
            
        }
        when AFTER_INSERT 
        {
            handler.onAfterInsert(Trigger.new);
            
        }
        when AFTER_UPDATE 
        {
            handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
            
        }
        when BEFORE_DELETE 
        {
            handler.onAfterUpdate(Trigger.old, Trigger.oldMap);
            
        }
    }
}