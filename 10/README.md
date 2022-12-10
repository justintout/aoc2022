# Day 10

Useful way to chunk a JS array from [this SO answer](https://stackoverflow.com/a/50766024).

## Part 1

Pretty quick.  

Grab our inputs, split the 2-cycle commands out into 2 parts, the `addx` and the int. 
Then, just tick through each line.  
The only thing to consider here is the 3rd line of the solution chain; if the slice we're considering ends with a number, the end needs to be dropped, since the register is added _after_ the cycle completes. 

```js
input = document.querySelector('pre').innerText.trim().split('\n')
  .map(l => l.split(' ').map((v,i) => i > 0 ? parseInt(v) : v))
  .map(i => i[0] === 'addx' ? [i[0], i[1]]: i)
  .flat();

[20, 60, 100, 140, 180, 220]
  .map(x => [x, (s = input.slice(0,x)), s.at(-1)])
  .map(([x,s,l]) => Number.isInteger(l) ? [x,s.slice(0, s.length-1)] : [x,s])
  .map(([x,s]) => s.filter(v => Number.isInteger(v)).reduce((a,v) => a+v, 1) * x)
  .reduce((a,v) => a+v, 0);
```

## Part 2

THIS WAS SO COOL.

Might be clearer to split the screen into lines at the beginning, but I felt it would be easier to keep track of the pixel if the screen was held as a single line.  

`screen` tracks the position of the pixel `px`, the line being drawn `li`, and the horizontal position of the sprite on the line `sp`. It has methods to:
- `print()` the screen (optionally rendering the position of the sprite, for debugging)
- `draw()` the current pixel
- `cycle()` once, drawing the pixel, moving the sprite if in the 2nd cycle of an `addx` command, incrementing the pixel, and incrementing the line if the pixel is at a boundary
- `run()` through a given input

Then, it's just a matter of `run`ning our `input` and printing the screen to console. 
Solution left up to the reader (get it?). 

```js
screen = (new Array(40 * 6)).fill(0).map(_ => '.');
screen.sp = 1;
screen.li = 0;
screen.px = 0;
screen.print = function(sprite) {
  const clone = [...this];
  if (sprite) [-1,0,1].map(v => this.sp + v).forEach(i => clone[i] = this[i] === '#' ? '+' : '-');
  console.log(clone.reduce((a,_,i) => 
    (i % 40) 
      ? a 
      : [...a, clone.slice(i, i + 40)],[]).map(l => 
        l.join(' ')).join('\n')) };
screen.draw = function() {
  const s = this.sp + (this.li * 40);
  this[this.px] = (s-1 === this.px || s === this.px || s+1 === this.px) 
    ? '#'
    : '.';
}
screen.cycle = function(x) {
  this.draw();
  if (Number.isInteger(x)) {
    this.sp += x;
  }
  this.px += 1;
  this.li = (this.px !== 0 && this.px % 40 === 0) ? this.li + 1 : this.li;
}
screen.run = function(input) {
  input.forEach(i => this.cycle(i));
}
screen.run(input);
screen.print();
```