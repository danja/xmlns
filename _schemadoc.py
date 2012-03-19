#!/usr/bin/env python
"""
schemadoc.py - Format RDF Schemata
Author: Sean B. Palmer, inamidst.com
Usage: ./schemadoc.py URI
"""

import sys
from rdflib.Graph import ConjunctiveGraph as Graph
from rdflib import URIRef, Literal, BNode, Namespace
from rdflib import RDF, RDFS

OWL = Namespace('http://www.w3.org/2002/07/owl#')
prefix = {
   'http://purl.org/dc/elements/1.1/': 'dc', 
   'http://www.w3.org/WAI/ER/EARL/nmg-strawman#': 'earl', 
   'http://www.w3.org/1999/02/22-rdf-syntax-ns#': 'rdf', 
   'http://www.w3.org/2000/01/rdf-schema#': 'rdfs'
}

def split(uri): 
   """Split URI into racine (greedy), [#/], component."""
   hash = uri.rfind('#')
   slash = uri.rfind('/')
   i = max(hash, slash)
   return uri[:i], uri[i+1:]   

def format(uriref): 
   uri = str(uriref)

   for ns in prefix.iterkeys(): 
      if uri.startswith(ns): 
         return prefix[ns], uri[len(ns):]

   namespace, label = split(uri)
   racine, nslabel = split(namespace)
   return nslabel, label

class Class(object): 
   def __init__(self, uri): 
      self.uri = str(uri)
      self.qname = format(self.uri) # @@ rename format
      self.classes = []
      self.properties = []

   def __cmp__(self, obj): 
      return cmp(self.qname, obj.qname)

   def __str__(self): 
      return self.name()

   def name(self, format='html'): 
      prefix, name = self.qname
      if format == 'html': 
         return prefix + ':<a href="' + self.uri + '">' + name + '</a>'
      else: return ':'.join([prefix, name])

class Property(object): 
   def __init__(self, uri): 
      self.uri = str(uri)
      self.qname = format(self.uri) # @@ rename format

   def __cmp__(self, obj): 
      return cmp(self.qname, obj.qname)

   def __str__(self): 
      return self.name()

   def name(self, format='html'): 
      prefix, name = self.qname
      if format == 'html': 
         return prefix + ':<a href="' + self.uri + '">' + name + '</a>'
      else: return ':'.join([prefix, name])

def test(): 
   uris = [
     'http://www.w3.org/1999/02/22-rdf-syntax-ns', 
     'http://www.w3.org/2000/01/rdf-schema' 
     # 'http://www.w3.org/2000/10/swap/grammar/ebnf.rdf'
     # 'http://www.w3.org/2002/07/owl'
   ]

   schemadoc(uris)

def schemadoc(uris): 
   G = Graph()
   for uri in uris: 
      G.parse(uri)

   print """
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Schema Documentation</title>
<style type="text/css">
body { margin: 1em; font-family: Georgia, sans-serif; }
h1 { font-family: Tahoma, sans-serif; }
h2, h3, h4, h5, h6 { font-family: Arial, sans-serif; }
a { font-weight: bold; color: #036; }
dt.class { margin-top: 0.75em; }
dt.property { margin-top: 0.75em; }
address { padding-top: 0.35em; border-top: 2px solid #369; }
</style>
</head>
<body>
<h1>Schema Documentation</h1>
"""
   classes = []
   for metaclass in [RDFS.Class, OWL.Class]: 
      for uri in G.subjects(RDF.type, metaclass): 
         if not isinstance(uri, URIRef): continue

         c = Class(uri)
         c.classes = [Class(u) for u in G.objects(uri, RDFS.subClassOf)
                      if isinstance(u, URIRef)]
         for prop in G.subjects(RDFS.domain, uri): 
            p = Property(prop)
            ranges = [Class(u) for u in G.objects(prop, RDFS.range)]
            c.properties.append((p, ranges))
         # c.properties = [Property(u) for u in G.subjects(RDFS.domain, uri)]
         c.comments = [str(s) for s in G.objects(uri, RDFS.comment)]
         classes.append(c)

   print '<h2>Classes</h2>'
   print '<ul>'
   for c in sorted(classes): 
      print '<li>'
      print '<dl>'
      print '<dt class="class">'
      sys.stdout.write(c.name())

      if c.classes: 
         o = ', '.join(cls.name(format='text') for cls in sorted(c.classes))
         print '(' + o + ')'
      else: print
      print '</dt>'

      for comment in c.comments: 
         print '<dd>'
         print comment
         print '</dd>'

      for prop, ranges in sorted(c.properties): 
         print '<dd>'
         print '   ' + prop.name()
         if ranges: 
            print ' => ' + ', '.join(range.name() for range in ranges)
         print '</dd>'
      print '</dt>'
      print '</li>'
   print '</ul>'

   print '<h2>Properties</h2>'
   properties = []
   print '<dl>'
   for propclass in [RDF.Property, OWL.FunctionalProperty,
                     OWL.InverseFunctionalProperty]: 
      for uri in G.subjects(RDF.type, propclass): 
         if not isinstance(uri, URIRef): continue

         p = Property(uri)
         properties.append(p)
         p.kind = Class(propclass)
         p.domains = [Class(u) for u in G.objects(uri, RDFS.domain)
                      if isinstance(u, URIRef)]
         p.ranges = [Class(u) for u in G.objects(uri, RDFS.range) 
                     if isinstance(u, URIRef)]
         p.comments = [str(s) for s in G.objects(uri, RDFS.comment)]

   for p in sorted(properties): 
      print '<dt class="property">'
      print p.name() + ' (' + p.kind.name(format='text') + ')'
      print '</dt>'

      for comment in p.comments: 
         print '<dd>'
         print comment
         print '</dd>'

      if p.domains: 
         print '<dd>domain: '
         print ', '.join(domain.name() for domain in p.domains)
         print '</dd>'

      if p.ranges: 
         print '<dd>range: '
         print ', '.join(range.name() for range in p.ranges)
         print '</dd>'
   print '</dl>'

   print '<address>'
   print 'Generated by <a href="http://inamidst.com/proj/sdoc/"'
   print '>Schemadoc</a>'
   print '</address>'
   print '</body>'
   print '</html>'

# @@ report errors at the bottom
# @@ call from CGI
# @@ XHTML vs. Plain Text

def main(): 
   try: arg = sys.argv[1]
   except IndexError: 
      print __doc__.strip()
      sys.exit()

   if arg == '--test': 
      test()
   elif arg == '--help': 
      print __doc__.strip()
   else: schemadoc([arg])

if __name__ == '__main__': 
   main()
