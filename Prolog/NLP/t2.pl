
%% Transformcao 2 'ocultar campos'

%%Frases exemplo: 
%% Delete identity field in the customer register / Delete identity from customer register / 
%% Delete identity card field in the customer register
%% On the customer register, please remove Cell Phone field
%% Cut out identity field from customer register (nao funciona)

%%Aqui tem adicao da palavra panel no final
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,Where,nmod),
	%%edge_dependence_basic(Where,Where_Complement,compound),
	is_synonym('field',What),
	is_synonym('panel',Where),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Complete_What),

	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	assertz(transformation(t2,0.0)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

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

%%Frase exemplo: 
%%Delete identity card in the customer register
%%I would like to remove cell phone number in the customer form 

t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),
	%%edge_dependence_basic(Where,Where_Complement,compound),

	is_synonym('panel',Where),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),	

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	assertz(transformation(t2,1.0)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
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

	assertz(transformation(t2,1)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

%%NAO ESTA FUNCIONANDO
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

%%NAO ESTA FUNCIONANDO
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
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),
	%%edge_dependence_basic(Where,Where_Complement,compound),
	
	is_synonym('panel',Where),

	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	
	assertz(transformation(t2,5.0)),
	assertz(what(What)),
	assertz(where_name(Complete_Where)),
	make_response,!.
	%writeln('5'),
	%writeln('## Transformation 2 ##'),
	%write('Field To Hide: '),writeln(What),
	%write('Location Name: '),writeln(Complete_Where),!.

t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),
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

%%NAO ESTA FUNCIONANDO
%%Frase exemplo: 
%% I would like to hide patient's age
%%t2 :-
%%	verb(Verb),
%%	is_synonym('hide',Verb),
%%	edge_dependence_basic(Verb,What,dobj),
%%	assertz(transformation(t2,8)),
%%	assertz(what(What)),
	%assertz(where_name(Complete_Where)),
%%	make_response,!.
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

%% Nao esta funcionando	
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


