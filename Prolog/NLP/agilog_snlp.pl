:- [javalog].
:-style_check(-discontiguous).
:- [basefatosprolog].


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
	%writeln(ListTerm),
	retractall(word(_,_,_)),
	maplist(assertz,ListTerm).

snlp_assert_ner_tag(N) :-
	N::getNers([]) => Nes, 
	array::Nes=>List,
	maplist(term_string,ListTerm,List),
	%writeln(ListTerm),
	retractall(ner(_,_,_)),
	maplist(assertz,ListTerm).

%snlp_assert_parse_tree(N) :-
%	N::getParseTree([]) => ParseTree,
%	term_string(ParseTreeTerm,ParseTree),
%	retractall(parse_tree(_,_)),
%	assertz(ParseTreeTerm).

snlp_assert_dependence_tree(N) :-
	N::getDependenceGraph([]) => Edges, 
	array::Edges=>List,
	%write('Lista de Termos: '),
	%writeln(List),
	maplist(term_string,ListTerm,List),
	%writeln(ListTerm),
	retractall(edge_dependence(_,_,_)),
	maplist(assertz,ListTerm).

snlp_assert_basic_dependence_tree(N) :-
	N::getBasicDependenceGraph([]) => Edges, 
	array::Edges=>List,
	%write('Lista de Termos: '),
	%writeln(List),
	maplist(term_string,ListTerm,List),
	%writeln(ListTerm),
	retractall(edge_dependence_basic(_,_,_)),
	maplist(assertz,ListTerm).

snlp_parse(Txt) :- 
	new::'agilog.snlp.SNLPPrologAdapter'([Txt]) => N,
	snlp_assert_pos_tag(N),
	snlp_assert_ner_tag(N),
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
	memberchk(X, ['add','attach','append','annex','bind','connect','fix','put','create','include','insert']).

is_synonym(hide,X) :-
	memberchk(X, ['hide','delete','cover','exclude','destroy','annul','remove','erase','conceal']).

is_synonym(move,X) :-
	memberchk(X, ['move','change','put','attach','get','place','relocate','shift']).

is_synonym(upper,X) :-
	memberchk(X, ['upper','top']).

is_synonym(last,X) :-
	memberchk(X, ['last','bottom']).

is_synonym(new,X) :-
	memberchk(X, ['new']).

is_synonym(field,X) :-
	memberchk(X, ['field']).	

is_synonym(patient,X) :-
	memberchk(X, ['users','patient','person','visits','encounters','providers','locations']).

is_synonym(patient_names,X) :-
	memberchk(X,['patientNames']).

is_synonym('patient names',X) :-
	memberchk(X,['patientNames']).

is_synonym(name_panel,X) :-
	memberchk(X,['patientNames']).

is_synonym('name panel',X) :-
	memberchk(X,['patientNames']).



%Predicado para checar existencia do elemento na ONTOLOGIA e buscar o ID correspondente
check_id_ontology(Name,Id) :-
	is_synonym(Name,Ontology_name),
	interfaceElement(Id,Ontology_name).

avaliar_transformacoes :-
	retractall(resposta(_)),
	retractall(where(_)),
	retractall(what(_)),
	t1,
	resposta(R),
	++resposta(R),
	where(Id) -> ++where(Id),
	what(Complete_What) -> ++what(Complete_What).

%% Transformacao 1 permite 'adicionar campos'

%%Frases exemplo: 
%% Please, add an identity field in the customer register/Add age field on the customer form/Can I add a Cell Phone Number field on customer form?
%% Please, add up an identity field in the customer register/Add up age field in the customer form/ May I add Cell Phone Number field in customer form?
%% Include identity field in the customer register/ Create one more identity field / Create another identify field / Is it possible to add another identity field? 
%% How can/could I create an extra identity field? / Shall I add another field? 

