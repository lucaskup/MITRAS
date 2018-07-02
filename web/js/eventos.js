function getTexto(){
	return document.getElementById( "input" ).value.trim();
}
function enviarMensagem(){
	texto = getTexto();
	if(texto != ""){	
		addToMessagePanel(1,texto);
		enviarRequisicao(texto);
	}
}
function addToMessagePanel(type, message){
	//alert("TESTEE");
	//Usa o dom para criar uma div
	chat_line = document.createElement( "div" );
	chat_line.classList.add("chat-line");
	
	//usa o dom para criar a div text-wrapper
	text_wrapper = document.createElement( "div" );
	text_wrapper.classList.add("text-wrapper") 
	
	
	//usa o dom para criar um texto
	text_line = document.createElement( "div" );
	text_line.classList.add("text"); 
	
	
	text_line.innerHTML = message;
	
	text_wrapper.appendChild(text_line);
	
	avatar = document.createElement( "div" );
	avatar.classList.add("avatar") 
	
	container_block = document.getElementById( 'panel-conversas' );
	container_block.appendChild( chat_line );

	
	if(type == 0){
		avatar.classList.add("avatar-mitras");
		text_wrapper.classList.add("text-wrapper-right");
		text_line.classList.add("text-right");
		chat_line.appendChild(text_wrapper);
		chat_line.appendChild(avatar);
	}else{
		avatar.classList.add("avatar-user");
		text_wrapper.classList.add("text-wrapper-left");
		text_line.classList.add("text-left");
		chat_line.appendChild(avatar);
		chat_line.appendChild(text_wrapper);	
	}
	chat_line.scrollIntoView();
	
	document.getElementById( "input" ).value = "";
}


$(document).ready(function() {
	document.getElementById("input")
		.addEventListener("keyup", function(event) {
		event.preventDefault();
		if (event.keyCode === 13) {
			enviarMensagem();
		}
	});

});

window.setInterval(receberResposta, 400);

function receberResposta(){
	
$.get( 'http://localhost:8091/mitras')
  .done(function( data ) {
	  console.log(data);
	  if(data.message){
	  	addToMessagePanel(0,data.message);	
	  }
    //alert( "Data Loaded: " + data );
  });
	
}
  
function enviarRequisicao(texto){


$.post( "http://localhost:8091/mitras", { mensagem: texto },
	function( data ) {
	  console.log(data);
	  //addToMessagePanel(0,data.status);
    //alert( "Data Loaded: " + data );
  },"json");
	
}

