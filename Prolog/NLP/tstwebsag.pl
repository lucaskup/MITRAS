tststart :- 
	start_agent(webserver_agent, websag_start),
	start_agent(ag_mitras_nlp, setup_ag_mitras_nlp),
	start_web_server(8090).
tststart_mitras :- 
	tststart.

setup_ag_mitras_nlp :- 
	writeln('Starting NLP Agent'),
	start_console,
	snlp_parse('I need'),
	handle_event(frase(Frase) << webserver_agent,
		parse_frase(Frase)).
parse_frase(Frase) :-
	snlp_parse(Frase),
	t1(X,Y),
	++what(X),
	++where(Y),
	:>writeln('Frase Parseada'),
	:>writeln(X),
	:>writeln(Y).
tststop :-
	stop_web_server(8090),
	stop_agent(webserver_agent),
	stop_agent(ag_mitras_nlp).
	
websag_start :- 
	writeln('Starting Web Server Agent'),
	start_console,
	handle_event(htpost(CliAddr,PathList,ParList,Content),
		websag_handle_htpost(CliAddr,PathList,ParList,Content) ),
	handle_event(htget(CliAddr,PathList,ParList),
		websag_handle_htget(CliAddr,PathList,ParList) ),
	writeln('Web Server Agent Started').

websag_handle_htget(_ClientAddr,[test],_ParList) :-
	!,
 	:> writeln('recebeu test'),
%	reply_html_page(
%		title('Web Server Agent'), [
%			h1('Web Server Agent'),
%			p(['The agent is running!'])
%			]
%		)
		tratar_requisicao.

websag_handle_htget(_ClientAddr,[file,FileName],_ParList) :-
	!,
 	:> writeln('recebeu file'),
	reply_html_page(
		title('Web Server Agent'),[
			h1('Web Server Agent'),
			p(['The file requested is:']),
			p([FileName])
			]
		).

websag_handle_htget(_ClientAddr,[service],ParList) :-
	!,
	:> writeln('recebeu service com parametros:'),
	:> writeln(ParList),
 	reply_html_page(
		title('Web Server Agent'),[
			h1('Web Server Agent'),
			p(['The service requested has the following parameters:']),
			p(ParList)
			]
		).
%Tratamento da requisição do MITRAS
websag_handle_htget(_ClientAddr,[mitras],ParList) :-
	!,
 	:> writeln('recebeu mitras'),
 	:> writeln(ParList),
 	memberchk(mensagem=Mensagem,ParList),
 	:>writeln(Mensagem),
 	frase(Mensagem) >> ag_mitras_nlp,
 	%snlp_parse(Mensagem),
 	:>writeln('Realizou parse'),
 	responder_requisicao,
 	:>writeln('Respondeu requisicao').
%	reply_html_page(
%		title('Web Server Agent'), [
%			h1('Web Server Agent'),
%			p(['The agent is running!'])
%			]
%		)
	

 websag_handle_htget(_ClientAddr,Service,ParList) :-
 	:> writeln('Caiu na requisicao'),
 	:> writeln(Service),
 	:> writeln(ParList).