:-use_module(library(http/json)).
:-use_module(library(http/json_convert)).
:-use_module(library(http/http_json)).

% Predicate for starting MITRAS, setups all the agents and starts prolog webserver
mitras_start :-
	start_agent(webserver_agent, setup_webs_agent),
	start_agent(nlp_agent, setup_nlp_agent),
	start_agent(transf_agent, setup_transf_agent),
	start_web_server(8090).
% Predicate for stoping MITRAS, stops all agents and stops prolog webserver
mitras_stop :-
	stop_web_server(8090),
	stop_agent(webserver_agent),
	stop_agent(nlp_agent).

% Code for NLP agent
setup_nlp_agent :- 
	writeln('Starting NLP Agent'),
	start_console,
	snlp_parse('I need'),
	handle_event(receber(Mensagem) << webserver_agent,
		parse_frase(Mensagem)),
	writeln('NLP Agent Started').

parse_frase(Frase) :-
	:>writeln('Comunicacao do Agente wesag'),
	%assertz(vouparser(Frase)),
	snlp_parse(Frase),
	t1(X,Y),
	++what(X),
	++where(Y),
	:>writeln('Frase Parseada'),
	:>writeln(X),
	:>writeln(Y),
	responder('Teste assincrono') >> webserver_agent,
	transform >> transf_agent.

% Code for Transformation Agent
setup_transf_agent :-
	writeln('Starting Web Server Agent'),
	start_console,
	handle_event(transform << nlp_agent,
		try_transform).

try_transform :-
	:>writeln('todo: fazer as transformações').

% Code for webserver agent
setup_webs_agent :- 
	writeln('Starting Web Server Agent'),
	start_console,
	handle_event(htpost(CliAddr,PathList,ParList,Content),
		websag_handle_htpost(CliAddr,PathList,ParList,Content) ),
	handle_event(htget(CliAddr,PathList,ParList),
		websag_handle_htget(CliAddr,PathList,ParList) ),
	handle_event(responder(Frase) << nlp_agent,
		registrar_proxima_resposta(Frase)),
	writeln('Web Server Agent Started').
registrar_proxima_resposta(Frase) :-
	++resposta(Frase).

websag_handle_htget(_ClientAddr,[mitras],_ParList) :-
	!,
 	:> writeln('recebeu mitras GET'),
 	responder_requisicao,
 	:>writeln('Respondeu GET').

 websag_handle_htpost(_ClientAddr,[mitras],_ParList, Content) :-
	!,
 	:> writeln('recebeu mitras POST'),
 	:> writeln(Content),
 	trata_post(Content,Mensagem),
 	:>writeln(Mensagem),
 	receber(Mensagem) >> nlp_agent,
 	:>writeln('Realizou parse'),
 	responder_requisicao_ok,
 	:>writeln('Respondeu POST').

 trata_post(Dados,Mensagem) :-
 	atom_string(Dados,X),
 	split_string(X,"=","",[_|Y]),
 	atomic_list_concat(Y,Z),
 	atomic_list_concat(A,'+',Z),
 	atomic_list_concat(A,' ',Mensagem).

responder_requisicao_ok :-
	reply_json(json([status="OK"])).

responder_requisicao :-
	??resposta(X),
	--resposta(X),
	responder_requisicao(X).

responder_requisicao :-
	reply_json(json([status="Empty"])).

responder_requisicao(Mensagem) :-
	reply_json(json([message=Mensagem])).