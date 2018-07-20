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

%%%%%%%%%%%%%%%%%%%%%%%%
%ONTOLOGIA DE SINONIMOS
%%%%%%%%%%%%%%%%%%%%%%%%

%o predicado abaixo funciona da seguinte forma is_synonym(formaCanonica,Possibilidades)
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

is_synonym(patientNames,X) :-
	memberchk(X,['patientNames','name_panel','patient_name','patient_names']).

is_synonym(patientIdentifiers,X) :-
	memberchk(X,['patientIdentifiers','id_panel','ids_panel','identification_panel','identifier_panel','patient_id','patient_ids','identity_panel']).

is_synonym(patientInformation,X) :-
	memberchk(X,['patientInformation','information_panel','info_panel','informations','informations_panel','customer_info', 'patient_info','patient_informations','patient_information']).

is_synonym(patientAddresses,X) :-
	memberchk(X,['patientAddresses','address_panel','addresses_panel','address','patient_adress','patient_addresses']).

is_synonym(deletePatient,X) :-
	memberchk(X,['deletePatient','delete_panel','deletion_panel','delete','exclude_panel','delete_patient']).

is_synonym(preferred,X) :-
	memberchk(X,['preferred','main','top']).

is_synonym(identifier,X) :-
	memberchk(X,['identifier','id','code']).

is_synonym(identifier_type,X) :-
	memberchk(X,['identifier_type','type_identifier']).

is_synonym(location,X) :-
	memberchk(X,['location','local']).

is_synonym(given,X) :-
	memberchk(X,['given','given_name','first_name']).

is_synonym(middle,X) :-
	memberchk(X,['middle','middle_name']).

is_synonym(family_name,X) :-
	memberchk(X,['family_name','last_name']).

is_synonym(address,X) :-
	memberchk(X,['address']).

is_synonym(section_homestead,X) :-
	memberchk(X,['section_homestead']).

is_synonym(estate_NearestCentre,X) :-
	memberchk(X,['estate_NearestCentre']).

is_synonym(sublocation,X) :-
	memberchk(X,['sublocation']).

is_synonym(division,X) :-
	memberchk(X,['division']).

is_synonym(province,X) :-
	memberchk(X,['province','state']).

is_synonym(latitude,X) :-
	memberchk(X,['latitude','lat']).

is_synonym(country,X) :-
	memberchk(X,['country']).

is_synonym(town_village,X) :-
	memberchk(X,['town_village']).

is_synonym(location,X) :-
	memberchk(X,['location']).

is_synonym(district,X) :-
	memberchk(X,['district']).

is_synonym(postalCode,X) :-
	memberchk(X,['postalCode','postal_code','postal_number','postal']).

is_synonym(longitude,X) :-
	memberchk(X,['longitude','long']).

is_synonym(gender,X) :-
	memberchk(X,['gender','sex']).
is_synonym(birthdate,X) :-
	memberchk(X,['birthdate','birth','birthday','birth_date']).

is_synonym(estimated,X) :-
	memberchk(X,['estimated']).

is_synonym(deceased,X) :-
	memberchk(X,['deceased','dead']).
is_synonym(deleted,X) :-
	memberchk(X,['deleted','excluded']).

is_synonym(uuid,X) :-
	memberchk(X,['uuid','id','identifier']).

is_synonym(created_by,X) :-
	memberchk(X,['created_by','creation','create']).

is_synonym(reason,X) :-
	memberchk(X,['reason']).


%%%%%%%%%%%%%%%%%%%%%%%%
%FIM ONTOLOGIA DE SINONIMOS
%%%%%%%%%%%%%%%%%%%%%%%%

%Predicado para checar existencia do elemento na ONTOLOGIA e buscar o ID correspondente
check_id_ontology(Name,Id) :-
	is_synonym(Ontology_name,Name),
	interfaceElement(Id,Ontology_name).
check_field_id_ontology(Name,Id) :-
	is_synonym(Ontology_name,Name),
	field(Id,Ontology_name).

