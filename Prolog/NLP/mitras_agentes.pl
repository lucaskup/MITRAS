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
		parse_frase(Mensagem)).

parse_frase(Frase) :-
	snlp_parse(Frase),
	t1(X,Y),
	++what(X),
	++where(Y),
	:>writeln('Frase Parseada'),
	:>writeln(X),
	:>writeln(Y),
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
	writeln('Web Server Agent Started').

websag_handle_htget(_ClientAddr,[mitras],ParList) :-
	!,
 	:> writeln('recebeu mitras'),
 	:> writeln(ParList),
 	memberchk(mensagem=Mensagem,ParList),
 	:>writeln(Mensagem),
 	receber(Mensagem) >> nlp_agent,
 	%snlp_parse(Mensagem),
 	:>writeln('Realizou parse'),
 	responder_requisicao,
 	:>writeln('Respondeu requisicao').