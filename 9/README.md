# Day 9

## Part 1

First try! 

`change` gives us the `[x,y]` change dictated by direction. 
`move` uses `change` to create a series of steps from each input line.

We add some fields and methods to our `input`:
- `hloc` and `tloc` track the current location of the head and tail respectively
- `trel` is the relative `[x,y]` distance tail is from the head
- `tvis` is a Set of the locations the tail has visited, as strings so we can take advantage of Set's uniqueness. 
- `hmov()` moves the head based on a given step 
- `tcha()` chases the tail behind the head, adding the location after the tail moves to the Set and updating its relative position
- `step()` moves the head and possibly tail forward one step 

`chaMov` is a map of all of the chase moves necessary for the tail to catch up to the head, based on where the tail is relative to the head.

We get the set of `move`s from each input line then step through them all. 
Our `input.tvis` Set at the end of the process holds all of the unique positions our tail has visited. 

```js
change = (dir) => dir === 'L' ? [-1,0] : dir === 'U' ? [0, 1] : dir === 'R' ? [1, 0] : [0, -1];
move = (dir, dis) => (new Array(dis)).fill(change(dir));
chaMov = {
  '-2-2': [-1,-1],
  '-2-1': [-1, -1],
  '-20': [-1, 0],
  '-21': [-1, 1],
  '-22': [-1,1],
  '-1-2': [-1, -1],
  '-12': [-1, 1],
  '0-2': [0, -1],
  '02': [0, 1],
  '1-2': [1, -1],
  '12': [1, 1],
  '2-2': [1,-1],
  '2-1': [1, -1],
  '20': [1, 0],
  '21': [1, 1],
  '22': [1,1],
};

input = document.querySelector('pre').innerText.trim().split('\n')
input.hloc = [0,0];
input.tloc = [0,0];
input.trel = [0,0];
input.tvis = new Set();
input.hmov = function(mov) {
  this.hloc[0] += mov[0]; this.hloc[1] += mov[1];
  this.trel[0] += mov[0]; this.trel[1] += mov[1];
}
input.tcha = function() {
  const mov = chaMov[this.trel.join('')] ?? [0,0];
  this.tloc[0] += mov[0]; this.tloc[1] += mov[1];
  this.trel[0] -= mov[0]; this.trel[1] -= mov[1];
  this.tvis.add(this.tloc.join(''));
}
input.step = function(mov) { this.hmov(mov); this.tcha(); }

input.map(l => 
  l.split(' ').map((v,i) => i === 0 ? v : parseInt(v))).map(m =>
    move(...m))
  .flat()
  .forEach(m => input.step(m));
input.tvis.size;
```

## Part 2

Now, we generalize movement. 

When knot `k` moves, it reduces the relative distance to `k-1` and increases the relative distance to `k+1`.
On each step of input, we move the head `k=0`. 
Recursion is started by chasing the head - it creates a series of moves for `k=1...9` to move to keep up.
The head knot has no relative distance, since it is the leader.
We don't chase the last knot, since there is nothing behind it (thus bounding our recursion). 

Given knot `k`: 
- `input.kloc[k]` is the location of `k`
- `input.krel[k]` is the relative `[x,y]` distance of knot `k+1` from `k`
- `input.cha(k)` chases `k`, by moving `k+1` if a valid `chaMove` is found


Something I got crazy stuck on here was JS's pass-by-reference arrays. 
Using `Array.fill()`, even with a shallow `[...[0,0]]` copy, still filled the array with identical references.
Swapping to that `.fill(0).map(() => [0,0])` call instead gives us unique references.

Also realized I missed a few relative moves at first and got lucky in the first problem! 
I've gone back and fixed `chaMov` in part 1. 

```js
change = (dir) => dir === 'L' ? [-1,0] : dir === 'U' ? [0, 1] : dir === 'R' ? [1, 0] : [0, -1];
move = (dir, dis) => (new Array(dis)).fill(change(dir));
chaMov = {
  '-2-2': [-1,-1],
  '-2-1': [-1, -1],
  '-20': [-1, 0],
  '-21': [-1, 1],
  '-22': [-1,1],
  '-1-2': [-1, -1],
  '-12': [-1, 1],
  '0-2': [0, -1],
  '02': [0, 1],
  '1-2': [1, -1],
  '12': [1, 1],
  '2-2': [1,-1],
  '2-1': [1, -1],
  '20': [1, 0],
  '21': [1, 1],
  '22': [1,1],
};

input = document.querySelector('pre').innerText.trim().split('\n')
input.s = 0;
input.kloc = (new Array(10)).fill(0).map(() => [0,0]);
input.krel = (new Array(9)).fill(0).map(() => [0,0]);
input.tvis = new Set();
input.tvis.add([0,0]);
input.hmov = function(mov) {
  this.mov(mov, 0);
}
input.mov = function(mov, k) {
  this.kloc[k][0] += mov[0]; this.kloc[k][1] += mov[1];
  // console.log(`\tknot ${k} mov ${mov} to ${this.kloc[k]}`);
  if (k !== 0) {
    // our move takes us closer to the knot ahead, if it isn't the first knot
    this.krel[k-1][0] -= mov[0]; this.krel[k-1][1] -= mov[1];
  }
  if (k < this.kloc.length - 1) {
    // our move takes us further away from the knot behind, if it isn't the last knot
    this.krel[k][0] += mov[0]; this.krel[k][1] += mov[1];
  } 
  if (k === this.kloc.length - 1) {
    // console.log(`\ttail add location ${this.kloc[k]}`);
    this.tvis.add(this.kloc[this.kloc.length-1].join(''));
    return;
  }
  // console.log(`\tchase ${k}`);
  this.cha(k);
}
input.cha = function(k) {
  const mov = chaMov[this.krel[k].join('')];
  if (mov) {
    // console.log(`\t\tknot ${k+1} chase ${mov} close ${this.krel[k]}`);
    this.mov(mov, k+1);
  }
}
input.step = function(mov) { 
  // console.log(`step ${this.s}: `); 
  // console.log(`\t${this.kloc.join(' ')}`); 
  // console.log(`\t${this.krel.join(' ')}`); 
  this.hmov(mov); this.s++
}

input.map(l => 
  l.split(' ').map((v,i) => i === 0 ? v : parseInt(v))).map(m =>
    move(...m))
  .flat()
  // .slice(0,25)
  .forEach(m => input.step(m));
input.tvis.size;
```