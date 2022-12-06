# Day 5

## Part 1

Very helpful array transposition from [this SO answer](https://stackoverflow.com/a/46805290).

```js
const [c, m] = document.querySelector('pre').innerText.split('\n\n');
const crates = c.split('\n')
  .map(l => l
    .split(/(.{4})/g)
    .filter(c => c !== '')
    .map(c => c.trim() === '' ? '' : c.trim().replace(/[\[\]]/g, '')))
  .reduce((prev, next) => next
    .map((item, i) => (prev[i] || []).concat(next[i])), [])
    .map(s => s.slice(0,8));
const moves = m.trim()
  .split('\n')
  .map(l => l.match(/move (\d+) from (\d+) to (\d+)/))
  .map(l => [parseInt(l[1]),parseInt(l[2])-1,parseInt(l[3])-1]);
const moves = m.trim()
  .split('\n')
  .map(l => l.match(/move (\d+) from (\d+) to (\d+)/))
  .map(l => [parseInt(l[1]),parseInt(l[2])-1,parseInt(l[3])-1]);
```

## Part 2
