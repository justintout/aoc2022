## Day 14

## Part 1

Note very optimal recursive drop. Give it a second...

```js
min = (a) => a.sort((a,b) => a === b ? 0 : a < b ? -1 : 1)[0];
spread = (start, end) => { 
  return Array(Math.abs(start-end) + 1)
    .fill(start-end>0?-1:1)
    .map((x,i) => start + (x * i));
};
path = ([x1,y1],[x2,y2]) => x1 - x2 === 0 
  ? spread(y1,y2).map((y) => [x1, y]) 
  : spread(x1,x2).map((x) => [x, y1]);
pair = (a) => a.map((v,i,a) => a[i+1]?[v,a[i+1]]:undefined).filter(v => v);
isWall = (walls, c) => walls.some((wc) => wc[0] === c[0] && wc[1] === c[1]);
firstWallBelow = (walls, cs) => {
  const y = min(walls
    .filter((c) => c[0] === cs[0] && c[1] >= cs[1] )
    .map((c) => c[1]));
  return y ? [cs[0], y] : null;
};
fall = (walls, cs) => {
  let w = firstWallBelow(walls, cs);
  if (w === null) {
    return null;
  }
  const left = [w[0]-1,w[1]];
  const right = [w[0]+1,w[1]];
  if (isWall(walls,left) && isWall(walls, right)) {
    return [w[0], w[1]-1];
  }
  if (!isWall(walls, left)) {
    return fall(walls, left);
  }
  if (!isWall(walls, right)) {
    return fall(walls, right)
  }
}
drop = (walls) => {
  let cs = fall(walls, [500,0]);
  if (cs) {
    walls.push(cs);
    return true;
  }
  return false;
}
fill = (walls) => {
  let units = 0;
  while(drop(walls)) {
    units++;
  }
  return units;
}

input = document.querySelector('pre').innerText.trim();
walls = input.split('\n')
  .flatMap(l => pair(l.split('->')
    .map(s => s.trim()
      .split(',')
      .map(x => parseInt(x))))
    .flatMap(p => path(...p)));
fill(walls);
```

Don't refresh the page!

## Part 2 - NOT SOLVED


```js
floorLevel = (walls) => max(walls.map((c) => c[1])) + 2;
fall = (walls, sand, cs) => {
  let w = firstWallBelow([...walls, ...sand], cs);
  if (w === null) {
    const y = floorLevel(walls);
    sand.push(...path([cs[0]-3, y], [cs[0]+3, y]));
    return [cs[0], y-1];
  }
  const left = [w[0]-1,w[1]];
  const right = [w[0]+1,w[1]];
  if (isWall([...walls,...sand],left) && isWall([...walls,...sand], right)) {
    if (w[0] === 500 && w[1] === 1) {
      return null;
    }
    return [w[0], w[1]-1];
  }
  if (!isWall([...walls,...sand], left)) {
    return fall(walls, sand, left);
  }
  if (!isWall([...walls,...sand], right)) {
    return fall(walls, sand, right)
  }
}
drop = (walls, sand) => {
  let cs = fall(walls, sand, [500,0]);
  if (cs) {
    if (cs[0] === 500 && cs[1] === 0) {
      return false;
    }
    sand.push(cs);
    return true;
  }
  return false;
}
fill = (walls, sand) => {
  let units = 0;
  while(drop(walls, sand)) {
    units++;
    if (units % 100) { 
      console.log(`(100 units)`);
    }
    if (units > 8000) {
      throw new Error("idk we might be in infinity");
    }
  }
  return units;
}

walls = input.split('\n')
  .flatMap(l => pair(l.split('->')
    .map(s => s.trim()
      .split(',')
      .map(x => parseInt(x))))
    .flatMap(p => path(...p)));
max = (a) => a.sort((a,b) => a === b ? 0 : a < b ? -1 : 1)[a.length-1];
floory = floorLevel(walls)
xmin = min(walls.map((c) => c[0]));
xmax = max(walls.map((c) => c[0]));
floor = path([xmin+1,floory],[xmax+1,floory]);
fill(walls, floor);
```