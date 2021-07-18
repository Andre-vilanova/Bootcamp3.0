global class ContactCreateTask {
    
    @InvocableMethod(label = 'Cria Tarefa para o contato')
    public  static void ContactCreateTask( List<CreateTaskRequest> requests){
        // Vai retorna as informações que estão chegando do process builder
        System.debug('>>> requests :: '+ requests);
        
        List<Id> listaContatosIds = new List<Id>();
        
        for(CreateTaskRequest Request : requests ){
            listaContatosIds.add(request.contactId);
        System.debug('>>> listaContatosIds :: '+listaContatosIds);    
        
        List<HabilidadeContato__c> listaHabilidadesContatos = [select Id, Contato__C, Habilidade__r.Name from HabilidadeContato__c WHERE Contato__c IN : listaContatosIds];
        System.debug('>>> listaHabilidadesContatos :: '+listaHabilidadesContatos);  
            
            Map<Id, List<String>> mapContatoHabilidades = new Map<Id, List<String>>();
            
            // pega todas as habilidades aqui 
            for(HabilidadeContato__c habilidadeContato : listaHabilidadesContatos){
                System.debug('>>>HabilidadesContato ::'+habilidadeContato.Habilidade__r.Name);
                
                if(mapContatoHabilidades.containsKey(habilidadeContato.Contato__c)){
                    //
                    mapContatoHabilidades.get(habilidadeContato.Contato__c).add(habilidadeContato.Habilidade__r.Name);
                    
                }else{
                    // adicionando valor dentro do mapa
                    mapContatoHabilidades.put(habilidadeContato.Contato__c,new list<String>{habilidadeContato.Habilidade__r.Name});
                }
            }
        
        createTasks(requests , mapContatoHabilidades);
        }
    }   
        
        public static void createTasks(List<CreateTaskRequest> requests, Map<Id, List<String>> mapContatoHabilidades){
            List<Task> tasksToInsert = new List<Task>();
             // Pegar oque precisa pra fazer a tarefa
        	for(CreateTaskRequest request : requests ){
            // Criando a tarefa para enviar pro cliente
            	Task tarefa = new Task();
            		tarefa.Subject = request.subject;
            		tarefa.WhoId = request.contactId;
                    tarefa.OwnerId = request.ownerId;
            		tarefa.Status = 'Open';
                	tarefa.Description = 'Por favor avalie este heroi. Suas habilidades são: '+ String.valueOf(mapContatoHabilidades.get(request.contactId));
             	tasksToInsert.add(tarefa);   
        	}
             if(!tasksToInsert.isEmpty()){
            	insert tasksToInsert;
        		}
            
        }
        
    global class CreateTaskRequest{
        @InvocableVariable(required=true)
        global string contactId;
        @InvocableVariable(required=true)
        global String ownerId;
        @InvocableVariable
        global String subject;
    }
}