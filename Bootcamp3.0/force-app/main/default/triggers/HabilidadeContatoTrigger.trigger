trigger HabilidadeContatoTrigger on habilidadeContato__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

        HabilidadeContatoTriggerHandler triggerHandler = new HabilidadeContatoTriggerHandler();
    
        switch on Trigger.operationType{
            when BEFORE_INSERT{
    
                System.debug('>>> onBeforeInsert <<<');
                triggerHandler.onBeforeInsert(Trigger.new);
    
            }
    
            when BEFORE_UPDATE{
    
                System.debug('>>> onBeforeUpdate <<<');
                triggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);//Map<Id,habilidadeContato__c>
    
            }
    
    
            when AFTER_INSERT{
    
                System.debug('>>> onAfterInsert <<<');
                triggerHandler.onAfterInsert(Trigger.new);
    
            }
        }
    
    }
