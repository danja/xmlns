rapper -i turtle -o rdfxml index.ttl > index.rdf
cd ../specgen
python specgen6.py --indir=../proc/ --ns=http://purl.org/stuff/proc/  --prefix=proc --ontofile=index.rdf --outdir=../proc/ --templatedir=../proc/ --outfile=proc.html
cd ../proc

