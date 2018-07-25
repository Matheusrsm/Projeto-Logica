module empresa

sig TimeCorretorDeBugs {
	corrigindo: DiaDaSemana -> VersaoMaisAtual
}

abstract sig DiaDaSemana {}
one sig Segunda, Terca, Quarta, Quinta, Sexta extends DiaDaSemana {}

one sig Repositorio {
	clientes: some Cliente
}
sig Cliente {
	projetos: some Projeto
}
sig Projeto {
	pastas: one Pasta
}
sig Pasta {
	maisAtual: one VersaoMaisAtual,
	versoesAnteriores: some VersaoAnterior
}
abstract sig Versao {
	bugs: set Bug
}
sig VersaoMaisAtual extends Versao {
}
sig VersaoAnterior extends Versao {}

sig Bug {
	relatorio: one Relatorio
}
sig Relatorio {
	descricao: one Descricao,
	gravidade: one Gravidade
}
sig Descricao {}
abstract sig Gravidade {}
one sig GravidadeUm, GravidadeDois, GravidadeTres extends Gravidade {}

--Funções
-- Retorna os projetos de um cliente
fun getProjetosOfCliente[c: Cliente]: Projeto {
	c.projetos
}
-- Retorna a versão atual de um projeto
fun getVersaoAtualDoProjeto[p: Projeto]: VersaoMaisAtual {
	p.pastas.maisAtual
}
-- Retorna o bug mais atual de um projeto
fun getBugsDoProjeto[p: Projeto]: Bug {
	getVersaoAtualDoProjeto[p].bugs
}

--Predicados
pred clienteLigadoRepositorio {
	all c:Cliente | one c.~clientes
}
pred projetoLigadoCliente {
	all p:Projeto | one p.~projetos
}
pred pastaLigadaProjeto {
	all p:Pasta | one p.~pastas
}
pred subPastaLigadaUmaPasta {
	all v:VersaoAnterior | one v.~versoesAnteriores 
}
pred todaPastaTemUmaVersaoAtual {
 	all m:VersaoMaisAtual | one m.~maisAtual
}
pred todoBugEstaEmAlgumaPasta {
	all b:Bug | one b.~bugs	
}
pred apenasUmBugPorPasta {
	all s:Versao | #s.bugs <= 1
}
pred timeCorrigeApenasVersoesComBug{
	all t:TimeCorretorDeBugs | #t.corrigindo.bugs =1
}
pred temTimes {
	all t:TimeCorretorDeBugs | #t.corrigindo > 0
}

pred relatorioOrganizadoDoBug {
	all r:Relatorio | one r.~relatorio	    //Todo relatorio está ligado a somente um bug
	all g:Gravidade | some g.~gravidade   //Toda gravidade está ligada a um relatorio
	all d:Descricao | one d.~descricao	   //Toda descrição está ligada a um relatorio
}

--fatos
fact {
	clienteLigadoRepositorio
	projetoLigadoCliente
	pastaLigadaProjeto
	subPastaLigadaUmaPasta
	todaPastaTemUmaVersaoAtual
	todoBugEstaEmAlgumaPasta
	apenasUmBugPorPasta
	relatorioOrganizadoDoBug
	temTimes
}

--asserts
assert todoRepositorioTemCliente {
	all r:Repositorio | #r.clientes > 0
}
assert todoClienteTemProjeto {
	all c:Cliente | #c.projetos > 0
}
assert todaPastaTemApenasUmaVersaoMaisAtual {
	all p:Pasta | #p.maisAtual = 1
}

check todoRepositorioTemCliente
check todoClienteTemProjeto
check todaPastaTemApenasUmaVersaoMaisAtual


pred show[] {}
run show for 5

/* 
--Requisitos Faltando:
	-- Time trabalhar para projetos de um cliente por no maximo dois dias por semana 
	> A cada dia irão selecionar um projeto de um cliente diferente para trabalhar; 
	> Não podem trabalhar dois dias consecutivos para identificar bugs de um mesmo cliente. 
	> time trabalhar apenas em versões com bugs
	> times trabalhando em um projetos por dia
*/
