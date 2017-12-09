# Chatbot NLU Series, Introduction

Chatbot NLU is difficult; I mean **really, really, extremely** difficult. In this series, I'll share the knowledge that 
I gain from my experiments. Most of the ideas also applies to e-mail classificiation tasks and information extraction.

Charging meaning to short text has always been a though task, it's even thougher when **context** info comes to play.
Consider the short fragment of a financial chatbot:

```
- Which creditcards are available?
- We provide only one: Mastercard 
- What are the conditions?
- Yearly fee 80 euros, interest rate %1.

- Welche Kreditkarten bieten Sie an?
- Wir bieten nur eine: Mastercard
- der Zins?
- .....

- Hangi kredi kartlarını alabiliyoruz?
- Bankamız Masterkart sağlamaktadır.
- Faiz oranı nedir?
- ....
```

Even in such a short converstaion fragment, there are multiple issues to be solved:

- What is the answer to the first question? I mean, bot **has to** have some knowledge about products. 
- At 3rd line, human brain resolves that `conditions/der Zins` belong to the `Mastercard`. Nobody would write 
`what are the conditions for the Mastercard?` , even `what is` part is skipped in German version. Here there are 2 problems:

- In German version, there's **no** decent question with a **wh-word**. Even though it's a **wh-question** obviously,
interrogative pronoun is not there. 
- Question refers to the entity `Mastercard` obviously, but word itself is not there, it's one line up. Correct resolution 
is `conditions for Mastercard`, `Zinsen bei Mastercard` and `Masterkart'ın faiz oranı`

- Again, bot has to have a knowledgebase for the product. Also, every customer bank who uses this bot gotta has 
their own knowledgebase, products and rates differ for BankA and BankB.

and things can get much worse. Consider the following conversation fragment about bank loans:

```
- Ich brauche einen Kredit.
- Wir bieten ....
- Kann man im Internet bestellen?
- Ja, natürlich. Besuchen Sie uns unter: http://www.Dbank.de/DKredit/bestellen.html
- per Telefon?
- Rufen Sie uns unter 099 99999 an und vereinbaren Sie einen Termin. 

- Kredi almak istiyorum.
- .....
- Internetten başvurabiliyor muyuz?
- Evet, başvuru formunu http://www.Dbank.com.tr/DKredi/satinal.html den doldurabilirsiniz.
- Telefonla?
- 0999 0 999u arayıp bilgi alabilirsiniz.
```
- At 3rd line, again `bestellen` and `başvuru` belongs to the entity `Kredit/Kredi`.
- This time 5th line has a different problem. Attribute is not stated completely, i.e. `per Telefon/Telefonla` is indeed `per Telefon bestellen/Telefonla başvuru`. Now it's tougher, because resolution is **half** from 2 lines up, `Internet bestellen/Internetten başvuru` is there, however different from 1st scenario this time but entity of interest `Kredit/Kredi` is **too** far and buying with phone's resolution depend's on previous entity's resolution. Also question type is the same, 3rd line is a **yes no question**, so is 5th line. 

Yes, keeping the dialogue state and resolving, i.e. understanding what is written can go insane very quickly.

Coming to the scientific view, when it comes to any sort of NLU, one has to hit as hard as (s)he can. In everyday life, I benefit from 
all classes in the Chomsky hierarchy, regular, context free and Turing-acceptable and of course...substring look-up, 
our old friend! (he has a special place in my heart):wink: Statistical models are Turing machines; fancy, exciting and 
surprising ones, but **still** Turing machines. And costly Turing machines. Here then comes the #1 principle of good engineering,
simplest solution **is always** the best solution: easier to develop, easier to test and requires less human resource.
Throughout this series, you'll see that I'll try to pick the simplest solution to the tasks; if conquering the problem
with a context free parser is possible, there's no point developing a statistical model. In general, a  statistical model is a big-hammer:
training data, test data is expensive, time consuming to prepare; also human effort is very big. We'll try to optimize cost
function both by time, by frustration level and human effort :wink:

#2 issue in any NLP problem is to pick the correct data structure. String processing, especially search algorithms can be very
costly, in order to result in a suitable runtime performance one has to pick the most suitable data structures as well. As
an intro, %90 of the language data structures are **Graph** and %90 of that %90 is **DAG** (directed acylic graph, simply
think sentence/time goes from left to right and builds a lattice. We'll come to this issue later on.) Especially in 
language modelling, DAGs provide uber-efficient solutions and used extensively in MT and ASR platforms.

Series will provide examples on German(morphologically complex), Turkish(morphologically rich, agglunative) and English
(morphologically not very interesting) languages. We'll discover banking/financial, sales and general customer care 
domains. 
I should warn readers beforehand that series contain a big amount worshipping to father Turing. At the very end, he's 
father of everyone who computes something somehow, isn't he :wink:
Fasten your seatbelt, grab your compiler and please feel free to contact me for all questions. Happy hacking! :dizzy: :sparkles:

