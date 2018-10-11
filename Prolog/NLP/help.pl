%% Transformcao 4 (HELP) 'permite responder perguntas sobre a funcionalidade do sistema'



%%help
%%obs: se o nlp receber apenas uma palavra, ocorre um erro e o programa nao replica uma resposta para o usuario, a nao ser que seja inserido um ponto apos a palavra.
help :-

	(word('help',nn,_);word('help',vb,_)),
	assertz(transformation(help,1)),
	make_response,!.

%%What is the options
help :-

	pronoun(Wh_pronoun),
	edge_dependence_basic(Wh_pronoun,Noun,nsubj),
	is_synonym('opt',Noun),
	assertz(transformation(help,2)),
	make_response,!.

%%What changes can I do/What changes can I make
help :-
	
	verb(Verb),
	is_synonym('do',Verb),
	edge_dependence_basic(Verb,Changes,dobj),
	edge_dependence_basic(Changes,What,det),
	whpronoun(What),
	assertz(transformation(help,3)),
	make_response,!.

%%What can I do/What can I make
help :-
	
	verb(Verb),
	is_synonym('do',Verb),
	edge_dependence_basic(Verb,What,dobj),
	whpronoun(What),
	assertz(transformation(help,4)),
	make_response,!.

%%What can I add?/Create
help :-
	
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	whpronoun(What),
	assertz(transformation(help,5)),
	assertz(addVerb(_)),
	make_response,!.
	
%%Can I add a field?/Create
help :-
	
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,_,aux),
	is_synonym('field',What),
	
	assertz(transformation(help,6)),
	assertz(addVerb(_)),
	make_response,!.	

%%What can I hide?/Delete
help :-
	
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	whpronoun(What),
	assertz(transformation(help,7)),
	assertz(hideVerb(_)),
	make_response,!.
	
%%Can I hide a field?/Delete
help :-
	
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,_,aux),
	is_synonym('field',What),
	
	assertz(transformation(help,8)),
	assertz(hideVerb(_)),
	make_response,!.	

%%What can I move?/Change
help :-
	
	verb(Verb),
	is_synonym('move',Verb),
	edge_dependence_basic(Verb,What,dobj),
	whpronoun(What),
	assertz(transformation(help,9)),
	assertz(moveVerb(_)),
	make_response,!.
	
%%Can I move a field?/Change
help :-
	
	verb(Verb),
	is_synonym('move',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,_,aux),
	is_synonym('field',What),
	
	assertz(transformation(help,10)),
	assertz(moveVerb(_)),
	make_response,!.	

%%Frase exemplo: 
%%Please, create a field

%help :-
%	verb(Verb),
%	is_synonym('add',Verb),
%	edge_dependence_basic(Verb,What,dobj),
%	\+edge_dependence_basic(What,_,acl),
	

%	assertz(transformation(help,10)),
%	assertz(addVerb(_)),
%	make_response,!.



	
