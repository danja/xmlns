# scutters-mate.py
#
# walks directories looking for RDF files
# creates rdf:seeAlso links
#
# URIs should be set for base and this
# you may want to tweak media types in formats
import os
from os.path import join

# where this is being run from
base = "http://hyperdata.org/xmlns/"
this = "http://hyperdata.org/xmlns/meta.ttl"

turtle = """# auto-generated using scutters-mate.py
# danja 2012-01-04

@prefix rdf:     <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:    <http://www.w3.org/2000/01/rdf-schema#> .
@prefix owl:     <http://www.w3.org/2002/07/owl#> .
@prefix xsd:     <http://www.w3.org/2001/XMLSchema#> .
@prefix dc:      <http://purl.org/dc/terms/> .
@prefix foaf:    <http://xmlns.com/foaf/0.1/> .
@prefix format:       <http://purl.org/stuff/formats/> .
\n@base <"""+base+"> .\n\n"

formats = {'.rdf': 'application/rdf+xml', 
           '.owl': 'application/rdf+xml', 
           '.n3': 'text/turtle', # or text/n3
           '.nt': 'text/turtle', # or text/plain
           '.ttl': 'text/turtle',
           '.turtle': 'text/turtle'
}
for root, dirs, files in os.walk('.'):
    for name in files:
	ext = name[name.rfind("."):]
	if ext in formats:
		path = join(root, name)
		if path[0:2] == "./":
			path = path[2:]
		turtle = turtle + "\n<"+this+">  rdfs:seeAlso <" + path +"> .\n"
		turtle = turtle + "<"+path+">  rdfs:seeAlso <" + this +"> .\n"
		turtle = turtle +"<"+path+"> format:format " + "<http://purl.org/stuff/formats/" + formats[ext].replace("+","%2B") + "> .\n"
		turtle = turtle + "<http://purl.org/stuff/formats/" + formats[ext].replace("+","%2B") + "> rdfs:label \"" + formats[ext] + "\" .\n"
print turtle
