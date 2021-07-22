@isTest
public with sharing class ValidaAprovadoDiretoTest {
    @TestSetup
    public static void setup() {
        Contact capitaoAmerica = new Contact(FirstName='Steve', LastName='Rogers', NomeDeGuerra__c='Capitão América', StatusCandidato__c='Aprovado direto');
        Contact viuvaNegra = new Contact(FirstName='Natasha', LastName='Romanoff', NomeDeGuerra__c='Viúva Negra', StatusCandidato__c='Aprovado no Treinamento');
        List<Contact> herois = new List<Contact>{capitaoAmerica, viuvaNegra};
        insert herois;
    }
}