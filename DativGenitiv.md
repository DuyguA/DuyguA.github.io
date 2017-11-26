## Dativ ist dem Genitiv sein Tod: Story of a Bloody Murder in SpaCy and Numpy

German genitive case is roughly the case that marks possession and is expressed by the apostrophe ('s) and possessive "of" in English. See quick examples:
```
Die Nachrichten des Tages          news of the day
Der Beruf des Mannes ist Arzt.     Profession of the man is doctor./Man's profession is doctor.
```
The genitive of possession and relationships occurs frequently in formal standart German. For instance the following sentence about private customer loans, is from Deutsche Bank customer service website:
```
Sie ist befugt, den Darlehensnehmer bei der Beantragung des Darlehens zu 
```
In everyday spoken German, story is completely different. von + Dative often replaces Genitive. See the example:
```
Das ist der Hund des Mannes.  That's the man's dog.
Das ist def Hund vom Mann.    That's the dog from the man. -> That's the dog of the man.
```
In this post, we'll carry an emprical examination if Dative really replaced Genitive. We'll investigate cases of nominal genitiv and prepositinal genitiv i.e.
- Is von + Dative replacing Genitive?
- What's up with prepositions that are supposed to be used with genitive? I often see them incorrectly used with Dative, as well in informal wriiting language.

Basically what we'll do is: 
- Collect samples
- Look for all genitive forms and count how many of them is real genitive, how many of them dative replacement
- Look for genitive prepositions, count how many of them used correctly
- Count occurences of **Dessen**, **Deren** and **Wessen**, see the explanations below

First, let's see the genitive case in detail, then we can jump onto our dataset and do the hypothesis testing!

### Genitive in NP

In grammar, genitive is the grammatical case that marks a noun as modifying another noun. Genitive also has prepositional and adverbial uses.
In general, NP in German consists of the following word order:
```
Article, Number, Adjective(s), Noun, Genitive attribute, Position(s), Relative Cluase, Reflexive Pronoun
```
significantly longer than the English counterpart. However, usual noun phrases are not this long of course, usually of the form Article + Adjective? + Noun (so don't be scared and run away :blush:). Reason that genitive attribute use is declining might be due to this reason as well, not to make long noun phrases; longer it gets more difficult to understand.
Genitive in NP, i.e. nominal genitive marks possession:
```
Der Beruf des alten Mannes     the profession of the old man
Des alten Mannes Beruf         the old men's profession
```
and replaced by von + dative combo in everyday spoken language:
```
der Hund meines Bruders  ->  der Hund von meinem Bruder
```
#1 murderer is, this usage of the Dative. Though this construction is not incorrect, considered as "not very elegant". However, educated or not many people use these sort of construction in spoken language and informal written communication such as texting, emailing and blogging. That's how a language use one of its cases, in my opinon.

### Prepositional Genitive

In formal standart German, the object of an accusative preposition takes the genitive case. Some of common genitive prepositions are
```
jenseits      on the other side of
anlässlich    on the occasion of
kraft         by virtue of
anstelle      in place of
laut          according to
aufgrund      on the basis of
seitens       on the part of
außerhalb     outside of
trotz         despite, in spite of
bezüglich     with regard to
während       during
innerhalb     within
wegen         because of
```
with some examples:
```
innerhalb eines Tages          within a day
statt des Hemdes               instead of the shirt
während unserer Abwesenheit    during our absence
```

In my opinoin, #2 murderer is incorrectly used datives after these prepositions. For instance, evein in written language I see a lot `wegen dem` instead of the correct use `wegen des`. Unlike replacement with Dative, this usage is wrong.

### Personal, Relative, Interrogative and Demonstrative Pronouns

`Wessen` literally means **whose**. Here are some demonstrative pronouns:
```
desjenigen
desselben
```
relative pronouns:
```
derer
deren
dessen
```
and personal pronouns:
```
meines
deines
seines
ihres
unseres
eures
ihres
```

There is also adverbial genitive and some verbs that are used with genitive but quite limited use. Hence in our emprical study we'll count easily distinguishable cases (we'll be über-tricky :wink:).

## The Dataset

We'll dig the Yelp restaurant reviews dataset, reviews from Germany has reviews in German generally. Reviews are written in informal language, hence ideal for our emprical study :wink:
Go ahead and download the famous Yelp dataset. I pulled a little stunt to find German cities, flushed the list to `city_list.txt`. Reviewed restaurants are in:
```

Denkendorf
Freyburg
Filderstadt
Ditzingen
Waiblingen
Neuhausen
Henderson
Fellbach
Ludwigsburg
Esslingen am Neckar
Esslingen
Stuttgart
Leonberg
Boblingen
Sindelfingen
Stuttgart-Vaihingen
Stuttgart - Bad Cannstatt
Ostfildern
Gerlingen
Ludwigsburg
Leinfelden-Echterdingen
Kornwestheim
Schwaikheim
Remseck am Neckar
Remseck
```
Then we're ready to find business_ids of restaurants in German cities with `find_id_from_city.sh`and write them into `ids.txt`. 7044 places joined Yelp dataset from Germany:
```bash
$ wc -l ids.txt
7044 ids.txt
```
In order to select German restaurant reviews from `review.json`, I play a bit with `jq` instead of benefitting from chunk reading talents of **Pandas**. Obviously such a huge json can't be read into memory once, one has to iterate in chunks. However, as a text miner I play with **jq** a lot, here I decided to filter first German reviews then read them into Python. Surely **Pandas** provide nice methods for chunk iterating, but remember there's always more than one way to swim a fish :wink:
Following lines will select lines from `review.json` where **business_id** is in `ids.txt`:
```bash
$ jq -R . ids.txt > ids.json
$ jq --slurpfile ids ids.json 'map(select(.business_id as $id|any($ids[];$id==.)))' review.json > german_reviews.json
```
Note that there are also English reviews for German restaurants, mainly by expats. We'll make a small trick and filter mixed reviews by existence of the words **ich, Sie, und, aber, oder, bin, habe, kann, sind, hatte, gern, gerne, viele, nicht, kein, keine, mehr, vieles, ein, eine, sehr, muss, die, der, das, ja**. Roughly, %99 of the German written text includes at least one of these words, frequent personal pronouns, modal and auxiliary verbs, adverbs and articles. :wink:
```bash
$ egrep -i "\b(ich|Sie|und|aber|oder|bin|habe|kann|sind|hatte|gern|gerne|viele|nicht|kein|keine|mehr|vieles|ein|eine|sehr|muss|die|das|ja)\b" german_reviews.json > german_reviews.json
```
There are total **32564** reviews about 7044 different business, it seems:
```bash
$ wc -l german_reviews.json
32564 german_reviews.json
```
After preparing the corpus, we're ready to move onto the counting parts. We keep the text only, we don't need the other fields such as stars or user id.
```bash
$ jq .text german_reviews.json > german_reviews.txt
```

### #1 Murderer: Nominal Genitive Replacements

As I wrote previously, I suspect this is the most common type of avoiding the genitive. Basically we'll

- count number of all definite articles **der, die, das, des, dem, den** and see percentage of **des** 
- count all possessive noun phrases and see how many of them is with genitive. 

For the first task, we iterate over all reviews and count tokens with **ART** tag. **ART** includes both definite and indefinite articles, so we need to filter the results a bit.
```python
from __future__ import unicode_literals

import codecs
from collections import Counter
import spacy

nlp = spacy.load("de")

def_arts_list = ["die", "der", "das", "den", "dem", "des"]

counter = Counter()

with codecs.open("german_reviews.txt", "r", encoding="utf-8") as f:
    for line in f:
        review = nlp(line.strip())
        def_arts = [t.text.lower() for t in review if t.tag_=="ART" and t.text.lower() in def_arts_list]
        counter.update(def_arts)

print counter

```
Here is the result:
```bash
Counter({u'die': 69698, u'der': 55810, u'das': 38734, u'den': 22346, u'dem': 12347, u'des': 6435})
```
It doesn't look that bad indeed. **Des** is half as **Dem**, which is not that bad. There are **205370** definite articles in  **32564**  reviews i.e. 6 article per review and **%3** of all articles is **Des**. 
```python
import numpy as np
import matplotlib.pyplot as plt

N = len(counter)
x = np.arange(1,N+1)
y = [num for (s, num) in counter.items() ]
labels = [ s for (s, num) in counter.items() ]

width = 0.35 #Use 1 to make it as a histogram
bar1 = plt.bar( x, y, width, color="y")
plt.ylabel( 'Number of Ocuurences' )
plt.xticks(x + width/2.0, labels )
plt.show()
```
![](https://github.com/DuyguA/DuyguA.github.io/blob/master/dem_barchart.png)

Ok, it looks that bad now. **%3** is higher than I expected, but still looks very close to graveyard as well. In Turkish one can describe the situation with the idioms "To have one foot in the grave" or "To have eyes looking down to the soil".  

In the second task, we'll do a more detailed count. We'll count all possessive noun phrases and see percentage of genitive. We count
```
ART NN ART ADJA? NN             der Beruf des (alten) Mannes
ART ADJA? NN NN                 des alten mannes Beruf
ART NN PPOSAT NN                der Hund meines Bruders
ART NN APPR (ART|PPOSAT) NN     der Hund von meinem Bruder, der Weg von der Haltestelle
```
sequences and filter by some small tricks to distinguish genitive ones :wink:. 
We begin by counting noun chunks of the form 4th. We'll use **Matcher** class from **Spacy** to match POS tags. Then we'll do a filtering by existing of **vor** because **APPR (ART|PPOSAT)** matches a bigger superclass of strings of interest, see some:
```
einer Woche mit einem Groupon
der Kellner mit einem Grinsen
die Schmiereien in den Toiletten
der Kellner mit der Speisekarte, dem Wunsch nach der Rechnung
```
Note that German POS tags of Spacy come from  [Stuttgart tagset](http://www.ims.uni-stuttgart.de/forschung/ressourcen/lexika/TagSets/stts-table.html). German tagset is richer than English counterpart, due to rich morphosyntactic features. Text miners who work with German are acquainted with Stuttgart tagset, which is the standart tagset for German language. Don't worry if you're not %100 comfortable with the tagset, you can make a rough mapping onto English counterparts :wink: 
I will do a very rough preprocessing, then do the counting:
```python
from spacy.matcher import Matcher
from spacy.attrs import TAG

matcher = Matcher(nlp.vocab)

tags = [
    [{TAG:"ART"}, {TAG:"NN"}, {TAG:"APPR"}, {TAG:"PPOSAT"}, {TAG:"NN"}],
    [{TAG:"ART"}, {TAG:"NN"}, {TAG:"APPR"}, {TAG:"ART"}, {TAG:"NN"}],
    ]

[matcher.add_pattern("noun noun chunk", tag_pattern) for tag_pattern in tags]

little_preprocess = lambda rev: " ".join(rev.replace("\\n", " ").strip().split())

vors = ["vor ", "vom ", "von "]
count = 0 
with codecs.open("german_reviews.txt", "r", encoding="utf-8") as f:
    for line in f:
        review = nlp(little_preprocess(line))
        matches = matcher(review)
        match_strings = [review[m[-2]:m[-1]] for m in matches]
        match_strings = filter(lambda match: any(v in match.text for v in vors), match_strings)
        count += len(match_strings)
print count
```
Result is **451** and some example matches are:
```
einen Zeitungsberricht von der Eröffnung
Ein Freisitz vor dem Restaurant
Der Ausblick von der Terrasse
Die Sepia von der Tageskarte
ein Fleischgericht von der Tageskarte
der Nähe von der Bar
der Tisch von der Kellnerin
den Platz vor dem Salatbüffet
[Die Pizza von meinem Mann
dem Elefanten von unserem Nachbarn (Elefants of our neighbor)?!!?
```
Now we count "real" genitives. We pull the same stunt with **Matcher** with the corresponding POS tags. Here are some examples from the matched strings:
```
eine Nachbau des antiken Kolosseums
des Spaßfaktors den Besuch
Die Kreationen des Küchenchefs
Die Besonderheit des Restaurants
den Sternen des Hotels
das Thema des Hotel
Der Hummus des Tages
das Geheimnis des Ladens
Das Highlight des Abends
die Qualität des Essens
des Geschmacks des Essens
Das Konzept des Ladens, das Konzept des Restaurants, einem Drittel des Gerichtes, den Eindruck des Ambientes
die Qualität des alten Mövenpicks
die Qualität des Fisches
die Qualität des Sushis
```
and the number is **2474?!!??**. Good Lord, either I counted dative constructions wrong or ... I should stop writing immediately :flushed: My theory is completely wrong?!(so is Bastian Sick, [sorry](http://www.spiegel.de/kultur/zwiebelfisch/zwiebelfisch-der-dativ-ist-dem-genitiv-sein-tod-a-267725.html) Herr Sick!)

### Wrong Usages with Prepositional Genitive

Ok, here also we use **Matcher** class as follows: First we'll match phrases of the form **One of Genitive Prepositions + Article**. Then, we'll count how many of the articles definite or indefinite in genitive or dative and compare the numbers. Note that Dative usage is **WRONG**, unlike von + dative replacements. Let's hit it:

```
preplist = [ 
u"jenseits",      
u"anlässlich",    
u"kraft",         
u"anstelle",      
u"laut",          
u"aufgrund",    
u"seitens",       
u"außerhalb", 
u"trotz",         
u"bezüglich",     
u"während",     
u"innerhalb",     
u"wegen"         
]

from spacy.matcher import Matcher
from spacy.attrs import TAG, ORTH
matcher = Matcher(nlp.vocab)
tags = [[{ORTH:w}, {TAG:"ART"}] for w in preplist]
    
[matcher.add_pattern("noun noun chunk", tag_pattern) for tag_pattern in tags]
```
Rest is almost same with previous iterating over the corpus and counting code. Here are some wrong usages with dative:
```
während dem
wegen dem
wegen einem
trotz dem
```
**NAHAAA!!!** I caught Dative with his two hands covered in blood!! :grin:
Out of 1845 prepositional genitive constructions, 241 usages were wrongly with dative...looks like the real murderer here :scream: :scream: :scream:.

### Genitive Pronouns

Earlier we saw personal, relative, interrogative and demonstrative pronouns in genitive forms. Now we make a rough count. We'll find ratio of our genitive guys **wessen, desselben, derer, deren, dessen** to all words with pronoun tags **PDAT, PDS, PWS, PWAT, PWAV**. Here are the results:
```
counter.most_common()[:30]

[(u'das', 12147),
 (u'was', 6632),
 (u'wie', 2995),
 (u'diese', 2764),
 (u'wer', 2628),
 (u'dieses', 2175),
 (u'dieser', 2138),
 (u'diesem', 2041),
 (u'wo', 1568),
 (u'dies', 1346),
 (u'diesen', 1053),
 (u'die', 891),
 (u'warum', 675),
 (u'der', 584),
 (u'wobei', 539),
 (u'dem', 371),
 (u'welche', 314),
 (u'denen', 221),
 (u'welches', 191),
 (u'draussen', 178),
 (u'deren', 157),
 (u'drinnen', 154),
 (u'welcher', 144),
 (u'den', 140),
 (u'weshalb', 135),
 (u'wann', 126),
 (u'dass', 125),
 (u'dessen', 122),
 (u'wem', 95),
 (u'welchen', 89)]
```
Our friends **deren** and **dessen** made it to top 30, which is sort of a success. Distribution of the other genitive friends is as follows:
```
wessen  1
desselben   1
derjenigen  1
derer   3
dessen  122
deren   157
```
