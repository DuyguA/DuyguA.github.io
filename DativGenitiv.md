## Der Dativ ist dem Genitiv sein Tod: Story of a Bloody Murder in SpaCy and Tensorflow

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
Das ist der Hund des Mannes. That's the man's dog.
Das ist def Hund vom Mann.    That's the dog from the man. -> That's the dog of the man.
```

In this post, we'll carry an emprical examination if Dative really replaced Genitive. We'll investigate cases of nominal genitiv and prepositinal genitiv i.e.

- Is von + Dative replacing Genitive?
- What's up with prepositions that are supposed to be used with genitive? I often see them incorrectly used with Dative, as well in informal wriiting language.

Basically what we'll do is: 

- Collect samples
- Look for all genitive forms and how many of them is real genitive, how many of them dative replacement
- Look for genitive prepositions, see how many of them used correctly
- Count occurences of **Dessen** and **Wessen**, see the explanations below

First, let's see genitive in detail, then we can jump onto our dataset and do the hypothesis testing!

### Genitive in NP

