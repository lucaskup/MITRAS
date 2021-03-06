
%% Transformcao 2 'ocultar campos'

%%Frases exemplo: 
%% Delete identity field in the customer register / Delete identity from customer register / 
%% Delete identity card field in the customer register
%% On the customer register, please remove Cell Phone field
%% Cut out identity field from customer register (nao funciona)


%%contempla nomes de campos com relacoes amod e panel no final
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

	edge_dependence_basic(What,What_Conc,amod),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),

	atom_concat(What_Conc,'_',U_What_Complement),
	atom_concat(U_What_Complement,Compound_What,Complete_What),

	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	length(List_Compound_Where,CompoundQTD),
	CompoundQTD > 1,
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	assertz(transformation(t2,0.0)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

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
	length(List_Compound_Where,CompoundQTD),
	CompoundQTD > 1,
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	assertz(transformation(t2,0)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

%%contempla nomes de campos com relacoes amod
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),
	is_synonym('field',What),


	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	edge_dependence_basic(What,What_Conc,amod),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),

	atom_concat(What_Conc,'_',U_What_Complement),
	atom_concat(U_What_Complement,Compound_What,Complete_What),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	assertz(transformation(t2,1.1)),
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

	assertz(transformation(t2,1)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

%%contempla nomes de campos com relacoes amod sem 'field' e panel no final
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	edge_dependence_basic(Verb,Where,nmod),
	%%edge_dependence_basic(Where,Where_Complement,compound),

	is_synonym('panel',Where),

	edge_dependence_basic(What,What_Conc,amod),

	atom_concat(What_Conc,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	length(List_Compound_Where,CompoundQTD),
	CompoundQTD > 1,
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	assertz(transformation(t2,2.0)),
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
	length(List_Compound_Where,CompoundQTD),
	CompoundQTD > 1,
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	assertz(transformation(t2,2)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

%%%%sem field e sem panel mas com relacao de um verbo e campo por amod
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),
	edge_dependence_basic(Where,Where_Complement,compound),

	edge_dependence_basic(What,What_Conc,amod),

	atom_concat(What_Conc,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),	

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	assertz(transformation(t2,3.0)),
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

	assertz(transformation(t2,3)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

%%Frases exemplo: 
%% Delete information about patient's cell phone field in patient address panel
%% Delete information about patient's street name field in the register
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,What,nmod),

	is_synonym('field',What),

	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),
	%%edge_dependence_basic(Where,Where_Complement,compound),

	is_synonym('panel',Where),

	%% garantir o tipo nmod:poss	
	edge_dependence_basic(What,_,nmod:poss),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Complete_What),	
	
	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	length(List_Compound_Where,CompoundQTD),
	CompoundQTD > 1,
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	assertz(transformation(t2,4)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

%%Frases exemplo: 
%% Delete information about patient's cell phone field in patient address
%% Delete information about patient's street name field in the register
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,What,nmod),

	is_synonym('field',What),

	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),
	edge_dependence_basic(Where,Where_Complement,compound),

	%% garantir o tipo nmod:poss	
	edge_dependence_basic(What,_,nmod:poss),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Complete_What),	
	

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	assertz(transformation(t2,5)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

%%Frases exemplo: 
%% Delete information about patient's cell phone from patient address panel
%% Delete information about patient's street name in the register
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,What,nmod),
	edge_dependence_basic(What,Where,nmod),
	is_synonym('panel',Where),
	%%edge_dependence_basic(Where,Where_Complement,compound),

	%% garantir o tipo nmod:poss	
	edge_dependence_basic(What,_,nmod:poss),

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

	assertz(transformation(t2,6)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

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

	%% garantir o tipo nmod:poss	
	edge_dependence_basic(What,_,nmod:poss),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),	
	
	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	assertz(transformation(t2,7)),
	assertz(what(Complete_What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

%%Frases exemplo: 
%% Delete information about patient's age field in the customer register
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,What,nmod),

	is_synonym('field',What),

	%% garantir o tipo nmod:poss	
	edge_dependence_basic(What,_,nmod:poss),
	
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),

	(edge_dependence_basic(What,What_Complete,compound);edge_dependence_basic(What,What_Complete,amod)),


	edge_dependence_basic(Where,Where_Complement,compound),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	assertz(transformation(t2,8)),
	assertz(what(What_Complete)),
	assertz(where_name(Complete_Where)),
	make_response,!.

%%Frases exemplo: 
%% Delete information about patient's age in the customer register
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,Ligacao,dobj),
	edge_dependence_basic(Ligacao,What,nmod),

	%% garantir o tipo nmod:poss	
	edge_dependence_basic(What,_,nmod:poss),
	
	edge_dependence_basic(What,Where,nmod),
	edge_dependence_basic(Where,Where_Complement,compound),

	atom_concat(Where_Complement,'_',U_Where_Complement),
	atom_concat(U_Where_Complement,Where,Complete_Where),

	assertz(transformation(t2,9)),
	assertz(what(What)),
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
	%edge_dependence_basic(Where,Where_Complement,compound),
	
	is_synonym('panel',Where),

	findall(X,edge_dependence_basic(Where, X, compound),List_Compound_Where),
	length(List_Compound_Where,CompoundQTD),
	CompoundQTD > 1,
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),

	
	assertz(transformation(t2,10)),
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
	
	assertz(transformation(t2,9)),
	assertz(what(What)),
	assertz(where_name(Complete_Where)),
	make_response,!.
	%writeln('5'),
	%writeln('## Transformation 2 ##'),
	%write('Field To Hide: '),writeln(What),
	%write('Location Name: '),writeln(Complete_Where),!.

%Frase exemplo:
%Hide cell phone field in address
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	is_synonym('field',What),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Complete_What),	

	assertz(transformation(t2,11)),
	assertz(what(Complete_What)),
	assertz(where_name(Where)),
	make_response,!.

%Frase exemplo:
%Hide cell phone in address
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),	


	assertz(transformation(t2,12)),
	assertz(what(Complete_What)),
	assertz(where_name(Where)),
	make_response,!.

%Frase exemplo:
%Add cell phone in address
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),

	%%usa a proxima verificacao apenas para comprovar a existencia de um compound relacionado com um substantivo para validar a regra.	
	edge_dependence_basic(What,_,compound),

	%%encontra todas as dependencias entre um substantivo ligado ao verbo principal e seus compounds	
	findall(X,edge_dependence_basic(What, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Compound_What),	

	atom_concat(Compound_What,'_',U_What_Complement),
	atom_concat(U_What_Complement,What,Complete_What),

	assertz(transformation(t2,13)),
	assertz(what(Complete_What)),
	assertz(where_name(Where)),
	make_response,!.

%Frase exemplo:
%Hide cell in address
t2 :-
	verb(Verb),
	is_synonym('hide',Verb),
	edge_dependence_basic(Verb,What,dobj),
	(edge_dependence_basic(Verb,Where,nmod);edge_dependence_basic(What,Where,nmod)),

	assertz(transformation(t2,14)),
	assertz(what(What)),
	assertz(where_name(Where)),
	make_response,!.

%%Frase exemplo: 
%% Delete identity card field in the register/Remove cell phone number field/Hide status field

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

	assertz(transformation(t2,15)),
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

	assertz(transformation(t2,16)),
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

	assertz(transformation(t2,17)),
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

	assertz(transformation(t2,18)),
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

	assertz(transformation(t2,19)),
	assertz(what(Complete_What)),
	%assertz(where_name(Complete_Where)),
	make_response,!.

	%writeln('11'),
	%writeln('## Transformation 2 ##'),
	%write('Field To Hide: '),writeln(Complete_What),
	%write('Location Name: >> NOT INFORMED <<'),!.


t2_reverse_miss_where :-
	\+verb(_),	
	noun(Panel),
	is_synonym('panel',Panel),
	findall(X,edge_dependence_basic(Panel, X, compound),List_Compound_Where),
	atomic_list_concat(List_Compound_Where, '_',Complete_Where),
	assertz(transformation(t2,1113333)),
	%assertz(what(What)),
	assertz(where_name(Complete_Where)),
	make_response,!.

t2_reverse_miss_where :-
	\+verb(_),	
	noun(Noun),
	\+is_synonym('panel',Noun),
	edge_dependence_basic(Noun,Where,compound),

	atom_concat(Where,'_',U_What_Complement),
	atom_concat(U_What_Complement,Noun,Complete_Where),
	
	assertz(transformation(t2,222)),
	%assertz(what(What)),
	assertz(where_name(Complete_Where)),
	make_response,!.	

t2_reverse_miss_what :-
	\+verb(_),	
	noun(Field),
	is_synonym('field',Field),
	findall(X,edge_dependence_basic(Field, X, compound),List_Compound_What),
	atomic_list_concat(List_Compound_What, '_',Complete_What),
	assertz(transformation(t2,333)),
	%assertz(what(What)),
	assertz(what(Complete_What)),
	make_response,!.

t2_reverse_miss_what :-
	\+verb(_),	
	noun(Noun),
	\+is_synonym('field',Noun),
	edge_dependence_basic(Noun,What,compound),

	atom_concat(What,'_',U_What_Complement),
	atom_concat(U_What_Complement,Noun,Complete_What),
	
	assertz(transformation(t2,444)),
	%assertz(what(What)),
	assertz(what(Complete_What)),
	make_response,!.	
	


