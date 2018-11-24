#!/usr/bin/env bash
#
# Runs Stanford CoreNLP.
# Simple uses for xml and plain text output to files are:
#    ./corenlp.sh -file filename
#    ./corenlp.sh -file filename -outputFormat text
# Split into sentences, run POS tagger and NER, write CoNLL-style TSV file:
#    ./corenlp.sh -annotators tokenize,ssplit,pos,lemma,ner -outputFormat conll -file input.txt
# You can also start a simple shell where you can enter sentences to be processed:
#    ./corenlp.sh

OS=`uname`
# Some machines (older OS X, BSD, Windows environments) don't support readlink -e
if hash readlink 2>/dev/null; then
  scriptdir=`dirname $0`
else
  scriptpath=$(readlink -e "$0") || scriptpath=$0
  scriptdir=$(dirname "$scriptpath")
fi

NUMBER_OF_CORES=`getconf _NPROCESSORS_ONLN`

echo "Starting CoreNLP with ${NUMBER_OF_CORES}"
echo "CoreNLP username ${NUMBER_OF_CORES}"
echo "CoreNLP password ${NUMBER_OF_CORES}"


echo java -mx4g -cp "$scriptdir/*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -port 9000 -timeout 15000 -XX:+CrashOnOutOfMemoryError $*
java -mx4g -cp "$scriptdir/*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -annotators tokenize,ssplit,pos,parse,sentiment -threads ${NUMBER_OF_CORES} -port 9000 -timeout 15000 -username ${CORENLP_USERNAME} -password ${CORENLP_PASSWORD} -XX:+CrashOnOutOfMemoryError $*