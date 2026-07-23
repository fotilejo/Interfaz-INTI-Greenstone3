function preparar(){
	var div=document.getElementsByTagName("div");
	for (var i=0;i<div.length;i++){
		div[i].style.display="none";
		}
}	
function mostrar(id){
	var div=document.getElementById(id);div.style.display=="none";
	if (div.style.display=="none"){
		div.style.display="block";
	} else {
		div.style.display="none";
	}
}
function show(a){
	var span=document.getElementById(a);span.style.display=="block";
	if (span.style.display=="none"){
		span.style.display="block";
	} else {
		span.style.display="none";
	}
}
