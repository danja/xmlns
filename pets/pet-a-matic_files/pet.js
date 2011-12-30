/*
 * Description: Javascript pet helper objects and utilties.
 *
 * Original Author: Leigh Dodds, leigh@ldodds.com
 *
 * Taken down the evolutionary chain by Danny Ayers, danny666@virgilio.it
 *
 * License: Consider this PUBLIC DOMAIN code, do with it what you will, just mention where
 * you got it. Cheers.
 *
 * Dependencies: depends on Paul Johnston's SHA1 Javascript implementation
 *                     see http://pajhome.org.uk/crypt/md5/ for details.
 *
 * $Id: pet.js,v 1.3 2002/07/23 15:46:04 ccslrd Exp $
 */

/* =========================== Globals ============================= */

//We doan need no steenkin' globals!
//Um actually we do...

// Well I'm gonna ignore them anyway...

gSpamProtect = false;

gGeneratorAgent = 'http://purl.org/stuff/pets/pet-a-matic';
gErrorReportsTo = 'mailto:danny666@virgilio.it';

/* =========================== Globals ============================= */

/* ======================== pet Object =========================== */
function Pet()
{
    //properties
    this.depiction = document.details.depiction.value;
    
    this.name = document.details.name.value;
    this.email = document.details.email.value;
    this.gender = document.details.gender.value;
    this.species = document.details.species.value;
    this.order = document.details.order.value;
    this.breed = document.details.breed.value;
    this.primaryColor = document.details.primaryColor.value;
    this.secondaryColors = document.details.secondaryColors.value;
    this.furStyle = document.details.furStyle.value;
    this.neutered = document.details.neutered.value;

    this.favoriteFood = document.details.favoriteFood.value;
    this.likes = document.details.likes.value;
    this.dislikes = document.details.dislikes.value;
    this.peculiarities = document.details.peculiarities.value;
    this.seeAlso = '';


  //  this.friends = new Array();

    //methods
    this.getName = getName;
    this.mbox = mbox;
    this.mboxSha1 = mboxSha1;
  //  this.getPhone = getPhone;
    this.dumpToTextArea = dumpToTextArea;
    this.topet = topet;
  //  this.addFriend = addFriend;

}

function addFriend(pet)
{
    this.friends[this.friends.length] = pet;
}

function getName()
{
    return (this.name != '' ? this.name : this.firstName + ' ' + this.surname);
}

function mbox()
{
    return 'mailto:' + this.email;
}

function mboxSha1()
{
    return calcSHA1('mailto:' + this.email);
}

function getPhone()
{
    return 'tel:' + this.phone.replace(/ /g, '-');
}

function dumpToTextArea(textarea)
{
    textarea.value = this.topet();
}

function topet()
{
    serializer = new petSerializer(this);
    return serializer.getProfile();
}

/* ======================== pet Object =========================== */

/* ===================== pet Serializer Object ======================= */

//Note: I could have simply built up a DOM tree for the pet elements, and
//then serialized this, rather than using this object+methods. However I wasn't
//confident in getting DOM accesses to work cross-browser. I may still do it
//however. It was also easy to port my first code iteration to this structure.

