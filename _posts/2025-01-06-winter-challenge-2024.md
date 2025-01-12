---
title: My post mortem for the codingame Winter Challenge 2024
description: My post mortem for the codingame Winter Challenge 2024
layout: post
lang: en
---
<style>
    table {
        border-collapse: collapse;
        width: 50%;
        margin: 20px auto;
    }
    th, td {
        border: 1px solid black;
        text-align: center;
        padding: 0px;
        font-size: 48px;
        width: 60px; /* Fixed width */
        height: 60px; /* Fixed height */
    }
</style>
- Rank: #99/3900
- Language: Scala
- LOC: 1000

## Introduction

December is always a challenging month, especially with the Advent of Code daily puzzles. 
By mid-December, as my motivation for Advent of Code began to decrease, 
I received an invitation for the CodinGame Winter Challenge, 
scheduled from December 19 to January 6. Despite trying to resist, I ultimately registered.

I'm also proud of my older son, who created a CodinGame account and decided to participate 
for the first time. With just a little help correcting Python coding mistakes in the IDE, 
he successfully progressed through the wood league and ultimately reached the silver league. 
Congrats to him!

## Strategy

This contest was particularly friendly to heuristic approaches, 
allowing participants to achieve good ranks with a heuristic-only bot. 
Therefore, I decided not to implement a simulation this time.

For each turn, I generated all possible actions: a cartesian product of 
available locations within a distance of 1, different organ types, 
and the four directions, plus all spore possibilities. 

For each action, I computed a score.

## The scoring function

Score values by organ type : Tentacle > Harvester > Sporer > Basic

Each type had a specific scoring function:

- Tentacle
    - The closer to the opponent, the highest score
    - If at a distance of 1 from the opponent (figure 1), 
        - I used also the number of destroyed opponent organs
        - and also a boost if the location isn't controlled by another of my tentacles (not as in fig 2)
    - If at a distance of 2/3, the idea is to prevent the opponent from growing toward us. (figure 3'
        - and also a boost if the target of the tentacle is controlled by an opponent tentacle (figure 4)

Figure 1 (score 3.1)

<table>
    <tr>
        <td style="color: blue;">&#x25A0;</td>
        <td style="color: blue; background-color: #f9e79f;">&#x25B6;</td>
        <td style="color: red;">&#x25A0;</td>
    </tr>
</table>

Figure 2 (score 3.0)

<table>
    <tr>
        <td>&nbsp;</td>
        <td style="color: blue;">&#x25BC;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td style="color: blue;">&#x25A0;</td>
        <td style="color: blue; background-color: #f9e79f;">&#x25B6;</td>
        <td style="color: red;">&#x25A0;</td>
    </tr>
</table>

Figure 3 (score 2.8)

<table>
    <tr>
        <td style="color: blue;">&#x25A0;</td>
        <td style="color: blue; background-color: #f9e79f;">&#x25B6;</td>
        <td style="color: blue; ">&nbsp;</td>
        <td style="color: red;">&#x25A0;</td>
    </tr>
</table>


Figure 4 (score 2.9)

<table>
    <tr>
        <td style="color: blue;">&#x25A0;</td>
        <td style="color: blue; background-color: #f9e79f;">&#x25B6;</td>
        <td style="color: blue; ">&nbsp;</td>
        <td style="color: red;">&#x25C0;</td>
    </tr>
</table>

- Harvester
    - The fewer harvesters of this type, the higher the score.
- Sporer
    - I computed an expected number of roots (based on the number of proteins harvested) 
    and scored positively if under this number.
    - I aimed to encourage sporers with a longer line of sight.
- Basic
    - Either move towards the enemy or target a needed protein (for all protein types without a harvester on them, we targeted the closest).
- Spore
    - We targeted the location with the most protein within a distance of 2.
    - and favor the farthest from the sporer

Additionally, 
- penalties were applied for growing on protein 
    - almost no penalty if it's on the shortest path to the target (to avoid being stuck when there are no alternatives).
    - bigger penalties for growing on an harvested protein.
    - smaller penalties for growing on regular protein.
        - if no more resources for this type, the penalty becomes > 1 (reward)

A distance bonus was also applied to encourage movement towards the target.

Here is the score calculation formula

```
finalScore = penalty * (score + distbonus)
```

## Multi agent

We selected organisms in decreasing order of scores, updating resources each time to avoid invalid actions. 
The goal is to prevent scenarios where the optimal action is unavailable because the resource was already used for a less beneficial action on another organism.

However, I still faced the limitation where two organisms could decide to harvest the same protein simultaneously.

## Code reuse

I reused grid code from a previous contest. It represents the grid as a one-dimension array which is more efficient in term of memory and cpu (cache locality). 
It was largely a copy-paste job as I didn’t use a bundler this time.

## Timeout issues

I encountered performance issues that caused some battles to be lost due to timeouts. 
After some random guesses, I concluded that I needed better optimization. 
Using a real profiler, I achieved a 3x performance gain by replacing a `Set` with a `List`.

Initially, I used a `Set` to return all growable locations at depth 1, 
not realizing that the cartesian product operation happened on `Set`, which is costly due to the computation of numerous hash codes.

## Fine tuning
On the last day, I set up BrutalTester to test some ideas with a better feedback loop 
than waiting for a submit.

## Things to improve

### Scoring as double

My score is currently a double, but I believe using an integer would be a better approach because:

- It’s faster to compute.
- It avoids annoying floating-point issues, like `0.19999999999999998`

### local minimum

The drawback of using depth 0 is that the bot will go for a local minimun.
In the example below, it will harvest A, which prevents the harvesting of B later on.

<table>
    <tr>
        <td>W</td>
        <td>A</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>B</td>
        <td style="color: blue; background-color: #f9e79f;">&#x25B2;</td>
        <td style="color: blue;">&#x25A0;</td>
    </tr>
</table>

A better situation after two turns would have been

<table>
    <tr>
        <td>W</td>
        <td>A</td>
        <td style="color: blue;">&#x25C0;</td>
    </tr>
    <tr>
        <td>B</td>
        <td style="color: blue;">&#x25C0;</td>
        <td style="color: blue;">&#x25A0;</td>
    </tr>
</table>

Unfortunately, I couldn't find a simple way to implement this !

## Conclusion

I thoroughly enjoyed the long-duration format during the winter holidays, which allowed participation whenever I had time.

I personally enjoy grid-based challenges; in the past, I really liked games like Pac-Man and Wondev Woman, for example.

The map generator added plenty of diversity, offering different scenarios such as open worlds versus labyrinths and varying numbers of proteins.

I found the challenge both interesting and fun. The rules were simple, but implementing effective strategies was far from easy.

The battles were also entertaining to watch.
