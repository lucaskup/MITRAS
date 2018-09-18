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