function petSerializer(p, merging)
{
    //properties
    this.pet = p;
    this.top = '<?xml version=\'1.0\'?>\n<?xml-stylesheet type=\"text/xsl\" href=\"pet.xsl\"?>\n<rdf:RDF\n      ' +
    		  'xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n      ' +
                  'xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n      ' +
                  'xmlns:pet=\"http://purl.org/stuff/pets/\"\n      '+
                  'xmlns:foaf=\"http://xmlns.com/foaf/0.1/\"\n      ' +
                  'xmlns:admin=\"http://webns.net/mvcb/\">\n';

    this.documentDescription = '<pet:PetProfileDocument rdf:about=\"\">\n' +
                                           '   <foaf:maker>' + 
                                           makePerson() +
                                           '\n    </foaf:maker>\n' + 
                                            '  <foaf:primaryTopic rdf:nodeID=\"me\"/>\n' +
                                            '  <admin:generatorAgent rdf:resource=\"' + gGeneratorAgent + '\"/>\n' +
                                            '  <admin:errorReportsTo rdf:resource=\"' + gErrorReportsTo + '\"/>\n' +
                                            '</pet:PetProfileDocument>';

    this.tail = '\n</rdf:RDF>';
    this.merging = merging || false;

    //methods
        this.makeOwner = makeOwner;
    this.makeMbox = makeMbox;
    
    this.getProfile = getProfile;
    this.makePet = makePet;
        this.makeHumanName = makeHumanName;
    this.makeName = makeName;
    this.makePack = makePack;

    this.makeID = makeID;
    this.makeGender = makeGender;
    this.makeOrder = makeOrder;
    this.makeSpecies = makeSpecies;
    this.makeBreed = makeBreed;
    this.makePrimaryColor = makePrimaryColor;
    this.makeDepiction = makeDepiction;
    this.makeSecondaryColors = makeSecondaryColors;
    this.makeSeeAlso = makeSeeAlso;
    
    this.makeFurStyle = makeFurStyle;
    this.makeNeutered = makeNeutered;
    this.makeFavoriteFood = makeFavoriteFood;  
    this.makeLikes = makeLikes;    
    this.makeDislikes = makeDislikes;  
    this.makePeculiarities = makePeculiarities;   
}

function getProfile()
{
    return (this.merging ? this.makePet() : this.top + this.documentDescription + this.makePet() + '\n' + this.tail);
}

function makePet()
{
    //merging this pet into the main description? if so, wrap in a knows element.
    if (this.merging)
    {
        return makeSimpleTag('pet', 'knows', makeSimpleTag('pet', 'Pet', this.makeName() +
                                                           this.makeGender() +
                                                           this.makeOwner() +
                                                           this.makeID() +
                                                           this.makeDepiction() +
                                                              this.makePack() +
                                                           this.makePrimaryColor() +
                                                           this.makeSpecies() +
                                                           this.makeOrder() +
                                                           this.makeBreed() +
                                                           this.makeSeeAlso() +
                                                           this.makeSecondaryColors() +
                                                           this.makeFurStyle() +
                                                           this.makeNeutered() +
                                                           this.makeFavoriteFood() +
                                                           this.makeLikes() +
                                                           this.makeDislikes() +
                                                           this.makePeculiarities() 
                                                         
                                                           )

                                    );

    }

    return makeSimpleTag('pet', 'Pet', 			   '    '+this.makeName() +
                                                          this.makeGender() + 
                                                         this.makeOwner() +
                                                         this.makeID() +
                                                       this.makeDepiction() +
                                                               this.makePack() +
                                                         this.makePrimaryColor() +
                                                             this.makeSecondaryColors() +
                                                        this.makeSpecies() +
                                                        this.makeOrder() +
                                                        this.makeBreed() +
                                                         this.makeSeeAlso() +
                                                   
                                                       this.makeFurStyle() +
                                                      this.makeNeutered() +
                                                       this.makeFavoriteFood() +
                                                           this.makeLikes() +
                                                   this.makeDislikes() +
                                                        this.makePeculiarities() +
                                                           '\n',
                                                       'me');
}

function makeSecondaryColors()
{
    if (this.pet.secondaryColors == '')
    {
        return '';
    }
    return makeSimpleTag('pet', 'secondaryColors', this.pet.secondaryColors);
}

function makeSeeAlso()
{
    if (this.pet.seeAlso == '')
    {
        return '';
    }

    return makeRDFResourceTag('rdfs', 'seeAlso', this.pet.seeAlso);
}

function makeName()
{
    return makeSimpleTag('foaf', 'name', this.pet.name);
}

function makePack()
{
        return makeSimpleTag('pet', 'inPack', makePackPack());
}

function makePackPack()
{
    return makeSimpleTag('pet', 'Pack', makePackName());
}

function makePackName()
{
    return makeSimpleTag('foaf', 'name', this.pet.pack);
}

function makeGender()
{
    if (this.pet.gender == '')
    {
        return '';
    }
    makeSimpleTag('pet', 'gender', this.pet.gender);
}

function makeOwner()
{
return  makeSimpleTag('pet', 'fedBy', makePerson()+'\n');
}

function makePerson()
{
return makeSimpleTag('foaf', 'Person', makeMbox()+'\n'+makeHumanName());
}

