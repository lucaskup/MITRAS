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
	is_synonym('field',What),
	is_synonym('panel',Where),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),Z),
	atomic_list_concat(Z,'_', Complete_What),

	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	length(List_Compound_Where,CompoundQTD),
	CompoundQTD > 1,
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	assertz(transformation(t1,0)),
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
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),Z),
	atomic_list_concat(Z,'_', Complete_What),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	assertz(transformation(t1,1)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

%%t1 :-
%%	verb(Verb),
%%	is_synonym('add',Verb),
%%	edge_dependence_basic(Verb,What,dobj),
%%	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),
%%	edge_dependence_basic(Where,Where_Complement,compound),
%%	is_synonym('field',What),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
%%	edge_dependence_basic(What,_,amod),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
%%	findall(X,edge_dependence_basic(What, X, amod),Z),
%%	atomic_list_concat(Z,'_', Complete_What),

%%	atom_concat(Where_Complement,'_',U_Where_Complement),
%%	atom_concat(U_Where_Complement,Where,Complete_Where),
 
%%	assertz(transformation(t1,b1)),
%%	assertz(what(Complete_What)),
%%	assertz(where_name(Complete_Where)),
%%	make_response,!.

t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),
	is_synonym('panel',Where),	
	%%edge_dependence_basic(Where,Where_Complement,compound),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),	

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	length(List_Compound_Where,CompoundQTD),
	CompoundQTD > 1,
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	%writeln('2'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '), writeln(Complete_What),
	%write('Location Name: '),writeln(Complete_Where),
	assertz(transformation(t1,1)),
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
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),
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
%%Please, add a new field for secret name in the customer form

