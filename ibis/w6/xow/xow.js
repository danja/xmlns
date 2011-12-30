/* CSS for w6 in XHTML Outlines
   Derived in part from the expanding menus at
   http://inspire.server101.com/js/xc/

*/

// document.onmousedown = mouseDown;
document.onmouseover = mouseOver;
window.onload = init;

function init(){
	detectBrowser();
	transformElements('1');
//	
	setAll('1', true);
	refreshScreen();
	setAll('1', true);
//	
}

function mouseOver(evt){

	if (isIE4) evt = window.event;
	var obj = getTarget(evt);
	var className = getAttrVal(obj,'class');
	if(className != 'unknown'){
		obj.title = className;
	}
}
	
function mouseDown(evnt){
	if (isIE4) {
		evnt = window.event; 
	}

//alert('mousedown');
	var target = getTarget(evnt);
	alert(target.nodeName);
	if(	target.nodeName == 'li' 
		|| target.nodeName == 'LI' 
		|| target.nodeName == 'a' 
		|| target.nodeName == 'A' 
		|| target.nodeName == 'p'
		|| target.nodeName == 'P'){
			target.contentEditable = true;
		editNode(target);
	} else {
		if (	target.nodeName == 'a' 
			|| target.nodeName == 'A' ){
	target = target.parentNode;
	target.contentEditable = true;
		editNode(target);
	}
	}
}

function getTarget(evnt){
	if (isIE4){obj = evnt.srcElement;}
	else{
		obj = evnt.target;
		if(obj){
			while (obj.nodeName != 'ul' 
			&& obj.nodeName != 'li' 
			&& obj.nodeName != 'p' 
			&& obj.parentNode){
			obj = obj.parentNode;
			}
		}
	}
	return (obj);
}

function editNode(obj){
	// alert(getXML());
	// alert('edit = '+obj.innerHTML);

	if (isIE55) {
		htmlEdit(obj);
	} else {
		var newVal = window.prompt('edit',obj.innerHTML);
		if(newVal != null){obj.innerHTML = newVal;}
	//	refreshScreen(isIE4);
	}
}

/* Expanding menus */

var controlNodes = [];

function setAll(parentId, open){
	var listElements = document.getElementById(parentId).getElementsByTagName('ul');
	for (i = 0; i < listElements.length; i++) {
		if (id = listElements[i].getAttribute('id')) {
			if(open){
				expand(id);
			}else {
				contract(id);
			}
		}
	}
}

function transformElements(parentId) {
if (document.getElementById && document.createElement) {
	var listElements = document.getElementById(parentId).getElementsByTagName('ul');
	var id, parent, control, h, i, j;
	for (i = 0; i < listElements.length; i++) {
		if (id = listElements[i].getAttribute('id')) {
			
			createControlLink(id, 'expand', '+', 'expand', listElements[i].getAttribute('title')+' - expand');
			control = createControlLink(id, 'contract', '-', 'contract', listElements[i].getAttribute('title')+' - contract');

			parent = listElements[i].parentNode;
			if (h = !parent.className) {
				j = 2;
				while ((h = !(id == arguments[j])) && (j++ < arguments.length));
				if (h) {
					m[i].style.display = 'none';
					control = controlNodes[id+'expand'];
				}
			}
		//	parent.insertBefore(control, parent.firstChild);
		// @@TODO may cause problems if not enough children
		var children = parent.childNodes;
	
		parent.insertBefore(control, children[1]);
		}
	}
}}


function expand(id) {
	toggle(id, 'block', id+'contract', id+'expand');
}


function contract(id) {
 //alert(getXML());
	toggle(id, 'none', id+'expand', id+'contract');
}


function toggle(id, display, showNode, hideNode) {
	var element = document.getElementById(id);
	element.style.display = display;
try{
		element.parentNode.replaceChild(controlNodes[showNode], controlNodes[hideNode]);
			controlNodes[showNode].firstChild.focus();
} catch (e) {
  // forget it
}

//
	refreshScreen();
}

function createControlLink(id, suffix, controlText, toggleFunction, title) {
	var a = document.createElement('a');
	a.setAttribute('href', 'javascript:'+toggleFunction+'(\''+id+'\');');
	a.setAttribute('title', title);

//	a.appendChild(document.createTextNode(controlText+suffix)); // 
	var img = document.createElement('img');
	img.setAttribute('src', suffix+'.gif');
	a.appendChild(img);
	var divElement = document.createElement('div');
//	divElement.className = className + suffix;
//	alert(className + suffix);
	divElement.appendChild(a);
	return controlNodes[id+suffix] = divElement;
}


/* ********* XML Serialization *********** */

// DOM Constants

var ELEMENT_NODE = 1;
var TEXT_NODE = 3;
var CDATA_SECTION_NODE = 4;

