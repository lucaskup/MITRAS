/********************************************************
    Agilog

    Author:        Joao Carlos Gluz
    E-mail:        jcgluz@gmail.com
    Copyright (C): 2014-2017, Joao Carlos Gluz

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This software is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  

    This software is provided "as is" and any express or implied warranties, 
    including, but not limited to, the implied warranties of merchantability 
    and fitness for a particular purpose are disclaimed. The entire risk as 
    to the quality and performance of the program is with you. Should the 
    program prove defective, you assume the cost of all necessary servicing, 
    repair or correction.

    In no event shall the copyright owner or contributors be liable for any 
    direct, indirect, incidental, special, exemplary, or consequential 
    damages (including, but not limited to, procurement of substitute goods 
    or services; loss of use, data, or profits; or business interruption) 
    however caused and on any theory of liability, whether in contract, 
    strict liability, or tort (including negligence or otherwise) arising 
    in any way out of the use of this software, even if advised of the 
    possibility of such damage.

    See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/
/********************************************************
*
* AgiLog: Agent oriented programming in Prolog
*
* agilog.pl
* 
* Synopsis:	Source code of the Agilog programming environment.
*
* Author: 	João Carlos Gluz - 2014/2015/2016/2017
*
*/

/******************************************************************
*
* Change Log:
*
* Version 0.5 (April 2015): 
*
*    - Initial version, programming environment still called 
*      AgentLog
*
* Version 0.6: (2016):  
*
*    - Minor corrections
*
* Version 0.7 (August 2017): 
*
*    - First version of Agilog (programming environment
*      renamed to Agilog) 
*    - JCGLUZ: Major revision, correction of several errros and
*    - JCGLUZ: Inclusion of support to OWL2 ontologies
*    - JCGLUZ: Inclusion of support to Bayesian Decision Networks
*
*     Revision 0.7a (September 2017)
*  
*    - JCGLUZ: Minor revision
*    - JCGLUZ: Correction of errors in the support to OWL2 annotations
*
*     Revision 0.7b (November 2017)
*
* 	 - JCGLUZ: minor correction in agilog_owl2.pl
*
*	  Revision 0.7c (November 2017)
*
*    - JCGLUZ: minor corrections in update belief (-+ operator)
*    - JCGLUZ: automatic execution of BDN reasoner when BDN evidences
*              where changed was not working, this was corrected in
*              this revision
*
*     Revision 0.7d (MAY 2018)
*
*    - JCGLUZ: minor revision, created agishell.pl start program, which
*              loads entire set of Agilog modules: javalog.pl, agilog.pl, 
*              agilog_bdn.pl, agilog_owl.pl, agilog_jade.pl
* 
*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SETUP DIRECTIVES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- 	use_module(library(jpl)).
:- 	use_module(library(time)).
:- 	use_module(library(http/thread_httpd)).
:- 	use_module(library(http/http_dispatch)).
:- 	use_module(library(http/html_write)).		
:- 	use_module(library(http/http_parameters)).
:- 	use_module(library(http/http_client)).

:- use_module(library(http/http_cors)).
:- set_setting(http:cors, [*]).

:- 	op(900, xfy, <<).
:- 	op(900, xfy, >>).
:- 	op(900, fx, ++).
:- 	op(900, fx, --).
:- 	op(900, fx, -+).
:- 	op(890, fx, ??).
:- 	op(890, fx, ??-).
%:- 	op(950, xfy, ##).
%:- 	op(950, xfy, ^^).
:- 	op(950, xfy, &&).
:- 	op(870, fx, :> ).
:- 	op(870, fx, <: ).
%:- 	op(850, xfy, @@).
:- 	op(850, xfy, @).
%:- 	op(850, xfy, //).
:- 	op(950, xf, sec ).


:- op(1150, xfy, :=).
:- op(650, xfy, &).
:- op(750, xfy, :).
:- op(850, xfy, =>).

:- 	multifile (:>)/1.
:- 	discontiguous (:>)/1.

:- 	multifile (<:)/1.
:- 	discontiguous (<:)/1.


:- 	multifile (>>)/2.
:- 	discontiguous (>>)/2.

:- 	multifile (&&)/2.
:- 	discontiguous (&&)/2.

%:- 	multifile (^^)/2.
%:- 	discontiguous (^^)/2.

%:- 	multifile (##)/2.
%:- 	discontiguous (##)/2.

:- 	multifile (??)/1.
:- 	discontiguous (??)/1.

:- 	multifile (??-)/1.
:- 	discontiguous (??-)/1.

:- 	multifile (++)/1.
:- 	discontiguous (++)/1.

:- 	multifile (--)/1.
:- 	discontiguous (--)/1.

:- 	multifile (-+)/1.
:- 	discontiguous (-+)/1.

:- multifile (=>)/2.
:- discontiguous (=>)/2.

:- dynamic (:=)/2.
:- discontiguous (:=)/2.


:- 	multifile alog_help/4.
:- 	discontiguous alog_help/4.

:- 	dynamic bel/2.

:- 	dynamic agentLocalId/1.
:- 	dynamic jadeAgentController/2.
:- 	dynamic jadeMsgReceptionThread/2.
:- 	dynamic mainGoalThread/2.
:- 	dynamic concGoalThread/3.
:- 	dynamic agentGoalThreadWaiting/4.
:- 	dynamic eventDispatchThread/2.
:- 	dynamic last_reception_time/2.
:- 	dynamic controllingAgent/1.
:- 	dynamic prologAgentsContainer/1.
:- 	dynamic webAgents/1.
:- 	dynamic webAgentThread/2.
:-	dynamic eventHandler/3.
:-	dynamic agentConsole/4.

:- 	discontiguous alog_help/4.


:- 	mutex_create(agilog_jade_mutex).
:- 	mutex_create(agilog_bels_mutex).
:- 	mutex_create(agilog_threads_mutex).
:- 	mutex_create(agilog_rectime_mutex).
:-  mutex_create(agilog_evhandler_mutex).


:- 	at_halt(mutex_destroy(agilog_jade_mutex)).
:- 	at_halt(mutex_destroy(agilog_bels_mutex)).
:- 	at_halt(mutex_destroy(agilog_threads_mutex)).
:- 	at_halt(mutex_destroy(agilog_rectime_mutex)).
:-	at_halt(mutex_destroy(agilog_evhandler_mutex)).


:- 	http_handler(root(.), web_server_handler, [prefix]).

:- 	writeln('*** Agilog - The Agential Programming Logic ***'),
	writeln('*** Developed by: J.C. Gluz - Version: 0.7d ***'),
	writeln('*** Agilog programming environment is ready ***'),
	writeln('*** Use ahlp command for help               ***' ).

:-	[javalog].
%:-  [agilog_bdn].
%:-  [agilog_owl2].
%:-  [agilog_jade].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% AGENTS & GOALS MANAGEMENT
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


alog_help(agilog_agents,predicate, 'List Agilog agents currently in execution', 
	[
	'Usage: agilog_agents '
	]).

agilog_agents :-
	forall(eventDispatchThread(AgId,EvThread),
		print_agent_info(AgId,EvThread)).

print_agent_info(AgId,EvThread) :-
	findall(gt(CGId,CGThread), 
		concGoalThread(AgId, CGId, CGThread),
		CGList),
	write('Agent: '), writeln(AgId),
	(mainGoalThread(AgId, MainThread) ->
		(write(' Main goal thread: '), write(MainThread) )
		;
		write(' Main goal thread not running - ')
		),
	write(' Events dispatching thread: '), writeln(EvThread),
	(CGList=[] ->
		writeln('No concurrent goals')
		;
		(writeln('Concurrent goals:'),
		forall(member(gt(CGI,CGT), CGList),	
			(write('Primary goal: '),write(CGI),write(' Thread: '), writeln(CGT))
			)
		)
	).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Start/Stop agent
%
%

alog_help(start_agent,predicate, 'Start the operation of a new agent', 
	[
	'Usage: start_agent(AgentId,InitGoal) - starts a new agent',
	'Where: AgentId: agent identifier on Agilog (must be an unique literal)',
	'       InitGoal: predicate called on the main thread of the agent'
	]).

start_agent(AgentId) :-
	start_agent(AgentId) => _.

start_agent(AgentId) => CurrentThreadId:-
	atom(AgentId),
	safe_thread_self(CurrentThreadId),
	assert(agentLocalId(AgentId)),
	assert(mainGoalThread(AgentId, CurrentThreadId)),
	safe_thread_create(event_dispatch_thread(AgentId), DispatchThreadId,[at_exit(agent_clean_exit_dispatch_thread(AgentId))]),
	assert(eventDispatchThread(AgentId, DispatchThreadId)).
%	init_belief_base(AgentId).

start_agent(AgentId,MainGoal) :-
	start_agent(AgentId,MainGoal) => _.

start_agent(AgentId,MainGoal) => MainThreadId :-
	atom(AgentId),
	assert(agentLocalId(AgentId)),
%	safe_thread_create(MainGoal,MainThreadId,[detached(true)]),
	safe_thread_create(MainGoal,MainThreadId,[at_exit(agent_clean_exit_main_thread(AgentId))]),
	assert(mainGoalThread(AgentId, MainThreadId)),
	safe_thread_create(event_dispatch_thread(AgentId), DispatchThreadId,[at_exit(agent_clean_exit_dispatch_thread(AgentId))]),
	assert(eventDispatchThread(AgentId, DispatchThreadId)).
%	init_belief_base(AgentId).


agent_clean_exit_main_thread(AgentId) :-
	with_mutex(agilog_threads_mutex,(
		retractall(mainGoalThread(AgentId,_))
	)).

agent_clean_exit_dispatch_thread(AgentId) :-
	catch( ignore(AgentId && stop_agent), _, true),
	with_mutex(agilog_threads_mutex,(
		retractall(eventDispatchThread(AgentId,_))
	)).

%init_belief_base(AgentId) :-
%	forall((AgentId ## Bel, \+is_list(Bel)),
%		assert(bel(AgentId,Bel))
%		),
%	forall((AgentId ## BelList, is_list(BelList)),
%		forall(member(Bel,BelList),
%			assert(bel(AgentId,Bel))
%			)
%		).

%alog_help((##),operator, 'Define the initial beliefs of the agent', 
%	[
%	'Usage: AgId ## Bel - set Bel as an initial belief of agent AgId',
%	'       AgId ## [Bel_1, Bel_2, ..., Bel_n] - compact notation, set Bel_1 to Bel_n as initial beliefs'
%	]).
	
		
alog_help(stop_agent,predicate, 'Stop the operation of an agent, kill running threads of this agent', 
	[
	'Usage: stop_agent - stops the agent running in the current thread',
	'       stop_agent(AgentId) - stops the agent identified by AgentId',
	'Where: AgentId: identifier of an existing agent running on Agilog'
	]).


stop_agent :-
	this_agent(AgentId),
	stop_agent(AgentId).

stop_agent(AgentId) :-
	check_need_dettach_agent(AgentId),
	with_mutex(agilog_threads_mutex,(
		eventDispatchThread(AgentId,DispatchThreadId)
	)),
	safe_thread_send_message(DispatchThreadId,stop),
	check_need_stop_jade_thread(AgentId),
	retractall(agentLocalId(AgentId)).

check_need_dettach_agent(AgentId) :-
	with_mutex(agilog_jade_mutex,(
		jadeAgentController(AgentId,_)
	)),
	!,
	dettach_agent(AgentId).

check_need_dettach_agent(_).
	
check_need_stop_jade_thread(AgentId) :-
	with_mutex(agilog_threads_mutex,(
		jadeMsgReceptionThread(AgentId, RecThreadId)
	)),
	!,
	safe_thread_send_message(RecThreadId,stop).
	
check_need_stop_jade_thread(_).
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Control/Release agent
%
%

alog_help(control_agent,predicate, 'Control an agent running on another thread (for debugging purposes)', 
	[
	'Usage: control_agent(AgentId)',
	'Where: AgentId: identifier of an existing agent running on Agilog'
	]).

control_agent(AgentId) :-
	agentLocalId(AgentId),
	(controllingAgent(_) -> retractall(controllingAgent(_)); true),
	assert(controllingAgent(AgentId)).

release_agent :-
	(controllingAgent(_) -> retractall(controllingAgent(_)); true).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Obtain identifier of the agent associated
% to current thread
%
%

alog_help(this_agent,predicate, 'Obtain the identifier of the agent running in the current thread', 
	[
	'Usage: this_agent(AgentId)'
	]).


this_agent(AgentId) :-
% for debugging purposes
	controllingAgent(AgentId),!.

this_agent(AgentId) :-
	safe_thread_self(CurrentThread),
	(this_agent(AgentId,CurrentThread) -> 
		(true,!)
	;(isWebAgentThread(AgentId,CurrentThread) ->
		(true,!)
	;	
		fail
	)).

this_agent(AgentId,CurrentThread) :-
	with_mutex(agilog_threads_mutex,(
		mainGoalThread(AgentId, CurrentThread)
	)),!.

this_agent(AgentId,CurrentThread) :-
	with_mutex(agilog_threads_mutex,(
		eventDispatchThread(AgentId,CurrentThread)
	)),!.

this_agent(AgentId,CurrentThread) :-
	with_mutex(agilog_threads_mutex,(
		concGoalThread(AgentId,_,CurrentThread)
	)).

isWebAgentThread(AgentId,CurrentThread) :-
	with_mutex(agilog_threads_mutex,(
		webAgentThread(AgentId,CurrentThread)
	)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Concurrent goals management
%
% Concurrent goals work as secondary threads of the agent
%

alog_help(launch_goal,predicate, 'Start a new concurrent goal of the agent', 
	[
	'Usage: launch_goal(CGoal) - starts a concurrent goal in a new thread',
	'Where: CGoal: predicate called on the concurrent goal thread'
	]).


% Create concurrent goal
launch_goal(CGoal) :- !,
	launch_goal(CGoal) => _.

launch_goal(CGoal) => CThreadId :-
	\+var(CGoal),
	CGoal=..[CGId|_],
	this_agent(AgId),
	\+ with_mutex(agilog_threads_mutex,(
		concGoalThread(AgId,CGId,_)
	)),
	safe_thread_create(CGoal,CThreadId,[at_exit(with_mutex(agilog_threads_mutex,(
								retractall(concGoalThread(AgId,CGId,_))
							)))]),
	assert(concGoalThread(AgId, CGId, CThreadId)).

alog_help(wait_goal,predicate, 'Wait a concurrent goal to finish', 
	[
	'Usage: wait_goal(CGoal) - wait the thread of the concurrent goal to finish',
	'       wait_goal(CGoal,Status) - wait a concurrent goal thread to finish, return status',
	'Where: CGoal: predicate initially called on the concurrent goal thread,',
	'       Status:   the returning status of the concurrent goal thread'
	]).

% Wait concurrent goal to finish
wait_goal(CGoal) :- !,
	wait_goal(CGoal,_).

wait_goal(CGoal,Status):-
	\+var(CGoal),	
	CGoal=..[CGId|_],
	this_agent(AgId),
	with_mutex(agilog_threads_mutex,(
		concGoalThread(AgId,CGId, CGThread)
	)),
	safe_thread_join(CGThread,Status).

set_goal_timeout(Timeout,TimeoutPred,IdTimeout) :-
%	alarm(Timeout, (TimeoutPred,safe_thread_exit(false)), IdTimeout, [remove(true),install(true)]).
	alarm(Timeout, call_goal_timeout_pred(TimeoutPred), IdTimeout, [remove(true),install(true)]).

reset_goal_timeout(IdTimeout) :-
	remove_alarm(IdTimeout).	


call_goal_timeout_pred(TimeoutPred) :-
	ignore(TimeoutPred),
	safe_thread_exit(false).
	

%alog_help((^^),operator, 'Operator used to define the goals of the agent .', 
%	[
%	'Usage: Must be used in the head of the goals of the agent.',
%	'Format: ',
%	'       AgId ^^ Goal :- Plan.'
%	]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% CONSOLE ENVIRONMENT MANAGEMENT
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Start/Stop Console Environment
%
%

alog_help(start_console,predicate, 'Start a console for the agent', 
	[
	'Usage: start_console - starts a console for the agent',
	'Note: must be called from some agent goal'
	]).


start_console :-
	this_agent(Ag),
	agentConsole(Ag,_,_,_),
	!,
	writeln('Console for this agent is already running').
	
start_console :-
	this_agent(Ag),
	atom_concat('Console for agent: ',Ag,ConsTit),
%	writeln('will open console'),
	open_xterm(ConsTit,InStream,OutStream,ErrStream,[]),
%	writeln('console opened'),
	assert(agentConsole(Ag,InStream,OutStream,ErrStream)),
	write('Console for agent: '),write(Ag),writeln(' started.').

start_console :-
	this_agent(Ag),
	\+ agentConsole(Ag,_,_,_),
	!,
	writeln('Console is not running.').

alog_help(stop_console,predicate, 'Stops the console', 
	[
	'Usage: stop_console - stops the console'
	]).

	
stop_console :-
	this_agent(Ag),
	(   retract(agentConsole(Ag, In, Out, Err)) -> (
		close(In, [force(true)]),
	    close(Out, [force(true)]),
	    close(Err, [force(true)])
	);( true
	)),
	write('Console for agent: '),write(Ag),writeln(' stopped.').


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Execute action operator
%
:> Act :-
	Act \= (_=>_),
	!,
	:> Act => _.

alog_help((:>),operator,'Command the agent to execute an action in some environment',
	[
	'Usage: :> Act',
	'Where: Act: an action supported by the agent'
	]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Console actions
%

alog_help((:>),operator, 'Console Environment: Action Operator', 
	[
	'Actions possible in console environment are the same used in Prolog term I/O.',
	'Note that all actions must be preceded by action operator :> to work properly.',
	'Usage: :> write(T) -  write Prolog term T on the console (no new line)',
	'       :> writeln(T) - same as write, but write a new line at the end',
	'       :> writeq(T) - write Prolog term T to console, using  brackets and',
	'                      operators where  appropriate,',
	'       :> put_char(C) - write  char C to console, obeying current encoding',
	'       :> put_code(C) - similar to put_char(C), but using char code',
	'       :> flush_output - flush pending output on console',
	'       :> read(T) - Read next Prolog term from console and unify with term T',
	'       :> read_term(T,O) - similar to read(T), but with list of options O.',
	'                      For specific details on options see SWI-Prolog manual',
	'       :> read_string(L,S) - read at most L chars from console and return',
	'                      them as string S',
	'       :> read_char(C) - read next char unifying it with C as a one-char atom',
	'       :> read_code(C) - read next char unifying it with C as a char code',
	'       :> exist_input(E) - return E=true if there is input data on console,',
	'                      otherwise return E=false'
	]).


:> nl => _:-
	this_agent(Ag),
	agentConsole(Ag,_,OutStream,_),
	nl(OutStream).
	
	
:> write(A) => _ :-
	this_agent(Ag),
	agentConsole(Ag,_,OutStream,_),
	write(OutStream,A).

:> writeln(A) => _ :-
	this_agent(Ag),
	agentConsole(Ag,_,OutStream,_),
	writeln(OutStream,A).
	
:> writeq(A) => _ :-
	this_agent(Ag),
	agentConsole(Ag,_,OutStream,_),
	writeq(OutStream,A).

:> put_char(C) => _ :-
	this_agent(Ag),
	agentConsole(Ag,_,OutStream,_),
	put_char(OutStream,C).

:> put_code(C) => _ :-
	this_agent(Ag),
	agentConsole(Ag,_,OutStream,_),
	put_code(OutStream,C).

:> flush_output => _ :-
	this_agent(Ag),
	agentConsole(Ag,_,OutStream,_),
	flush_output(OutStream).



:> read(A) => _ :-
	this_agent(Ag),
	agentConsole(Ag,InStream,_,_),
	read(InStream,A).

:> read_term(A,O) => _ :-
	this_agent(Ag),
	agentConsole(Ag,InStream,_,_),
	read_term(InStream,A,O).

:> read_string(L,S) => _ :-
	this_agent(Ag),
	agentConsole(Ag,InStream,_,_),
	read_string(InStream,L,S).

:> get_char(C) => _ :-
	this_agent(Ag),
	agentConsole(Ag,InStream,_,_),
	get_char(InStream,C).

:> get_code(C) => _ :-
	this_agent(Ag),
	agentConsole(Ag,InStream,_,_),
	get_code(InStream,C).

:> exist_input(Exist) => _ :-
%	gtrace,
	this_agent(Ag),
	agentConsole(Ag,InStream,_,_),
	wait_for_input([InStream],ReadyStreamList,0.1),
	(member(InStream,ReadyStreamList) -> (
		Exist=true
	);(
		Exist=false
	)).
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% WEB ENVIRONMENT MANAGEMENT
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Start/Stop Web Environment
%
%

alog_help(start_web_server,predicate, 'Start web server for web environment', 
	[
	'Usage: start_web_server - starts web server on port 9090',
	'       start_web_server(Port) - starts web server on port Port'
	]).


start_web_server :-
	start_web_server(9090).

start_web_server(Port) :-
    http_server(http_dispatch, [port(Port)]),
	write('Web Server started on port:'),write(Port), nl.

alog_help(stop_web_server,predicate, 'Stop web server of web environment', 
	[
	'Usage: stop_web_server - stops web server on port 9090',
	'       stop_web_server(Port) - stops web server on port Port'
	]).


stop_web_server :-
	stop_web_server(9090).
	
stop_web_server(Port) :-
%	webAgent(WebAgent),
	http_stop_server(Port,[]),
	retractall(webAgents(_)),
	write('Web Server running on port: '),write(Port),write(' stopped'),nl.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Web Server Callback Predicate 
%
%

% Call back predicate called by web server thread
web_server_handler(HttpRequest) :-
%	write(user_error,' HttpRequest='),write(user_error,HttpRequest),nl(user_error),
	%writeln('Até aqui foi'),
	      cors_enable(HttpRequest,
                  [ methods([get,post,delete])
                  ]),
	safe_thread_self(CurrThread),
	member(method(Method),HttpRequest),
	member(peer(ClientAddr),HttpRequest),
	member(path(Path),HttpRequest),
	path_to_path_list(Path,PathList),
%	write(user_error,' PathList='),write(user_error,PathList),
	(member(search(ParamList),HttpRequest) -> (
		true
	);(	
		ParamList=[]
	)),
	get_time(Time),
	dispatch_http_request(Method,ClientAddr,PathList,ParamList,Time,CurrThread,HttpRequest).

web_server_handler(_) :-
	reply_bad_request.
	

dispatch_http_request(get,ClientAddr,PathList,ParamList,Time,CurrThread,_HttpRequest) :-
	web_event_dispatch(CurrThread,htget(ClientAddr, PathList, ParamList),Time).

dispatch_http_request(delete,ClientAddr,PathList,ParamList,Time,CurrThread,_HttpRequest) :-
	web_event_dispatch(CurrThread,htdel(ClientAddr, PathList, ParamList),Time).

dispatch_http_request(post,ClientAddr,PathList,ParamList,Time,CurrThread,HttpRequest) :-
	http_read_data(HttpRequest, Content, [to(atom)]),
	web_event_dispatch(CurrThread,htpost(ClientAddr,PathList,ParamList,Content),Time).

dispatch_http_request(put,ClientAddr,PathList,ParamList,Time,CurrThread,HttpRequest) :-
	http_read_data(HttpRequest, Content, [to(atom)]),
	web_event_dispatch(CurrThread,htput(ClientAddr,PathList,ParamList,Content),Time).
dispatch_http_request(options,ClientAddr,PathList,ParamList,Time,CurrThread,_HttpRequest) :-
	web_event_dispatch(CurrThread,htoptions(ClientAddr, PathList, ParamList),Time).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Web Server Events Dispatch 
%
%

web_event_dispatch(CurrentThread, Request, Time) :-
	with_mutex(agilog_evhandler_mutex,(
		eventHandler(RecAgentId, Request @ Time, EvHandler)
	)),
	!,
	% Some agent registered an web event that matches with current request.
	% Clear any relationship of current thread (which is the web server
	% reception thread) with other agent and associate this thread to the
	% agent that matched the request.
	with_mutex(agilog_threads_mutex,(
		retractall(webAgentThread(_,CurrentThread)),
		assert(webAgentThread(RecAgentId,CurrentThread))
	)),
	catch(ignore(call(EvHandler)),_,true),
	with_mutex(agilog_threads_mutex,(
		retractall(webAgentThread(_,CurrentThread))
	)).

web_event_dispatch(CurrentThread, Request, _Time) :-
	with_mutex(agilog_evhandler_mutex,(
		eventHandler(RecAgentId, Request, EvHandler)
	)),
	!,
	% Some agent registered an web event that matches with current request.
	% Clear any relationship of current thread (which is the web server
	% reception thread) with other agent and associate this thread to the
	% agent that matched the request.
	with_mutex(agilog_threads_mutex,(
		retractall(webAgentThread(_,CurrentThread)),
		assert(webAgentThread(RecAgentId,CurrentThread))
	)),
	catch(ignore(call(EvHandler)),_,true),
	with_mutex(agilog_threads_mutex,(
		retractall(webAgentThread(_,CurrentThread))
	)).
	

	
path_to_path_list('/',[]).
path_to_path_list(P,PL):-
	atomic_list_concat([_|PL],'/',P).


reply_created :-
	format('Status: 201~n~n').

reply_accepted :-
	format('Status: 202~n~n').

reply_no_content :-
	format('Status: 204~n~n').

reply_bad_request :-
	throw(http_reply(bad_request(''))).

reply_forbidden :-
	throw(http_reply(forbidden(''))).

reply_not_found :-
	throw(http_reply(not_found(''))).

reply_not_acceptable :-
	throw(http_reply(not_acceptable(''))).

reply_unavailable :-
	throw(http_reply(unavailable(''))).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Web actions executed as web client
%

alog_help((:>),operator, 'Web Environment: web client actions', 
	[
	'Usage: :> htget(Server, Path, ParamL) => Reply - send an HTTP GET request to Server.',
	'             The reply of the server can be retrieved by Reply variable',
	'       :> htdel(Server, Path, ParamL) => Reply - send an HTTP DELETE request to Server.',
	'             The reply of the server can be retrieved by Reply variable',
	'       :> htpost(Server, Path, ParamL, Content) - send an HTTP POST request to Server.',
	'             The reply of the server can be retrieved by Reply variable',
	'       :> htput(Server, Path, ParamL, Content) - send an HTTP PUT request to Server.',
	'             The reply of the server can be retrieved by Reply variable',
	'Where: Server - a Prolog atom representing the Host-name or IP-address of web server',
	'       Path - path of the URL resource, can be an atom or a list of the parts of',
	'              of the path, list [a,b,c] is transformed in path /a/b/c',
	'       ParamL - list representing HTTP request parameters',
	'       Content - the HTTP request content represented as a Prolog atom',
	'       Reply - a Prolog atom containing the reply of the server'
	]).


:> htget(Server,Path,ParamList) => Reply :-
	http_get([host(Server),path(Path),search(ParamList)],Reply,[]).

:> htdel(Server,Path,ParamList) => Reply :-
	http_delete([host(Server),path(Path),search(ParamList)],Reply,[]).

:> htpost(Server,Path,ParamList,Content) => Reply :-
	http_post([host(Server),path(Path),search(ParamList)],Content,Reply,[]).

:> htput(Server,Path,ParamList,Content) => Reply :-
	http_put([host(Server),path(Path),search(ParamList)],Content,Reply,[]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% AGENT COMMUNICATION MANAGEMENT
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Send message operation
%
%

alog_help((>>),operator, 'Send a message to an agent', 
	[
	'Usage: CAct >> RecAgentIds - send a message to a list of agents',
	'       CAct >> RecAgentId - send a message to one agent'
	]).
	
CAct >> RecAgentId :-
	atom(RecAgentId),
	with_mutex(agilog_threads_mutex,(
		eventDispatchThread(RecAgentId,RecAgentDispatchThread)
	)),
	!,
	this_agent(SndAgentId),
	% Local agent, use local messages
	get_time(Time),
%	write(SndAgentId),write(': local send: '),write(CAct),write(' to: '),writeln(RecAgentId),
	safe_thread_send_message(RecAgentDispatchThread,msg(RecAgentId,CAct,SndAgentId,Time)).

CAct >> RecAgentIds :-
	is_list(RecAgentIds),
	forall(member(RecAgentId,RecAgentIds),
		with_mutex(agilog_threads_mutex,(
			eventDispatchThread(RecAgentId,_)
		))),
	!,
	this_agent(SndAgentId),
	% List of local agents, use local messages
	forall(member(RecAgentId,RecAgentIds),
		(with_mutex(agilog_threads_mutex,(
			eventDispatchThread(RecAgentId,RecAgentDispatchThread)
			)), 
		get_time(Time),
		safe_thread_send_message(RecAgentDispatchThread,msg(RecAgentId,CAct,SndAgentId,Time)) )
		).

CAct >> RecAgentIds :-
	this_agent(SndAgentId),
	with_mutex(agilog_jade_mutex,(
		jadeAgentController(SndAgentId, SndAgentController)
	)),
	prologToJadeMsg(RecAgentIds, CAct, JadeMsg),
	!,
%	writeln('sending msg to jade'),
	'agilog.jade.AgilogJadeInterface'::sendMessage([SndAgentController,JadeMsg]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Receive message operation
%
%

alog_help((<<),operator, 'Wait for the reception of a message from an agent', 
	[
	'Usage: (CAct << SndAgentId) / Timeout - wait a message for a maximum period of time (the',
	'                                        Timeout) in seconds, parenthesis are mandatory',
	'       CAct << SndAgentId - wait for a message (without timeout)'
	]).

(CAct << SndAgentId) / Timeout :-
	!,
%	write('vai esperar com timeout '), writeln(Timeout),
	integer(Timeout),
	this_agent(RecAgentId),
	safe_thread_self(RecAgentThread),
	with_mutex(agilog_threads_mutex,(
		assert(agentGoalThreadWaiting(RecAgentId,CAct,SndAgentId,RecAgentThread))
	)),
	safe_thread_get_message(RecAgentThread,msg(_,CAct,SndAgentId,_),[timeout(Timeout)]),
	with_mutex(agilog_threads_mutex,(
		retractall(agentGoalThreadWaiting(RecAgentId,CAct,SndAgentId,RecAgentThread))
	)).
	
CAct << SndAgentId :-
	!,
	this_agent(RecAgentId),
	safe_thread_self(RecAgentThread),
	with_mutex(agilog_threads_mutex,(
		assert(agentGoalThreadWaiting(RecAgentId,CAct,SndAgentId,RecAgentThread))
	)),
	safe_thread_get_message(RecAgentThread, msg(_,CAct,SndAgentId,_)),
	with_mutex(agilog_threads_mutex,(
		retractall(agentGoalThreadWaiting(RecAgentId,CAct,SndAgentId,RecAgentThread))
	)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% LOW LEVEL THREAD MANAGEMENT
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Exception safe thread operations
%
%

safe_thread_self(T) :-
	catch(thread_self(T),_,print_debug_fail(thread_self)).
	
safe_thread_create(G,T,O) :-	
	catch(thread_create(G,T,O),_,print_debug_fail(thread_create)).

safe_thread_join(T,S) :-
	catch(thread_join(T,S),_,print_debug_fail(thread_join)).
	
safe_thread_exit(R) :-
	catch(thread_exit(R),_,print_debug_fail(thread_exit)).	
	
	
safe_thread_get_message(M):-
	catch(thread_get_message(M),_,print_debug_fail(thread_get_message)).
	
safe_thread_get_message(Q,M):-
	catch(thread_get_message(Q,M),_,print_debug_fail(thread_get_message)).
	
safe_thread_get_message(Q,M,O):-
	catch(thread_get_message(Q,M,O),_,print_debug_fail(thread_get_message)).
	
safe_thread_send_message(Q,M):-
	catch(thread_send_message(Q,M),_,print_debug_fail(thread_send_message)).

safe_thread_peek_message(M)	:-
	catch(thread_peek_message(M),_,print_debug_fail(thread_peek_message)).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Destroy threads of agent
%
%

destroy_threads(AgentId) :-
	with_mutex(agilog_threads_mutex,(
		jadeMsgReceptionThread(AgentId,_)
	)),
	with_mutex(agilog_threads_mutex,(
		mainGoalThread(AgentId,_)
	)),
	with_mutex(agilog_threads_mutex,(
		retractall(jadeMsgReceptionThread(AgentId,_))
	)),
	with_mutex(agilog_threads_mutex,(
		retractall(mainGoalThread(AgentId,_))
	)),
	!.
destroy_threads(_).	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% EVENT MANAGEMENT
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


alog_help((++),event, 'Add belief event pattern: ++ Bel, where Bel is a belief.', []).
alog_help((--),event, 'Delete belief event pattern: -- Bel, where Bel is a belief.', []).
alog_help((-+),event, 'Update belief event pattern: -+ Bel, where Bel is a belief.', []).
alog_help(htget,event, 'Web server event pattern: htget(CliAddr,PathL,ParamL) - received HTTP GET request', []).
alog_help(htdel,event, 'Web server event pattern: htdel(CliAddr,PathL,ParamL) - received HTTP DELETE request', []).
alog_help(htpost,event, 'Web server event pattern: htpost(CliAddr,PathL,ParamL,Content) - received HTTP POST request', []).
alog_help(htput,event, 'Web server event pattern: htput(CliAddr,PathL,ParamL,Content) - received HTTP PUT request', []).

alog_help(handle_event,predicate, 'Predicate used to create event handlers.', 
	[
	'Usage: handle_event(EvPatt,EvHandler) - sets EvHandler as the predicate that will handle',
	'                                        the event identified by the event pattern EvPatt.',
	'Event patterns can be: ',
	'       (<Event>) @ T - <Event> received at time T, <Event> can be any of following events', 
	'       CAct << SndId - message reception event', 
	'       ++ Bel        - add belief event',
	'       -- Bel        - delete belief event',
	'       -+ Bel        - update belief event',
	'       htget(CliAddr, PathL, ParamL) - web environment server event, indicates',
	'              the reception of an HTTP GET request',
	'       htdel(CliAddr, PathL, ParamL) - web environment server event, indicates',
	'              the reception of an HTTP DELETE request',
	'       htpost(CliAddr, PathL, ParamL,Content) - web environment server event,',
	'              indicates the reception of an HTTP POST request',
	'       htput(CliAddr, PathL, ParamL,Content) - web environment server event,',
	'              indicates the reception of an HTTP PUT request',
	'Where: CAct is the communication act of the message',
	'       SndId is the identifier of sender agent',
	'       T is the arrival time of the message',
	'       Bel is a belief',
	'       CliAddr - IP address of web client that sent request, represented as an atom',
	'       PathL - list representing HTTP request path. Path /a/b/c becomes list [a,b,c]',
	'       ParamL - list representing HTTP request parameters',
	'       Content - the HTTP request content represented as a Prolog atom'
	]).

handle_event(EvPatt, EvHandler) :-
	this_agent(AgId),
	handle_event(AgId,EvPatt, EvHandler).

handle_event(AgId, EvPatt, EvHandler) :-
	with_mutex(agilog_evhandler_mutex,(
		assert(eventHandler(AgId,EvPatt,EvHandler))
	)).

alog_help(ignore_event,predicate, 'Predicate used to remove event handlers.', 
	[
	'Usage: ignore_event(EvPatt) - removes any event handler predicate associated',
	'                              to the event pattern EvPatt. '
	]).

	
ignore_event(EvPatt) :-
	this_agent(AgId),
	ignore_event(AgId,EvPatt).

ignore_event(AgId, EvPatt) :-
	with_mutex(agilog_evhandler_mutex,(
		retractall(eventHandler(AgId,EvPatt))
	)).

alog_help(signal_event,predicate, 'Predicate used to signal a user defined event.', 
	[
	'Usage: signal_event(Event) - signal an user defined event, which can be any Prolog term'
	]).

signal_event(Event) :-
	this_agent(AgId),
	signal_event(AgId,Event).

signal_event(AgId,Event):-	
	with_mutex(agilog_threads_mutex,(
		eventDispatchThread(AgId,EventDispatchThread)
	)),
	get_time(Time),
	safe_thread_send_message(EventDispatchThread,event(AgId,Event,Time)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Event management
%
% Main thread for dispatching events
%
%


event_dispatch_thread(AgentId) :-
	safe_thread_get_message(Event),
%	write('dispatching event: '),writeln(Event),
	((Event=stop)-> (
		true
	);(
%        gtrace,
		catch(ignore(dispatch_event_to_handlers(Event)),_,true),
		event_dispatch_thread(AgentId)
	)).

dispatch_event_to_handlers(msg(RecAgentId,CAct,SndAgentId,Time)) :-
	!,
%	gtrace,
	write('event: '),writeln(msg(RecAgentId,CAct,SndAgentId,Time)),
	dispatch_msg_to_handlers(RecAgentId,CAct,SndAgentId,Time),
	upd_receptions(CAct,SndAgentId,Time).

dispatch_event_to_handlers(add_bel(Ag,Bel)) :-
	!,
%	write('event: '),writeln(add_bel(Ag,Bel)),
	update_bdn_engine(Ag,Bel),
	dispatch_add_bel_to_handlers(Ag,Bel).

dispatch_event_to_handlers(del_bel(Ag,Bel)) :-
	!,
%	write('event: '),writeln(del_bel(Ag,Bel)),
	update_bdn_engine(Ag,Bel),
	dispatch_del_bel_to_handlers(Ag,Bel).

dispatch_event_to_handlers(upd_bel(Ag,Bel)) :-
	!,
%	write('event: '),writeln(upd_bel(Ag,Bel)),
	update_bdn_engine(Ag,Bel),
	dispatch_upd_bel_to_handlers(Ag,Bel).

dispatch_event_to_handlers(event(RecAgentId,Event,Time)):-
%	RecAgentId && Event @@ Time,
%	write('event: '),writeln(event(RecAgentId,Event,Time)),
	with_mutex(agilog_evhandler_mutex,(
		eventHandler(RecAgentId, Event @ Time, EvHandler)
	)),
	call(EvHandler),
	!.

dispatch_event_to_handlers(event(RecAgentId,Event,_)):-
%	RecAgentId && Event,
%	write('event: '),writeln(event(RecAgentId,Event)),
	with_mutex(agilog_evhandler_mutex,(
		eventHandler(RecAgentId, Event, EvHandler)
	)),
	call(EvHandler),
	!.

dispatch_event_to_handlers(_).

dispatch_msg_to_handlers(RecAgentId,CAct,SndAgentId,Time) :-
%	writeln('checks if some goal thread is waiting msg'),
	with_mutex(agilog_threads_mutex,(
		agentGoalThreadWaiting(RecAgentId,CAct,SndAgentId,RecAgentThread)
	)), 
	!,
	safe_thread_send_message(RecAgentThread,msg(RecAgentId,CAct,SndAgentId,Time)).

	
dispatch_msg_to_handlers(RecAgentId,CAct,SndAgentId,Time) :-
%	writeln('checks recv handler with sndagent and time'),
	with_mutex(agilog_evhandler_mutex,(
		eventHandler(RecAgentId, (CAct << SndAgentId) @ Time, EvHandler)
	)),
	call(EvHandler),
	!.
dispatch_msg_to_handlers(RecAgentId,CAct,SndAgentId,_) :-
	with_mutex(agilog_evhandler_mutex,(
		eventHandler(RecAgentId, CAct << SndAgentId, EvHandler)
	)),
	call(EvHandler),
	!.
dispatch_msg_to_handlers(_,_,_,_).


upd_receptions(CAct,RecAgid,Time) :-
	!,
	upd_last_reception_time(Time),
	add_curr_reception(CAct,RecAgid,Time),
	clear_old_receptions(Time).

upd_receptions(_).


upd_last_reception_time(Time) :-
	this_agent(Agid),
	with_mutex(agilog_rectime_mutex,
		(retractall(last_reception_time(Agid,_)))),
	assert(last_reception_time(Agid,Time)).

add_curr_reception(CAct,SndAgid,Time) :-
	!,
	++ receive(CAct,SndAgid,Time).

add_curr_reception(_,_,_).

clear_old_receptions(_).


dispatch_add_bel_to_handlers(Ag,Bel) :-
%	Ag && ++ Bel,
	with_mutex(agilog_evhandler_mutex,(
		eventHandler(Ag, ++ Bel, EvHandler)
	)),
	call(EvHandler),
	!.

dispatch_add_bel_to_handlers(_,_).



dispatch_del_bel_to_handlers(Ag,Bel) :-
%	Ag && -- Bel,
	with_mutex(agilog_evhandler_mutex,(
		eventHandler(Ag, -- Bel, EvHandler)
	)),
	call(EvHandler),
	!.

dispatch_del_bel_to_handlers(_,_).



dispatch_upd_bel_to_handlers(Ag,Bel) :-
%	Ag && -+ Bel,
	with_mutex(agilog_evhandler_mutex,(
		eventHandler(Ag, -+ Bel, EvHandler)
	)),
	call(EvHandler),
	!.

dispatch_upd_bel_to_handlers(_,_).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% BELIEF BASE MANAGEMENT
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Belief base queries
%
%

alog_help((??),operator, 'Query the belief base', 
	[
	'Usage: ?? Bel - query if the belief Bel is in belief base, Bel is a Prolog fact',
	'       ?? (CAct << SndAg) - query if a message (CAct << SndAg) was received and is in the belief base',
	'       ?? (CAct << SndAg) @ TimeExpr - query is a message was received at time defined by TimeExpr',
	'Where: TimeExpr can be: ',
	'       RTime: reception time',
	'       after(Time): messages received after time Time',
	'       past(N sec): messages received in the past N seconds',
	'       before(Time): messages received before time Time',
	'       prior(N sec): messages received prior to past N seconds ',
	'       last: last message received',
	'Note:  parenthesis, when indicated above, are mandatory'
	]).

?? Bel :-
	var(Bel),
	this_agent(Ag),
	safe_findall_bels(Ag,Bel,Bels),
	member(Bel,Bels).

?? (CAct << SndAg) :-
	this_agent(Ag),
	safe_findall_bels(Ag,receive(CAct,SndAg,_),Bels),
	member(receive(CAct,SndAg,_),Bels).

?? (CAct << SndAg) @ RTime :-
	\+compound(RTime),
	!,
	this_agent(Ag),	
	safe_findall_bels(Ag,receive(CAct,SndAg,RTime),Bels),
	member(receive(CAct,SndAg,RTime),Bels).

?? (CAct << SndAg) @ after(Time) :-
	!,
	this_agent(Ag),	
	safe_findall_bels(Ag,receive(CAct,SndAg,_),Bels),
	member(receive(CAct,SndAg,T),Bels),
	T >= Time.

?? (CAct << SndAg) @ past(N sec) :-
	!,
	get_time(T0),
	T0_N is T0 - N,
	this_agent(Ag),	
	safe_findall_bels(Ag,receive(CAct,SndAg,_),Bels),
	member(receive(CAct,SndAg,T),Bels),
	T >= T0_N.

?? (CAct << SndAg) @ before(Time) :-
	!,
	this_agent(Ag),	
	safe_findall_bels(Ag,receive(CAct,SndAg,_),Bels),
	member(receive(CAct,SndAg,T),Bels),
	T < Time.
	
?? (CAct << SndAg) @ prior(N sec) :-
	!,
	get_time(T0),
	T0_N is T0 - N,
	this_agent(Ag),	
	safe_findall_bels(Ag,receive(CAct,SndAg,_),Bels),
	member(receive(CAct,SndAg,T),Bels),
	T < T0_N.
	
?? (CAct << SndAg) @ last :-
	!,
	this_agent(Agid),
	with_mutex(agilog_rectime_mutex,(
		last_reception_time(Agid,Time)
	)),
	?? CAct << SndAg @ Time.

?? Bel :-
	this_agent(Ag),
	safe_findall_bels(Ag,Bel,Bels),
	member(Bel,Bels).

% Safe database query using mutexes: 
% Note that because with_mutex() works 
% like once() it is necessary to retrieve 
% a list of beliefs to allow backtracking

safe_findall_bels(Ag,Bel,Bels) :-
	with_mutex(agilog_bels_mutex,(
		copy_term(Bel,BelTempl),
		findall(BelTempl, bel(Ag,BelTempl), Bels)
	)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Add belief operations
%
%

alog_help((++),operator, 'Add a new belief to the belief base', 
	[
	'Usage: ++ Bel',
	'Where: Bel: is a Prolog fact'
	]).

++ Bel :-
	is_fact(Bel),
	this_agent(Ag),
	with_mutex(agilog_bels_mutex,(
		assert(bel(Ag,Bel))
	)),
	with_mutex(agilog_threads_mutex,(
		eventDispatchThread(Ag,EventDispatchThread)
	)),
%	writeln('vai enviar add_bel para a thread'),
	safe_thread_send_message(EventDispatchThread,add_bel(Ag,Bel))
%	,writeln('enviou add_bel para a thread')
	.

is_fact(_:-_) :- 
	!,
	fail.
is_fact(_).
	

silent_add_bel(Bel) :-
	is_fact(Bel),
	this_agent(Ag),
	with_mutex(agilog_bels_mutex,(
		assert(bel(Ag,Bel))
	)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Delete belief operations
%
%

alog_help((--),operator, 'Delete a belief from the belief base', 
	[
	'Usage: -- Bel',
	'Where: Bel: is a Prolog fact'
	]).

-- Bel :-
	is_fact(Bel),
	this_agent(Ag),
	with_mutex(agilog_bels_mutex,
		(retractall(bel(Ag,Bel)))),
	with_mutex(agilog_threads_mutex,(
		eventDispatchThread(Ag,EventDispatchThread)
	)),
	safe_thread_send_message(EventDispatchThread,del_bel(Ag,Bel)).

silent_del_bel(Bel) :-
	is_fact(Bel),
	this_agent(Ag),
	with_mutex(agilog_bels_mutex,
		(retractall(bel(Ag,Bel)))).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Update belief operations
%
%

alog_help((-+),operator, 'Update a belief from the belief base', 
	[
	'Usage: -+ Bel',
	'Where: Bel: is a Prolog fact'
	]).

-+ Bel/N :-
	!,
	is_fact(Bel),
	integer(N),
	this_agent(Ag),
	Bel =.. [BelP | BelArgs],
	bel_args_to_vars(BelArgs,BelArgsVars,N),
	DelBel =.. [BelP | BelArgsVars],
%	findall(DelBel,
%		with_mutex(agilog_bels_mutex,(
%			bel(Ag,DelBel)
%		)),
%		DelBelList),
	with_mutex(agilog_bels_mutex, (
		retractall(bel(Ag,DelBel)),
		assert(bel(Ag,Bel))
	)),
	with_mutex(agilog_threads_mutex,(
		eventDispatchThread(Ag,EventDispatchThread)
	)),
	safe_thread_send_message(EventDispatchThread,upd_bel(Ag,Bel)).

-+ Bel :-
	-+ Bel/0.
	
silent_upd_bel(DelBel,AddBel) :-
	!,
	is_fact(AddBel),
	this_agent(Ag),
	with_mutex(agilog_bels_mutex, (
		retractall(bel(Ag,DelBel)),
		assert(bel(Ag,AddBel))
	)).
	
	
bel_args_to_vars([Arg|BelArgs],[Arg|BelArgsVars],N) :-
	N \= 0,
	!,
	N1 is N-1,
	bel_args_to_vars(BelArgs,BelArgsVars,N1).

bel_args_to_vars([_|BelArgs],[_|BelArgsVars],N) :- 
	!,
	bel_args_to_vars(BelArgs,BelArgsVars,N).

bel_args_to_vars([],[],_).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% AUXILIARY PREDICATES
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Debugging predicates
%
%

print_debug_fail(M) :-
	write('***debug:'),
	write(M),
	writeln('***'),
	fail.
	

%========================================================
%
% Help predicate.
%.
alog_help(ahlp,predicate,'Get help about Agilog predicates, operators and events',
	[
	'Usage: ahlp | ahlp(Category) | ahlp(Pred) | ahlp(Oper) | ahlp(Event)',
	'Where: Category: one of: preds, ops, events',
	'       Pred, Oper, Event: identifiers, respectivelly, of some Agilog predicate, operator or event'
	]).

ahlp :-
	ahlp(ahlp),
    writeln('Agilog predicates:'),
    forall(alog_help(P,predicate,PTit,_), (
		format('~w~32|~w~n',[P,PTit])
	)),
	nl,
    writeln('Agilog operators:'),
    forall(alog_help(O,operator,OTit,_), (
		format('~w~20|~w~n',[O,OTit])
	)),
	nl,
    writeln('Agilog events:'),
    forall(alog_help(E,event,ETit,_),
		format('~w~20|~w~n',[E,ETit])),
    nl.

ahlp(preds) :-
	!,
    writeln('Agilog predicates:'),
    forall(alog_help(P,predicate,PTit,_), (
		format('~w~32|~w~n',[P,PTit])
	)),
    nl.

ahlp(ops) :-
	!,
    writeln('Agilog operators:'),
    forall(alog_help(O,operator,OTit,_), (
		format('~w~20|~w~n',[O,OTit])
	)),
    nl.

ahlp(events) :-
	!,
    writeln('Agilog events:'),
    forall(alog_help(E,event,ETit,_), (
		format('~w~20|~w~n',[E,ETit])
	)),
    nl.

ahlp(P) :-
	alog_help(P,predicate,_,_),
	!,
	forall(alog_help(P,predicate,Tit,Descr), (	
		write('Agilog predicate: '),writeln(P),
        write('Descr: '), writeln(Tit),
		forall(member(Lin,Descr), (
			writeln(Lin)
		)),
		nl
	)).

ahlp(O) :-
	alog_help(O,operator,_,_),
	!,
	forall(alog_help(O,operator,Tit,Descr), (
		write('Agilog operator: '),writeln(O),
        write('Descr: '), writeln(Tit),
		forall(member(Lin,Descr), (
			writeln(Lin)
		)),
		nl
	)).

ahlp(E) :-
	alog_help(E,event,_,_),
	!,
	forall(alog_help(E,event,Tit,Descr), (
		write('Agilog event: '),writeln(E),
        write('Descr: '), writeln(Tit),
		forall(member(Lin,Descr), (
			writeln(Lin)
		)),
		nl
	)).

ahlp(_) :-
	ahlp(ahlp).



