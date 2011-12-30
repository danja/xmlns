/*
 * Description: Javascript Pet-a-matic implementation
 *
 * Author: Leigh Dodds, leigh@ldodds.com
 *
 * Taken down the evolutionary chain by Danny Ayers, danny666@virgilio.it
 *
 * License: Consider this PUBLIC DOMAIN code, do with it what you will, just mention where
 * you got it. Cheers.
 */

/* =========================== Globals ============================= */

// gDefaultNumberOfFriends=3;
// gCurrentNumberOfFriends=0;
// gFriendTableBody = null;

/* =========================== Globals ============================= */

/* =========================== Generate ============================= */

function generate()
{
    if (validate())
    {
        //clear text area
        document.results.rdf.value='';

        gSpamProtect = document.results.spamProtect.checked;

        //process the form values to make a FOAF person
        pet = buildPet();

        //dump the final RDF description
        pet.dumpToTextArea(document.results.rdf);
    }
}
/* =========================== Generate ============================= */

/* =========================== Build Person =========================== */
function buildPet()
{
    p = new Pet();

    p.depiction = document.details.depiction.value;
    
    p.name = document.details.name.value;
        p.human_name = document.details.human_name.value;
    p.hasID = document.details.hasID.value;
    p.email = document.details.email.value;
     p.pack = document.details.pack.value;
    p.gender = document.details.gender.value;
    p.species = document.details.species.value;
    p.order = document.details.order.value;
    p.breed = document.details.breed.value;
    p.primaryColor = document.details.primaryColor.value;
    p.secondaryColors = document.details.secondaryColors.value;
    p.furStyle = document.details.furStyle.value;
    p.neutered = document.details.neutered.value;

    p.favoriteFood = document.details.favoriteFood.value;
    p.likes = document.details.likes.value;
    p.dislikes = document.details.dislikes.value;
    p.peculiarities = document.details.peculiarities.value;
    
    /* /now add friends
    for (i=1; i<=gCurrentNumberOfFriends;i++)
    {
        if (document.friends.elements['friend_' + i].value != '' && document.friends.elements['friend_' + i + '_mbox'].value != '')
        {
            friend = new Person();
            friend.name=document.friends.elements['friend_' + i].value;
            friend.email=document.friends.elements['friend_' + i + '_mbox'].value;
            friend.seealso=document.friends.elements['friend_' + i + '_seealso'].value;
            p.addFriend(friend);
        }
    }
	*/
	
    return p;
}
/* =========================== Build Pet =========================== */

/* ========================== Form Validation ========================== */

//TODO -- validate email addresses

function validate()
{

    isValid = true;
    msg = '';

    if (document.details.name.value=='')
    {
        isValid=false;
        msg = msg + 'name \n';
    }

    if (document.details.email.value=='')
    {
        isValid=false;
        msg = msg + 'email \n';
    }

    if (document.details.human_name.value=='')
    {
        isValid=false;
        msg = msg + 'your name \n';
    }
/*
    for (i=1; i<=gCurrentNumberOfFriends;i++)
    {
        if (document.friends.elements['friend_' + i].value != '' && document.friends.elements['friend_' + i + '_mbox'].value == '')
        {
            isValid=false;
            nameMessage = msg_missingFriendEmail.split('?');
            msg = msg + nameMessage[0] + document.friends.elements['friend_' + i].value;
            msg = msg + nameMessage[1] + '\n';
            //msg = msg + 'An Email Address for ' + document.friends.elements['friend_' + i].value +'\n';
        }
    }
*/
    if (!isValid)
    {
        alert('You\'re missing : \n' + msg);
    }

    return isValid;
}
/* ========================== Form Validation ========================== */

/* ========================== Form Utilities ============================ */

function createFriendFields()
{
    gFriendTableBody = document.getElementById('friendtable');
    for (i=1; i<=gDefaultNumberOfFriends; i++)
    {
        addFriendFields();
    }

    //if we've been referred, then populate first friend
    if (gReferredFriend != null)
    {
        document.friends[0].value = gReferredFriend.friendname;
        document.friends[1].value = gReferredFriend.email;
        document.friends[2].value = gReferredFriend.seealso;
    }
}

function addFriendFields()
{
    gCurrentNumberOfFriends++;
    tr = document.createElement('tr');
    tr.appendChild(addCol(field_friend + '--'));
    tr.appendChild(addCol(field_friendName));
    tr.appendChild(addCol('<input type=\"text\" name=\"friend_'+gCurrentNumberOfFriends+'\" value="">'));
    tr.appendChild(addCol(field_friendEmail));
    tr.appendChild(addCol('<input type=\"text\" name=\"friend_'+gCurrentNumberOfFriends+'_mbox\" value="">'));
    tr.appendChild(addCol(field_friendSeeAlso));
    tr.appendChild(addCol('<input type=\"text\" name=\"friend_'+gCurrentNumberOfFriends+'_seealso\" value="">'));

    gFriendTableBody.appendChild(tr);
}

function addCol(html) {
 var td=document.createElement('td')
 td.innerHTML=html
 return td
}


/* ========================== Form Utilities ============================ */

/* ========================== Refer a Friend ============================ */

gReferredFriend = null;

function ReferredFriend(friendname, surname, email, seealso)
{
    this.friendname= friendname || '';
    this.email = email || '';
    this.seealso=seealso || '';
}

function checkParameters()
{
    rawParameters = document.location.search;

    if (rawParameters == '')
    {
        return;
    }

    rawParametersArray = rawParameters.substring(1).split("&");
    gReferredFriend = new ReferredFriend();

    for (i=0; i<rawParametersArray.length; i++)
    {
        nameAndValue = rawParametersArray[i].split("=");
        if (nameAndValue[0] == 'name')
        {
            gReferredFriend.friendname=unescape(nameAndValue[1]);
        }
        if (nameAndValue[0] == 'email')
        {
            gReferredFriend.email=unescape(nameAndValue[1]);
        }
        if (nameAndValue[0] == 'seealso')
        {
            gReferredFriend.seealso=unescape(nameAndValue[1]);
        }
    }
}

 function initLinkedSelect(from,to) {

	var options = new Array();
	(from.style || from).visibility = "visible";
	for (var i=0; i < to.options.length; i++) 
	{

		options[i] = new Array(to.options[i].text,to.options[i].value);
	}
	from.onchange = function() 
	{
		var fromCode = from.options[from.selectedIndex].value;
		to.options.length = 0;
		for (i = 0; i < options.length; i++) 
		{
			if (options[i][1].indexOf(fromCode) == 0) 
			{
				to.options[to.options.length] = new Option(options[i][0],options[i][1]);
			}
		}
		to.options[0].selected = true;
	}		
	from.onchange();
} 

function copyRdf(){
 document.dummy.rdf_copy.value = document.results.rdf.value;
document.forms[4].elems['rdf_copy'].value = document.forms[3].elems['rdf'];
}