var INDENT_CHARS ="   ";

var accumulator;
var indent;

function getXML(){

//	var svgDocElement = SVGDoc.documentElement;
	accumulator = "";
	indent ="";
//	var content = elementToString(svgDocElement);
	var content = elementToString(document.documentElement);
	return '<?xml version="1.0" ?>'
		+ '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">'
		+ content;
}




function elementToString(element) {
	if (element){
      		var attribute;
      		var i;
      		
      		accumulator += "\n"+INDENT_CHARS+"<" + element.nodeName;
      	//	indent += INDENT_CHARS; // indent
      	//	alert(accumulator);
      		for (i = element.attributes.length-1; i>=0; i--){
         		attribute = element.attributes.item(i);
         		if(attribute.nodeValue){ // ignore "null" entries
				accumulator += " " + attribute.nodeName + '="' + attribute.nodeValue+ '"';
			}
     	 	}
      		if (element.hasChildNodes()){
      		
      		var children = element.childNodes;
         		accumulator += ">";
         		
         		for (i=0; i<children.length; i++){
            			if (children.item(i).nodeType == ELEMENT_NODE){
            				
               				elementToString(children.item(i));
               			} else if (children.item(i).nodeType == TEXT_NODE) {				
					accumulator += escape(children.item(i).nodeValue);
            			}
            		else if (children.item(i).nodeType == CDATA_SECTION_NODE) {
            			accumulator += "\x3c![CDATA["; 		// unescaped <
            			accumulator += children.item(i).nodeValue;
            			accumulator += "]]\x3e"; 		// unescaped >
			}           
         }
         accumulator += "</" + element.nodeName + ">";
      } else {
         accumulator += " />";
      }
   }
   return accumulator;
}	

function escape(markup){
	markup = markup.replace(/&/g, "&amp;");
	markup = markup.replace(/</g, "&lt;");
	markup = markup.replace(/>/g, "&gt;");
	return markup;
}

/* */
var isNav6, isIE4, isIE55;

function detectBrowser(){
if (parseInt(navigator.appVersion.charAt(0)) >= 4) {
   isNav6 = (navigator.appName == "Netscape");
   isIE4 = (navigator.appName.indexOf("Microsoft") > -1);
}
isIE55 = (isIE4 && (navigator.appVersion.indexOf("5.5") > -1));

if (isNav6) {
	document.captureEvents(Event.MOUSEDOWN);
	document.captureEvents(Event.MOUSEOVER);
	document.captureEvents(Event.MOUSEOUT);
	document.captureEvents(Event.KEYPRESS);
}

}

/* Utilities */
function getAttrVal(obj,aname){
	try{
	if (obj.attributes){
		if (isNav6) {if (obj.attributes.getNamedItem(aname)){
			return (obj.attributes.getNamedItem(aname).nodeValue);
		}}
		if (isIE4) {if (obj.attributes.item(aname)){if (obj.attributes.item(aname).nodeValue){
			return (obj.attributes.item(aname).nodeValue);
		}}}
	}}
	catch(er){
	}
	return('unknown');
}

function setAttrVal(obj,aname,aval){
	if (obj.attributes){
		if (isNav6){
			return(obj.setAttribute(aname,aval));
		}
		if (isIE4){
			
			try{obj.attributes.item(aname).nodeValue = aval;}
			catch (er){}
		}
	}
	return (false);
}

/*------------------------------------------
screen refresh functions to compensate for
a very peculiar IE bug (and an even stranger
Netscape 6 bug!)
-------------------------------------------*/
function refreshScreen(){
	// if (isIE4){
	//	if (contextNode){
			scTopPrevious = ((isNav6)?window.scrollY:window.screenTop);
	//	}

		squeeze();
		window.setTimeout('relax()',5);
//	}
//	return true;
}

function squeeze(){
	var curNode
	
	curNode = document.getElementById('1');
	curNode.style.visibility = 'hidden';
	curNode.style.marginLeft = '10%';
	curNode.style.marginRight = '10%';
	
	if (isNav6){
		document.getElementsByTagName('body').item(0).style.visibility = 'hidden';
		curNode.style.display = 'none';
	}
}

function relax(){
	var curNode, scLeft, scTop
	
	curNode = document.getElementById('1');
	if (isNav6) {
		curNode.style.display = 'block';
		document.getElementsByTagName('body').item(0).style.visibility = '';
	}
		
	curNode.style.marginLeft = '';
	curNode.style.marginRight = '';
	curNode.style.visibility = '';
	
//	if (contextNode){
		scLeft = ((isNav6)?window.scrollX:window.screenLeft);
		scTop = ((isNav6)?window.scrollY:window.screenTop);
		if (scTop != scTopPrevious) window.scrollTo(scLeft,scTopPrevious);
//	}
}

