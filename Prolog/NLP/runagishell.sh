#!/bin/sh
PATH_TO_ME=`dirname $0`;

JPL_DIR=/usr/share/java

#JRE_DIR=/usr/lib/jvm/java-7-openjdk-amd64/jre
JRE_DIR=/usr/lib/jvm/java-8-openjdk-amd64/jre

LD_LIBRARY_PATH=$JRE_DIR/lib/amd64/server:$JRE_DIR/lib/amd64:$PATH_TO_ME/thea2/FaCT++-linux-v1.6.2/64bit

export LD_LIBRARY_PATH
CLASSPATH=$PATH_TO_ME/agilogj.jar:$PATH_TO_ME/bnjv33/bnjv33.jar:/usr/share/java/jpl.jar:$PATH_TO_ME/jade-4.3.1/jade.jar:$PATH_TO_ME/jade-4.3.1/commons-codec-1.3.jar:$JPL_DIR/jpl.jar:$PATH_TO_ME/thea2/jars/aterm-java-1.6.jar:$PATH_TO_ME/thea2/jars/pellet-cli.jar:$PATH_TO_ME/thea2/jars/pellet-el.jar:$PATH_TO_ME/thea2/jars/pellet-modularity.jar:$PATH_TO_ME/thea2/jars/pellet-query.jar:$PATH_TO_ME/thea2/jars/FaCTpp-OWLAPI-3.4-v1.6.2.jar:$PATH_TO_ME/thea2/jars/pellet-core.jar:$PATH_TO_ME/thea2/jars/pellet-explanation.jar:$PATH_TO_ME/thea2/jars/pellet-owlapi.jar:$PATH_TO_ME/thea2/jars/pellet-rules.jar:$PATH_TO_ME/thea2/jars/org.semanticweb.HermiT.jar:$PATH_TO_ME/thea2/jars/pellet-datatypes.jar:$PATH_TO_ME/thea2/jars/pellet.jar:$PATH_TO_ME/thea2/jars/pellet-owlapiv3.jar:$PATH_TO_ME/thea2/jars/pellet-test.jar:$PATH_TO_ME/thea2/jars/owlapi-distribution-3.5.2.jar:$PATH_TO_ME/thea2/jars/pellet-dig.jar:$PATH_TO_ME/thea2/jars/pellet-jena.jar:$PATH_TO_ME/thea2/jars/pellet-pellint.jar:$PATH_TO_ME/thea2/jars/guava-18.0.jar:$PATH_TO_ME/thea2/jars/trove-3.0.3.jar:$PATH_TO_ME/thea2/jars/jgrapht-core-0.9.0.jar:$PATH_TO_ME/ejml-0.23.jar:$PATH_TO_ME/javax.json-api-1.0-sources.jar:$PATH_TO_ME/javax.json.jar:$PATH_TO_ME/joda-time-2.9-sources.jar:$PATH_TO_ME/joda-time.jar:$PATH_TO_ME/jollyday-0.4.9-sources.jar:$PATH_TO_ME/jollyday.jar:$PATH_TO_ME/protobuf.jar:$PATH_TO_ME/slf4j-api.jar:$PATH_TO_ME/slf4j-simple.jar:$PATH_TO_ME/stanford-corenlp-full-2017-06-09/stanford-corenlp-3.8.0.jar:$PATH_TO_ME/stanford-corenlp-full-2017-06-09/stanford-corenlp-3.8.0-models.jar:$PATH_TO_ME/xom-1.2.10-src.jar:$PATH_TO_ME/xom.jar:$PATH_TO_ME/NLPPrologAdapter.jar:$PATH_TO_ME/stanford-corenlp-full-2017-06-09/stanford-english-kbp-corenlp-2017-06-09-models.jar:$PATH_TO_ME/stanford-corenlp-full-2017-06-09/stanford-english-corenlp-2017-06-09-models.jar

export CLASSPATH

export _JAVA_SR_SIGNUM=20 

swipl -g '[agishell],[agilog_snlp],[basefatosprolog],[regras],[mitras_agentes],[ontologiasinonimos],[t1],[t2],[t3],[help]'
