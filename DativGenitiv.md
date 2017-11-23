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
#1 murderer of this Dative. Though this construction is not incorrect, considered as "not very elegant". However, educated or not many people use these sort of construction in spoken language and informal written communication such as texting, emailing and blogging. That's how a language use one of its cases, in my opinon.

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

## Personal, Relative, Interrogative and Demonstrative Pronouns

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
```
$wc -l ids.txt
1044 ids.txt
```
In order to select German restaurant reviews from `reviews.json`, I play a bit with `jq` instead of benefitting from chunk reading talents of **Pandas**. Obviously such a huge json can't be read into memeory once, one has to iterate in chunks. However, as a text miner I play with **jq** a lot, here I decided to filter first German reviews then read them into Python. Surely **Pandas** provide nice methods for chunk iterating, but remember there's always more than one way to swim a fish :wink:
Following lines will select lines from `reviews.json` where **business_id** is in `ids.txt`:
```
jq -R . ids.txt > ids.json
jq --slurpfile ids ids.json 'map(select(.business_id as $id|any($ids[];$id==.)))' reviews.json > german_reviews.json
```
