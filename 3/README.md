# day 3

REPL is kinda fun 

## Part 1

```js
scores = Object.fromEntries(['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l' ,'m', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'].map((v,i) => [v, i+1]))
document.querySelector('pre').innerText.split('\n').filter(l => l.trim() !== '')
    .map((l) => [l.substring(0, l.length / 2), l.substring(l.length / 2)])
    .map((r) => r[0].split('').filter((i) => r[1].split('').indexOf(i) > -1)[0])
    .map(r => scores[r])
    .reduce((a,v) => a + v)
```

Don't reload!

## Part 2

```js
document.querySelector('pre').innerText.split('\n').filter(l => l.trim() !== '')
    .reduce((a,v, i) => (i % 3 ? a[a.length - 1].push(v) : a.push([v])) && a, [])
    .map(r => r[0].split('')
        .filter(i => r[1].split('').indexOf(i) > -1)
        .filter(i => r[2].split('').indexOf(i) > -1)[0])
    .map(i => scores[i])
    .reduce((a,v) => a+v)
```
