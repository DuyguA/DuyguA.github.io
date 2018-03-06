---
layout: post
title: Chatbot NLU Series
date: 2018-03-06 09:00:00
categories: [blog]
tags: [chatbot nlu, chatbot, german nlp]
comments: false
preview_pic: /assets/images/onticonfused.jpg
---

# Understanding German Word Forms: DEMorphy

When it comes to processing the German language, it's unavoidable to consider rich morphology. Same noun, adjective or verb may appear in many different forms upto the gender, number, person... For instance, all "rufen", "rufe", "rufst" is "to phone"; same verb in different forms. Hence if one wants to understand German text, it's compulsory to recognize the word forms.  
DEMorphy is a German word form analyzer with more than 10M word forms. DEMorphy can assist chatbots, e-mail analyzers, statistical MT, ASR... all sorts of machine learning system that assigns "meaning" to German text.  
Let's see DEMorphy on action:

### Analyzing Sentence Tense
For chatbots, it's crucial to "understand" customer *already did/wants to do* which action. For instance, compare the two sentences

```
Ich habe dich schon angerufen (I already phoned you).
Ich werde dich anrufen (I'll phone you).
```

In the former, the customer already phoned but their problem is still not yet, possibly an angry customer! In the latter, the customer maybe wants to schedule a call tomorrow...meanings are *completely different* in customer care concept.


<figure>
  <img class="fullw" src="/assets/images/onticonfused.jpg" alt="onticonfused.jpg">
</figure>


Here DEMorphy comes to help:

```
Past <= Ich habe[haben sing,1per] schon angerufen[anrufen V,PPast].
Future <= Ich werde[werden sing,1per] anrufen[anrufen V,Inf].
```

For the first sentence, we locate the auxiliary verb "haben" together with  past participle verb and immediately deduce that the sentence tense is past. The second sentence contains the future auxiliary "werden" together with an infinitive verb, hence the sentence tense is future (most probably an appointment request in this case). Both sentences has their own importance and requires immediate action, the former includes an angry customer emergency!; the latter is also of high priority.
Here, these two sentences has more or less the same wording. Without any time adverbs, sentiment and intent classifiers can put these sentences into the same category mistakenly. Human language is never a bag of words, chatbot NLU will never be a easy task for this reason. One needs to include both statistical components and linguistic features to their chatbot NLU pipeline. DEMorphy helps chatbots to syntactically parse the German language and make all the users happy.

<figure>
  <img class="fullw" src="/assets/images/ontilovesdemorphy.jpg" alt="ontilovesdmeorphy.jpg">
</figure>

### Analyzing Sentence Tone

Most probably your chatbot would like to respond to customers in their own tone i.e. "Sie" or "du". Until the customer offers "du" first, the chatbot is better to be formal and conversate in "Sie". However, after the customer switches to "du", the chatbot should also go informal.

PICCCCCCCCC#


### Language Modelling and Semantic Similarity

```
Bitte rufen Sie uns morgen an.
Bitte rufts du uns morgen an.
```

Here, these two sentences are identical except the tone; hence they should admit the semantic distance `0`. Here's how you can lemmatize with DEMorphy:

```
bitte, rufen+2nd plural person, Sie->2nd plural person, uns, an
bitte, rufen+2nd singular person, du->2nd singular person, uns, an
```
More techincal highlights are as follows:

* DEMorphy can accompany all ARPA formatted language models. Compacting all forms of the same word to the lemma might reduce perplexity significantly. 
* According to my experiments of German text classification, lemmatizing overperforms stemming (consider gender and number declensions). 
* Lemmatizing improves keyword ranking dramatically. We'll discover this issue in detail, wait for the oncoming semantic search post :)


Happy lemmatizing and hacking. We will get to know DEMorphy better in oncoming Chatbot NLU posts.
