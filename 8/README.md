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

## Part 2

😈 EVIL GANG 😈

`left`, `right`, `up`, and `down` all do similar things. 
Take the whole `grid`, a `row` and `col` index, and grab an array of the trees from the tree at `[row, col]` to the edge in that direction. 
This array is ordered from the perspective of the tree. 
For each of those, find the first index that is at least the same height of the tree. 
If none is found, the tree can see all the way to the edge. 

`max` and `score` are obvious. 

To find our answer, iterate each row of the grid, find the score for each tree, then return the highest score. 

```js
grid = document.querySelector('pre').innerText.trim().split('\n').map(r => 
  r.split('').map(t => parseInt(t)));
left = (grid, row, col) => 
  (s = (g = grid[row].slice(0, col).reverse()).findIndex(v => v >= grid[row][col])) === -1 
    ? g.length 
    : s + 1;
right = (grid, row, col) => 
  (s = (g = grid[row].slice(col+1)).findIndex(v => v >= grid[row][col])) === -1 
    ? g.length 
    : s + 1;
up = (grid, row, col) => 
  (s = (g = grid.slice(0,row).map(r => r[col]).reverse()).findIndex(v => v >= grid[row][col])) === -1 
    ? g.length 
    : s + 1;
down = (grid, row, col) => 
  (s = (g = grid.slice(row+1).map(r => r[col])).findIndex(v => v>=grid[row][col])) === -1 
    ? g.length 
    : s + 1;
score = (left, up, right, down) => 
  left * up * right * down;
max = (a) => 
  a.sort((a,b)=>a===b?0:a<b?-1:1).reverse()[0];
max(grid.map((trees, row) => 
  trees.map((height, col) => 
    score(...[left, right, up, down].map(f => 
      f(grid, row, col))))).flat());
```

