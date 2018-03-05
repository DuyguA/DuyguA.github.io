---
layout: post
title: A Short Survey of German 2-Level Morphology
date: 2017-12-10 09:00:00
categories: [blog]
tags: [german nlp, german 2-level morphology]
comments: false
preview_pic: /assets/images/german-morph.png
---

# German 2-Level Morphology

2-level morphology is commonly being used for morphological analysis of morphologically complex languages since 1980s. Given surface form, one aims to find the lexical form(s) (possibly more than one, as we’ll see soon) and vice versa, switch between the surface form and the lexical form; hence the morphological analysis easily. FSTs are used to map a regular language (the surface language) to another regular language (the lexical language). The lexical and surface levels are connected via several FSTs.

```sh
Lexical form:  s p y + 0 s	g e h en+  s t
Surface form:  s p i 0 e s      g e h   0  s t
```

However, we’ll use morphological analysis more in this post:

```sh
girls  ↔ girl<+N><Plu>            gegangen → gehen<+V><PPast>
walked ↔ walk<+V><Past>                      gegangen<+ADJ><Pos>
```

Computationally, 2-level morphology processing consists of language specific components, the lexicon and the context rules and finite state transducers. Environment of the rules are also specified as a string of two-level correspondences e.g.  `i/y <=> __ e/0 + /0 i`. Rules constrain lexical/surface correspondences and the environment in which correspondence is allowed, prohibited or required. Several lexicons, usually by grammatical category and regularity/irregularity makes up the dictionary component. FST provides processing rules in parallel, as well as offering memory and time efficient solutions.   
Before German, let’s see his morphologically not-so-interesting cousin English, also comes from West-Germanic family. English morphology is quite minimalistic, here are the inflectional suffixes: 

| Grammatical Class |Suffix                                                                    |
|-------------------|--------------------------------------------------------------------------|
| Noun              |               -s  plural                                                 |
|                   |               -'s  possessive                                            |
| Verb              |               -ed  past tense                                            |
|                   |               -s   3rd singular person present tense -ing progressive    |
| Adjective         |               -er comparative                                            |
|                   |               -es superlative                                            |


The list of context rules is not very long either:

* Epenthesis: ch, sh, s, x, z, y/i before s; otherwise lexical + corresponds to 0  
e.g: boxes, churches, spies (+.e)  
     dogs, girls, boys      (+.0)  
* Y-replacement: allies, tried, tries
* Gemination: capped, bigger, referred
* Ellision: larger, moving, moved, agreed
* I-replacement: dying, lying
- K-insertion: panicked

That's it, really it. You can express English inflectional morphology with only 9 FSTs.  
German morphology is mainly concatenative. Inflection, derivation and composition are done via concatenation. Inflections occur as adjective, noun declensions and verb conjugations. For example,
The nominal number inflection:

```sh
Freund  →  Freund(friend)  N,masc,acc/nom/dat,singular
Freunde →  Freund(friends) N,masc,acc/gen/nom,plural
``` 

Adjectives and nouns are inflected upto gender, number and case:

```sh
Kalt → kalter, kaltem, kaltes, kalte, kalten 
```

One surface form might map to more than one distinct lexical forms:

```sh
roter →  rot(red) ADJ,base,nogender,gen,plural,strong
         rot ADJ,base,fem,dat/gen,singular,strong
         rot ADJ,base,masc,nom,sing,strong
         rot ADJ,comparative
```

Circumfixing is used in making regular past participles: e.g. `gespielt(played) → ge+spielen(play)+t`. Prefixes, suffixes and circumfixes all occur in German language, different from English; consequently one needs to compose more FSTs.  
In my own implementations, I usually focus on derivations that involve nouns, adjectives and verbs. Most of the sentence level information “who, when, how”, as well as the sentence tense is captured by these three classes. Verbs admit special attention from my morphological processor unit designs to understand the “action” of the sentence better. For instance, “angerufen” (have phoned) is a frequent verb from many customer service corpora:

<figure>
  <img class="halfw" src="/assets/images/german-morph.png" alt="german-morph.png">
</figure>


Nouns are not very difficult to recognize due to capitalization, `essen – Essen (to eat – food)`. Verbs admit  three typical suffixes `-en, -eln, -ern`, adjectivization is similar for instance `Tag – täglich (day – daily)`. Here, derivation might cause stem vowel changes as **Umlaut** and **Ablaut** shifts.

