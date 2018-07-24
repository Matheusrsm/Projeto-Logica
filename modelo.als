module empresa

one sig Empresa {
	repositorios: one Repositorio
}
one sig Repositorio{
	clientes: some Cliente
}
sig Cliente {
	projetos: some Projeto
}
sig Projeto {
	pastas: one Pasta
}
sig Pasta{
	maisAtual: one MaisAtual,
	versoesAnteriores: some VersaoAnterior
}
abstract sig SubPasta{
	bugs: set Bug
}
sig MaisAtual extends SubPasta{}
sig VersaoAnterior extends SubPasta{}

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
pred clienteLigadoRepositorio{
	all c:Cliente | one c.~clientes
}
pred projetoLigadoCliente{
	all p:Projeto | one p.~projetos
}
pred pastaLigadaProjeto{
	all p:Pasta | one p.~pastas
}
pred subPastaLigadaUmaPasta{
	all v:VersaoAnterior | one v.~versoesAnteriores 
}
pred todaPastaTemUmaVersaoAtual{
 	all m:MaisAtual | one m.~maisAtual
}
pred todoBugEstaEmAlgumaPasta{
	all b:Bug | one b.~bugs	
}
pred apenasUmBugPorPasta{
	all s:SubPasta | #s.bugs <= 1
}

pred relatorioOrganizadoDoBug{
	all r:Relatorio | one r.~relatorio		   //Todo relatorio está ligado a somente um bug
	all g:Gravidade | some g.~gravidade	   //Toda gravidade está ligada a um relatorio
	all d:Descricao | one d.~descricao	   //Toda descrição está ligada a um relatorio
}

--Fatos
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
assert temUmRepositorio{
	all e:Empresa | #e.repositorios = 1
}
assert todoClienteTemProjeto{
	all c:Cliente | #c.projetos > 0
}
assert todaPastaTemApenasUmaVersaoMaisAtual{
	all p:Pasta | #p.maisAtual = 1
}
check temUmRepositorio
check todoClienteTemProjeto
check todaPastaTemApenasUmaVersaoMaisAtual


pred show[] {}
run show for 5
