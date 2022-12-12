# Day 11

## Part 1

A `monkey` is parsed from a block of `note`s, separated by an empty line. The monkey's operation, test, and result actions are parsed and bound as new methods that act on the monkey's `items`. An item is `throw`n by having the receiving monkey `catch` an item, then splicing in `null` for the empty object, so that our `turn` iteration isn't interrupted by the underlying array changing size. At the end of a `turn` the array is filtered for nulls. 

A little debugging went into this, so each `round` can be given a `verbosity`: `0` for no printing, `1` for the round summary style printing found in the example, and `>1` for the in-depth turn-by-turn printing found in the example. 

```js
input = document.querySelector('pre').innerText.trim();

monkeyRe = /Monkey (\d+):\n.*Starting items: (.*)\n.*Operation: (.*)\n.*Test: (.*)\n.*If true: (.*)\n.*If false: (.*)/;
monkeyKeys = ['monkey', 'starting', '_operation', '_test', '_ifTrue', '_ifFalse'];
monkeyMap = (notes) => notes
  .match(monkeyRe)
  .slice(1)
  .map((v,i) => [monkeyKeys[i],v]);
monkiesMake = (input) => input.split('\n\n').map(m => new monkey(m));

parseOperation = (operation) => {
  return Function('item', operation.replace(/new/g, 'this.items[item].worry').replace(/old/g, 'this.items[item].worry'))
};
parseTest = (test) => Function('item', test.replace('divisible by', 'return this.items[item].worry % ') + '===0');
parseResult = (result) => Function('item', result.replace('throw to monkey ', 'this.throw(item, ') + ')');
class monkey {
  constructor(notes) {
    Object.assign(this, Object.fromEntries(monkeyMap(notes)));
    this.items = this.starting.split(',').map(v => ({worry: parseInt(v), toString: function() { return this.worry.toString()}}));
    this.operation = parseOperation(this._operation).bind(this);
    this.test = parseTest(this._test).bind(this);
    this.ifTrue = parseResult(this._ifTrue).bind(this);
    this.ifFalse = parseResult(this._ifFalse).bind(this);
    this.inspected = 0;
  }
  throw(item, to) {
    if (this.verbose) console.log(`    Item with worry level ${this.items[item]} is thrown to monkey ${to}`);
    const t = parseInt(to);
    monkies[t].catch(this.items[item]);
    this.items.splice(item,1,null);
  }
  catch(incoming) {
    this.items.push(incoming);
  }
  inspect(item) {
    if (this.verbose) console.log(`  Monkey inspects an item with a worry level of ${this.items[item]}`);
    this.operation(item);
    this.inspected += 1;
  }
  bore(item) {
    const w = Math.floor(this.items[item].worry / 3);
    if (this.verbose) console.log(`    Monkey gets bored with item. Worry level is divided by 3 to ${w}`);
    this.items[item].worry = w;
  }
  turn(verbose) {
    this.verbose = verbose
    if (this.verbose) console.log(`Monkey ${this.monkey}:`);
    this.items.forEach((_,i) => {
      this.inspect(i);
      this.bore(i);
      if (this.test(i)) {
        if (this.verbose) console.log(`    Current worry level is ${this._test}`);
        this.ifTrue(i);
      } else {
        if (this.verbose) console.log(`    Current worry level is not ${this._test}`);
        this.ifFalse(i);
      }
    });
    this.items = this.items.filter(v => v !== null); 
    this.verbose = false;
  }
}

monkies = monkiesMake(input)
monkies.rounds = 0;
monkies.round = function(verbosity) { 
  this.forEach(m => m.turn(verbosity > 1)); 
  this.rounds++;
  if (verbosity > 0) console.log(this.map(m => `Monkey ${m.monkey}: ${m.items.join(', ')}`).join('\n'));
};
while (monkies.rounds < 20) {
  monkies.round();
}
monkies.map(m => m.inspected).sort((a,b)=>a === b ? 0 : a < b ? 1 : -1).slice(0,2).reduce((a,v) => a * v, 1);
```

## Part 2

