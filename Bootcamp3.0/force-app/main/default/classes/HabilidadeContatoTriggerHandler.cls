public with sharing class HabilidadeContatoTriggerHandler {
    

        public void onBeforeInsert(List<habilidadeContato__c> newRecords){
    
            HabilidadeContatoTriggerHelper.ChecaCampo(newRecords);
    
        }
    
        public void onBeforeUpdate(List<habilidadeContato__c> newRecords,Map<Id,habilidadeContato__c> oldMap){
    
            HabilidadeContatoTriggerHelper.ChecaNullNivel(newRecords, oldMap);
    
        }
    
        public void onAfterInsert(List<habilidadeContato__c> newRecords){
    
            HabilidadeContatoTriggerHelper.OrdenaRanking(newRecords);
    
        }
    
    }

