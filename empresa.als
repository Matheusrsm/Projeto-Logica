module empresa

one sig Empresa {
	repositorios: one Repositorio,
	funcionarios: one TimeCorretorDeBugs
}
one sig TimeCorretorDeBugs {
	diaDeTrabalho: one DiaDaSemana,
	corrigindo: one MaisAtual
}
one abstract sig DiaDaSemana {}
sig Segunda, Terca, Quarta, Quinta, Sexta extends DiaDaSemana {}

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
	maisAtual: one MaisAtual,
	versoesAnteriores: some VersaoAnterior
}
abstract sig SubPasta {
	bugs: set Bug
}
sig MaisAtual extends SubPasta {
}
sig VersaoAnterior extends SubPasta {}

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
fun getVersaoAtualDoProjeto[p: Projeto]: MaisAtual {
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
 	all m:MaisAtual | one m.~maisAtual
}
pred todoBugEstaEmAlgumaPasta {
	all b:Bug | one b.~bugs	
}
pred apenasUmBugPorPasta {
	all s:SubPasta | #s.bugs <= 1
}
pred timeCorrigeApenasVersoesComBug{
	all t:TimeCorretorDeBugs | #t.corrigindo.bugs =1
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
}

--asserts
assert temUmRepositorio {
	all e:Empresa | #e.repositorios = 1
}
assert todoClienteTemProjeto {
	all c:Cliente | #c.projetos > 0
}
assert todaPastaTemApenasUmaVersaoMaisAtual {
	all p:Pasta | #p.maisAtual = 1
}

check temUmRepositorio
check todoClienteTemProjeto
check todaPastaTemApenasUmaVersaoMaisAtual


pred show[] {}
run show for 5

/* 
--Requisitos Faltando:
	-- Time trabalhar para projetos de um cliente por no maximo dois dias 
	-- Dias trabalhados para o time
	> A cada dia irão selecionar um projeto de um cliente diferente para trabalhar; 
	> Não podem trabalhar dois dias consecutivos para identificar bugs de um mesmo cliente. 
	> Todos os bugs devem ser corrigidos pela equipe de desenvolvimento em uma semana. 
*/
