/* CSS for w6 in XHTML Outlines
   see 	

   Derived from stuff from all over the place, including -
   expanding menus at
   http://inspire.server101.com/js/xc/
   key handling
   http://www.netcrucible.com/xslt/opml.html
   extracting the XML
   http://dannyayers.com/2003/08/jspwiki/whiteboard.htm

*/

document.onmousedown = mouseDown;
document.onmouseover = mouseOver;
document.onkeyup = keyStruck;
window.onload = init;

var inEdit;

function init(){
	detectBrowser();
	transformElements('list-1');
//	
	setAll('list-1', true);
	refreshScreen();
	setAll('list-1', true);
//	
}

function mouseOver(evt){

	if (isIE4) evt = window.event;
		var obj = getTarget(evt);
		var className = getAttributeValue(obj,'class');
		if(className != 'unknown'){
			obj.title = className;
		}
}
	
function mouseDown(evnt){
	inEdit = false;
//alert('mousedown');
	if (isIE4) {
		evnt = window.event; 
	}
	

	var target = getTarget(evnt);
//	alert(target.nodeName);
	contextNode = target;
	
	if(target.nodeName == 'li' 
		|| target.nodeName == 'LI' 
		|| target.nodeName == 'a' 
		|| target.nodeName == 'A' 
		|| target.nodeName == 'p'
		|| target.nodeName == 'P'){
		//	target.contentEditable = true;
		return tryEdit(evnt, target);		
	} else {
		if (	target.nodeName == 'a' 
			|| target.nodeName == 'A' ){
			target = target.parentNode;
		return tryEdit(evnt, target);	
	}
	}
	return true;
}

function getTarget(evnt){
	try{
	
	if (isIE4){
		obj = evnt.srcElement;
	}else{
		obj = evnt.target;
	//	alert(obj.nodeName);
		if(obj){
			while (obj.nodeName != 'ul' 
			&& obj.nodeName != 'UL' 
			&& obj.nodeName != 'li' 
			&& obj.nodeName != 'LI' 
			&& obj.nodeName != 'p' 
			&& obj.nodeName != 'P' 
			&& obj.parentNode){
			obj = obj.parentNode;
			}
		}
	}
	
	return (obj);
		}catch(e){
	// forget it
	}
}

function tryEdit(evnt, target){
	if (evnt.altKey){
		editNode(target);
		return false;
	}
}

function editNode(obj){
	inEdit = true;
	// alert(getXML());
	// alert('edit = '+obj.innerHTML);
	

	if (isIE55) {
//	alert(isIE55);
		htmlEdit(obj);
	} else {
		var newVal = window.prompt('edit',obj.innerHTML);
		if(newVal != null){obj.innerHTML = newVal;}
		refreshScreen();
	}
}


function htmlEdit(obj){
	obj.contentEditable = true;
	inEdit = true;
}

function unEdit(obj){
	obj.contentEditable = false;
	inEdit = false;	
	refreshScreen(isIE4);
}

/* Keystroke handler */
function keyStruck(evnt){
	var k;
	if (isIE4){
	 	evnt = window.event;
	 }

	if (isIE4){
		k = evnt.keyCode;
	} else {
		k = evnt.which;
	}
	
	evnt.cancelBubble = true;
	//	alert(k);
		
	switch (k){
	
	case 87: // 'w'
		if(evnt.altKey){
			var className = getClassAttribute(contextNode);
		// alert(className);
			className = nextClassName(className);
			setClassAttribute(contextNode, className);
		}
			break;

	case 27:  // escape
		if (contextNode && inEdit){unEdit(contextNode);return false;}
		break;
	case 13:  // 'Enter'
		if (evnt.ctrlKey){
			if (contextNode && !inEdit){editNode(contextNode);return false;}
		}
		break;
	case 88:  // 'X'
		if (!inEdit && evnt.ctrlKey){
			toggleOPML();
		}
		return false;
		break;
	case 75:  // 'K'
		if (contextNode && !inEdit && evnt.ctrlKey){return(nodeLink(contextNode.parentNode));}
		break;
	case 191: // '/'
		if (contextNode && !inEdit){return(nodeCommentToggle(contextNode.parentNode));}
		break;
	case 46:  // delete
		if (contextNode && !inEdit){
			if (confirm('Do you really want to delete this node and all child nodes?!?')){
				blastNode(selectedNode);
				return false;
		}}
		break;
	case 37:  // left arrow
		if (selectedNode && !inEdit && evnt.ctrlKey){
			if(nodeLeft(selectedNode.parentNode)) refreshScreen(isIE4 || isNav6);return false;}
		break;
	case 38:  // up arrow
		if (selectedNode && !inEdit && evnt.ctrlKey){
			if(nodeUp(selectedNode.parentNode)) refreshScreen(isIE4 || isNav6);return false;}
		break;
	case 39:  // right arrow
		if (selectedNode && !inEdit && evnt.ctrlKey){
			if(nodeRight(selectedNode.parentNode)) refreshScreen(isIE4);return false;}
		break;
	case 40:  // down arrow
		if (selectedNode && !inEdit && evnt.ctrlKey){
			if(nodeDown(selectedNode.parentNode)) refreshScreen(isIE4 || isNav6);return false;}
		break;
	case 45:  // insert
		if (selectedNode && !inEdit){
			var newNode = nodeNew(selectedNode.parentNode);
			if (newNode){
				refreshScreen(isIE4);
				unContext(selectedNode);
				setContext(getOutlineText(newNode));
				editNode(getOutlineText(newNode));
				return false;
		}}
		break;
	default:
		break;
	}
	// alert(k);
	evnt.cancelBubble = false;
	return true;
}

