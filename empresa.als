module empresa

sig Empresa{
	repositorios: set Repositorio
}

sig Repositorio{
	clientes: set Cliente
}

sig Cliente {
	projetos: set Projeto
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
}

sig Bug {
	relatorio: one Relatorio
}

sig Relatorio {
	descricao: set Descricao,
	gravidade: one Gravidade
}

sig Descricao {
}

abstract sig Gravidade {
}

sig GravidadeUm in Gravidade{
}

sig GravidadeDois in Gravidade{
}

sig GravidadeTres in Gravidade{
}

pred temUmRepositorio[e:Empresa] {
	one e.repositorios
}

fact {
	all e:Empresa | temUmRepositorio[e]
}

