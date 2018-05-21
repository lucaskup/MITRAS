function enviarMensagem(){
	//alert("TESTEE");
	//Usa o dom para criar uma div
	chat_line = document.createElement( "div" );
	chat_line.classList.add("chat-line");
	
	//usa o dom para criar a div text-wrapper
	text_wrapper = document.createElement( "div" );
	text_wrapper.classList.add("text-wrapper") 
	text_wrapper.classList.add("text-wrapper-right");
	
	//usa o dom para criar um texto
	text_line = document.createElement( "div" );
	text_line.classList.add("text"); 
	text_line.classList.add("text-right");
	
	texto = document.getElementById( "input" ).value.trim()
	text_line.innerHTML = texto;
	
	text_wrapper.appendChild(text_line);
	chat_line.appendChild(text_wrapper);
	
	avatar = document.createElement( "div" );
	avatar.classList.add("avatar") 
	avatar.classList.add("avatar-mitras");
	chat_line.appendChild(avatar);
	
	container_block = document.getElementById( 'panel-conversas' );
	container_block.appendChild( chat_line );
	document.getElementById( "input" ).value = "";
	
	
	chat_line.scrollIntoView();
	
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