t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,Where,nmod),
	is_synonym('panel',Where),	
	%%edge_dependence_basic(Where,Where_Complement,compound),

	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,What,nmod),
	(edge_dependence_basic(What,What_Complement,amod);edge_dependence_basic(What,What_Complement,compound)),

	atom_concat(What_Complement,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	length(List_Compound_Where,CompoundQTD),
	CompoundQTD > 1,
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	%writeln('4'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(Complete_What),
	%write('Location Name: '),writeln(Complete_Where),
	assertz(transformation(t1,3)),
	assertz(what(Complete_What)),
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
	(edge_dependence_basic(What,What_Complement,amod);edge_dependence_basic(What,What_Complement,compound)),
	
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
	edge_dependence_basic(Verb,Ligacao,dobj),

	is_synonym('add',Verb),

	%% verifica se o objeto direto possui um adjetivo relacionado, neste caso 'new'
	edge_dependence_basic(Ligacao,_,amod),

	(edge_dependence_basic(Ligacao,Where,nmod);edge_dependence_basic(Verb,Where,nmod)),
	%%edge_dependence_basic(Where,Where_Complement,compound),

	is_synonym('panel',Where),

	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	length(List_Compound_Where,CompoundQTD),
	CompoundQTD > 1,
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),
	

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

	(edge_dependence_basic(Ligacao,Where,nmod);edge_dependence_basic(Verb,Where,nmod)),
	edge_dependence_basic(Where,Where_Complement,compound),
	
	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	%writeln('5'),
	%writeln('## Transformation 1 ##'),
	%writeln('Field Name: >> NOT INFORMED <<'),
	%write('Location Name: '),writeln(Complete_Where),
	assertz(transformation(t1,6)),
	assertz(where_name(Complete_Where)),
	%%responder('falta alguma coisa') >> webserver_agent,
	make_response,!.

%% Frase exemplo:
%% I need a field for secret name in the patient form
t1 :- 
	adjective(Adjective),
	edge_dependence_basic(What,Adjective,amod),
	edge_dependence_basic(What,Where,nmod),
	is_synonym('panel',Where),
	word(What,nn,_),		

	atom_concat(Adjective,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	length(List_Compound_Where,CompoundQTD),
	CompoundQTD > 1,
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	assertz(transformation(t1,7)),
	assertz(what(Complete_What)),
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
	assertz(transformation(t1,8)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.
	
%%Frase exemplo: 
%% Aqui usuario indica nome do local como registro ou algo parecido sem mencionar qual tipo especifico
%% Please, add a cell phone field in the register/Add a document field in the register
%%t1 :-
%%	verb(Verb),
%%	is_synonym('add',Verb),
%%	edge_dependence_basic(Verb,What,dobj),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
%%	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds		
%%	findall(X,edge_dependence_basic(What, X, compound),Z),
%%	atomic_list_concat(Z,'_' , Complete_What),
%%	edge_dependence_basic(Verb,_,nmod),
	
	%writeln('9'),
	%%writeln('## Transformation 1 ##'),
%%	assertz(transformation(t1,9)),
%%	assertz(what(Complete_What)),
%%	make_response,!.

%%Frase exemplo: 
%%Please, add age in the customer form
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,Where,nmod),
	%%edge_dependence_basic(Where,Where_Complement,compound),
	\+is_synonym('field',What),
	is_synonym('panel',Where),

	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	length(List_Compound_Where,CompoundQTD),
	CompoundQTD > 1,
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),
	
	assertz(transformation(t1,9)),
	assertz(what(What)),
	assertz(where_name(Complete_Where)),
	make_response,!.
	
%%Frase exemplo: 
%%Please, add up age in the patient name panel
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),

	\+is_synonym('field',What),
	is_synonym('panel',Where),
	
	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	assertz(transformation(t1,10)),
	assertz(what(What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

%%Frase exemplo: 
%%Please, add up age in the patient name
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),
	edge_dependence_basic(Where,Where_Complement,compound),
	\+is_synonym('field',What),
	
	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

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

	(edge_dependence_basic(Nominal,Where,nmod);edge_dependence_basic(What,Where,nmod)),
	is_synonym('panel',Where),
	
	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds		
	findall(X,edge_dependence_basic(What, X, compound),Z),
	atomic_list_concat(Z, '_', Compound_What),

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	length(List_Compound_Where,CompoundQTD),
	CompoundQTD > 1,
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	assertz(transformation(t1,12)),
	assertz(what(Complete_What)),
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

	(edge_dependence_basic(Nominal,Where,nmod);edge_dependence_basic(What,Where,nmod)),
	edge_dependence_basic(Where,Where_Complement,compound),
	
	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds		
	findall(X,edge_dependence_basic(What, X, compound),Z),
	atomic_list_concat(Z, '_', Compound_What),

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	assertz(transformation(t1,13)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

%Frase exemplo:
%Create a field called name in the patient names panel
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,Nominal,acl),
	edge_dependence_basic(Nominal,What,xcomp),
	edge_dependence_basic(Nominal,Where,nmod),

	is_synonym('panel',Where),
	
	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	length(List_Compound_Where,CompoundQTD),
	CompoundQTD > 1,
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	
	assertz(transformation(t1,14)),
	assertz(what(What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

%Frase exemplo:
%Create a field called name in the patient names
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
	assertz(transformation(t1,15)),
	assertz(what(What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

%Frase exemplo:
%Add cell phone field in address
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	is_synonym('field',What),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Complete_What),	

	assertz(transformation(t1,16)),
	assertz(what(Complete_What)),
	assertz(where_name(Where)),
	make_response,!.

%Frase exemplo:
%Add cell phone in address
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),	


	assertz(transformation(t1,17)),
	assertz(what(Complete_What)),
	assertz(where_name(Where)),
	make_response,!.

%Frase exemplo:
%Add cell phone in address
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),	

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	assertz(transformation(t1,18)),
	assertz(what(Complete_What)),
	assertz(where_name(Where)),
	make_response,!.

%%Frase exemplo: 
%%Please, add cell phone field/create an age field/add age field
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	is_synonym('field',What),

	edge_dependence_basic(What,What_next,compound),
	edge_dependence_basic(What_next,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds		
	findall(X,edge_dependence_basic(What_next, X, compound),Z),
	
	length(Z,CompoundQTD),
	CompoundQTD > 1,
	%%foi necessaria a verificacao para conseguir fazer um or com a regra seguinte	
	atomic_list_concat(Z, '_', Compound_What),

	atom_concat(Compound_What,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,What_next,Complete_What),

	%writeln('15'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(Complete_What),
	assertz(transformation(t1,19)),
	assertz(what(Complete_What)),
	
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
	length(Z,CompoundQTD),
	CompoundQTD > 1,
	atomic_list_concat(Z, '_', Complete_What),

	%writeln('15'),
	%writeln('## Transformation 1 ##'),
	%write('Field Name: '),writeln(Complete_What),
	assertz(transformation(t1,20)),
	assertz(what(Complete_What)),
	
	make_response,!.

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
	assertz(transformation(t1,21)),
	assertz(what(What)),
	assertz(where_name(Complete_Where)),
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

	assertz(transformation(t1,22)),
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
	assertz(transformation(t1,23)),
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

	assertz(transformation(t1,24)),
	assertz(what(What)),
	make_response,!.


%Frase exemplo:
%Add cell in address
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),

	assertz(transformation(t1,25)),
	assertz(what(What)),
	assertz(where_name(Where)),
	make_response,!.
	
%%Frase exemplo: 
%%Please, add stauts/Add age
t1 :-
	verb(Verb),
	is_synonym('add',Verb),
	edge_dependence_basic(Verb,What,dobj),
	noun(What),
	\+edge_dependence_basic(What,_,_),
	\+is_synonym('field',What),
	\+whpronoun(What),

	assertz(transformation(t1,26)),
	assertz(what(What)),
	make_response,!.