t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),
	edge_dependence_basic(Where,Where_Complement,compound),
	is_synonym('field',What),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),Z),
	atomic_list_concat(Z, ' ', Complete_What),

	atom_concat(Where_Complement,' ',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	%writeln('1'),
	
	check_where(Complete_Where,Id),
	assertz(resposta('identificamos a transformacao T1.1')),
	assertz(what(Complete_What)),
	assertz(where(Id)),!.

%% Praticamente a mesma regra que a anterior, mas como nao temos a palavra field, a verificacao tem que ser diferente
%%Frase exemplo: 
%% Please, add cell phone number in customer register
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),	

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	%writeln('2'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '), writeln(Complete_What),
	%write('Location Name: '),writeln(Complete_Where),
	check_where(Complete_Where,Id),
	assertz(resposta('identificamos a transformacao T1.2')),
	assertz(what(Complete_What)),
	assertz(where(Id)),!.

%%Frase exemplo: 
%% VERIFICAR NECESSIDADE PELO FATO DAS MAIUSCULAS
%% Please, add identity field in the customer register
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(What, What_Complement,compound),
	edge_dependence_basic(Verb,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	%writeln('3'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '), writeln(What_Complement),
	%write('Location Name: '),writeln(Complete_Where),
	check_where(Complete_Where,Id),
	assertz(resposta('identificamos a transformacao T1.3')),
	assertz(what(What_Complement)),
	assertz(where(Id)),!.

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

	%writeln('4'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(Complete_What),
	%write('Location Name: '),writeln(Complete_Where),
	check_where(Complete_Where,Id),
	assertz(resposta('identificamos a transformacao T1.4')),
	assertz(what(Complete_What)),
	assertz(where(Id)),!.

%%Frase exemplo: 
%%Put a new information in costumer register
t1(Id, What) :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),

	%% verifica se o objeto direto possui um adjetivo relacionado, neste caso 'new'
	edge_dependence_basic(Ligacao,_,amod),

	edge_dependence_basic(Verb,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),
	
	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	%writeln('5'),
	%writeln('## Transformation 1 ##'),
	%writeln('Field Name: >> NOT INFORMED <<'),
	%write('Location Name: '),writeln(Complete_Where),
	miss_what(Complete_Where,What),	
	check_where(Complete_Where,Id),!.


%%Frase exemplo: 
%%Put a new information in costumer register
t1(Id, What) :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),

	%% verifica se o objeto direto possui um adjetivo relacionado, neste caso 'new'
	edge_dependence_basic(Ligacao,_,amod),

	edge_dependence_basic(Ligacao,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),
	
	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	%writeln('6'),
	%writeln('## Transformation 1 ##'),
	%writeln('Field Name: >> NOT INFORMED <<'),
	%write('Location Name: '),writeln(Complete_Where),	
	check_where(Complete_Where,Id),
	namePanel(Id,NeWhere),
	miss_what(NeWhere,What),!.

%% Frase exemplo:
%% I need a field for secret name in the patient form
t1 :- 
	adjective(Adjective),
	edge_dependence_basic(What,Adjective,amod),
	edge_dependence_basic(What,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),
	%is_synonym('field',What),
	word(What,nn,_),		

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	atom_concat(Adjective,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	%writeln('7'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(Complete_What),
	%write('Location Name: '),writeln(Complete_Where),
	check_where(Complete_Where,Id),
	assertz(resposta('identificamos a transformacao T1.7')),
	assertz(what(Complete_What)),
	assertz(where(Id)),!.

%%Frase exemplo: 
%% Please, add a phone number field in the person/Add a document field in the patient
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	%edge_dependence_basic(What, What_Complement,compound),
	edge_dependence_basic(Verb,Where,nmod),
	is_synonym('patient',Where),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds		
	findall(X,edge_dependence_basic(What, X, compound),Z),
	atomic_list_concat(Z, '_', Complete_What),
	
	%writeln('8'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '), writeln(Complete_What),
	%write('Location Name: '),writeln(Where),
	check_where(Where,Id),
	assertz(resposta('identificamos a transformacao T1.8')),
	assertz(what(Complete_What)),
	assertz(where(Id)),!.

%%Frase exemplo: 
%% Aqui usuario indica nome do local como registro ou algo parecido sem mencionar qual tipo especifico
%% Please, add a cell phone field in the register/Add a document field in the register
t1(Id,Complete_What) :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds		
	findall(X,edge_dependence_basic(What, X, compound),Z),
	atomic_list_concat(Z, ' ', Complete_What),
	edge_dependence_basic(Verb,_,nmod),
	
	%writeln('9'),
	%%writeln('## Transformation 1 ##'),
	
	miss_where(Complete_What,Id).	
	
%%Frase exemplo: 
%%Please, add age in the customer form
t1(Id,What) :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),
	\+is_synonym('field',What),
	
	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	%writeln('10'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(What),
	%write('Location Name: '),writeln(Complete_Where),
	check_where(Complete_Where,Id),
	assertz(resposta('identificamos a transformacao T1.10')),
	assertz(what(What)),
	assertz(where(Id)),!.

%%verificar real necessidade
%%Frase exemplo:
%%Please, add up Form/Age in the customer form
t1(Id, What) :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(What,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),
	\+is_synonym('field',What),
	
	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	%writeln('11'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(What),
	%write('Location Name: '),writeln(Complete_Where),
	check_where(Complete_Where,Id),
	assertz(resposta('identificamos a transformacao T1.11')),
	assertz(what(What)),
	assertz(where(Id)),!.

%Frase exemplo:
%Create a field called Phone Number on the customer register
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,Nominal,acl),
	edge_dependence_basic(Nominal,What,xcomp),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	edge_dependence_basic(Nominal,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),
	
	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds		
	findall(X,edge_dependence_basic(What, X, compound),Z),
	atomic_list_concat(Z, '_', Compound_What),

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	%writeln('12'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(Complete_What),
	%write('Location Name: '),writeln(Complete_Where),
	check_where(Complete_Where,Id),
	assertz(resposta('identificamos a transformacao T1.12')),
	assertz(what(Complete_What)),
	assertz(where(Id)),!.

%Frase exemplo:
%Create a field called name on the customer register
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,Nominal,acl),
	edge_dependence_basic(Nominal,What,xcomp),
	edge_dependence_basic(Nominal,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),
	
	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	%writeln('13'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(What),
	%write('Location Name: '),writeln(Complete_Where),
	check_where(Complete_Where,Id),
	assertz(resposta('identificamos a transformacao T1.13')),
	assertz(what(What)),
	assertz(where(Id)),!.


%Frase exemplo:
%Create a field called name on the customer register
t1(Id, What) :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,Nominal,acl),
	edge_dependence_basic(Nominal,What,xcomp),
	edge_dependence_basic(Nominal,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),
	
	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	%writeln('14'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(What),
	%write('Location Name: '),writeln(Complete_Where),
	check_where(Complete_Where,Id),
	assertz(resposta('identificamos a transformacao T1.14')),
	assertz(what(What)),
	assertz(where(Id)),!.

%%Frase exemplo: 
%%Please, add cell phone field/create an age field/add age field
t1(Id, Complete_What) :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	is_synonym('field',What),
	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds		
	findall(X,edge_dependence_basic(What, X, compound),Z),
	atomic_list_concat(Z, '_', Complete_What),

	%writeln('15'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(Complete_What),
	miss_where(Complete_What,Id),!.

%%Frase exemplo: 
%%Please, add cell phone number
t1(Id, Complete_What) :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds		
	findall(X,edge_dependence_basic(What, X, compound),Z),
	atomic_list_concat(Z, '_', What_Complement),

	atom_concat(What_Complement,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	%writeln('16'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(Complete_What),
	miss_where(Complete_What,Id),!.

%%Frase exemplo: 
%%I would like to create a field called Identity Card
t1(Id, Complete_What) :-
	verb(Verb),
	is_synonym('add',Verb),
	%is_synonym('field',What),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,Nominal,acl),
	edge_dependence_basic(Nominal,What,xcomp),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds		
	findall(X,edge_dependence_basic(What, X, compound),Z),
	atomic_list_concat(Z, '_', Compound_What),

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),
	
	%writeln('17'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(Complete_What),
	miss_where(Complete_What,Id),!.

%%Frase exemplo: 
%%I would like to create a field called age
t1(Id, What) :-
	verb(Verb),
	is_synonym('add',Verb),
	%is_synonym('field',What),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,Nominal,acl),
	edge_dependence_basic(Nominal,What,xcomp),

	%writeln('18'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(What),
	miss_where(What,Id),!.

%%Frase exemplo: 
%%Please, add stauts/Add age
t1(Id, What) :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),

	%writeln('19'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(What),
	miss_where(What,Id),!.

miss_where(What,Id) :-

	write('Ok, I get you want to add '), write(What), write('. But I need to know what\'s the panel you want to add it. '),
	write('Please, write the panel name you want to add '), write(What), write(' field:'), nl,

       repeat,
	 nl,
  	 read(Where),
         (    check_id_ontology(Where,Id)
	 -> !
	 ; write('This panel name doesn\'t match a valid instance. Please enter a valid panel:' ),
	   fail
	 ).

check_where(Where,Id) :-

       repeat,
         (    check_id_ontology(Where,Id)
	 -> !
	 ; (write(Where), write(' doesn\'t match a valid instance. Please enter a valid panel:' ),
	 nl,
	 read(Newhere),
	 check_where(Newhere,Id)),
	    !
	 ).

miss_what(Where,NeWhat) :-

	write('Ok, I get you want to add a field in '), write(Where), write('. But I need to know what\'s the field you want to add in it. '),
	write('Please, write the field name you want to add: '), nl,

       repeat,
	 nl,
  	 read(NeWhat),
         (    nonvar(NeWhat)
	 -> !
	 ; write('This field is not valid. Please enter a valid field name:' ),
	   fail
	 ).

%% Transformcao 2 'ocultar campos'

%%Frases exemplo: 
%% Delete identity field in the customer register / Delete identity from customer register / 
%% Delete identity card field in the customer register
%% On the customer register, please remove Cell Phone field
%% Cut out identity field from customer register (nao funciona)
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),
	is_synonym('field',What),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Complete_What),

	atom_concat(Where_Complement,' ',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	writeln('0'),
	writeln('## Transformation 2 ##'),
	write('Field To Hide: '), writeln(Complete_What),
	write('Location Name: '),writeln(Complete_Where),!.

%%Frase exemplo: 
%%Delete identity card in the customer register
%%I would like to remove cell phone number in the customer form 
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),	

	atom_concat(Compound_What,' ',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	atom_concat(Where_Complement,' ',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	writeln('1'),
	writeln('## Transformation 2 ##'),
	write('Field To Hide: '),writeln(Complete_What),
	write('Location Name: '),writeln(Complete_Where),!.

%%Frase exemplo: 
%%Delete Identifier Type in the customer register
%%I would like to remove cell phone in the customer form 
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(What,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),	

	atom_concat(Compound_What,' ',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	atom_concat(Where_Complement,' ',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	writeln('2'),
	writeln('## Transformation 2 ##'),
	write('Field To Hide: '),writeln(Complete_What),
	write('Location Name: '),writeln(Complete_Where),!.



%%Frases exemplo: 
%% Delete information about patient's cell phone in the customer register
%% Delete information about patient's street name in the register
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,What,nmod),
	edge_dependence_basic(What,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),	
	
	atom_concat(Compound_What,' ',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	atom_concat(Where_Complement,' ',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	writeln('3'),
	writeln('## Transformation 2 ##'),
	write('Field To Hide: '),writeln(Complete_What),
	write('Location Name: '),writeln(Complete_Where),!.

%%Frases exemplo: 
%% Delete information about patient's age in the customer register
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,What,nmod),
	edge_dependence_basic(What,What_Complement,nmod:poss),
	edge_dependence_basic(What,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),

	atom_concat(What_Complement,' ',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	atom_concat(Where_Complement,' ',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	writeln('4'),
	writeln('## Transformation 2 ##'),
	write('Field To Hide: '),writeln(Complete_What),
	write('Location Name: '),writeln(Complete_Where),!.

%%Frase exemplo: 
%% Delete weight in the customer register
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),

	atom_concat(Where_Complement,' ',U_What_Complement),
	atom_concat(U_What_Complement,Where,Complete_Where),

	writeln('5'),
	writeln('## Transformation 2 ##'),
	write('Field To Hide: '),writeln(What),
	write('Location Name: '),writeln(Complete_Where),!.

%%Frase exemplo: 
%% Delete identity card field in the register/Remove cell phone number field
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	is_synonym('field',What),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Complete_What),	

	writeln('6'),
	writeln('## Transformation 2 ##'),
	write('Field To Hide: '),writeln(Complete_What),
	write('Location Name: >> NOT INFORMED <<'),!.

%%Frase exemplo: 
%% Delete cell phone in the register
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),

	atom_concat(Compound_What,' ',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	writeln('7'),
	writeln('## Transformation 2 ##'),
	write('Field To Hide: '),writeln(Complete_What),
	write('Location Name: >> NOT INFORMED <<'),!.

%%Frase exemplo: 
%% I would like to hide patient's age
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),

	writeln('8'),
	writeln('## Transformation 2 ##'),
	write('Field To Hide: '),writeln(What),
	write('Location Name: >> NOT INFORMED <<'),!.


%%Frase exemplo: 
%% Delete weight in the register
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,_,nmod),
	%%edge_dependence_basic(Where,Where_Complement,compound),

	writeln('9'),
	writeln('## Transformation 2 ##'),
	write('Field To Hide: '),writeln(What),
	write('Location Name: >> NOT INFORMED <<'),!.

	
%%Frase exemplo: 
%% Delete information about patient's age
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,What,nmod),

	writeln('10'),
	writeln('## Transformation 2 ##'),
	write('Field To Hide: '),writeln(What),
	write('Location Name: >> NOT INFORMED <<'),!.

%%Frases exemplo: 
%% Delete cell phone field.
%% Hide street name field.
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),

	%%usa a verificacao abaixo apenas para comprovar a existencia de um compound relacionado com um verbo para validar a regra.	
	edge_dependence_basic(Ligacao,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(Ligacao, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Complete_What),

	writeln('11'),
	writeln('## Transformation 2 ##'),
	write('Field To Hide: '),writeln(Complete_What),
	write('Location Name: >> NOT INFORMED <<'),!.


%% Transformcao 3 'mudar posicao dos campos/paineis'


	inf(IndiceT,up,What,Position,Numeral) :-
	
	NewPosition is Position - Numeral,

	writeln(IndiceT),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(What),
	write('Going To Position: '),writeln(NewPosition).

	inf(IndiceT,down,What,Position,Numeral) :-
	
	NewPosition is Position + Numeral,

	writeln(IndiceT),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(What),
	write('Going To Position: '),writeln(NewPosition).
	
%%Frase exemplo:
%%Please, move Identifier Type up/down one position
%% Swap identity  for location / Switch identity in place of location / Move identity from customer register to patient indentifiers / Get identifier type to upper position / Get-place-relocate-shift-change-move identifier type to the top-bottom / Place identifier type in ... / Put address in between division and province / Place address between division and province / Relocate adress above-below division /   

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),

	atom_concat(Compound_What,' ',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),


	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Inflaction,case),
	edge_dependence_basic(Nominal,Elipsed,nummod),
	idCampo(Complete_What,Id),
	posicao(Id,Position),
	ner(Elipsed,Numeral,_),
	%%conv(Elipsed,Numeral),
	inf('1',Inflaction,Complete_What,Position,Numeral),!.
	

%%Frase exemplo:
%%Please, move Identifier Type Field up/down one position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),

	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Inflaction,case),
	edge_dependence_basic(Nominal,Elipsed,nummod),
	idCampo(Compound_What,Id),
	posicao(Id,Position),
	ner(Elipsed,Numeral,_),
	%%conv(Elipsed,Numeral),
	inf('2',Inflaction,Compound_What,Position,Numeral),!.

%%Move Identifier Type field up/down one position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),

 	edge_dependence_basic(Verb,Inflaction,compound:prt),
 	edge_dependence_basic(Verb,Dep,dep),
 	edge_dependence_basic(Dep,Elipsed,nummod),
	idCampo(Compound_What,Id),
	posicao(Id,Position),
	ner(Elipsed,Numeral,_),	
	%%conv(Elipsed,Numeral),

	inf('3',Inflaction,Compound_What,Position,Numeral),!.


%%Frase exemplo:
%%Please, move Location Field up/down one position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(What, What_Complement,compound),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Inflaction,case),
	edge_dependence_basic(Nominal,Elipsed,nummod),
	idCampo(What_Complement,Id),
	posicao(Id,Position),
	ner(Elipsed,Numeral,_),
	%%conv(Elipsed,Numeral),
	inf('4',Inflaction,What_Complement,Position,Numeral),!.

%%Frase exemplo:
%%Move Location Field up/down one position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(What, What_Complement,compound),
 	edge_dependence_basic(Verb,Inflaction,compound:prt),
	edge_dependence_basic(Verb,Dep,dep),
 	edge_dependence_basic(Dep,Elipsed,nummod),
	idCampo(What_Complement,Id),
	posicao(Id,Position),
	ner(Elipsed,Numeral,_),
	%%conv(Elipsed,Numeral),
	inf('5',Inflaction,What_Complement,Position,Numeral),!.


%%Frase exemplo:
%%Please, move Preferred up one position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Inflaction,case),
	edge_dependence_basic(Nominal,Elipsed,nummod),
	idCampo(What,Id),
	posicao(Id,Position),
	%%conv(Elipsed,Numeral),
	ner(Elipsed,Numeral,_),
	inf('6',Inflaction,What,Position,Numeral),!.

