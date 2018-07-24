module empresa

one sig Empresa {
	repositorios: one Repositorio,
	funcionarios: one TimeCorretorDeBugs
}
one sig TimeCorretorDeBugs {
	diaDeTrabalho: one DiaDaSemana,
	corrigindo: one Bug
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



--predicados
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

pred relatorioOrganizadoDoBug {
	all r:Relatorio | one r.~relatorio	    //Todo relatorio está ligado a somente um bug
	all g:Gravidade | some g.~gravidade   //Toda gravidade está ligada a um relatorio
	all d:Descricao | one d.~descricao	   //Toda descrição está ligada a um relatorio
}

-- Retorna os projetos de um cliente
fun getProjetosOfCliente[c: Cliente]: Projeto {
	c.projetos
}

-- Retorna a versão atual de um projeto
fun getVersaoAtualDoProjeto[p: Projeto]: MaisAtual {
	p.pastas.maisAtual
}

-- Retorna os bugs de um projeto
fun getBugsDoProjeto[p: Projeto]: Bug {
	getVersaoAtualDoProjeto[p].bugs
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
	-- Corrigir os dias trabalhados para o time
	-- 3 Funções
	-- Time trabalhar apenas no bug cuja pasta é a mais recente

	> A empresa irá atribuir um time de caçadores de bugs para vasculhar no repositório os projetos em andamento que possuem bugs. 
	> O time irá atuar da seguinte forma: a cada dia irão selecionar um projeto de um cliente diferente para trabalhar; 
	> Sempre irão atuar na versão mais recente do projeto;
	> Não podem trabalhar dois dias consecutivos para identificar bugs de um mesmo cliente. 
	> Todos os bugs devem ser corrigidos pela equipe de desenvolvimento em uma semana. 
	> Somente após todos os bugs corrigidos é que o projeto volta a estar apto a uma nova revisão pela equipe caçadora de bugs.
*/
