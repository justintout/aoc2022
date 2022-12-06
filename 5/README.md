# Day 5

Very helpful array transposition from [this SO answer](https://stackoverflow.com/a/46805290).

## Part 1

The crates and the moves are pretty different, so we'll start by breaking them up.

I want to squash the crates down to a transposed 2D array with no empty spaces, so we can just move the first index around `n` times. Our `move` method does just this - shifts `from` `n` times and pushes the shifted value to `to`. 

I want the moves format to just be `n` moves with `from` and `to` as array indexes, so we match out those numbers, parse them, then decrement the `from` and `to` values by one, since they're 1-indexed in the puzzle. 

Then, for each of our `moves`, we just call `move`. Grab the first element, join them together, and we have our message.

```js
const [c,m] = document.querySelector('pre').innerText.split('\n\n');
const crates = c.split('\n')
  .map(l => l
    .split(/(.{4})/g)
    .filter(c => c !== '')
    .map(c => c.trim() === '' ? '' : c.trim().replace(/[\[\]]/g, '')))
  .reduce((prev, next) => next
    .map((item, i) => (prev[i] || []).concat(next[i])), [])
    .map(s => s.slice(0,8)
    .filter(s => s !== ''));
crates.move = (n, from, to) => { for (let i = 0; i < n; i++) { to = [from.shift(), ...to]} };
const moves =  m.trim()
  .split('\n')
  .map(l => l.match(/move (\d+) from (\d+) to (\d+)/))
  .map(l => [parseInt(l[1]),parseInt(l[2])-1,parseInt(l[3])-1]);
moves.forEach(m => crates.move(...m));
crates.map(l => l[0]).join('');
```

Reload the inputs page.

## Part 2

It's funny, this is the original solution I had for 1 that I was stumped on for a whille - I forgot that I'd need to use `.reverse()` to work with splices in part 1.

This process is basically the same, but we use `splice` to grab multiple values and prepend `to` in order, instead of individually `shift`ing values. 

```js
const [c,m] = document.querySelector('pre').innerText.split('\n\n');
const crates = c.split('\n')
  .map(l => l
    .split(/(.{4})/g)
    .filter(c => c !== '')
    .map(c => c.trim() === '' ? '' : c.trim().replace(/[\[\]]/g, '')))
  .reduce((prev, next) => next
    .map((item, i) => (prev[i] || []).concat(next[i])), [])
    .map(s => s.slice(0,8)
        .filter(s => s !== ''));
crates.multiMove = (n, from, to) => crates[to].splice(0, 0, ...crates[from].splice(0, n > crates[from].length ? crates[from].length : n))
const moves =  m.trim()
  .split('\n')
  .map(l => l.match(/move (\d+) from (\d+) to (\d+)/))
  .map(l => [parseInt(l[1]),parseInt(l[2])-1,parseInt(l[3])-1]);
moves.forEach(m => crates.multiMove(...m));
crates.map(l => l[0]).join('');
```

