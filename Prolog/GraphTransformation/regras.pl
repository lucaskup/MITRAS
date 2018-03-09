path_source('D:\\Users\\Lucas\\TesteDissertacao').
path_python_inj('D:\\Users\\Lucas\\Google Drive\\Documentos\\Unisinos\\Mestrado\\').


run_python(Script,Option,Lines):-
    setup_call_cleanup(
    process_create(path(python),[Script|Option],[stdout(pipe(Out))]),
    read_lines(Out,Lines),
    close(Out)).

read_lines(Out, Lines) :-
        read_line_to_codes(Out, Line1),
        read_lines(Line1, Out, Lines).

read_lines(end_of_file, _, []) :- !.
read_lines(Codes, Out, [Line|Lines]) :-
        atom_codes(Line, Codes),
        read_line_to_codes(Out, Line2),
        read_lines(Line2, Out, Lines).

caminho(N1,N2,C,L) :- 
    caminho([],N1,N2,C,L).


caminho(_,N1,N2,[N1,N2],[L|[]]) :-
    arco(N1,N2,L).

caminho(Visitado,N1,N2,[N1|T],[L1|LT]) :-
    arco(N1,X,L1),
    \+memberchk(X,Visitado),
    [X|Visitado] = V,
    caminho(V,X,N2,T,LT).

caminho_mais_curto(N1,N2,C,L) :- 
    findall(X,caminho(N1,N2,X,_),Y),
    menorlista(Y,C),
    caminho(N1,N2,C,L).

menorlista(Y,C):-
    menorlista(Y,[],C).
menorlista([],Temp,Temp).

menorlista([H|T],Temp,C) :-
    Temp = [] ->
        menorlista(T,H,C);
        length(H,X),
        length(Temp,Y),
        X < Y ->
            menorlista(T,H,C);
            menorlista(T,Temp,C).
%Predicado para traducao de ID de Nodo em Par Ordenado NomeXRotulo
traduz(Id,[Nome,Rotulo]) :-
    nodo(Id,Nome,Rotulo).
traduzlista([],[]).
traduzlista([HId|T],[HNomeRotulo|T2]) :-
    traduz(HId,HNomeRotulo),
    traduzlista(T,T2).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Predicados auxiliares para geração do arquivoTULIP    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

generateTulipCsv(Info1,Info2,Info3,Linha) :-
    atom_concat(Info1,';',X),
    atom_concat(X,Info2,Y),
    atom_concat(Y,';',Z),
    atom_concat(Z,Info3,Linha).

writeTulipFile(Info1,Info2,Info3,Stream) :-
    generateTulipCsv(Info1,Info2,Info3,Linha),
    write(Stream,Linha),
    nl(Stream).

geraCsvTulip(File) :-
    atom_concat('Nodes',File,FileNode),
    atom_concat('Edge',File,FileEdge),
    open(FileNode,write,StreamN),
    forall(nodo(Id,Nome,Label),writeTulipFile(Id,Nome,Label,StreamN)),
    close(StreamN),
    open(FileEdge,write,StreamE),
    forall(arco(IdLeft,IdRight,LabelEdge),writeTulipFile(IdLeft,IdRight,LabelEdge,StreamE)),
    close(StreamE).

%%% Predicados Uteis para as Transformações

ultimoId(Id) :-
    findall(X,nodo(X,_,_),Y), %percorre todos os nodos e encontra o ultimo id
    max_list(Y,Z),
    Id is Z + 1. 

generate_test(Nome) :- 
    nodo(Id,Nome,'class'), %Classe pivot para o match, seria a classe model (Person)
    arco(IdPai,Id,'association'),

    ultimoId(IdController),
    assertz(arco(IdController,IdPai,'controller')),% Verifica tambem a existência de um vinculo 
    assertz(nodo(IdController,'PersonFormController','class')),      % com controller
    
    ultimoId(IdHibernateConf),
    assertz(arco(IdPai,IdHibernateConf,'config')),      %Para adição de campos a classe deve
    assertz(nodo(IdHibernateConf,'PersonName.hbm.xml','hibernateConf')),%estar mapeada no hibernate

    ultimoId(IdMessagesConf),
    assertz(arco(IdPai,IdMessagesConf,'config')), % A descrição dos campos novos fica em arquivo de 
    assertz(nodo(IdMessagesConf,'messages.properties','messages')),% configuração

    ultimoId(IdWebConf),
    assertz(arco(IdPai,IdWebConf,'config')), %Esse arquivo armazena a extrutura da tela
    assertz(nodo(IdWebConf,'ArquivoWeb.xml','webConf')). % deve ser atualizado também

