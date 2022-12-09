# Day 8

Very useful array rotations from [this answer on StackOverflow](https://stackoverflow.com/a/58668351).  

ALWAYS REMEMBER `Array.prototype.sort()` SORTS ARRAYS IN PLACE.  

## Part 1

Muhaahahhahhahaahah. 😈

I forget all the technical matrix-math words, so forgive my "grid," and "flip," and "rotate" nonsense.

We define some functions:
- `max`: find the max of an array
- `absMax`: report if the given `x` is an absolute max[^1] of `a`
- `noRotate`: a noop rotation
- `flip`: to flip a 2d array horizontally
- `rotateRight`: to rotate a 2d array 90° clockwise
- `rotateLeft`: to rotate a 2d array 90° counter-clockwise

We grab our `input` as usual, and parse each line to a list of numbers.  

Now, the rest is a matter of perspective 🥁. 
We want to look at a row of trees from above, from each side, and from below.
Instead of changing our point of view each time (needing to iterate forward/backward/up/down the 2d array), we instead get 4 different grids, each rotated such that the "left" side is the side we're viewing from.
This lets us iterate forwards from each perspective.

We start with a matrix of `[grid, undo]` where `grid` is the rotated grid relative to the perspective we want to test, and `undo` is the function to call to rotate that grid back to its original orientation. 
For each of those grids, we check if each tree in the row is the `absMax` of the series of trees itself and before (the `r.slice(0, i+1)` bit). 
If it is the `absMax`, the tree is visible from that perspective.
We finish by calling `undo` to rotate back to the original orientation.

Once we have these boolean grids back in their original orientation, we overlay one on top of the other.
Since we don't want to quadruple-count a tree, we need just a single grid to report whether the tree is visible from any of the 4 perspectives.  

After the overlay grid is created, it's a matter of summing all of our `true` values.  

You should see how great I am at [rotating a cow](https://twitter.com/AynRandy/status/1356087211070869507) in my head after all of this. 

[^1]: a number is an *absolute max* iff it is the max of an array and no other array entries have the same value

```js
max = (a) => [...a].sort().reverse()[0];
absMax = (a, x) => x === max(a) && a.findIndex(v => v === x) === a.findLastIndex(v => v === x);
noRotate = (m) => m
flip = (m) => m.map((r) => [...r].reverse());
rotateRight = (m) => m[0].map((val, index) => m.map(row => row[index]).reverse());
rotateLeft = (m) => m[0].map((val, index) => m.map(row => row[row.length-1-index]));

input = document.querySelector('pre').innerText.trim().split('\n').map(l => l.split('').map(n => parseInt(n)));
input.fromLeft = function() { return this };
input.fromRight = function() { return flip(this); };
input.fromBottom = function() { return rotateRight(this); };
input.fromTop = function() { return rotateLeft(this); };

[
  [input.fromLeft(), noRotate],
  [input.fromRight(), flip],
  [input.fromTop(), rotateRight],
  [input.fromBottom(), rotateLeft]
].map(
  ([grid, undo]) => undo(grid.map(row => row.map((tree,i,r) => absMax(r.slice(0, i+1), tree))))
).reduce(
  (overlay, grid) => grid.map((row, r) => row.map((tree, i) => overlay[r][i] || tree))
).reduce(
  (total, row) => total + row.reduce((n, visible) => visible ? n + 1 : n, 0), 0
);
```

Don't refresh the page!

## Part 2

```js

```

