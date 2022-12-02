# Day 2 

> REPL-paper-scissors

This solution is meant to be pasted into the DevTools window on the [day 2 input]() page.

It's inelegant, hard to parse, and fun.

## Part 1 

Solved naively, though you wouldn't know by looking. 

Find the round score `rs` by summing the outcome of the round `or` and the shape score `ss`.
Find the total score by performing the round score calculation for each line of input, found on the page in a `<pre>` block, while filtering some noise from the input.


```js
rock = 1;
paper = 2;
scissors = 3;
outcome = [0, 3, 6];
cmp = (t, m) => {
  if (ss(t) === ss(m)) return 0;
  if (
    (ss(t) === rock && ss(m) === paper) 
    || (ss(t) === paper && ss(m) === scissors) 
    || (ss(t) === scissors && ss(m) === rock) 
  ) return 1;
  return -1;
}
or = (r) => outcome[cmp(...r.split(' ')) + 1];
ss = (s) => s === 'A' || s === 'X' 
  ? rock 
  : s === 'B' || s === 'Y' 
    ? paper
    : scissors;
sr = (r) => ss(r.substring(r.length-1)) + or(r)
ts = (rr) => rr.map(sr).reduce((a,v) => a += v)
ts(document.querySelector('pre').innerText.split('\n').filter(r => r.length === 3));
```

Don't reload the input page!

## Part 2

We just need to solve for each round. Map opponent moves to desired outcomes, then transform the input.
Once transformed, the input is passed to the previous calculation. 

```js
moves = {
    A: {X: 'Z', Y: 'X', Z: 'Y'},
    B: {X: 'X', Y: 'Y', Z: 'Z'},
    C: {X: 'Y', Y: 'Z', Z: 'X'}
}
solve = (r) => {
  const [t, o] = r.split(' ');
  return `${t} ${moves[t][o]}`;
}
ts(document.querySelector('pre').innerText.split('\n').filter(r => r.length === 3).map(solve));
```