first_char_uppercase(WordLC, WordUC) :-
    atom_chars(WordLC, [FirstChLow|LWordLC]),
    atom_chars(FirstLow, [FirstChLow]),
    upcase_atom(FirstLow, FirstUpp),
    atom_chars(FirstUpp, [FirstChUpp]),
    atom_chars(WordUC, [FirstChUpp|LWordLC]).


nomeGetterSetter(Atributo,NomeGetter,NomeSetter) :-
    first_char_uppercase(Atributo,AtributoCC),
    atom_concat('get',AtributoCC,NomeGetter),
    atom_concat('set',AtributoCC,NomeSetter).



source_injection(t1,ClassName,AttributeName,Lines) :- 
    path_python_inj(PathPython),
    atom_concat(PathPython,'transf1AddField.py',PyAddField),
    path_source(SourcePath),
    nomeGetterSetter(AttributeName,GetterName,SetterName),
    run_python(PyAddField,[SourcePath,ClassName,AttributeName,GetterName,SetterName],Lines).



%%%Transformação 1 - Adicionar um campo a Pessoa
%%%    openmrs-core-2.0.5\api\src\main\java\org\openmrs\PersonName.java -> adicionado o campo novo, método getter e setter
%%%    openmrs-api/src/main/resources/org/openmrs/api/db/hibernate/PersonName.hbm.xml -> Arquivo de mapeamento objeto relacional
%%%    openmrs-core-2.0.5/api/src/main/resources/messages.properties -> Adição do Label do novo campo
%%%    openmrs-module-legacyui-master\omod\src\main\resources\webModuleApplicationContext.xml -> adicionar o campo novo ao xml pois a tela é criada dinâmicamente
%%%    legacyui-omod/src/main/java/org/openmrs/web/controller/person/PersonFormController.java -> Controller do form, precisa ser atualizado com o novo campo

t1_applyTransformation(Id_pivo, NomeAtributo) :-
    t1_matchStep(NomePivo,Id_pivo),
    t1_productionStep(Id_pivo,NomeAtributo),
    source_injection(t1,NomePivo,NomeAtributo,_).

t1_matchStep(NomePivo,Id) :-
    nodo(Id,NomePivo,'class'), %Classe pivot para o match, seria a classe model (Person)
    
    arco(IdPai,Id,'association'),% Classe também de model, quando a classe principal
    nodo(IdPai,_,'class'),     % possui associacao para uma segunda. Exemplo relacao 1-n 
    
    arco(IdController,IdPai,'controller'),% Verifica tambem a existência de um vinculo 
    nodo(IdController,_,'class'),      % com controller

    arco(IdPai,IdHibernateConf,'config'),      %Para adição de campos a classe deve
    nodo(IdHibernateConf,_,'hibernateConf'),%estar mapeada no hibernate

    arco(IdPai,IdMessagesConf,'config'), % A descrição dos campos novos fica em arquivo de 
    nodo(IdMessagesConf,_,'messages'),% configuração

    arco(IdPai,IdWebConf,'config'), %Esse arquivo armazena a extrutura da tela
    nodo(IdWebConf,_,'webConf'),!. % deve ser atualizado também

t1_matchStep(NomePivo,Id) :-
    arco(Id,IdPivo,'show'),
    nodo(IdPivo,NomePivo,'class'), %Classe pivot para o match, seria a classe model (Person)
    
    arco(IdPai,IdPivo,'association'),% Classe também de model, quando a classe principal
    nodo(IdPai,_,'class'),     % possui associacao para uma segunda. Exemplo relacao 1-n 
    
    arco(IdController,IdPai,'controller'),% Verifica tambem a existência de um vinculo 
    nodo(IdController,_,'class'),      % com controller

    arco(IdPai,IdHibernateConf,'config'),      %Para adição de campos a classe deve
    nodo(IdHibernateConf,_,'hibernateConf'),%estar mapeada no hibernate

    arco(IdPai,IdMessagesConf,'config'), % A descrição dos campos novos fica em arquivo de 
    nodo(IdMessagesConf,_,'messages'),% configuração

    arco(IdPai,IdWebConf,'config'), %Esse arquivo armazena a extrutura da tela
    nodo(IdWebConf,_,'webConf'),!. % deve ser atualizado também

