@isTest
public class AtualizaRankingHabilidadeTriggerTest {

    @testSetup
    public static void setup(){
        //Habilidade do Contato
        //Contato
        //Habilidade
    
    	Contact capitaoAmerica = new Contact(FirstName='Steve', LastName='Rogers', NomeGuerra__c='Capitão América', StatusCandidato__c='Aprovado direto');
    	Contact viuvaNegra = new Contact(FirstName='Natasha', LastName='Romanoff', NomeGuerra__c='Viúva Negra', StatusCandidato__c='Aprovado no Treinamento');
        
        List<Contact> herois = new List<Contact> {capitaoAmerica, viuvaNegra};
        insert herois;
        
        Habilidade__c arteMarcial = new Habilidade__c(Name='Arte Marcial');
        Habilidade__c atirador = new Habilidade__c(Name='Atirador');
        Habilidade__c superForca = new Habilidade__c(Name='Super Força');
        
        List<Habilidade__c> habilidades = new List<Habilidade__c>{superForca, atirador, arteMarcial};
        insert habilidades;
        
        HabilidadeContato__c habilidadeContato1 = new HabilidadeContato__c();
        habilidadeContato1.Contato__c = capitaoAmerica.Id;
        habilidadeContato1.Habilidade__c = superForca.Id;
        habilidadeContato1.Level__c = 90;
        
        HabilidadeContato__c habilidadeContato2 = new HabilidadeContato__c();
        habilidadeContato2.Contato__c = capitaoAmerica.Id;
        habilidadeContato2.Habilidade__c = arteMarcial.Id;
        habilidadeContato2.Level__c = 80;
        
        HabilidadeContato__c habilidadeContato3 = new HabilidadeContato__c();
        habilidadeContato3.Contato__c = capitaoAmerica.Id;
        habilidadeContato3.Habilidade__c = atirador.Id;
        habilidadeContato3.Level__c = 50;
        
        HabilidadeContato__c habilidadeContato4 = new HabilidadeContato__c();
        habilidadeContato4.Contato__c = viuvaNegra.Id;
        habilidadeContato4.Habilidade__c = arteMarcial.Id;
        habilidadeContato4.Level__c = 70;
        
        HabilidadeContato__c habilidadeContato5 = new HabilidadeContato__c();
        habilidadeContato5.Contato__c = viuvaNegra.Id;
        habilidadeContato5.Habilidade__c = atirador.Id;
        
        List<HabilidadeContato__c> habilidadesContato = new List<HabilidadeContato__c>{habilidadeContato1, habilidadeContato2, habilidadeContato3, habilidadeContato4, habilidadeContato5};
        insert habilidadesContato;
    }
    
    @isTest
    public static void validaNovoRankingAfterInsert(){
        List<HabilidadeContato__c> habilidadesContato = [SELECT Id, Habilidade__r.Name, NomeHabilidade__c, Ranking__c 
                                                         FROM  HabilidadeContato__c 
                                                         WHERE Contato__r.NomeGuerra__c = 'Capitão América'
                                                         AND Ranking__c != null];
        
        //System.debug('XXXXXX');
        //System.assert(habilidadesContato.size() == 3);
        System.assertEquals(3, habilidadesContato.size());
        
        for(HabilidadeContato__c habilidadeContato : habilidadesContato){
            switch on habilidadeContato.NomeHabilidade__c {
                when 'Super Força'{
                    system.assertEquals(1, habilidadeContato.Ranking__c);
                }
                when 'Arte Marcial'{
                    system.assertEquals(2, habilidadeContato.Ranking__c);
                }
                when 'Atirador'{
                    system.assertEquals(3, habilidadeContato.Ranking__c);
                }
                when else{
                    //do nothing
                }
                
            }
            
        }
        
    }
    
    @isTest
    public static void validaQuandoRankingNulo(){ //sugestão de outro nome de método: deveManterRankingNuloQuandoLevelNaoPreenchido
        HabilidadeContato__c habilidadeContato = [SELECT Id, Level__c, Ranking__c 
                                                  FROM HabilidadeContato__c 
                                                  WHERE Contato__r.NomeGuerra__c = 'Viúva Negra'
                                                  AND Habilidade__r.Name = 'Atirador'];
        
        system.assertEquals(null, habilidadeContato.Ranking__c);
    }
    
    @isTest
    public static void validaNovoRankingAfterUpdate(){
        List<HabilidadeContato__c> habilidadesContato = [SELECT Id, Habilidade__r.Name, NomeHabilidade__c, Ranking__c, Level__c 
                                                         FROM HabilidadeContato__c
                                                         ORDER BY Contato__r.NomeGuerra__c, NomeHabilidade__c];
        
        //Capitão América - Arte Marcial [0]
        //Capitão América - Atirador [1]
        //Capitão América - Super Força [2]
        //Viúva Negra - Arte Marcial [3]
        //Viúva Negra - Atirador [4]
        
        habilidadesContato[0].Level__c = 95;
        habilidadesContato[4].Level__c = 85;
        
        update habilidadesContato;
        
        List<HabilidadeContato__c> habilidadesContatoAfterUpdate = [SELECT Id, Habilidade__r.Name, NomeHabilidade__c, Ranking__c 
                                                         FROM HabilidadeContato__c
                                                         ORDER BY Contato__r.NomeGuerra__c, NomeHabilidade__c];
        
        system.assertEquals(1, habilidadesContatoAfterUpdate[0].Ranking__c); //Capitão América - Arte Marcial
        system.assertEquals(3, habilidadesContatoAfterUpdate[1].Ranking__c); //Capitão América - Atirador
        system.assertEquals(2, habilidadesContatoAfterUpdate[2].Ranking__c); //Capitão América - Super Força
        system.assertEquals(2, habilidadesContatoAfterUpdate[3].Ranking__c); //Viúva Negra - Arte Marcial
        system.assertEquals(1, habilidadesContatoAfterUpdate[4].Ranking__c); //Viúva Negra - Atirador
        
    }
    
    @isTest
    public static void validaNovoRankingAfterDelete(){
    	HabilidadeContato__c habilidadeArteMarcialCapitao = [SELECT Id, Habilidade__r.Name, NomeHabilidade__c, Ranking__c 
                                                         FROM  HabilidadeContato__c 
                                                         WHERE Contato__r.NomeGuerra__c = 'Capitão América'
                                                         AND NomeHabilidade__c = 'Arte Marcial'];
        
        delete habilidadeArteMarcialCapitao;
        
        List<HabilidadeContato__c> habilidadesCapitao = [SELECT Id, Habilidade__r.Name, NomeHabilidade__c, Ranking__c 
                                                         FROM  HabilidadeContato__c 
                                                         WHERE Contato__r.NomeGuerra__c = 'Capitão América'
                                                         ORDER BY NomeHabilidade__c
                                                        ];
        
        system.assertEquals(2, habilidadesCapitao[0].Ranking__c); //Capitão América - Atirador
        system.assertEquals(1, habilidadesCapitao[1].Ranking__c); //Capitão América - Super Força
    }
}