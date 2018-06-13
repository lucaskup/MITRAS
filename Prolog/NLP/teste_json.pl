:-use_module(library(http/json)).
:-use_module(library(http/json_convert)).
:-use_module(library(http/http_json)).


tratar_requisicao :-
	%:>writeln("output json"),
	reply_json(json([message="Nós viemos em paz"])).
	%:>writeln("enviado json").

responder_requisicao :-
	:>writeln('vai chamar t1'),
	t1(X,Y),
	:>writeln('chamou t1'),
	atom_concat(X,Y,XY),
	atom_string(XY,Mensagem),
	responder_requisicao(Mensagem).
responder_requisicao :-
	responder_requisicao('Nenhuma transformacao identificada').

responder_requisicao(Mensagem) :-
	reply_json(json([message=Mensagem])).