package agilog.snlp;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import edu.stanford.nlp.ling.CoreAnnotations.NormalizedNamedEntityTagAnnotation;
import edu.stanford.nlp.ling.CoreAnnotations.PartOfSpeechAnnotation;
import edu.stanford.nlp.ling.CoreAnnotations.SentencesAnnotation;
import edu.stanford.nlp.ling.CoreAnnotations.TextAnnotation;
import edu.stanford.nlp.ling.CoreAnnotations.TokensAnnotation;
import edu.stanford.nlp.ling.CoreLabel;
import edu.stanford.nlp.pipeline.Annotation;
import edu.stanford.nlp.pipeline.StanfordCoreNLP;
import edu.stanford.nlp.semgraph.SemanticGraph;
import edu.stanford.nlp.semgraph.SemanticGraphCoreAnnotations.BasicDependenciesAnnotation;
import edu.stanford.nlp.semgraph.SemanticGraphCoreAnnotations.EnhancedPlusPlusDependenciesAnnotation;
import edu.stanford.nlp.semgraph.SemanticGraphEdge;
import edu.stanford.nlp.util.CoreMap;

public class SNLPPrologAdapter {
	private String[] words;
	private String[] ners;

	private String parseTree;
	private String[] dependenceGraph;
	
	private String[] basicDependenceGraph;

	public String[] getBasicDependenceGraph() {
		return this.basicDependenceGraph;
	}
	
	public String[] getDependenceGraph() {
		return this.dependenceGraph;
	}

	public String getParseTree() {
		return this.parseTree;
	}

	public String[] getWords() {
		return this.words;
	}

	public String[] getNers() {
		return this.ners;
	}
	public SNLPPrologAdapter(String text) {
		/*
		// this is your print stream, store the reference
		PrintStream err = System.err;

		// now make all writes to the System.err stream silent 
		System.setErr(new PrintStream(new OutputStream() {
			
			@Override
			public void write(int arg0) throws IOException {
				// TODO Auto-generated method stub
				
			}
		}));

		*/

		
		  
		
		// creates a StanfordCoreNLP object, with POS tagging, lemmatization, NER,
		// parsing, and coreference resolution
		Properties props = new Properties();
		props.setProperty("annotators", "tokenize, ssplit, pos, lemma, ner, depparse");
		StanfordCoreNLP pipeline = new StanfordCoreNLP(props);
		
		

		// create an empty Annotation just with the given text
		Annotation document = new Annotation(text);

		// run all Annotators on this text
		pipeline.annotate(document);

		// these are all the sentences in this document
		// a CoreMap is essentially a Map that uses class objects as keys and has values
		// with custom types
		List<CoreMap> sentences = document.get(SentencesAnnotation.class);
		//Tree tree = null;
		SemanticGraph dependencies = null;
		ArrayList<String> vetorPOS = new ArrayList<>();
		ArrayList<String> vetorNER = new ArrayList<>();


		words = new String[1];
		ners = new String[1];
		for (CoreMap sentence : sentences) {
			// traversing the words in the current sentence
			// a CoreLabel is a CoreMap with additional token-specific methods
			for (CoreLabel token : sentence.get(TokensAnnotation.class)) {
				// this is the text of the token
				String word = token.get(TextAnnotation.class);
				// this is the POS tag of the token
				String pos = token.get(PartOfSpeechAnnotation.class);
				// this is the NER label of the token
				String ne = token.get(NormalizedNamedEntityTagAnnotation.class);
				//System.out.println(ne);
				// Monta o predicado das palavras com a extrutura palavra,pos tag e ne tag
				vetorPOS.add("word(" + word.toLowerCase() + "," + pos.toLowerCase() + "," + "0" + ").");
				
				String[] numeroInt = {"0"};
				if(ne != null){
				String temp = ne.replace('.','#');
				numeroInt = temp.split("#");
				}
				vetorNER.add("ner(" + word.toLowerCase() + "," + numeroInt[0] + "," + "0" + ").");
				
			}

			// this is the Stanford dependency graph of the current sentence
			dependencies = sentence.get(EnhancedPlusPlusDependenciesAnnotation.class);

			ArrayList<String> grafoDependencias = new ArrayList<String>();
			for (SemanticGraphEdge edge : dependencies.edgeListSorted()) {
				String arco = "edge_dependence(" + edge.getSource().toString().split("/")[0] + ","
						+ edge.getTarget().toString().split("/")[0] + "," + edge.getRelation().toString().split("/")[0]
								+ ").";
				grafoDependencias.add(arco.toLowerCase());
			}
			this.dependenceGraph = new String[0];
			this.dependenceGraph = grafoDependencias.toArray(this.dependenceGraph);
			
			
			dependencies = sentence.get(BasicDependenciesAnnotation.class);

			ArrayList<String> grafoDependenciasBasica = new ArrayList<String>();
			for (SemanticGraphEdge edge : dependencies.edgeListSorted()) {
				String arco = "edge_dependence_basic(" + edge.getSource().toString().split("/")[0] + ","
						+ edge.getTarget().toString().split("/")[0] + "," + edge.getRelation().toString().split("/")[0]
								+ ").";
				grafoDependenciasBasica.add(arco.toLowerCase());
			}
			this.dependenceGraph = new String[0];
			this.dependenceGraph = grafoDependencias.toArray(this.dependenceGraph);
			
			this.basicDependenceGraph = new String[0];
			this.basicDependenceGraph = grafoDependenciasBasica.toArray(this.basicDependenceGraph);

		}
		this.words = vetorPOS.toArray(this.words);
		this.ners = vetorNER.toArray(this.ners);
		
		// This is the coreference link graph
		// Each chain stores a set of mentions that link to each other,
		// along with a method for getting the most representative mention
		// Both sentence and token offsets start at 1!
		//Map<Integer, CorefChain> graph = document.get(CorefChainAnnotation.class);
		limpaApostrofo();
		//System.setErr(err);
	}

