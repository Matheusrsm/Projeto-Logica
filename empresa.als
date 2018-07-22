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
	pasta: one Pasta,
	time: one Time,
	bugs: set Bug
}

sig Pasta {
	subpastas: set SubPasta
}

sig SubPasta {
	versoes: set VersaoCodigo
}

abstract sig VersaoCodigo {
}

sig VersaoAntiga extends VersaoCodigo{}

one sig UltimaVersao extends VersaoCodigo {}

one sig Time {
	dias: set diaDaSemana,
	projetoAtual: diaDaSemana one -> one Projeto
}

sig diaDaSemana {
}

one sig Segunda, Terca, Quarta, Quinta, Sexta extends diaDaSemana {
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
	
	all r:Repositorio | one r.~repositorios	   //Todo repositorio está ligado a somente um empresa
	all p:Projeto | one p.~projetos		   // Todo projeto está ligado a somente um cliente
	all c:Cliente | one c.~clientes		   //Todo cliente está ligado a somente um repositorio
	all p:Pasta | one p.~pasta		   //Toda pasta está ligada a um projeto
	all s:SubPasta | one s.~subpastas 	   //Toda subpasta está ligada a somente uma pasta
	all b:Bug | one b.~bugs			   //Todo bug está ligado a somente um projeto
	all r:Relatorio | one r.~relatorio		   //Todo relatorio está ligado a somente um bug
	all g:Gravidade | some g.~gravidade	   //Toda gravidade está ligada a um relatorio
	all d:Descricao | one d.~descricao	   //Toda descrição está ligada a um relatorio
}

--Falta corrigir:
	-- Fazer uma pasta poder ter mais de uma subpasta
	-- Fazer toda subpasta ter uma ultima versão
	-- Time trabalhar para projetos de um cliente por no maximo dois dias 
	-- Corrigir os dias trabalhados para o time

pred show[] {}
run show for 5

