## Dativ ist dem Genitiv sein Tod: Story of a Bloody Murder in SpaCy and Scipy

German genitive case is roughly the case that marks possession and is expressed by the apostrophe ('s) and possessive "of" in English. See an quick example:
```
Die Nachrichten des Tages          news of the day
Der Beruf des Mannes ist Arzt.     Profession of the man is doctor./Man's profession is doctor.
```
The genitive of possession and relationships occurs frequently in formal standart German. For instance the following sentence about private customer loans, is from Deutsche Bank customer service, 
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
- Look for all genitive forms and how many of them is real genitive, how many of them dative replacement
- Look for genitive prepositions, see how many of them used correctly
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
#1 murderer is this usage of the Dative. Though this construction is not incorrect, considered as "not very elegant". However, educated or not many people use these sort of construction in spoken language and informal written communication such as texting, emailing and blogging. That's how a language use one of its cases, in my opinon.

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
1044 ids.txt
```
In order to select German restaurant reviews from `review.json`, I play a bit with `jq` instead of benefitting from chunk reading talents of **Pandas**. Obviously such a huge json can't be read into memeory once, one has to iterate in chunks. However, as a text miner I play with **jq** a lot, here I decided to filter first German reviews then read them into Python. Surely **Pandas** provide nice methods for chunk iterating, but remember there's always more than one way to swim a fish :wink:
Following lines will select lines from `review.json` where **business_id** is in `ids.txt`:
```bash
$ jq -R . ids.txt > ids.json
$ jq --slurpfile ids ids.json 'map(select(.business_id as $id|any($ids[];$id==.)))' review.json > german_reviews.json
```
Note that there are also English reviews for German restaurants, mainly by expats. We'll make a small trick and filter mixed reviews by existence of the words **ich, Sie, und, aber, oder, bin, habe, kann, sind, hatte, gern, gerne, viele, nicht, kein, keine, mehr, vieles, ein, eine, sehr, muss, die, der, das, ja**. Roughly, %99 of the German written text includes at least one of these words, frequent personal pronouns, modal and auxiliary verbs, adverbs and articles. :wink:
```bash
$ egrep -i "\b(ich|Sie|und|aber|oder|bin|habe|kann|sind|hatte|gern|gerne|viele|nicht|kein|keine|mehr|vieles|ein|eine|sehr|muss|die|das|ja)" german_reviews.json > german_reviews.json
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
```bash
ART NN ART ADJA? NN         der Beruf des (alten) Mannes
ART ADJA? NN NN             des alten mannes Beruf
ART NN PPOSAT NN            der Hund meines Bruders
ART NN APPR PPOSAT NN       der Hund von meinem Bruder
```
sequences and filter by some small tricks to distinguish genitive ones :wink: .