t1_productionStep(IdClasseAdd,NomeAtributo) :- 
    ultimoId(IdNovoAtributo), %Adiciona o atributo ao grafo
    assertz(nodo(IdNovoAtributo,NomeAtributo,'attribute')),
    assertz(arco(IdClasseAdd,IdNovoAtributo,'attribute')),

    nomeGetterSetter(NomeAtributo,NomeGetter,NomeSetter),

    ultimoId(IdMetodoGetter), %adiciona metodo getter ao grafo
    assertz(nodo(IdMetodoGetter,NomeGetter,'method')),
    assertz(arco(IdClasseAdd,IdMetodoGetter,'method')),

    ultimoId(IdMetodoSetter), %adiciona metodo getter ao grafo
    assertz(nodo(IdMetodoSetter,NomeSetter,'method')),
    assertz(arco(IdClasseAdd,IdMetodoSetter,'method')).

%%%Transformação 2 - Oclusão de campo do Nome da Pessoa
%%%    openmrs-module-legacyui-master\omod\src\main\resources\webModuleApplicationContext.xml -> Ocultar o campo novo ao xml pois a tela é criada dinâmicamente

t2_applyTransformation(NomePivo,NomeAtributo) :-
    t2_matchStep(NomePivo,NomeAtributo,IdAtribute,IdWebConf),
    t2_productionStep(IdAtribute,IdWebConf).

t2_matchStep(NomePivo,NomeAtributo,IdAtributo,IdWebConf) :-
    nodo(Id,NomePivo,'class'), %Classe pivot para o match, seria a classe model (Person)
    
    nomeGetterSetter(NomeAtributo,NomeGetter,NomeSetter), % O primeiro passo é encontrar as relações de getter, setter e atributo na classe indicada
    nodo(IdSetter,NomeSetter,'method'),
    arco(Id,IdSetter,'method'),
    
    nodo(IdGetter,NomeGetter,'method'),
    arco(Id,IdGetter,'method'),
    
    nodo(IdAtributo,NomeAtributo,'attribute'),
    arco(Id,IdAtributo,'attribute'),
        
    arco(IdPai,Id,'association'),% Classe também de model, quando a classe principal
    nodo(IdPai,_,'class'),     % possui associacao para uma segunda. Exemplo relacao 1-n 
    
    arco(IdController,IdPai,'controller'),% Verifica tambem a existência de um vinculo 
    nodo(IdController,_,'class'),      % com controller

    arco(IdPai,IdHibernateConf,'config'),      %Para adição de campos a classe deve
    nodo(IdHibernateConf,_,'hibernateConf'),%estar mapeada no hibernate

    arco(IdPai,IdMessagesConf,'config'), % A descrição dos campos novos fica em arquivo de 
    nodo(IdMessagesConf,_,'messages'),% configuração

    arco(IdPai,IdWebConf,'config'), %Esse arquivo armazena a extrutura da tela
    nodo(IdWebConf,_,'webConf'), % deve ser atualizado também

    \+arco(IdWebConf,IdAtributo,'occlusion'). % o campo nao pode estar com oclusao


t2_productionStep(IdAtribute,IdConfigFile) :- 
    assertz(arco(IdConfigFile,IdAtribute,'occlusion')).


%%%Transformação 3 - Desfazer a oclusão de campo do Nome da Pessoa
%%%    openmrs-module-legacyui-master\omod\src\main\resources\webModuleApplicationContext.xml -> Ocultar o campo novo ao xml pois a tela é criada dinâmicamente

t3_applyTransformation(NomePivo,NomeAtributo) :-
    t3_matchStep(NomePivo,NomeAtributo,Id,IdWebConf),
    t3_productionStep(Id,IdWebConf).

t3_matchStep(NomePivo,NomeAtributo,IdAtributo,IdWebConf) :-
    nodo(Id,NomePivo,'class'), %Classe pivot para o match, seria a classe model (Person)
    
    nomeGetterSetter(NomeAtributo,NomeGetter,NomeSetter), % O primeiro passo é encontrar as relações de getter, setter e atributo na classe indicada
    nodo(IdSetter,NomeSetter,'method'),
    arco(Id,IdSetter,'method'),
    
    nodo(IdGetter,NomeGetter,'method'),
    arco(Id,IdGetter,'method'),
    
    nodo(IdAtributo,NomeAtributo,'attribute'),
    arco(Id,IdAtributo,'attribute'),
        
    arco(IdPai,Id,'association'),% Classe também de model, quando a classe principal
    nodo(IdPai,_,'class'),     % possui associacao para uma segunda. Exemplo relacao 1-n 
    
    arco(IdController,IdPai,'controller'),% Verifica tambem a existência de um vinculo 
    nodo(IdController,_,'class'),      % com controller

    arco(IdPai,IdHibernateConf,'config'),      %Para adição de campos a classe deve
    nodo(IdHibernateConf,_,'hibernateConf'),%estar mapeada no hibernate

    arco(IdPai,IdMessagesConf,'config'), % A descrição dos campos novos fica em arquivo de 
    nodo(IdMessagesConf,_,'messages'),% configuração

    arco(IdPai,IdWebConf,'config'), %Esse arquivo armazena a extrutura da tela
    nodo(IdWebConf,_,'webConf'), % deve ser atualizado também

    arco(IdWebConf,IdAtributo,'occlusion'). % o campo nao pode estar com oclusao


t3_productionStep(IdAtribute,IdConfigFile) :- 
    retract(arco(IdConfigFile,IdAtribute,'occlusion')).

%%%Transformação 4 - Mover painel na JSP
%%%    
createQueue(Id,[Id|Tl]) :-
    arco(Id,IdNext,'next'),
    createQueue(IdNext,Tl).
createQueue(Id,[Id]) :-
    \+arco(Id,_,'next').

t4_matchStep(NomeForm,Posicao,NomeElemento,[IdForm|ListaTela]) :-
    nodo(IdForm,NomeForm,'form'), 
    nodo(IdElemento,NomeElemento,'panel'),
    arco(IdForm,IdComecoFila,'has'),
    createQueue(IdComecoFila,ListaTela), %A ordem dos elementos da tela é dada por uma lista
    memberchk(IdElemento,ListaTela),
    length(ListaTela,L),
    L >= Posicao .

insertList([H|T],Value,Pos,[H|TResult]) :-
    NPos is Pos - 1,
    insertList(T,Value,NPos,TResult).
insertList(List,Value,1,[Value|List]).

retractArcs(_,[]).
retractArcs(X,[H|T]):-
    retract(arco(X,H,_)),
    retractArcs(H,T).
retractArcs([H|T]) :-
    retractArcs(H,T).

resumeArcs(_,[],_).
resumeArcs(X,[H|T],Label):-
    assertz(arco(X,H,Label)),
    resumeArcs(H,T,'next').
resumeArcs([H|T]) :-
    resumeArcs(H,T,'has').

t4_productionStep(List,Id,Posicao) :- 
    retractArcs(List),
    delete(List, Id, PartialList),
    P is Posicao + 1,
    insertList(PartialList,Id,P,FinalList),
    resumeArcs(FinalList).
    

t5_matchStep(ClassName,AttName) :-
    node(IdClass,ClassName,'class'),
    node(IdAtt,AttName,'class'),
    arco(IdClass,IdAtt,'attribute').

t5_matchProductionStep(IdClass) :-
    ultimoId(IdClassFactory),
    ultimoId(IdFormController),
    ultimoId(IdStatisticsClass),
    ultimoId(IdSJSP),
    nodo(IdClass,NomeClass,'class'),

    atom_concat(NomeClass,'Factory',FactoryName),
    assertz(nodo(IdClassFactory,FactoryName,'class')),

    atom_concat(NomeClass,'FormController',ControllerName),
    assertz(nodo(IdFormController,ControllerName,'class')),

    atom_concat(NomeClass,'Statistics',StatisticsName),
    assertz(nodo(IdStatisticsClass,StatisticsName,'class')),

    atom_concat(NomeClass,'Form',FormName),
    assertz(nodo(IdSJSP,FormName,'form')),

    assertz(arco(IdClassFactory,IdStatisticsClass,'use')),

    assertz(arco(IdFormController,IdClassFactory,'use')),
    assertz(arco(IdFormController,IdStatisticsClass,'controller')),

    assertz(arco(IdSJSP,IdStatisticsClass,'show')),

    arco(IdService,IdClass,'service'),
    assertz(arco(IdClassFactory,IdService,'use')).
