---
layout: post
title: Chatbot NLU Series, Part III
date: 2018-03-28 09:00:00
categories: [blog]
tags: [chatbot nlu, date-time parser] 
comments: false
preview_pic: /assets/images/onticonfused.jpg
---

# Chatbot NLU Part III: Date-Time Parser
Entity extraction and evaluation is an important part of e-mail processing and chatbot NLU pipelines. In this post, we'll see how to parse date-time strings out and evaluate them into Python objects.  
Customer care and sales domain *always* contain date-time expressions; more appointment dates in sales context, more past 'complaint' dates in customer care area. Whether marking the date to the sales agent's calendar, search for a ticket in CRM system or join as a feature to NLU algorithms; recognizing and evaluating date-time expressions is a crucial part of customer care text processing.

```
Can we have a phone call tomorrow afternoon, after 14.00?
I phoned yesterday at 11.00, 14:00 and 16:00 o'clocks. No answer from the customer hotline!!
Let's schedule a Skype call. I'm free on 26th March, Monday 14.00pm or 12.00pm. Would that be suitable? 
```

In sales context, dates can vary from very near future (*today afternoon*) to indeed very far away future (*in 6 months*). In this post, we'll process precise dates as an example; longer term dates can be parsed similarly.

We will recognize  and parse formal language of date-stime strings with Context Free Grammars. I like to use [Lark](https://github.com/erezsh/lark) for mainly efficiency reasons, availability of several parsing algorithms and full Unicode support. Another very important issue is Lark can handle ambiguity, as we'll see very soon date-time grammars can get quite ambiguous. PyParsing is also great, but Lark is much lighter and faster. We'll visit performance issues later; first we focus on forming the grammars.

We'll parse German date-time expression for an example. As you will see from the design

* Non-numeric nonterminals are language dependent i.e. date-time words morgen/morning, gestern/yesterday...
* Ways of writing date time expressions are different in these two languages. In my observation USA English contains more patterns with timezone info i.e. PST, PDT, GMT etc. My feeling is that, timezones add more ambiguity to USA English data-time grammars.

Enough speaking, let's see the CFGs on action:

## German date-time CFG

We'll build a grammar to recognize the **precise dates**: dates look like appointment dates, near future or near past. For instance *yesterday 11 am*, *yesterday afternoon*, *tomorrow at 8.00Uhr*, *23 March Monday, 12:00*... Far away dates i.e. *after 6 moths*, *in 3rd Quarter*, *beginning of the new year* ... can be processed similarly. Let's make a list of strings that we want to recognize:

Days, either weekdays or relative days yesterday, tomorrow etc. Let's include abbreviations as well. Abbreviations can end with a period or not.

```
Mittwoch
Freitag
Gestern
Heute
Morgen 
Mi
Mi.
```

We can add time of the day to the above. Notice that *Morgen* can be either *tomorrow* or *morning* i.e. can join as a weekday or as a time of the day qualifier.

```
Mittwoch vormittag	Wednesday afternoon
Heute nachmittag	today afternoon
gestern morgen		Yesterday morning
Do nachmittag		Thursday afternoon
morgen nachmittag       tomorrow afternoon
Freitag ganzer Tag	Friday all day
```

or we can qualify the day expression. Don't forget to relax umlauts by non-umlaut equivalents.

```
Kommenden Mittwoch 	        Coming Wednesday
n[äa]chster Woche Montag	next week Monday
```

OK, customer might also say *this day or that day*. *I'm available Wednesday or Friday afternoon*  style patterns frequently occur in customer text. 

```
Mi or Do.                               Wednesday or Thursday
heute oder am Do nachmittags            today or Thursday afternoon
heute nachmittag oder Freitag morgen    today afternoon or Friday morning
Donnerstag oder Freitag vormittags      Thursday or Friday morning
nachste Woche Dienstagnachmittag oder Mittwochnachmittag   next week Tuesday afternoon or Wednesday afternoon
```



