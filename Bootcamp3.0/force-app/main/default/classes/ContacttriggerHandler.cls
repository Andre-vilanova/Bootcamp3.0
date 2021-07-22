public with sharing class ContacttriggerHandler {
    //Vai tratar as ações que chegaram da trigger

    public ContacttriggerHandler() {}

    public void onBeforeInsert(List<Contact> newRecords)
    {
        System.debug('>>> onBEFOREInsert<<<');
    }

    public void onBeforeUpdate(List<Contact> newRecords, Map<Id, Contact> oldMap )
    {
        System.debug('>>> onBeforeUpdate<<<');
    }

    public void onAfterInsert(List<Contact> newRecords)
    {
        System.debug('>>>onAfterInsert<<<');

        ContactTriggerHelper.criaTarefaParaEncontrarFraquezas(newRecords);
    }


    public void onAfterUpdate(List<Contact> newRecords, Map<Id, Contact> oldMap)
    {
        System.debug('>>> onAfterUpdate<<<');
    }

    public void onBeforeDelete(List<Contact> newRecords, Map<Id, Contact> oldMap)
    {
        ContactTriggerHelper.naoPermiteApagarQuandoExisteTaskEmAberto(newRecords, oldMap);
    }

}
