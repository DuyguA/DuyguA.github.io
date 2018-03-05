---
layout: post
title: A Short Survey of German 2-Level Morphology
date: 2017-12-10 09:00:00
categories: [blog]
tags: [german nlp, german 2-level morphology]
comments: false
preview_pic: /assets/images/wessen.png
---

# German 2-Level Morphology

2-level morphology is commonly being used for morphological analysis of morphologically complex languages since 1980s. Given surface form, we aim to find the lexical form(s) (possibly more than one, as we’ll see soon) and vice versa, switch between the surface form and the lexical form hence the morphological analysis easily. FSTs are used to map a regular language(surface language) to another regular language(lexical language). The lexical and surface levels are connected via several FSTs.

```sh
Lexical form:  s p y + 0 s	g e h en+  s t
Surface form:  s p i  0 e s     g e h   0  s t
```

However, we’ll use morphological analysis more in this post:

```sh
girls ↔ gir<+N><Plu>              gegangen → gehen<+V><PPast>
walked ↔ walk<+V><Past>           gegangen<+ADJ><Pos>
```

Computationally, 2-level morphology processing consists of language specific components, the lexicon and the context rules and finite state transducers. Environment of the rules are also specified as a string of two-level correspondences e.g.  i/y <=> __ e/0 + /0 i. Rules constrain lexical/surface correspondences and the environment in which correspondence is allowed, prohibited or required. Several lexicons, usually by grammatical category and regularity/irregularity makes up the dictionary component. FST provides processing rules in parallel, as well as offering memory and time efficient solutions.   
Before German, let’s see his morphologically not-so-interesting cousin English, also comes from West-Germanic family. English morphology is quite minimalistic, here are the inflectional suffixes: 

| Grammatical Class |                  Suffix                                                  |
|-------------------|--------------------------------------------------------------------------|
| Noun              | -s  plural                                                               |
|                   |-'s  possessive                                                           |
| Verb              | -ed  past tense                                                          |
|                   | -s   3rd singular person present tense -ing progressive                  |
| Adjective         | -er comparative                                                          |
|                   | -es superlative                                                          |


List of context rules is not very long either:

* Epenthesis: ch, sh, s, x, z, y/i before s; otherwise lexical + corresponds to 0
e.g: boxes, churches, spies (+.e)
     dogs, girls, boys      (+.0)
* Y-replacement: allies, tried, tries
* Gemination: capped, bigger, referred
* Ellision: larger, moving, moved, agreed
* I-replacement: dying, lying
- K-insertion: panicked

That's it, really it. You can express English inflectional morphology with 9 FSTs.
German morphology is mainly  
