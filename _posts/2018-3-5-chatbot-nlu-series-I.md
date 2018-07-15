---
layout: post
title: Chatbot NLU Series, Part I
date: 2018-03-05 09:00:00
categories: [blog]
tags: [chatbot nlu, chatbot, text preprocessing]
comments: false
---

# Chatbot NLU Part I: Preprocess Your Text

In an earlier [Medium post](https://medium.com/@duygu.altinok12/preprocess-your-text-with-spacy-926e32289b27), we already covered entity extraction for the preprocessing pipeline. We'll continue with eliminating the stopwords, replace the synonyms and stem the rest of the words.

Traditional English text preprocessing pipelines contain stopword remover, synonyms replacer and stemmer units. However,if you happen to have a really huge corpus, you need not to worry about this issues, word embeddings will take care of the morphology and stopwords. As I also mentioned in the Medium post, this advice applies to small to mid-size corpora. 

Enough speaking, let's bring the action:

## Remove Stopwords

Stopwords are usually short words of the language that doesn't carry much information. Definite/indefinite articles, some interjections, personal pronouns, some particles, some question words, some conjunctions, some modal and auxiliary verbs fall into this category. SpaCy's list of English stopwords can be viewed from [here](https://github.com/explosion/spaCy/blob/master/spacy/lang/en/stop_words.py).
Let's continue from the example from the Medium post. Here is where we left:

```
import spacy
nlp = spacy.load("en") #we load the English models once, use it many times. Don't include this line into any methods, it'll dramatically reduce the efficiency

def email_preprocessor(mail):
    entities = {}
    mail = lexical_processor(mail)     #mail is unicode
    doc = nlp(mail)                    # mail is spacy.doc type
    entities['emails'] = extract_emails(doc)
    entities['persons'] = extract_person_names(doc)
```
is_stop is a token attribute and is a Boolean indicates if the token is in stopwords. 

```
def remove_stopwords(doc):
    words_list = []
    for token in doc:
        if token.is_stop:
            pass
        else:
            words_list.append(token.text)
    return words_list
```

This will remove all the stopwords from the sentence and returns a list of words. 
Another type of stopwords are rather stopphrases that occur in your text. For instance in sales, 

```
your e-mail
your message
many thanks for
thanks for
```
are quite common phrases. If you want to remove these ones, do it before the stopword removement because they contain stopwords as parts. 
There can be also sentences that you want to remove completely. Opening politeness and closing remarks are of this type:

```
Many thanks for your message.
Thanks for the information.
I wish a great weekend to you and your family.
```
If you want to remove sentences, it's better to do a sentence tokenizing first; then decide which sentences to eliminate. Something like this:

```
def remove_politeness(doc):
    sentences = [] 
    for sentence in doc.sents:
        if opening_politeness(sentence):
            pass #skip this sentence
        elif closing_remarks(sentence):
            pass #skip this sentence
        else:
            sentences.append(sentence) #add this sentence to the list
    return sentences
```
More on the third type will come, wait for the classification post:) Let's add the stopwords remover t the pipeline, we began with a string, switch to a spacy span, now we go back to a list of strings:

```
import spacy
nlp = spacy.load("en") 

def email_preprocessor(mail):
    entities = {}
    mail = lexical_processor(mail)     #mail is unicode
    doc = nlp(mail)                    # mail is spacy.doc type
    entities['emails'] = extract_emails(doc)
    entities['persons'] = extract_person_names(doc)
    word_list = remove_stopwords(doc)        #word_list is list(unicode) type
```

## Replace Synonyms
No matter what people say, if you have a close domain replacing synoynms is always a good idea. Especially in small/mid size corpus, it creates miracles. In order word vectors to achieve their best in your domain:

* they should be trained on your domain 
* they should be trained at least a bit supervised, otherwise antonyms possess the same word vector and that can lead to headaches

Antonym adjectives usually have the same word vector as they occur in same context and indeed in many cases interchangable. For instance:

```
I had a very good customer experience.
I had a very bad customer experience.

She had a very attractive sister.
She had a very unattractive sister.
```
Surrounding words i.e. the context are exactly the same, then no wonder word vectors are the same. If you want to use word vectors fro sentiment analysis especially, make sure that they're trainable. More onto this subject appears on the classification post.

I usually store synonyms as dictionaries, so the replacement is straightforward, just one dictionary lookup. One can also map multiword phrases to one word or again multiword phrases. In that case, some keys are substrings of the other keys. In this case, its better to hold your dictionary as a **Trie**. More onto this data structure will come later. 

## Stem 
Stemming is the process of finding the shortest substring of a word that keep the **concept** of the word. Important thing is to know that the stem does nt belong to the language's lexicon (i.e. a valid word) and 
