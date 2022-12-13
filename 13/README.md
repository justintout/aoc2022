# Day 13

## Part 1

```js
input = document.querySelector('pre').innerText.trim();
// input = `[1,1,3,1,1]
// [1,1,5,1,1]

// [[1],[2,3,4]]
// [[1],4]

// [9]
// [[8,7,6]]

// [[4,4],4,4]
// [[4,4],4,4,4]

// [7,7,7,7]
// [7,7,7]

// []
// [3]

// [[[]]]
// [[]]

// [1,[2,[3,[4,[5,6,7]]]],8,9]
// [1,[2,[3,[4,[5,6,0]]]],8,9]`;

max = (...n) => n.sort((a,b)=>a===b?0:a<b?1:-1)[0];
test = (left, right, indent = '') => {
  if(Number.isInteger(left) && Number.isInteger(right)) {
    if (left < right) {
      return true;
    }
    if (left > right) {
      return false;
    }
    return null;
  }
  if(!Number.isInteger(left) && !Number.isInteger(right)) {
    for (let i = 0; i < max(left.length, right.length); i++) {
      if (left.length <= i) {
        return true;
      }
      if (right.length <= i) {
        return false;
      }
      const t = test(left[i], right[i], indent + '  ')
      if (t !== null) {
        return t;
      }
    }
    return null;
  }
  if(Number.isInteger(left)) {
    const t = test([left] , right, indent + '  ');
    if (t !== null) {
      return t;
    }
  }
  if(Number.isInteger(right)) {
    const t = test(left, [right], indent + '  ');
    if (t !== null) {
      return t;
    }
  }
  return null;
}
input.split('\n\n')
  .map((pair, i) => test(...pair.split('\n').map(packet => JSON.parse(packet))) ? i + 1 : 0)
  .reduce((a,v) => a+v, 0);
```
