public with sharing class AtualizaRankingHabilidadeTrigger {
    
    private List<HabilidadeContato__c> lstDataNew;
    private Map<Id, HabilidadeContato__c> mapDataOld;
    private Map<Id, HabilidadeContato__c> mapObjFiltered;
    private Boolean hasRecords;
    
    public AtualizaRankingHabilidadeTrigger(List<HabilidadeContato__c> lstDataNew, Map<Id, HabilidadeContato__c> mapDataOld) 
    {
        this.lstDataNew = lstDataNew;
        this.mapDataOld = mapDataOld;
        filter();
        this.hasRecords = mapObjFiltered != null && !mapObjFiltered.isEmpty();
    }
    
    private void addMapFiltered(HabilidadeContato__c item)
    {
        if(mapObjFiltered == null)
            mapObjFiltered = new Map<Id, HabilidadeContato__c>();
        
        mapObjFiltered.put(item.Id, item);
    }
    
    private void filter() {
        
        if(this.lstDataNew != null){ //insert or update
            
            for(HabilidadeContato__c itemNew : this.lstDataNew)
            {
                HabilidadeContato__c itemOld = this.mapDataOld.get(itemNew.Id);
                
                if(
                    (itemOld == null && itemNew.Level__c != null) //insert && Level preenchido
                    ||
                    (itemOld != null && itemNew.Level__c != itemOld.Level__c) //update && Level preenchido
                ){
                    addMapFiltered(itemNew);
                }
                
            }
            
        }else{ //delete
            
            for(HabilidadeContato__c itemOld : this.mapDataOld.values()){
            	
                if(itemOld.Level__c != null) //possuia Level preenchido
                { 
                    addMapFiltered(itemOld);
                }
                
            }
        } 
    }
    
    public void run() {
    	if (hasRecords) 
        {
            Set<Id> idsContato = new Set<Id>();

            for(HabilidadeContato__c habilidadeContato : this.mapObjFiltered.values())
            {
                idsContato.add(habilidadeContato.Contato__c);
            }
            
            Map<Id,Contact> mapContatosRevisarRanking = new Map<Id,Contact>([SELECT Id, 

                    (SELECT Id, Name, Level__c 
                    FROM HabilidadesContato__r 
                    WHERE Level__c != null 
                    ORDER BY Level__c DESC, Habilidade__r.Name) 
                    FROM Contact 
                    WHERE Id in : idsContato]);
            
            List<HabilidadeContato__c> habilidadesParaAtualizarRanking = new List<HabilidadeContato__c>();
            for(Contact contato : mapContatosRevisarRanking.values())
            {
                if(!contato.HabilidadesContato__r.isEmpty())
                {
                    Integer ranking = 1;
                    for(HabilidadeContato__c habilidadeContato : contato.HabilidadesContato__r)
                    {
                        habilidadeContato.Ranking__c = ranking++;
                        habilidadesParaAtualizarRanking.add(habilidadeContato);
                    }
                }
            }

            TriggerHandler.bypass('HabilidadeContatoTriggerHandler');
            update habilidadesParaAtualizarRanking;
            TriggerHandler.clearBypass('HabilidadeContatoTriggerHandler');
        }        
    }
    
}