After some serious squinting, I realized this is a [congruence problem](https://artofproblemsolving.com/wiki/index.php/Modular_arithmetic/Introduction). All of the monkeys' test operations are modulo math, so we can track the residue of each monkeys' modulo instead of tracking the exact value. 

To do this, we create a new `item` class and get the number of monkies `nm` and the unique `modulos` for the monkies, since monkey number is in order 0-7. 

We have the item inspect itself now, with the monkey just passing its static `operation` as a transformation function. The item computes `r & modulos[i]` for each of the modulos it is tracking. 

```js
input = document.querySelector('pre').innerText.trim();
const modulos = [...input.matchAll(/divisible by (\d+)/g)].map(([_,m]) => parseInt(m));
const nm = input.split('\n\n').length;

class item {
  constructor(worry) {
    this.init = worry;
    this.residues = (new Array(nm)).fill(worry);
  }
  inspect(op) {
    this.residues = this.residues.map((r,i) => op(r % modulos[i]));
  }
}


monkeyRe = /Monkey (\d+):\n.*Starting items: (.*)\n.*Operation: (.*)\n.*Test: (.*)\n.*If true: (.*)\n.*If false: (.*)/;
monkeyKeys = ['monkey', 'starting', '_operation', '_test', '_ifTrue', '_ifFalse'];
monkeyMap = (notes) => notes
  .match(monkeyRe)
  .slice(1)
  .map((v,i) => [monkeyKeys[i],v]);
monkiesMake = (input) => input.split('\n\n').map(m => new monkey(m));


parseOperation = (operation, modulo) => Function('old', operation.replace('new =', 'return'));
parseTest = (test) => Function('item', test.replace('divisible by', 'return this.items[item].residues[this.monkey] % ') + '===0');
parseResult = (result) => Function('item', result.replace('throw to monkey ', 'this.throw(item, ') + ')');

class monkey {
  constructor(notes) {
    Object.assign(this, Object.fromEntries(monkeyMap(notes)));
    this.items = this.starting.split(',').map(v => new item(parseInt(v)));
    this.operation = parseOperation(this._operation, this.modulo);
    this.test = parseTest(this._test).bind(this);
    this.ifTrue = parseResult(this._ifTrue).bind(this);
    this.ifFalse = parseResult(this._ifFalse).bind(this);
    this.inspected = 0;
  }
  throw(item, to) {
    if (this.verbose) console.log(`    Item with worry level ${this.items[item]} is thrown to monkey ${to}`);
    const t = parseInt(to);
    monkies[t].catch(this.items[item]);
    this.items.splice(item,1,null);
  }
  catch(incoming) {
    this.items.push(incoming);
  }
  inspect(item) {
    if (this.verbose) console.log(`  Monkey inspects an item with a worry level of ${this.items[item]}`);
    this.items[item].inspect(this.operation);
    this.inspected += 1;
  }
  bore(item) {
    const w = Math.floor(this.items[item].worry / 3);
    if (this.verbose) console.log(`    Monkey gets bored with item. Worry level is divided by 3 to ${w}`);
    this.items[item].worry = w;
  }
  turn(verbose) {
    this.verbose = verbose
    if (this.verbose) console.log(`Monkey ${this.monkey}:`);
    this.items.forEach((_,i) => {
      this.inspect(i);
      // this.bore(i);
      if (this.test(i)) {
        if (this.verbose) console.log(`    Current worry level is ${this._test}`);
        this.ifTrue(i);
      } else {
        if (this.verbose) console.log(`    Current worry level is not ${this._test}`);
        this.ifFalse(i);
      }
    });
    this.items = this.items.filter(v => v !== null); 
    this.verbose = false;
  }
}

monkies = monkiesMake(input)
monkies.rounds = 0;
monkies.round = function(verbosity) {
  console.log(`Round ${this.rounds + 1}:`);
  this.forEach(m => m.turn(verbosity > 1)); 
  this.rounds++;
  if (verbosity > 0) console.log(this.map(m => `Monkey ${m.monkey}: ${m.items.join(', ')}`).join('\n'));
};
while (monkies.rounds < 10000) {
  monkies.round();
}
monkies.map(m => m.inspected).sort((a,b)=>a === b ? 0 : a < b ? 1 : -1).slice(0,2).reduce((a,v) => a * v, 1);
```