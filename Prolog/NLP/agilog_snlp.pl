:- [javalog].

snlp_demo(Txt) :-
    writeln('**** creating SNLP objects'),
    new::'java.util.Properties'([]) => Props,
    Props::setProperty(['annotators','tokenize, ssplit, pos, lemma, ner, parse']),
    new::'edu.stanford.nlp.pipeline.StanfordCoreNLP'([Props]) => Pipeline,
    new::'edu.stanford.nlp.pipeline.Annotation'([Txt]) => Annotation,

    writeln('**** runnning annotators on text'),
    Pipeline::annotate([Annotation]),

    writeln('**** preparing output string buffer'),
    new::'java.io.StringWriter'([]) => StringBuffer,
    new::'java.io.PrintWriter'([StringBuffer]) => PrintWriter,

    writeln('**** doing pipeline pretty printing'),
    Pipeline::prettyPrint([Annotation,PrintWriter]),

    writeln('**** recovering string from string buffer'),
    StringBuffer::toString([]) => Str,

    writeln('**** writing string'),
    writeln(Str).

snlp_assert_pos_tag(N) :-
	N::getWords([]) => Words, 
	array::Words=>List,
	maplist(term_string,ListTerm,List),
	writeln(ListTerm),
	retractall(word(_,_,_)),
	maplist(assertz,ListTerm).

%snlp_assert_parse_tree(N) :-
%	N::getParseTree([]) => ParseTree,
%	term_string(ParseTreeTerm,ParseTree),
%	retractall(parse_tree(_,_)),
%	assertz(ParseTreeTerm).

snlp_assert_dependence_tree(N) :-
	N::getDependenceGraph([]) => Edges, 
	array::Edges=>List,
	maplist(term_string,ListTerm,List),
	writeln(ListTerm),
	retractall(edge_dependence(_,_,_)),
	maplist(assertz,ListTerm).

snlp_assert_basic_dependence_tree(N) :-
	N::getBasicDependenceGraph([]) => Edges, 
	array::Edges=>List,
	maplist(term_string,ListTerm,List),
	writeln(ListTerm),
	retractall(edge_dependence_basic(_,_,_)),
	maplist(assertz,ListTerm).

snlp_parse(Txt) :- 
	new::'agilog.snlp.SNLPPrologAdapter'([Txt]) => N,
	snlp_assert_pos_tag(N),
	%snlp_assert_parse_tree(N),
	snlp_assert_dependence_tree(N),
	snlp_assert_basic_dependence_tree(N).

verb(X) :-
	word(X,vb,_);	
	word(X,vbd,_);
 	word(X,vbg,_);
 	word(X,vbn,_);
 	word(X,vbp,_);
 	word(X,vbz,_).

adjective(X) :-
	word(X,jj,_).

is_synonym(add,X) :-
	memberchk(X, ['add','attach','append','annex','bind','connect','fix','put']).

is_synonym(new,X) :-
	memberchk(X, ['new']).

%% Frase exemplo:
%% I need a field for secret name in the pacient form
t1 :- 
	adjective(Adjective),
	edge_dependence_basic(What,Adjective,amod),
	edge_dependence_basic(What,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,amod),
	
	word(What,nn,_),		

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	atom_concat(Adjective,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	writeln('0'),
	writeln('## Transformation 1 ##'),
	write('Field Name: '),writeln(Complete_What),
	write('Location Name: '),writeln(Complete_Where),!.


%% Frase exemplo:
%% I need a new information in the pacient form
t1 :- 
	adjective(Adjective),
	edge_dependence_basic(Connect,Adjective,amod),
	edge_dependence_basic(Connect,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,amod),
	
	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	writeln('1'),
	writeln('## Transformation 1 ##'),
	writeln('Field Name: >> NOT INFORMED <<'),
	write('Location Name: '),writeln(Complete_Where),!.



%%Frase exemplo: 
%%Put a new information in costumer register
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),
	
	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	writeln('3'),
	writeln('## Transformation 1 ##'),
	writeln('Field Name: >> NOT INFORMED <<'),
	write('Location Name: '),writeln(Complete_Where),!.


%%Frase exemplo: 
%%Please, add a new field for secret name in the customer form

t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),

	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,What,nmod),
	edge_dependence_basic(What,What_Complement,amod),
	
	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	atom_concat(What_Complement,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	writeln('4'),
	writeln('## Transformation 1 ##'),
	write('Field Name: '),writeln(Complete_What),
	write('Location Name: '),writeln(Complete_Where),!.

%%Frase exemplo: 
%%Please, add a new field in the customer form
t1 :-
	verb(X),
	is_synonym('add',X),
	edge_dependence_basic(X,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),
	
	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	writeln('5'),
	writeln('## Transformation 1 ##'),
	writeln('Field Name: >> NOT INFORMED <<'),
	write('Location Name: '),writeln(Complete_Where),!.

%% Essa regra tem que ser verificada pois talvez precise de mais informações
%%Frase exemplo: 
%% Please, add a new field in the register
t1 :-
	verb(X),
	is_synonym('add',X),
	edge_dependence_basic(X,Where,nmod),
	
	writeln('6'),
	writeln('## Transformation 1 ##'),
	writeln('Field Name: >> NOT INFORMED <<'),
	write('Location Name: '),writeln(Where),!.


	