/* Adding/removing nodes */
function nodeNew(obj){
	var newNode = document.createElement('li');
	
	setAttributeValue(newNode, 'class','what');

	if(obj.nextSibling) {	
	
	obj.parentNode.insertBefore(newNode,obj.nextSibling);
	} else {
//	obj.parentNode.addChild(newNode);
	}
	
	// 	obj.parentNode.insertBefore(newNode,obj);
	newNode.innerHTML = 'edit me';
	
	return newNode;
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
	divElement.className = "control";
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

	accumulator = "";
	indent ="";
	var content = elementToString(document.documentElement);
	return '<?xml version="1.0" encoding="UTF-8"?>'
		+ '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'
		+ content; 
}




function elementToString(element) {
	if (element){
      		var attribute;
      		var i;
      		var div;
      		
      		/* skip control divs */
      		if(element.nodeName == 'DIV'){	
      			for (i = element.attributes.length-1; i>=0; i--){
         			attribute = element.attributes.item(i);
         			if(attribute.nodeName == "class" && attribute.nodeValue == "control"){
					return;
				}
			}
     	 	}
     	 	
      		// @@TODO indent not right
      		accumulator += "\n"+INDENT_CHARS+"<" + element.nodeName; 

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

/* new window */
function newWindow(content){
	// alert(content);
 	var newWindow = window.open("", "XOW", 'toolbar=yes, scrollbars=yes, menubar=yes,  resizable=yes');
 	 
	<!-- mime type is workaround -->
	newWindow.document.open("text/html", "replace");
	
	newWindow.document.write(content);
	newWindow.document.close();
	newWindow.onload = init;
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
function getClassAttribute(element){
	return getAttributeValue(element, 'class');
}

function setClassAttribute(element, value){
	setAttributeValue(element, 'class', value);
}

function getAttributeValue(obj,aname){
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

function setAttributeValue(element, name, value){
	if (element.attributes){
		if (isNav6){
			return(element.setAttribute(name, value));
		}
		if (isIE4){
			
			try{element.attributes.item(name).nodeValue = value;}
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
	//	if (selectedNode){
			scTopPrevious = ((isNav6)?window.scrollY:window.screenTop);
	//	}

		squeeze();
		window.setTimeout('relax()',5);
//	}
//	return true;
}

function squeeze(){
try{
	var curNode;
	
	curNode = document.getElementById('1');
	curNode.style.visibility = 'hidden';
	curNode.style.marginLeft = '10%';
	curNode.style.marginRight = '10%';
	
	if (isNav6){
		document.getElementsByTagName('body').item(0).style.visibility = 'hidden';
		curNode.style.display = 'none';
	}
	}catch(e){
	// forget it
	}
}

function relax(){
try{
	var curNode, scLeft, scTop
	
	curNode = document.getElementById('1');
	if (isNav6) {
		curNode.style.display = 'block';
		document.getElementsByTagName('body').item(0).style.visibility = '';
	}
		
	curNode.style.marginLeft = '';
	curNode.style.marginRight = '';
	curNode.style.visibility = '';
	
//	if (selectedNode){
		scLeft = ((isNav6)?window.scrollX:window.screenLeft);
		scTop = ((isNav6)?window.scrollY:window.screenTop);
		if (scTop != scTopPrevious) window.scrollTo(scLeft,scTopPrevious);
//	}
	}catch(e){
	// forget it
	}
}

var classCount = 7;
var classes = new Array(classCount);
classes[0] = "subject";
classes[1] = "who";
classes[2] = "what";
classes[3] = "why";
classes[4] = "when";
classes[5] = "where";
classes[6] = "how";

function nextClassName(classString){
	var index = 0;
	for(i=0;i<classCount;i++){
		if(classString == classes[i]) {
			index = i;
			break;
		}
	}
	i++;
//	alert(classes[i % classCount]);
	return classes[i % classCount];
}


