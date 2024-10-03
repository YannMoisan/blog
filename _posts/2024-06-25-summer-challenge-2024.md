---
title: My post mortem for the codingame Summer Challenge 2024
description: My post mortem for the codingame Summer Challenge 2024
layout: post
lang: en
---
- Rank: 172
- Language: Scala
- LOC: 500

## Strategy

After testing some heuristics to pass the first leagues, I started writing the
simulation for each mini-game. It's a pure function (so easily testable) from `(State, Action) => State`.
In my experience, the first crucial step is to develop a well-tested, bug-free simulation.

Once you have that, you can write an evaluation for each mini game. It's also a pure function from
`State => Double`.

Let's have a look at my evaluation for each mini game :

- Hurdle: my position minus the stun timer (because positive when stunned)
- Archery: the max distance (~29) minus the euclidian distance from the center
- Roller: my position plus the stun timer when stunned (because negative when stunned)
- Diving: the number of points

As you can see, those evaluations are pretty straigthforward.

Next, you need a way to combine the results of each mini-game. For each game, I
compute a weight that is the inverse of the current number of points for this game. 
The intuition is to prioritize games that are lagging in terms of medals because the more uniform the scores are, the higher the overall product will be.

Example: if I have 2 gold and 1 silver, my weight is `1 / (2*3 + 1)`

Once you have that, you can perform a search to find the best action. I've
performed a search at depth 6, without simulating the opponents at all.

To perform the search, I leverage the fact that the branching factor is always
4, so you can encode the actions as an int and use it as the index of an array.

At depth 6, you explore `4^6 = 4096` combinations, so the search returns an array
of doubles of size 4096.

## Mixing some heuristics

### last turn

To counterbalance the fact that I don't simulate my opponents, I've used a
heuristic. If it's the last turn for a mini-game, I simulate my opponents and
force an action if I can win a gold or silver medal for sure.

For example, I use a high score for all actions that will produce a score stricly
greater than the best scores of both my opponents.

### the case of diving

Another heuristic at depth 1 is to determine if I am in a situation where, whatever may
happen, I'm guaranteed to be first, second or third in the diving game.

### unfinished game

Towards the end, if there are not enough turns left to complete a game, the evaluation returns 0 for all actions.

## A note on performance

At the top, there are not many players using a garbage-collected language, as
it can cause timeouts.
I had to make some improvments. I used the combo JMH and JFR to find the
hotspots. There is still plenty to do to go further than depth 6.

## What did not work

- normalize the scores of mini-game between 0 and 1 to ensure they all contribute fairly to the overall score.
- Apply a bigger penalty when stunned in the evaluation
- Remove the penalty when stunned in the evaluation. the intuition was that the
  search would handle it.

## Conclusion

As always, I had very good time participating in this challenge.

I found it's a good way to find the right balance between code quality and
delivering value:
- if your code is a mess, you will strugle to test new ideas and you could have
  some bugs that will make you take bad decisions.
- if your code is too perfect, as your time is limited, it will reduce the
  number of iterations

I had the feeling that I miss something to pretend to the very top of the
gold league and I look forward to reading the post-mortem of top players.
