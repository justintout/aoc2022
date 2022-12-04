# Day 4

## Part 1

```js
const cmp = (a,b) => a === b ? 0 : a < b ? -1 : 1)
const contain = (a,b) => cmp(a[0], b[0]) <= 0 && cmp(a[1] >= 0)
    || cmp(b[0],a[0]) <= 0 && cmp(b[1],a[1]) >= 0))
document.querySelector('pre').innerText.split('\n').filter(l => l.trim() !== '')
  .map(l => l.split(','))
  .map(l => l.map(l => l.split('-').map(i => parseInt(i))))
  .map(l => contain(l[0], l[1]))
  .reduce((a,v) => v ? a + 1 : a);
```


## Part 2

Take the inputs, split them out to 2 int arrays, sort the two arrays by their lower bound, check if the first array's upper bound is less than the second array's lower bound. If it is, there is no containment.

```js
document.querySelector('pre').innerText.split('\n').filter(l => l.trim() !== '')
  .map(l => l.split(','))
  .map(l => l.map(l => l.split('-').map(i => parseInt(i))))
  .map(l => l.sort((a,b) => a[0] === b[0] ? 0 : a[0] > b[0] ? 1 : -1))
  .map(l => l[0][1] >=  l[1][0])
  .reduce((a,v)=>v?a+1:a);
```
