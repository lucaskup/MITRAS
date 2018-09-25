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

is_synonym(opt,X) :-
	memberchk(X, ['option','options','command','commands','functions']).

is_synonym(field,X) :-
	memberchk(X, ['field','fields']).

is_synonym(panel,X) :-
	memberchk(X, ['panel']).	

is_synonym(patient,X) :-
	memberchk(X, ['users','patient','person','visits','encounters','providers','locations']).

is_synonym(patientNames,X) :-
	memberchk(X,['patientNames','name_panel','patient_name','patient_names']).

is_synonym(patientIdentifiers,X) :-
	memberchk(X,['patientIdentifiers','id_panel','ids_panel','identification_panel',
'identifier_panel','patient_id','patient_ids','identity_panel','patient_identifier','patient_identifiers']).

is_synonym(patientInformation,X) :-
	memberchk(X,['patientInformation','information_panel','info_panel','informations','informations_panel','customer_info', 'patient_info','patient_informations','patient_information']).

is_synonym(patientAddresses,X) :-
	memberchk(X,['patientAddresses','address_panel','addresses_panel','address','patient_address','patient_addresses']).

is_synonym(deletePatient,X) :-
	memberchk(X,['deletePatient','delete_panel','deletion_panel','delete','exclude_panel','delete_patient']).

is_synonym(preferred,X) :-
	memberchk(X,['preferred','main','top']).

is_synonym(identifier,X) :-
	memberchk(X,['identifier','id','code']).

is_synonym(identifierType,X) :-
	memberchk(X,['identifierType','identifier_type','type_identifier']).

is_synonym(location,X) :-
	memberchk(X,['location','local']).

is_synonym(given,X) :-
	memberchk(X,['given','given_name','first_name']).

is_synonym(middle,X) :-
	memberchk(X,['middle','middle_name']).

is_synonym(familyName,X) :-
	memberchk(X,['familyName','family_name','last_name']).

is_synonym(address,X) :-
	memberchk(X,['address']).

is_synonym(sectionHomestead,X) :-
	memberchk(X,['sectionHomestead','section_homestead','section']).

is_synonym(estateNearestCentre,X) :-
	memberchk(X,['estateNearestCentre','estate_NearestCentre','estate']).

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
	memberchk(X,['town_village','town/village','town']).

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

is_synonym(createdBy,X) :-
	memberchk(X,['createdBy','created_by','creation','create']).

is_synonym(reason,X) :-
	memberchk(X,['reason']).

is_synonym(do,X) :-
	memberchk(X,['do','make','produce','perform','model','build']).

is_synonym(can,X) :-
	memberchk(X,['can','could','would','may','should']).


%%%%%%%%%%%%%%%%%%%%%%%%
%FIM ONTOLOGIA DE SINONIMOS
%%%%%%%%%%%%%%%%%%%%%%%%
