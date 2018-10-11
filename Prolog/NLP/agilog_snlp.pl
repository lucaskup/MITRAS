:- [javalog].
:-style_check(-discontiguous).


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

noun(X) :-
	word(X,nn,_);
	word(X,nns,_);
	word(X,nnp,_);
	word(X,nnps,_).

pronoun(X) :-
	word(X,wp,_).

whpronoun(X) :-
	word(X,wdt,_). 

write_on_file(Texto) :-
	open('teste.txt',append,Stream),
	write(Stream,Texto), nl,
	close(Stream).

%Predicado para checar existencia do elemento na ONTOLOGIA e buscar o ID correspondente
check_id_ontology(Name,Id) :-
	is_synonym(Ontology_name,Name),
	interfaceElement(Id,Ontology_name).
check_field_id_ontology(Name,Id) :-
	is_synonym(Ontology_name,Name),
	field(Id,Ontology_name).
check_panel_id_ontology(Name,Id) :-
	is_synonym(Ontology_name,Name),
	panel(Id,Ontology_name).

limpa_base_crencas :-
	retractall(transformation(_,_)),
	retractall(resposta(_)),
	retractall(where(_)),
	retractall(where_name(_)),
	retractall(what(_)),
	retractall(what_id(_)),
	retractall(position(_)),
	retractall(addVerb(_)),
	retractall(hideVerb(_)),
	retractall(moveVerb(_)).

avaliar_transformacoes :-
	verb(Verb),	
	%is_synonym('add',Verb),
	\+is_synonym('hide',Verb),
	%\+is_synonym('move',Verb),
	limpa_base_crencas,
	t1,
	%%verifica se nao esta faltando where, se verdadeiro, entao prossegue na regra
	resposta(R),
	++resposta(R),	
	where(_),
	(where(Id) -> ++where(Id);true),
	(what(What) -> ++what(What);true),!.


avaliar_transformacoes :-
	verb(Verb),
	is_synonym('hide',Verb),
	\+is_synonym('add',Verb),
	\+is_synonym('move',Verb),	
	retractall(transformation(_,_)),
	retractall(resposta(_)),
	retractall(where(_)),
	retractall(where_name(_)),
	retractall(what(_)),
	retractall(what_id(_)),
	t2,
	resposta(R),
	++resposta(R),
	(where(Id) -> ++where(Id);true),
	(what(What) -> ++what(What);true),!.

avaliar_transformacoes :-
	verb(Verb),	
	is_synonym('move',Verb),
	%\+is_synonym('add',Verb),
	\+is_synonym('hide',Verb),	
	retractall(transformation(_,_)),
	retractall(resposta(_)),
	retractall(where(_)),
	retractall(where_name(_)),
	retractall(what(_)),
	retractall(what_id(_)),
	t3,
	resposta(R),
	++resposta(R),
	(position(Position) -> ++position(Position);true),
	(what(What) -> ++what(What);true),!.

%#################################################################


avaliar_transformacoes :-
	%retractall(transformation(_,_)),
	retractall(resposta(_)),
	what(_),
	transformation(t1,_),
	t1_reverse_miss_where,
	resposta(R),
	++resposta(R),
	(where(Id) -> ++where(Id);true),
	(what(What) -> ++what(What);true),
	write_on_file(R),
	:>writeln('ate aqui ja e'),!.

avaliar_transformacoes :-
	%retractall(transformation(_,_)),
	retractall(resposta(_)),
	where(_),
	t1_reverse_miss_what,
	resposta(R),
	++resposta(R),
	(where(Id) -> ++where(Id);true),
	(what(What) -> ++what(What);true),
	write_on_file(R),
	:>writeln('ate aqui ja e1'),!.

avaliar_transformacoes :-
	%retractall(transformation(_,_)),
	retractall(resposta(_)),
	what(_),
	t2_reverse_miss_where,
	resposta(R),
	++resposta(R),
	(where(Id) -> ++where(Id);true),
	(what(What) -> ++what(What);true),
	write_on_file(R),
	:>writeln('ate aqui ja e2'),!.

avaliar_transformacoes :-
	%retractall(transformation(_,_)),
	retractall(resposta(_)),
	where(_),
	t2_reverse_miss_what,
	resposta(R),
	++resposta(R),
	(where(Id) -> ++where(Id);true),
	(what(What) -> ++what(What);true),
	write_on_file(R),
	:>writeln('ate aqui ja e3'),!.


%%Preciso dessa regra para parar uma frase incompleta, pois frases incompletas vao ate a ultima regra avaliar_transformacoes e acaba
%mentindo que nao foi encontrada
avaliar_transformacoes :-
	what(_),
	\+where(_),!.

%%Preciso dessa regra para parar uma frase incompleta, pois frases incompletas vao ate a ultima regra avaliar_transformacoes e acaba
%mentindo que nao foi encontrada
avaliar_transformacoes :-
	where(_),
	\+what(_),!.


avaliar_transformacoes :-
		
	limpa_base_crencas,
	help,
	resposta(R),
	++resposta(R),!.


avaliar_transformacoes :-
:>writeln('ate aqui nao'),
	retractall(transformation(_)),
	retractall(resposta(_)),
	retractall(where(_)),
	retractall(where_name(_)),
	retractall(what(_)),
	++resposta('Sorry, we could not identify a transformation matching your necessity. I can add fields to specific panels and move UI elements.'),!.

make_response :- 
	transformation(t1,_),
	where_name(Where_Name),
	check_id_ontology(Where_Name,Id),
	assertz(where(Id)),
	assert_response,!.