avaliar_transformacoes :-
	retractall(transformation(_,_)),
	retractall(resposta(_)),
	retractall(where(_)),
	retractall(where_name(_)),
	retractall(what(_)),
	retractall(what_id(_)),
	t1,
	resposta(R),
	++resposta(R),
	(where(Id) -> ++where(Id);true),
	(what(What) -> ++what(What);true),!.

avaliar_transformacoes :-
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

avaliar_transformacoes :-
	retractall(transformation(_)),
	retractall(resposta(_)),
	retractall(where(_)),
	retractall(where_name(_)),
	retractall(what(_)),
	++resposta('Sorry, we could not identify a transformation matching your necessity. I can add fields to specific panels and move UI elements.'),!.

make_response :- 
	\+transformation(t3,_),
	where_name(Where_Name),
	check_id_ontology(Where_Name,Id),
	assertz(where(Id)),
	assert_response,!.

make_response :- 
	what(What),
	check_field_id_ontology(What,Id),
	assertz(what_id(Id)),
	assert_response,!.

make_response :- 
	assert_response,!.

assert_response :-
	transformation(t1,Rule),
	atom_concat('t1.',Rule,Transf),
	what(What),
	where(_),
	where_name(Where),
	atomic_list_concat(['Transformation ',Transf, ' identified. New field: ',What,' is going to be created in the ',Where],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-	
	transformation(t2,Rule),
	atom_concat('t2.',Rule,Transf),
	what(What),
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
	atomic_list_concat(['Transformation ',Transf, ' identified.',What, ' is going to the ', Pos, 'th position.'],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(t1,Rule),
	atom_concat('t1.',Rule,Transf),
	\+what(_),
	where_name(Where),	
	atomic_list_concat(['Transformation ',Transf, ' indentified, please inform what field do you want to create in the ',Where],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(t1,Rule),
	atom_concat('t1.',Rule,Transf),
	what(What),
	\+ where(_),
	\+ where_name(_),
	atomic_list_concat(['Transformation ',Transf, ' indentified, please inform where the field ',What, ' should be created.'],Resposta),
	assertz(resposta(Resposta)),!.

assert_response :-
	transformation(t1,Rule),
	atom_concat('t1.',Rule,Transf),
	what(What),
	\+ where(_),
	where_name(Where_Name),
	atomic_list_concat(['Transformation ',Transf, ' indentified, but the panel ',Where_Name ,' does not exists in the system. Please inform in what panel you want the field ',What, ' to be created.'],Resposta),
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
	\+ where(_),
	\+ where_name(_),
	atomic_list_concat(['Transformation ',Transf, ' indentified, please inform where the field ',What, ' is located.'],Resposta),
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
	transformation(t3,Rule),
	atom_concat('t3.',Rule,Transf),
	what(What),
	\+ position(_),
	atomic_list_concat(['Transformation ',Transf, ' indentified, but no position was specified. Please inform the position you want field ',What, ' to be placed.'],Resposta),
	assertz(resposta(Resposta)),!.

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
	atomic_list_concat(Z,'_', Complete_What),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	%writeln('1'),
	assertz(transformation(t1,1)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),
	edge_dependence_basic(Where,Where_Complement,compound),
	is_synonym('field',What),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,amod),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, amod),Z),
	atomic_list_concat(Z,'_', Complete_What),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	%writeln('1'), 
	assertz(transformation(t1,b1)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

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
	assertz(transformation(t1,2)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

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
	assertz(transformation(t1,3)),
	assertz(what(What_Complement)),
	assertz(where_name(Complete_Where)),
	make_response,!.
	

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
	assertz(transformation(t1,4)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.
	

%%Frase exemplo: 
%%Put a new information in costumer register
t1 :-
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
	assertz(transformation(t1,5)),
	assertz(where_name(Complete_Where)),
	make_response,!.



%%Frase exemplo: 
%%Put a new information in costumer register
t1 :-
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

	assertz(transformation(t1,6)),
	assertz(where_name(Complete_Where)),
	make_response,!.
	

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
	assertz(transformation(t1,7)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.
	

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
	assertz(transformation(t1,8)),
	assertz(what(Complete_What)),
	assertz(where_name(Where)),
	make_response,!.
	
%%Frase exemplo: 
%% Aqui usuario indica nome do local como registro ou algo parecido sem mencionar qual tipo especifico
%% Please, add a cell phone field in the register/Add a document field in the register
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds		
	findall(X,edge_dependence_basic(What, X, compound),Z),
	atomic_list_concat(Z,'_' , Complete_What),
	edge_dependence_basic(Verb,_,nmod),
	
	%writeln('9'),
	%%writeln('## Transformation 1 ##'),
	assertz(transformation(t1,9)),
	assertz(what(Complete_What)),
	make_response,!.

	
%%Frase exemplo: 
%%Please, add age in the customer form
t1 :-
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
	assertz(transformation(t1,10)),
	assertz(what(What)),
	assertz(where_name(Complete_Where)),
	make_response,!.
	
%%verificar real necessidade
%%Frase exemplo:
%%Please, add up Form/Age in the customer form
t1 :-
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

	assertz(transformation(t1,11)),
	assertz(what(What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

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
	assertz(transformation(t1,12)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

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
	assertz(transformation(t1,13)),
	assertz(what(What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

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

	%writeln('14'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(What),
	%write('Location Name: '),writeln(Complete_Where),

	assertz(transformation(t1,14)),
	assertz(what(What)),
	assertz(where_name(Complete_Where)),
	make_response,!.


%%Frase exemplo: 
%%Please, add cell phone field/create an age field/add age field
t1 :-
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
	assertz(transformation(t1,15)),
	assertz(what(Complete_What)),
	
	make_response,!.
	
%%Frase exemplo: 
%%Please, add cell phone number
t1 :-
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

	assertz(transformation(t1,16)),
	assertz(what(Complete_What)),
	make_response,!.

%%Frase exemplo: 
%%I would like to create a field called Identity Card
t1 :-
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
	assertz(transformation(t1,17)),
	assertz(what(Complete_What)),
	make_response,!.

%%Frase exemplo: 
%%I would like to create a field called age
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	%is_synonym('field',What),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,Nominal,acl),
	edge_dependence_basic(Nominal,What,xcomp),

	%writeln('18'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(What),

	assertz(transformation(t1,18)),
	assertz(what(What)),
	make_response,!.

%%Frase exemplo: 
%%Please, add stauts/Add age
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),

	edge_dependence_basic(Verb,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	%writeln('19'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(What),
	assertz(transformation(t1,19)),
	assertz(what(What)),
	assertz(where_name(Complete_Where)),
	make_response,!.
	
%%Frase exemplo: 
%%Please, add stauts/Add age
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),

	%writeln('19'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(What),
	assertz(transformation(t1,20)),
	assertz(what(What)),
	make_response,!.

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
	atomic_list_concat(List_Compound_What, '_',Complete_What),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	assertz(transformation(t2,0)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.


	%writeln('0'),
	%writeln('## Transformation 2 ##'),
	%write('Field To Hide: '), writeln(Complete_What),
	%write('Location Name: '),writeln(Complete_Where),!.

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
	atomic_list_concat(List_Compound_What, '_',Compound_What),	

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	assertz(transformation(t2,1)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

	%writeln('1'),
	%writeln('## Transformation 2 ##'),
	%write('Field To Hide: '),writeln(Complete_What),
	%write('Location Name: '),writeln(Complete_Where),!.

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
	atomic_list_concat(List_Compound_What, '_',Compound_What),	

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	assertz(transformation(t2,2)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.
	%writeln('2'),
	%writeln('## Transformation 2 ##'),
	%write('Field To Hide: '),writeln(Complete_What),
	%write('Location Name: '),writeln(Complete_Where),!.



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
	atomic_list_concat(List_Compound_What, '_',Compound_What),	
	
	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	assertz(transformation(t2,3)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.
	%writeln('3'),
	%writeln('## Transformation 2 ##'),
	%write('Field To Hide: '),writeln(Complete_What),
	%write('Location Name: '),writeln(Complete_Where),!.

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

	atom_concat(What_Complement,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	assertz(transformation(t2,4)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.
	%writeln('4'),
	%writeln('## Transformation 2 ##'),
	%write('Field To Hide: '),writeln(Complete_What),
	%write('Location Name: '),writeln(Complete_Where),!.

%%Frase exemplo: 
%% Delete weight in the customer register
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),

	atom_concat(Where_Complement,'_',U_What_Complement),
	atom_concat(U_What_Complement,Where,Complete_Where),
	
	assertz(transformation(t2,5)),
	assertz(what(What)),
	assertz(where_name(Complete_Where)),
	make_response,!.
	%writeln('5'),
	%writeln('## Transformation 2 ##'),
	%write('Field To Hide: '),writeln(What),
	%write('Location Name: '),writeln(Complete_Where),!.

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
	atomic_list_concat(List_Compound_What, '_',Complete_What),	

	assertz(transformation(t2,6)),
	assertz(what(Complete_What)),
	%assertz(where_name(Complete_Where)),
	make_response,!.

	%writeln('6'),
	%writeln('## Transformation 2 ##'),
	%write('Field To Hide: '),writeln(Complete_What),
	%write('Location Name: >> NOT INFORMED <<'),!.

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
	atomic_list_concat(List_Compound_What, '_',Compound_What),

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	assertz(transformation(t2,7)),
	assertz(what(Complete_What)),
	%assertz(where_name(Complete_Where)),
	make_response,!.
	%writeln('7'),
	%writeln('## Transformation 2 ##'),
	%write('Field To Hide: '),writeln(Complete_What),
	%write('Location Name: >> NOT INFORMED <<'),!.

%%Frase exemplo: 
%% I would like to hide patient's age
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),

	assertz(transformation(t2,8)),
	assertz(what(What)),
	%assertz(where_name(Complete_Where)),
	make_response,!.
	%writeln('8'),
	%writeln('## Transformation 2 ##'),
	%write('Field To Hide: '),writeln(What),
	%write('Location Name: >> NOT INFORMED <<'),!.


%%Frase exemplo: 
%% Delete weight in the register
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,_,nmod),
	%%edge_dependence_basic(Where,Where_Complement,compound),

	assertz(transformation(t2,9)),
	assertz(what(What)),
	%assertz(where_name(Complete_Where)),
	make_response,!.
	%writeln('9'),
	%writeln('## Transformation 2 ##'),
	%write('Field To Hide: '),writeln(What),
	%write('Location Name: >> NOT INFORMED <<'),!.

	
%%Frase exemplo: 
%% Delete information about patient's age
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,What,nmod),

	assertz(transformation(t2,10)),
	assertz(what(What)),
	%assertz(where_name(Complete_Where)),
	make_response,!.
	%writeln('10'),
	%writeln('## Transformation 2 ##'),
	%write('Field To Hide: '),writeln(What),
	%write('Location Name: >> NOT INFORMED <<'),!.

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
	atomic_list_concat(List_Compound_What, '_',Complete_What),

	assertz(transformation(t2,11)),
	assertz(what(Complete_What)),
	%assertz(where_name(Complete_Where)),
	make_response,!.

	%writeln('11'),
	%writeln('## Transformation 2 ##'),
	%write('Field To Hide: '),writeln(Complete_What),
	%write('Location Name: >> NOT INFORMED <<'),!.


%% Transformcao 3 'mudar posicao dos campos/paineis'


inf(IndiceT,up,What,Position,Numeral) :-
	
	NewPosition is Position - Numeral,

	assertz(transformation(t3,IndiceT)),
	assertz(what(What)),
	assertz(position(NewPosition)),
	make_response,!.
	%writeln(IndiceT),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(What),
	%write('Going To Position: '),writeln(NewPosition).

inf(IndiceT,down,What,Position,Numeral) :-
	
	NewPosition is Position + Numeral,

	assertz(transformation(t3,IndiceT)),
	assertz(what(What)),
	assertz(position(NewPosition)),
	make_response,!.
	%writeln(IndiceT),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(What),
	%write('Going To Position: '),writeln(NewPosition).
	
%%Frase exemplo:
%%Please, move Identifier Type up/down one position
%% Swap identity  for location / Switch identity in place of location / Move identity from customer register to patient indentifiers / Get identifier type to upper position / Get-place-relocate-shift-change-move identifier type to the top-bottom / Place identifier type in ... / Put address in between division and province / Place address between division and province / Relocate adress above-below division /   

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),


	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Inflaction,case),
	edge_dependence_basic(Nominal,Elipsed,nummod),
	check_field_id_ontology(Complete_What,Id),
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
	atomic_list_concat(List_Compound_What, '_',Compound_What),

	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Inflaction,case),
	edge_dependence_basic(Nominal,Elipsed,nummod),
	check_field_id_ontology(Compound_What,Id),
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
	atomic_list_concat(List_Compound_What, '_',Compound_What),

 	edge_dependence_basic(Verb,Inflaction,compound:prt),
 	edge_dependence_basic(Verb,Dep,dep),
 	edge_dependence_basic(Dep,Elipsed,nummod),
	check_field_id_ontology(Compound_What,Id),
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
	check_field_id_ontology(What_Complement,Id),
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
	check_field_id_ontology(What_Complement,Id),
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
	check_field_id_ontology(What,Id),
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
	atomic_list_concat(List_Compound_What, '_',Compound_What),

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Numerals,amod),
	ner(Numerals,Ordinal,_),
	%%conv2(Numerals,Ordinal),
	check_field_id_ontology(Complete_What,_),

	assertz(transformation(t3,7)),
	assertz(what(Complete_What)),
	assertz(position(Ordinal)),
	make_response,!.
	
	%writeln('7'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(Complete_What),
	%write('Going To Position: '),writeln(Ordinal),!.

%%Frase exemplo:
%%Move Identifier Type field to the first/second... position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),
	
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Numerals,amod),
	ner(Numerals,Ordinal,_),
	%%conv2(Numerals,Ordinal),
	check_field_id_ontology(Compound_What,_),
	
	assertz(transformation(t3,8)),
	assertz(what(Compound_What)),
	assertz(position(Ordinal)),
	make_response,!.

	%writeln('8'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(Compound_What),
	%write('Going To Position: '),writeln(Ordinal),!.

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
	check_field_id_ontology(What_Complement,_),

	assertz(transformation(t3,9)),
	assertz(what(What_Complement)),
	assertz(position(Ordinal)),
	make_response,!.		
	%writeln('9'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(What_Complement),
	%write('Going To Position: '),writeln(Ordinal),!.

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
	check_field_id_ontology(What,_),
	
	assertz(transformation(t3,10)),
	assertz(what(What)),
	assertz(position(Ordinal)),
	make_response,!.
	%writeln('10'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(What),
	%write('Going To Position: '),writeln(Ordinal),!.

%%Frase exemplo:
%%Get Identifier Type to upper position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),
	
	check_field_id_ontology(Complete_What,_),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Adjective,amod),
	is_synonym('upper',Adjective),
	
	assertz(transformation(t3,11)),
	assertz(what(Complete_What)),
	assertz(position(1)),
	make_response,!.
	%writeln('11'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(Complete_What),
	%write('Going To Position: '),writeln('1'),!.


%%Frase exemplo:
%%Get Identifier Type field to upper position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),
	
	check_field_id_ontology(Compound_What,_),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Adjective,amod),
	is_synonym('upper',Adjective),
	
	assertz(transformation(t3,12)),
	assertz(what(Compound_What)),
	assertz(position(1)),
	make_response,!.
	%writeln('12'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(Compound_What),
	%write('Going To Position: '),writeln('1'),!.

%%Frase exemplo:
%%Get Identifier to upper position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	
	check_field_id_ontology(What,_),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Adjective,amod),
	is_synonym('upper',Adjective),
	
	assertz(transformation(t3,13)),
	assertz(what(What)),
	assertz(position(1)),
	make_response,!.

	%writeln('13'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(What),
	%write('Going To Position: '),writeln('1'),!.

%%Frase exemplo:
%%Get Identifier Type to the last position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),
	
	check_field_id_ontology(Complete_What,Id),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Adjective,amod),
	is_synonym('last',Adjective),
	ultima(Id,UltimaPos),
	
	assertz(transformation(t3,14)),
	assertz(what(Complete_What)),
	assertz(position(UltimaPos)),
	make_response,!.
	%writeln('14'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(Complete_What),
	%write('Going To Position: '),writeln(UltimaPos),!.

%%Frase exemplo:
%%Get Identifier Type field to the last position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),
	
	check_field_id_ontology(Compound_What,Id),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Adjective,amod),
	is_synonym('last',Adjective),
	ultima(Id,UltimaPos),
	
	assertz(transformation(t3,15)),
	assertz(what(Compound_What)),
	assertz(position(UltimaPos)),
	make_response,!.
	%writeln('15'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(Compound_What),
	%write('Going To Position: '),writeln(UltimaPos),!.

%%Frase exemplo:
%%Get Identifier to last position

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	check_field_id_ontology(What,Id),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,Adjective,amod),
	is_synonym('last',Adjective),
	ultima(Id,UltimaPos),
	
	assertz(transformation(t3,16)),
	assertz(what(What)),
	assertz(position(UltimaPos)),
	make_response,!.
	%writeln('16'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(What),
	%write('Going To Position: '),writeln(UltimaPos),!.

%%Frase exemplo:
%%Get Identifier Type to the top

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),
	
	check_field_id_ontology(Complete_What,_),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,_,case),
	is_synonym('upper',Nominal),
	
	assertz(transformation(t3,17)),
	assertz(what(Complete_What)),
	assertz(position(1)),
	make_response,!.
	%writeln('17'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(Complete_What),
	%write('Going To Position: '),writeln('1'),!.

%%Frase exemplo:
%%Get Identifier Type field to the top

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),
	
	check_field_id_ontology(Compound_What,_),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,_,case),
	is_synonym('upper',Nominal),
	
	assertz(transformation(t3,18)),
	assertz(what(Compound_What)),
	assertz(position(1)),
	make_response,!.
	%writeln('18'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(Compound_What),
	%write('Going To Position: '),writeln('1'),!.

%%Frase exemplo:
%%Get Identifier to the top

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	
	check_field_id_ontology(What,_),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,_,case),
	is_synonym('upper',Nominal),
	
	assertz(transformation(t3,19)),
	assertz(what(What)),
	assertz(position(1)),
	make_response,!.
	%writeln('19'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(What),
	%write('Going To Position: '),writeln('1'),!.

%%Frase exemplo:
%%Get Identifier Type to the bottom

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),
	
	check_field_id_ontology(Complete_What,Id),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,_,case),
	is_synonym('last',Nominal),
	ultima(Id,UltimaPos),
	
	assertz(transformation(t3,20)),
	assertz(what(Complete_What)),
	assertz(position(UltimaPos)),
	make_response,!.
	%writeln('20'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(Complete_What),
	%write('Going To Position: '),writeln(UltimaPos),!.

%%Frase exemplo:
%%Get Identifier Type field to the bottom

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),
	
	check_field_id_ontology(Compound_What,Id),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,_,case),
	is_synonym('last',Nominal),
	ultima(Id,UltimaPos),
	
	assertz(transformation(t3,21)),
	assertz(what(Compound_What)),
	assertz(position(UltimaPos)),
	make_response,!.
	%writeln('21'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(Compound_What),
	%write('Going To Position: '),writeln(UltimaPos),!.

%%Frase exemplo:
%%Get Identifier to the bottom

t3 :-
	verb(Verb),
	is_synonym('move',Verb),
 	edge_dependence_basic(Verb,What,dobj),

	
	check_field_id_ontology(What,Id),
	edge_dependence_basic(Verb,Nominal,nmod),
	edge_dependence_basic(Nominal,_,case),
	is_synonym('last',Nominal),
	ultima(Id,UltimaPos),
	
	assertz(transformation(t3,22)),
	assertz(what(What)),
	assertz(position(UltimaPos)),
	make_response,!.
	%writeln('22'),
	%writeln('## Transformation 3 ##'),
	%write('Field To Move: '),writeln(What),
	%write('Going To Position: '),writeln(UltimaPos),!.



%%Frase exemplo:
%%Put preferred in between Identifier Type and Location (Nao esta pronta)

%t3 :-
%	verb(Verb),
%	is_synonym('move',Verb),
%	edge_dependence_basic(Verb,What,dobj),
%
%	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
%	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
%	atomic_list_concat(List_Compound_What, '_',Compound_What),
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
