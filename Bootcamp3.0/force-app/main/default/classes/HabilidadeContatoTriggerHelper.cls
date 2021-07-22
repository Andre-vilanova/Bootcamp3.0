public with sharing class HabilidadeContatoTriggerHelper {  

        public static void ChecaCampo(List<HabilidadeContato__c> newRecords){
            for(HabilidadeContato__c habCont: newRecords){
                if (habCont.Level__c == null) {
                    habCont.addError('Valor nível de habilidade inválido!');
                }
            }
        }
    
        public static void OrdenaRanking(List<HabilidadeContato__c> newRecords){
    
            List<HabilidadeContato__c> habCont = new List<HabilidadeContato__c>();
    
            if(newRecords.size() == 1){
                //habCont = [SELECT Id, contato__c, nivelHabilidade__c, habilidadeContato__c.ranking__c FROM habilidadeContato__c WHERE contato__c = :newRecords[0].contato__c AND nivelHabilidade__c != NULL  ORDER BY nivelHabilidade__c DESC];
                habCont = [SELECT Id, Contato__c, Level__c, HabilidadeContato__c.Ranking__c FROM HabilidadeContato__c WHERE Contato__c = :newRecords[0].Contato__c AND Level__c != NULL  ORDER BY Level__c DESC];
            }
    
            List<HabilidadeContato__c> newHabCont = new List<HabilidadeContato__c>();
    
            for (Integer i = 0 ; i < habCont.size(); i++){
                habCont[i].Ranking__c = i + 1;
                System.debug('olha o reg: ' + habCont[i]);
                newHabCont.add(habCont[i]);
            }
    
            update newHabCont;
    
        }
    
        public static void ChecaNullNivel(List<HabilidadeContato__c> newRecords, Map<Id,HabilidadeContato__c> oldMap){
            for (habilidadeContato__c hc : newRecords){
                System.debug('show hc: ' + newRecords);
                if (hc.Level__c == null) {
                    hc.addError('Valor nível de habilidade não pode ficar em branco!');
                }
            }
        }
    }