%%Frase exemplo:
%%Move Identifier Type to the first/second... position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),

	atom_concat(Compound_What,' ',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Numerals,amod),
	ner(Numerals,Ordinal,_),
	%%conv2(Numerals,Ordinal),
	idCampo(Complete_What,_),
		
	writeln('7'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(Complete_What),
	write('Going To Position: '),writeln(Ordinal),!.

%%Frase exemplo:
%%Move Identifier Type field to the first/second... position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),
	
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Numerals,amod),
	ner(Numerals,Ordinal,_),
	%%conv2(Numerals,Ordinal),
	idCampo(Compound_What,_),
		
	writeln('8'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(Compound_What),
	write('Going To Position: '),writeln(Ordinal),!.

%%Frase exemplo:
%%Move Location field to the first/second... position (Talvez nao precise desta regra pois a anterior a principio faz a funcao corretamente)

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(What, What_Complement,compound),
	
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Numerals,amod),
	ner(Numerals,Ordinal,_),	
	%%conv2(Numerals,Ordinal),
	idCampo(What_Complement,_),
		
	writeln('9'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(What_Complement),
	write('Going To Position: '),writeln(Ordinal),!.

%%Frase exemplo:
%%Move Location to the first/second... position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),
	
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Numerals,amod),
	ner(Numerals,Ordinal,_),	
	%%conv2(Numerals,Ordinal),
	idCampo(What,_),
		
	writeln('10'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(What),
	write('Going To Position: '),writeln(Ordinal),!.

%%Frase exemplo:
%%Get Identifier Type to upper position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),

	atom_concat(Compound_What,' ',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),
	
	idCampo(Complete_What,_),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Adjective,amod),
	is_synonym('upper',Adjective),
	
	writeln('11'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(Complete_What),
	write('Going To Position: '),writeln('1'),!.


%%Frase exemplo:
%%Get Identifier Type field to upper position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),
	
	idCampo(Compound_What,_),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Adjective,amod),
	is_synonym('upper',Adjective),
	
	writeln('12'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(Compound_What),
	write('Going To Position: '),writeln('1'),!.

%%Frase exemplo:
%%Get Identifier to upper position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	
	idCampo(What,_),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Adjective,amod),
	is_synonym('upper',Adjective),
	
	writeln('13'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(What),
	write('Going To Position: '),writeln('1'),!.

%%Frase exemplo:
%%Get Identifier Type to the last position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),

	atom_concat(Compound_What,' ',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),
	
	idCampo(Complete_What,Id),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Adjective,amod),
	is_synonym('last',Adjective),
	ultima(Id,UltimaPos),
	
	writeln('14'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(Complete_What),
	write('Going To Position: '),writeln(UltimaPos),!.

%%Frase exemplo:
%%Get Identifier Type field to the last position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),
	
	idCampo(Compound_What,Id),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Adjective,amod),
	is_synonym('last',Adjective),
	ultima(Id,UltimaPos),
	
	writeln('15'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(Compound_What),
	write('Going To Position: '),writeln(UltimaPos),!.

%%Frase exemplo:
%%Get Identifier to last position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	idCampo(What,Id),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Adjective,amod),
	is_synonym('last',Adjective),
	ultima(Id,UltimaPos),
	
	writeln('16'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(What),
	write('Going To Position: '),writeln(UltimaPos),!.

%%Frase exemplo:
%%Get Identifier Type to the top

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),

	atom_concat(Compound_What,' ',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),
	
	idCampo(Complete_What,_),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,_,case),
	is_synonym('upper',Nominal),
	
	writeln('17'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(Complete_What),
	write('Going To Position: '),writeln('1'),!.

%%Frase exemplo:
%%Get Identifier Type field to the top

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),
	
	idCampo(Compound_What,_),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,_,case),
	is_synonym('upper',Nominal),
	
	writeln('18'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(Compound_What),
	write('Going To Position: '),writeln('1'),!.

%%Frase exemplo:
%%Get Identifier to the top

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	
	idCampo(What,_),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,_,case),
	is_synonym('upper',Nominal),
	
	writeln('19'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(What),
	write('Going To Position: '),writeln('1'),!.

%%Frase exemplo:
%%Get Identifier Type to the bottom

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),

	atom_concat(Compound_What,' ',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),
	
	idCampo(Complete_What,Id),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,_,case),
	is_synonym('last',Nominal),
	ultima(Id,UltimaPos),
	
	writeln('20'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(Complete_What),
	write('Going To Position: '),writeln(UltimaPos),!.

%%Frase exemplo:
%%Get Identifier Type field to the bottom

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, ' ',Compound_What),
	
	idCampo(Compound_What,Id),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,_,case),
	is_synonym('last',Nominal),
	ultima(Id,UltimaPos),
	
	writeln('21'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(Compound_What),
	write('Going To Position: '),writeln(UltimaPos),!.

%%Frase exemplo:
%%Get Identifier to the bottom

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	
	idCampo(What,Id),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,_,case),
	is_synonym('last',Nominal),
	ultima(Id,UltimaPos),
	
	writeln('22'),
	writeln('## Transformation 3 ##'),
	write('Field To Move: '),writeln(What),
	write('Going To Position: '),writeln(UltimaPos),!.



