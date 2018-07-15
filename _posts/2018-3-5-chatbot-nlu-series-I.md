---
layout: post
title: Chatbot NLU Series, Part I
date: 2018-03-05 09:00:00
categories: [blog]
tags: [chatbot nlu, chatbot, text preprocessing]
comments: false
---

# Chatbot NLU Part I: Preprocess Your Text

In an earlier [Medium post](https://medium.com/@duygu.altinok12/preprocess-your-text-with-spacy-926e32289b27), we already covered entity extraction for the preprocessing pipeline. We'll continue with eliminating the stopwords, replace the synonyms and lemmatize the rest of the words.

Traditional preprocessing pipelines contain stopword remover, synonyms replacer and lemmatizer units. However,if you happen to have a really huge corpus, you need not to worry about this issues, word embeddings will take care of the morphology and stopwords. As I also mentioned in the Medium post, this advice applies to small to mid-size corpora. 

Enough speaking, let's bring the action:
