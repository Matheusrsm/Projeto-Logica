module empresa

sig Empresa{
	repositorios: one Repositorio
}

sig Repositorio{
	clientes: set Cliente
}

sig Cliente {
	projetos: some Projeto
}

sig Projeto{
	pastas: set Pasta,
	time: one Time,
	bug: set Bug
}

sig Pasta{
	subpastas: set SubPasta
}

sig SubPasta extends Pasta {
	versoes: set VersaoCodigo
}

sig VersaoCodigo {
}

sig Time {
	dias: set diasTrabalhados
}
sig diasTrabalhados {
	adj: diasTrabalhados -> lone Int
}

sig Bug {
	relatorio: one Relatorio
}

sig Relatorio {
	descricao: one Descricao,
	gravidade: one Gravidade
}

sig Descricao {
}

abstract sig Gravidade {
}

sig GravidadeUm extends Gravidade{
}

sig GravidadeDois extends Gravidade{
}

sig GravidadeTres extends Gravidade{
}

pred temUmRepositorio[e:Empresa] {
	one e.repositorios
}

fact {
	all r:Repositorio | one r.~repositorios
	all c:Cliente | one c.~clientes
	all r:Relatorio | one r.~relatorio
	all g:Gravidade | one g.~gravidade
	all d:diasTrabalhados | let x= d.(d.adj) | #x = 1 and some x => int[x] >=0 and int[x] <= 7
}

pred show[] {}
run show