make_response :- 
	transformation(t2,_),
	what(What),
	check_field_id_ontology(What,Id_What),
	assertz(what_id(Id_What)),
	where_name(Where_Name),
	check_panel_id_ontology(Where_Name,Id),
	assertz(where(Id)),
	
	assert_response,!.

make_response :- 
	transformation(t3,_),
	what(What),
	check_field_id_ontology(What,Id_What),
	assertz(what_id(Id_What)),
	assert_response,!.

make_response :- 
	assert_response,!.

assert_response :-
	transformation(t1,Rule),
	atom_concat('t1.',Rule,Transf),
	what(What),
	where(_),
	where_name(Where),
	assertz(miss_where('no')),
	atomic_list_concat(['Transformation ',Transf, ' identified. New field: ',What,' is going to be created in the ',Where],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-	
	transformation(t2,Rule),
	atom_concat('t2.',Rule,Transf),
	what(What),
	what_id(_),
	where(_),
	where_name(Where),
	atomic_list_concat(['Transformation ',Transf, ' identified. ',What, ' is going to removed from the ', Where],Resposta),
	assertz(resposta(Resposta)),!.
assert_response :-	
	transformation(t3,Rule),
	atom_concat('t3.',Rule,Transf),
	what(What),
	what_id(_),
	position(Pos),
	atomic_list_concat(['Transformation ',Transf, ' identified. ',What, ' is going to the ', Pos, 'th position.'],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(t1,Rule),
	atom_concat('t1.',Rule,Transf),
	\+what(_),
	assertz(miss_what('yes')),
	where_name(Where),	
	atomic_list_concat(['Transformation ',Transf, ' indentified, please inform what field do you want to create in the ',Where],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(t1,Rule),
	atom_concat('t1.',Rule,Transf),
	what(What),
	\+ where(_),
	\+ where_name(_),
	assertz(miss_where('yes')),
	atomic_list_concat(['Transformation ',Transf, ' indentified, please inform where the field ',What, ' should be created:'],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(t1,Rule),
	atom_concat('t1.',Rule,Transf),
	what(What),
	\+ where(_),
	assertz(miss_where('yes')),
	where_name(Where_Name),
	atomic_list_concat(['Transformation ',Transf, ' indentified, but the panel ',Where_Name ,' does not exists in the system. Please inform in what panel you want the field ',What, ' to be created:'],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(t2,Rule),
	atom_concat('t2.',Rule,Transf),
	\+what(_),
	where_name(Where),	
	atomic_list_concat(['Transformation ',Transf, ' indentified, please inform what do you want to hide in the ',Where],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(t2,Rule),
	atom_concat('t2.',Rule,Transf),
	what(What),
	what_id(_),
	\+ where(_),
	\+ where_name(_),
	atomic_list_concat(['Transformation ',Transf, ' indentified, please inform where the field ',What, ' is located:'],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(t2,Rule),
	atom_concat('t2.',Rule,Transf),
	what(What),
	\+what_id(_),
	\+ where(_),
	\+ where_name(_),
	atomic_list_concat(['Transformation ',Transf, ' indentified, but there is no ',What, ' field in the system.'],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(t2,Rule),
	atom_concat('t2.',Rule,Transf),
	what(What),
	\+ where(_),
	where_name(Where_Name),
	atomic_list_concat(['Transformation ',Transf, ' indentified, but the panel ',Where_Name ,' does not exists in the system. Please inform in what panel you want the field ',What, ' to be hidden.'],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(t2,Rule),
	atom_concat('t2.',Rule,Transf),
	what(What),
	\+what_id(_),
	where(_),
	where_name(Where_Name),
	atomic_list_concat(['Transformation ',Transf, ' indentified, but the field ',What ,' does not exists in the system. Please inform what field do you want to hide from ',Where_Name],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(t3,Rule),
	atom_concat('t3.',Rule,Transf),
	what(What),
	\+ position(_),
	atomic_list_concat(['Transformation ',Transf, ' indentified, but no position was specified. Please inform the position you want field ',What, ' to be placed.'],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(help,Rule),
	atom_concat('help.',Rule,Transf),
	addVerb(_),
	atomic_list_concat(['Transformation ',Transf, ' Hi! You can add fields or panels. If you want to add a new field, please write me the name and the location where you want to add it. Example: I want to add weight field in the Patient Information panel, thanks!!'],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(help,Rule),
	atom_concat('help.',Rule,Transf),
	hideVerb(_),
	atomic_list_concat(['Transformation ',Transf, ' Hi! You can hide fields or panels. If you want to hide a field, please write me the name and the location where you want to hide it. Example: I want to hide middle field in the Patient Name panel, thanks!!'],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(help,Rule),
	atom_concat('help.',Rule,Transf),
 	moveVerb(_),
	atomic_list_concat(['Transformation ',Transf, ' Hi! You can move fields or panels. If you want to move a field, please write me what field you want to move and the location. Example: I want to move middle to the last position or I want to change position to the third position, etc., thanks!!'],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(help,Rule),
	atom_concat('help.',Rule,Transf),
	\+addVerb(_),
	atomic_list_concat(['Transformation ',Transf, ' You can make changes in the graphical interface by adding new elements such as fields and panels, or modifying them by moving the position across the screen. You can also hide fields if you prefer. To do this, simply type what you want and I will interpret your requirements and present the modifications before you confirm. '],Resposta),
	assertz(resposta(Resposta)),!.
	



%% NOVA FORMA DE BUSCA DIRETAMENTE DA ONTOLOGIA
%% Verifica se o Id pertence a um campo 

%%Busca campo a partir do nome ou id na ontologia de interface
%idCampo(Nome,Id):-
%	field(Id,Nome).

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