%%Frase exemplo:
%%Put preferred in between Identifier Type and Location (Nao esta pronta)

%t3 :-
%	verb(Verb),
%	is_synonym('move',Verb),
%	edge_dependence_basic(Verb,What,dobj),
%
%	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
%	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
%	atomic_list_concat(List_Compound_What, ' ',Compound_What),
%	
%	edge_dependence_basic(Verb,Nominal,nmod),
%
%	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
%	findall(X,edge_dependence_basic(Nominal, Y, compound),List_Compound_What2),
%	atomic_list_concat(List_Compound_What2, ' ',Compound_What2),
%
%
%	edge_dependence_basic(Nominal,Conjunction,conj),
%	
%	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
%	findall(X,edge_dependence_basic(Conjunction, Z, compound),List_Compound_What3),
%	atomic_list_concat(List_Compound_What3, ' ',Compound_What3),
%
%	conv2(Numerals,Ordinal),
%	idCampo(Compound_What,_),
%		
%	writeln('17'),
%	writeln('## Transformation 3 ##'),
%	write('Field To Move: '),writeln(Compound_What),
%	write('Going To Position: '),writeln(Ordinal),!.

	

%% NOVA FORMA DE BUSCA DIRETAMENTE DA ONTOLOGIA
%% Verifica se o Id pertence a um campo 

%%Busca campo a partir do nome ou id
idCampo(Nome,Id):-
	field(Id,Nome).

%%Busca painel a partir do nome ou id
namePanel(Id,Nome):-
	panel(Id,Nome).

%%Busca posicao do campo na lista

posicao(Id,0):-
	\+ field(Id,_).

posicao(Id,1):-
	arco(Id,_,next),
	\+arco(_,Id,next).

posicao(Id,Posicao):-
	arco(IdAnterior,Id,next),
	posicao(IdAnterior,PosicaoAnterior),
	Posicao is PosicaoAnterior + 1.


%%Busca tamanho da lista de campos

ultima(Id,Tamanho):-
	\+arco(Id,_,next),
	posicao(Id,Tamanho).


ultima(Id,Tamanho):-
	arco(Id,IdProximo,next),
	ultima(IdProximo,Tamanho).
