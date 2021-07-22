public with sharing class ContactTriggerHelper {
    // Vai tratar quais são as ações pra cada metodo do handler
    public ContactTriggerHelper() {}

    public static void criaTarefaParaEncontrarFraquezas(List<Contact> newRecords)
    {
        List<Task> taskToInsert = new List<Task>();
        for (Contact contato : newRecords) 
        {   
            Id vilaoId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Vilão').getRecordTypeId();
            if (contato.RecordTypeId == vilaoId)
            {
                Task tarefa = new Task();
                    tarefa.Subject = 'Descobrir fraquezas do vilão';
                    tarefa.OwnerId = contato.OwnerId;
                    tarefa.WhoId = contato.Id;
                    tarefa.Status = 'Open';
                taskToInsert.add(tarefa);    
            }
        }
        if (!taskToInsert.isEmpty()) 
        {
            insert taskToInsert;   
        }
    }

    public static void naoPermiteApagarQuandoExisteTaskEmAberto(List<Contact> oldRecords, Map<Id, Contact> oldMap)
    {
        List<Task> tasks = [SELECT id, status, whoId FROM task WHERE whoId IN :oldRecords and status != 'Completed'];
        //[SELECT ID FROM Contact WHERE Id IN (SELECT WHOID FROM Task WHERE STATUS != 'Completed' AND WHOID IN :oldRecords) AND WHOID IN :oldRecords];
        for (Task tarefa : tasks) 
        {
            oldMap.get(tarefa.whoId).addError('Não é possivel deletar contatos com tarefas em aberto!!!');  
        }
    }
}