While implementing  German 2-level morphology, I treat non-concatenative events as context dependent rules. For instance, some irregular nouns go through **Umlautung** on number inflection: `Haus → Häuser`. New word forms follow from the irregular form by regular inflection: `Häusern → Haus N, neut, acc/gen/nom,plural`. Here, rather than having one FST both changes the stem vowel and adds `er`, we can compose two FSTs, one context dependently modifies stem vowel in some nouns and other deals with number inflection. Same for processing the second word form, the *case inflection FST* processes the word ending and the *Umlautung FST* modifies the stem vowel.  

Adjective and noun declensions are described by suffixes in general, however irregular declensions occur frequently. For instance many foreign nouns have irregular plurals, e.g. `der Modus-des Modus-die Modi`, as well as ordinary adjectives `gut-besser-am besten`. Here, we separate irregular forms and stems into different sorts of lexicons.  
In conclusion, inflectional and derivational morphology processing unit involves regular and irregular word lexicons as FSTs, prefix-suffix-circumfix FSTs and nonconcatenative event FSTs to cope with stem changes.

### Compositional Morphology

The productivity of the German language indeed comes from composing words to form new words, **Mammutwörter**. This process can occur with the nouns, adjectives, adverbs, verbs but the most productive in the case of the nouns. Compound words are richness of the Germanic languages, at the same time trouble of statistical machine translation, ASR, text classification... and source of %90 of the **OOV**s.

Most compounds are made from a *head* (**Grundwort or Determinatum**) and *modifier/qualifier words* (**Determinons or Bestimmungswort**). Compound grammatical gender and grammatical category is determined by the head, declension is determined only upto the head as well. Noun-noun (**die Zeitungsindustrie**), adjective-noun (**die Großeltern**), preposition-noun(**der Vorort**), preposition-verb (**runterspringen**), adjective-adjective (**dunkelblau**) are common ways of composing.

Decomposing compound words is not a trivial task, not always words come together as they are, but are often subject to morphological events. In most cases, the modifier stays uninflected e.g. **Schlafzimmer**; in some cases different word from appear e.g. **Bilderbuch, Kirchturm, Landbau, Landsmann, Landesmuseum, Ländercode, Tageskarte, Tagereise**. Though the elements `-e(s), -er, -e, -en` look like inflectional endings (and historically are), they are **Fugenelemente**, linking morphemes and admit no meaning. For instance *Fugen-s* occurs with `-tum, -ling, -ion, -heit, -keit, -schaft, -sicht, -ung` ending words e.g. **Altertumsforschung, Kommunionsfest, Ansichtskarte**. Genitive/plural elements occur in some morphemes e.g. **Urlaubsort, Wörterbuch** though, but we processed them as **Fugenlement** as well.

According to my own statistics:) about 2/3 of the compounds occur without **Fugenelemente**, I estimate `-(e)s and -(e)n` to occur 20-25 per cent, while `-e` is much rare, I would say 2 per cent. About 92 per cent of the compounds consist of two words, rest is 3 word compounds and 4 word compounds occurs almost none. Here are two frequent compounds from business e-mailing, one being a verb, the other a noun:

```sh
weitergeleitet →  weiter<#>leiten     V,PPast
Weiterleitung  →  weiter<#>leit+ung   N,nom/acc/dat/gen,singular
```
Decomposing compound words with FST is possible, jumping from the end of a word to the beginning of another word should emit a word boundary symbol, **<#>**. However, we shouldn’t forget to compose with the *Fugenelement FST* and *Umlautung FST*. This way, one can transduce all possible splittings of a compound, which splits are feasible or “make sense” is whole another issue. My in-house tool generates all possible splits, then filtered by impossible POS tag combinations (e.g. beiden is not bei<\#>den) and a language model. For instance “Rohrohrzucker” has 2 possible splits:

```sh
Rohr<#>ohr<#>zucker     pipe ear sugar
Roh<#>rohr<#>zucker     raw cane sugar
```

We eliminate the first form because “it doesn’t make sense”, i.e. it admits a very low probability from the language model. Also, we use the heuristic that “less split is better than more splits”. If a compound admits a 2 word split and a 3 word split, we prefer the former.  
As seen, processing German morphology is challenging but interesting and sophisticated. I usually have mixed feelings, sometimes find it too diffilcult, sometimes enjoy the level of sophistication.

Happy reading and processing!






