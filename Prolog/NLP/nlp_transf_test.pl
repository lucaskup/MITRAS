%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Integração entre módulos de NLP e Transformação %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
debug.

teste_t1 :- 
	%Predicado para identificar a transformação 1
	t1(Location_id,New_field_Name),
	%testa se está em modo debug para colocar mensagens
	(debug ->
	nodo(Location_id,Location_Name,_),
	write('Entidade encontrada: '),write(Location_id),write(' - '), writeln(Location_Name)),
	t1_applyTransformation(Location_id, New_field_Name). 
	 
