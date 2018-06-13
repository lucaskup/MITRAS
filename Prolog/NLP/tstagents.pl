%:- [agilog].


agstart :-
%	gtrace,
	start_agent(ag1,ag1_main_goal),
%	sleep(1),
	start_agent(ag2,generic_main_goal),
%	sleep(1),
%	start_agent(ag3,ag3_main_goal).
	start_agent(ag3,generic_main_goal).

agstop :-
	stop_agent(ag1),
	stop_agent(ag2),
	stop_agent(ag3).

ag1_main_goal :-
%	attach_agent,
%	gtrace,
	writeln('ag1: will start specific main goal'),
	handle_event(inform(C)<<SndAg, generic_received_inform(SndAg,C)),
	handle_event(++ recebeu(X,Y,Z,W), generic_received_add_bel(recebeu(X,Y,Z,W))),
	writeln('ag1: started main goal'),
	ag1_send_messages.

ag1_send_messages :-
	writeln('ag1:********************************************'),
	writeln('ag1: sending inform(hello) to ag2'),
	sleep(1),
	inform(hello) >> ag2,
	writeln('ag1: sleeping 10 seconds ***********************'),
	sleep(10),
	writeln('ag1:********************************************'),
	writeln('ag1: sending inform(hello1) to ag3'),
	inform(hello1) >> ag3,
	writeln('ag1: waiting for inform(done)'),
	(((inform(done) << ag3) / 20)-> writeln('ag1: received inform(done)'); writeln('ag1: ***Timeout')),
	writeln('ag1: sleeping 10 seconds ***********************'),
	sleep(10),
	writeln('ag1:********************************************'),
	writeln('ag1: sending inform(hello2) to ag2 and ag3'),
	inform(hello2) >> [ag2,ag3],
	writeln('ag1: sleeping 10 seconds ***********************'),
	sleep(10),
	writeln('ag1:********************************************'),
	writeln('ag1: sending inform(hello3) to ag3 and ag2'),
	inform(hello3) >> [ag3,ag2],
	writeln('ag1: sleeping 10 seconds ***********************'),
	sleep(10),
	writeln('ag1:++++++++++++++++++++++++++++++++++++++++++++'),
	ag1_send_messages.

ag2_main_goal :-
%	attach_agent,
	writeln('ag2: started specific main goal').

ag3_main_goal :-
%	attach_agent,
	writeln('ag3: will start specific main goal'),
	handle_event(inform(C)<<SndAg, ag3_received_inform(SndAg,C)),
	handle_event(++ recebeu(X,Y,Z,W), ag3_received_add_bel(recebeu(X,Y,Z,W))),
	writeln('ag3: started main goal').

ag3_received_inform(SAg,C) :-
	writeln('ag3: specific handler for reception of informs'),
	write('ag3: received inform from: '),
	write(SAg),
	write(' with content: '),
	writeln(C),
	write('ag3: send inform(done) back to agent '), 
	writeln(SAg),
	inform(done) >> SAg.

ag3_received_add_bel(recebeu(X,Y,Z,W)) :-
	writeln('ag3: specific handler for reception of add bel'),
	write('ag3: added the belief: '),
	writeln(recebeu(X,Y,Z,W)).


generic_main_goal :-
	this_agent(Ag),
	write(Ag),writeln(': will start generic main goal'),
	handle_event(inform(C)<<SndAg, generic_received_inform(SndAg,C)),
	handle_event(++ recebeu(X,Y,Z,W), generic_received_add_bel(recebeu(X,Y,Z,W))),
	write(Ag),
	writeln(': started generic main goal').
	
generic_received_inform(SAg,C) :-
	this_agent(RAg),
	write(RAg),
	writeln(': generic handler for reception of informs'),
	write(RAg),
	write(': received inform from: '),
	write(SAg),
	write(' with content: '),
	writeln(C),
	++ recebeu(RAg,inform,C,SAg).

generic_received_add_bel(recebeu(X,Y,Z,W)) :-
	this_agent(Ag),
	write(Ag),writeln(': generic handler for reception of add bel'),
	this_agent(Ag),write(Ag),
	write(': added the belief: '),
	writeln(recebeu(X,Y,Z,W)).


