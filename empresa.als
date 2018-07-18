module empresa

one sig Empresa {
	repositorios: one Repositorio
}

sig Repositorio{
	clientes: set Cliente
}

sig Cliente {
	projetos: set Projeto
}

sig Projeto {
	pastas: one Pasta,
	time: one Time,
	bug: set Bug
}

sig Pasta {
	subpastas: some SubPasta
}

sig SubPasta {
	versoes: set VersaoCodigo
}

sig VersaoCodigo {
}

one sig UltimaVersao extends VersaoCodigo {
}

one sig Time {
	dias: set diasTrabalhados
}

sig diasTrabalhados {
}

one sig Segunda, Terca, Quarta, Quinta, Sexta extends diasTrabalhados {
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

sig GravidadeUm, GravidadeDois, GravidadeTres extends Gravidade {
}

pred temUmRepositorio[e:Empresa] {
	one e.repositorios
}

fact {
	all r:Repositorio | one r.~repositorios
	all c:Cliente | one c.~clientes
	all r:Relatorio | one r.~relatorio
	all g:Gravidade | one g.~gravidade
	all p:Projeto | one p.~projetos
}

pred show[] {}
run show