	private void limpaApostrofo() {
		for (int i = 0; i < this.basicDependenceGraph.length; i++) {
			this.basicDependenceGraph[i] = this.basicDependenceGraph[i].replaceAll("'", "");
		}
		for (int i = 0; i < this.dependenceGraph.length; i++) {
			this.dependenceGraph[i] = this.dependenceGraph[i].replaceAll("'", "");
		}
		for (int i = 0; i < this.words.length; i++) {
			this.words[i] = this.words[i].replaceAll("'", "");
		}
		for (int i = 0; i < this.ners.length; i++) {
			this.ners[i] = this.ners[i].replaceAll("'", "");
		}
		//this.parseTree.replaceAll("'", null);
	}

	public static void main(String[] args) {
		SNLPPrologAdapter n = new SNLPPrologAdapter("Delete information about patient's middle in the name panel");
		String[] lista = n.getBasicDependenceGraph();
		for (int i = 0; i < lista.length; i++) {
			//System.out.println(lista[i]);
		}
		
		
		// creates a StanfordCoreNLP object, with POS tagging, lemmatization, NER,
		// parsing, and coreference resolution
//		Properties props = new Properties();
//		props.setProperty("annotators", "tokenize, ssplit, pos, lemma, ner, parse, dcoref");
//		StanfordCoreNLP pipeline = new StanfordCoreNLP(props);
//
//		// read some text in the text variable
//		String text = "Lucas is a nice guy and he is 28 years old";
//
//		// create an empty Annotation just with the given text
//		Annotation document = new Annotation(text);
//
//		// run all Annotators on this text
//		pipeline.annotate(document);
//
//		// these are all the sentences in this document
//		// a CoreMap is essentially a Map that uses class objects as keys and has 	 values
//		// with custom types
//		List<CoreMap> sentences = document.get(SentencesAnnotation.class);
//		Tree tree = null;
//		SemanticGraph dependencies = null;
//		for (CoreMap sentence : sentences) {
//			// traversing the words in the current sentence
//			// a CoreLabel is a CoreMap with additional token-specific methods
//			for (CoreLabel token : sentence.get(TokensAnnotation.class)) {
//				// this is the text of the token
//				String word = token.get(TextAnnotation.class);
//				// this is the POS tag of the token
//				String pos = token.get(PartOfSpeechAnnotation.class);
//				// this is the NER label of the token
//				String ne = token.get(NamedEntityTagAnnotation.class);
//
//				System.out.println(word + " " + pos + " " + ne);
//			}
//
//			// this is the parse tree of the current sentence
//			tree = sentence.get(TreeAnnotation.class);
//
//			String arv = tree.toString();
//			arv = arv.replaceAll("\\(", "parse_tree\\(");
//			//arv = arv.replaceAll(" ", ",");
//			String[] a = arv.split(" ");
//			String arvoreFinal = "";
//			for (int i1 = 0; i1 < a.length; i1++) {
//
//				if(i1 - 1 > 0 && a[i1].contains(")")) {
//					arvoreFinal += a[i1].replaceFirst("\\)",",nil,nil)");
//				}else {
//					arvoreFinal += a[i1];
//				}
//
//
//
//				if(i1 < a.length - 1 && a[i1+1].contains(")")) {
//					arvoreFinal += " ";
//				}else {
//					arvoreFinal += ",";
//				}
//
//			}
//
//
//			// this is the Stanford dependency graph of the current sentence
//			dependencies =
//					sentence.get(CollapsedCCProcessedDependenciesAnnotation.class);
//
//
//		}
//
//		// This is the coreference link graph
//		// Each chain stores a set of mentions that link to each other,
//		// along with a method for getting the most representative mention
//		// Both sentence and token offsets start at 1!
//		Map<Integer, CorefChain> graph = document.get(CorefChainAnnotation.class);


	}
}
