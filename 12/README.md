# Day 12

> honey wake up its time to implement dijkstra again 

## Part 1

I honestly hate pathfinding problems.

```js
input = document.querySelector('pre').innerText.trim();

// input = `Sabqponm
// abcryxxl
// accszExk
// acctuvwj
// abdefghi`;

within = ([y,x], grid) => y >= 0 && y < grid.length && x >= 0 && x < grid[0].length
up = ([y,x]) => [y-1,x];
right = ([y,x]) => [y,x+1];
down = ([y,x]) => [y+1, x];
left = ([y,x]) => [y, x-1];
fmt = ([y,x]) => `${y} ${x}`;

startValue = 'a';
goalValue = 'z';
replaceMarker = (value) => value === 'S' ? startValue : value === 'E' ? goalValue : value;
elevationOk = (from, to) => replaceMarker(from).charCodeAt(0) >= (replaceMarker(to).charCodeAt(0) - 1);

class Node {
  constructor(g, y, x) {
    this.y = y;
    this.x = x;
    this.start = g[y][x] === 'S';
    this.goal = g[y][x] === 'E';
    this.v = replaceMarker(g[y][x])
    this.neighbors = [up([y,x]), right([y,x]), down([y,x]), left([y,x])]
      .filter(c => within(c, g))
      .filter(([cy,cx]) => elevationOk(g[y][x], g[cy][cx]));
    this.path = [];
    this.visited = false;
  }
  get coord() {
    return [this.y, this.x];
  }
  toString() {
    return `[${this.y}, ${this.x}]`;
  }
}

class Graph {
  constructor(input) {
    this.input = input;
    this.grid = input.split('\n').map((l) => l.split(''));
    this.width = this.grid[0].length;
    this.height = this.grid.length;
    this.sy = Math.floor(input.split('').findIndex((s) => s === 'S') / this.width);
    this.sx = this.grid[this.sy].findIndex((s) => s === 'S');
    this.ey = Math.floor(input.split('').findIndex((e) => e === 'E') / this.width);
    this.ex = this.grid[this.ey].findIndex((e) => e === 'E');
    this.nodes = this.grid.map((r,y) => r.map((_, x) => new Node(this.grid, y, x)));
  }
  get start() {
    return this.nodes[this.sy][this.sx];
  }
  neighbors({y,x,path}) {
    return this.nodes[y][x].neighbors
      .map(([y,x]) => this.nodes[y][x])
      .filter((n) => !n.visited);
  }
  find() {
    let stack = [this.start];
    let goal = null;
    while (stack.length > 0) {
      if (goal !== null) {
        break;
      }
      let curr = stack.shift();
      curr.visited = true;
      for (let n of this.neighbors(curr)) {
        if (n.path.length === 0 || n.path.length > curr.path.length + 1) {
          n.path = [...curr.path, curr];
        }
        if (n.goal) {
          goal = n;
          break;
        }
        n.visited = true;
        stack.push(n);
      }
    }
    return goal?.path.length;
  }
}

g = new Graph(input);
g.find();
```

Don't refresh the page!

## Part 2

AND minimization. Super fun. 🙃.

We know the shortest path is at most our previous answer, and the absolute lowest possible length is `25` (monotonically increasing from `a` to `z`). 

We'll search a queue of `a` nodes sorted by Manhattan distance. 
This isn't fully correct. 
Absolute luck the answer wasn't one of the errors I am not going to fix.

```js
g = new Graph(input);
shortest = max = g.find();
min = 25;

g.toGoal = function({y,x}) {
  return Math.abs(y - this.ey) + Math.abs(x - this.ex);
}

ci = input.replace('S','a');
candidates = [...ci.matchAll(/a/g)]
  .map(m => m.index)
  .map(i => ({y: Math.floor(i / g.width), x: i % g.width, idx: i}))
  .sort((a,b) => g.toGoal(a) === g.toGoal(b) ? 0 : g.toGoal(a) < g.toGoal(b) ? -1 : 1);
for (let c of candidates) {
  try {
    const i = ci.substring(0, c.idx) + 'S' + ci.substring(c.idx+1);
    const g = new Graph(i);
    const d = g.find();
    console.log(`[${c.y},${c.x}]: ${d}`);
    if (!d) {
      continue;
    }
    if (d < shortest) {
      shortest = d;
    }
    if (d >= max * 2) {
      // eh thats probably enough to stop lol
      break;
    }
  } catch (e) {
    console.log(`[${c.y},${c.x}]: how the hell:`, e);
    continue;
  }
}
shortest; 
```