function makeHumanName()
{
return  makeSimpleTag('foaf', 'name', this.pet.human_name);
}
    
function makeMbox()
{
    if (this.pet.email == '')
    {
        return '';
    }
    if (gSpamProtect)
    {
        return makeSimpleTag('foaf', 'mbox_sha1sum', this.pet.mboxSha1());
    }
    return makeRDFResourceTag('foaf', 'mbox', this.pet.mbox());
}



function makePrimaryColor()
{
    if (this.pet.primaryColor == '')
    {
        return '';
    }
    return makeSimpleTag('pet', 'primaryColor', this.pet.primaryColor);
}

function makeID()
{
    if (this.pet.hasID == '')
    {
        return '';
    }
    return makeSimpleTag('pet', 'hasID', this.pet.hasID);
}

function makeSpecies()
{
    if (this.pet.species == '')
    {
        return '';
    }
    var value = this.pet.species.substring(this.pet.species.indexOf('-')+1);
  //  alert(value);
    if (value == 'Other')
    {
        return '';
    }
    return makeRDFResourceTag('pet', 'species', 'http://purl.org/stuff/pets/'+value);
}

function makeOrder()
{
    if (this.pet.species == '' || this.pet.species == 'Other')
    {
        return '';
    }
        return makeRDFResourceTag('pet', 'order', 'http://purl.org/stuff/pets/'+this.pet.order);
}

function makeDepiction()
{
    if (this.pet.depiction == '')
    {
        return '';
    }
    return makeRDFResourceTag('foaf', 'depiction', this.pet.depiction);
}

function makeBreed()
{
    if (this.pet.breed == '')
    {
        return '';
    }
    return makeSimpleTag('pet', 'breed', this.pet.breed);
}

function makeGender()
{
    if (this.pet.gender == '')
    {
        return '';
    }
    return makeSimpleTag('pet', 'gender', this.pet.gender);
}

function makeFurStyle()
{
    if (this.pet.furStyle == '')
    {
        return '';
    }
    return makeSimpleTag('pet', 'furStyle', this.pet.furStyle);
}

function makeNeutered()
{
    if (this.pet.neutered == '')
    {
        return '';
    }
    return makeSimpleTag('pet', 'neutered', this.pet.neutered);
}

function makeFavoriteFood()
{
    if (this.pet.favoriteFood == '')
    {
        return '';
    }
    return makeSimpleTag('pet', 'favoriteFood', this.pet.favoriteFood);
}

function makeLikes()
{
    if (this.pet.likes == '')
    {
        return '';
    }
    return makeSimpleTag('pet', 'likes', this.pet.likes);
}
function makeDislikes()
{
    if (this.pet.dislikes == '')
    {
        return '';
    }
    return makeSimpleTag('pet', 'dislikes', this.pet.dislikes);
}
function makePeculiarities()
{
    if (this.pet.breed == '')
    {
        return '';
    }
    return makeSimpleTag('pet', 'peculiarities', this.pet.peculiarities);
}

/* ===================== pet Serializer Object ======================= */

/* ====================== XML Utility Methods ========================= */

function makeRDFResourceTag(prefix, localname, resource)
{
    return  '\n' + '<' + prefix + ':' + localname + ' rdf:resource=\"' + resource + '\"/>';
}

function makeSimpleTag(prefix, localname, contents)
{
    return  '\n' + makeOpeningTag(prefix, localname) + contents + makeClosingTag(prefix, localname);
}

function makeSimpleTag(prefix, localname, contents, id)
{
    return  '\n' + makeOpeningTag(prefix, localname, id) + contents + makeClosingTag(prefix, localname);
}

function makeOpeningTag(prefix, localname)
{
    return '<' + prefix + ':' + localname + '>';
}

function makeOpeningTag(prefix, localname, id)
{
    if (id)
    {
        return '<' + prefix + ':' + localname + ' rdf:nodeID="' + id + '">';
    }
    else
    {
        return '<' + prefix + ':' + localname + '>';
    }
}


function makeClosingTag(prefix, localname)
{
    return '</' + prefix + ':' + localname + '>';
}
/* ====================== XML Utility Methods ========================= */