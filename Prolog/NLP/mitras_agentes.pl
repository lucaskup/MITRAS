:-use_module(library(http/json)).
:-use_module(library(http/json_convert)).
:-use_module(library(http/http_json)).
mitras_server_port(8091).

% Predicate for starting MITRAS, setups all the agents and starts prolog webserver
mitras_start :-
	start_agent(webserver_agent, setup_webs_agent),
	start_agent(nlp_agent, setup_nlp_agent),
	start_agent(transf_agent, setup_transf_agent),
	mitras_server_port(Porta),
	start_web_server(Porta).
% Predicate for stoping MITRAS, stops all agents and stops prolog webserver
mitras_stop :-
	
	control_agent(webserver_agent),
	stop_console,
	release_agent,
	control_agent(nlp_agent),
	stop_console,
	release_agent,
	control_agent(transf_agent),
	stop_console,
	release_agent,

	stop_agent(webserver_agent),
	stop_agent(nlp_agent),
	stop_agent(transf_agent),
	mitras_server_port(Porta),
	stop_web_server(Porta).

% Code for NLP agent
setup_nlp_agent :- 
	writeln('Starting NLP Agent'),
	start_console,
	snlp_parse('I need'),
	handle_event(receber(Mensagem) << webserver_agent,
		parse_frase(Mensagem)),
	writeln('NLP Agent Started'),
	:>writeln('NLP AGENT READY').

parse_frase(Frase) :-
	:>writeln('Comunicacao do Agente wesag'),
	%assertz(vouparser(Frase)),
	:>writeln(Frase),
	(log_requests -> 
		get_time(Time), 
		stamp_date_time(Time,Date,10800),
		format_time(atom(FormatedDate),'%Y%m%d%H%M%s',Date),
		assertz(log_frase(Frase,FormatedDate)) 
		;true),
	snlp_parse(Frase),
	:>writeln('Frase Parseada'),
	avaliar_transformacoes,	
	:>writeln('Transformações avaliadas'),
	??resposta(R),
	responder(R) >> webserver_agent,
	--resposta(R),
	--what(_),
	--where(_),
	transform >> transf_agent.

% Code for Transformation Agent
setup_transf_agent :-
	writeln('Starting Web Server Agent'),
	start_console,
	handle_event(transform << nlp_agent,
		try_transform),
	:>writeln('TRANSFORMATION AGENT READY').

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
	handle_event(htoptions(CliAddr,PathList,ParList),
		websag_handle_htoptions(CliAddr,PathList,ParList) ),
	handle_event(responder(Frase) << nlp_agent,
		registrar_proxima_resposta(Frase)),
	writeln('Web Server Agent Started'),
	:>writeln('WEBSAG AGENT READY').
	
registrar_proxima_resposta(Frase) :-
	++resposta(Frase).

websag_handle_htget(_ClientAddr,[mitras],_ParList) :-
	!,
 	%:> writeln('recebeu mitras GET'),
 	responder_requisicao.
 	%:>writeln('Respondeu GET').

websag_handle_htoptions(_ClientAddr,[mitras],_ParList) :-
	!,
 	:> writeln('recebeu mitras OPTIONS'),
      format('~n').
 	%:>writeln('Respondeu GET').


 websag_handle_htpost(_ClientAddr,[mitras],_ParList, Content) :-
	!,
 	:> writeln('recebeu mitras POST'),
 	%:> writeln(Content),
 	trata_post(Content,Mensagem),
 	:>writeln(Mensagem),
 	receber(Mensagem) >> nlp_agent,
 	:>writeln('Realizou parse'),
 	responder_requisicao_ok,
 	:>writeln('Respondeu POST').


%Os dados chegam na requisição post como um atomo, devem ser convertidos
%para string, separados no caracter = e devemos substituir a string + por espaço, pois
% por algum motivo o prolog converte os espaços em branco na requisição para sinais
% de +
trata_post(Dados,Mensagem) :-
	:>writeln('trata_post'),
	is_json_term(Dados), 
	atom_json_dict(Dados,Dict,_),
	%assertz(dicion(Dict)),
	MensagemS = Dict.mensagem,
	atom_string(Mensagem, MensagemS).
 	%atom_string(Dados,X),
 	%assertz(req_json(Dados)),
 	%:>writeln(X),
 	%split_string(X,"=","",[_|Y]),
 	%:>writeln(Y),
 	%atomic_list_concat(Y,Z),
 	%atomic_list_concat(A,'+',Z),
 	%atomic_list_concat(A,' ',Mensagem).

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
