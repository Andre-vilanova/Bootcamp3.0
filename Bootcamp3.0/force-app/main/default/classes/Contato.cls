public virtual class Contato {
    private String nome;
    private String email;
    
    public Contato( String nome, String email){
        this.nome = nome; 
        this.email = email; 
    }
    
    // 
    public void informaDados(){
        system.debug('>>> :: ' +this.nome);
        system.debug('>>> :: ' +this.email);
        
    }
    // Percorre a lista e exibe todos os contatos
    public static void mostrarTodosContatos(List<Contato> contatos){
        // for(int i=; <contato.size(); i++) = iteração
        for (Contato personagem : contatos){
        System.debug('>>>personagens ::'+ personagem);
            }
    }   
}