# Twitter Tech News Bot
 
## What does this bot do?
This bot controls the [Twitter News Bot](https://twitter.com/TechNewsBot1). The Account follows a bunch of Tech Companies from which it takes tweets every 15 minutes and retweets the announcements these compaines make using a basic needle-in-haystack filter to differentiate between announcements and other tweets.

## How does this bot work?
First of all, this bot is ENTIRELY written in Julia. Julia is an amazing language that I have recently discovered and learnt a big chunk about. You can always check the source code in `src`. Comments are added to every block of code to help make the code clearer. This bot also uses Github Actions to run the script automatically every 15 minutes.

## Fake News? Rumors?
This bot only takes posts from Official accounts of Tech Companies, so there is no fake news or automated rumor spreading here!

## The filter is weak.
You can always make a Pull Request and make changes! Maybe you just want to add new trigger words, or you have come up with a Natural Language Processing model that can identify news tweets! Go creative. At first I had the idea of the NLP model, but I didn't have the time, resources, or knowledge to implement this.

## Why?
Why not?
