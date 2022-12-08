# Day 7

## Part 1

This one was tricky and took a couple of dog walks. 
90% was generally straightforward, but properly shaping the tree and counting the sizes took some debugging.  

My first pass wanted an actual tree instead of indexing by full path, but moving back up the tree would have required many more moving pieces afaict, so I opted for a tree based on directory paths. 
My initial model to use "pushd/popd/dirs" style directory tracking was super helpful. 
We could entirely ignore the red-herring `dir`/`ls` and focus on the directory changes and file lists.  

I was _really_ stuck on adding sizes until I realized that directires were not uniquely named among the tree (duh!), just within their own directory. 
A small modificaiton to how I recorded total sizes fixed my issues.  

`fs` will be our main object. 
It'll track our directory queue `fs.dirs`, the filesystem tree `tree`, and carry a few methods: 
- `fs.dirname()`: get the name of the current directory 
- `fs.pwd()`: get the full current path (space-separated)
- `fs.pushd()`: push a directory to our queue, adding it to the tree if necessary (since we're guaranteed to change into a directory before listing it)
- `fs.popd()`: move one level up in our directory queue 
- `fs.sizes()`: total up all the directory sizes, keyed on the full path 

`fs.tree` is also keyed on the full, space-separated path. 
To get the total in `fs.sizes()`, we loop over each path in our tree doing:
1. get the total size of the current path
2. get the list of all paths counted at the current path (ex: `/ a b` would be `['/', '/ a', '/ a b']`)
3. add the total size to each of the counted paths 

We'll take the input and split the lines as usual, ignoring `$ ls` and `dir` lines. 
Then, if the line starts with `$`, check if we're changing up (`..`) or down into a new directory.
If up, `fs.popd()` up one directory; otherwise, `fs.pushd()` down to the directory.
If the line doesn't start with `$`, it must be a file entry. 
Add that file to the path by merging the current list of files with the new line, parsing the size as an integer in the process. 

Once this process is complete, we have a completed tree to calculate sizes with. 
Get all the directory sizes, filter for those at most 100000, and sum their sizes. 

```js
selector = 'pre';
fs = {
  dirs: [],
  tree: {},
  dirname: function() {
    return this.dirs[this.dirs.length-1];
  },
  pwd: function() {
    return this.dirs.join(' ');
  },
  pushd: function(dir) { 
    this.dirs.push(dir);
    if (!this.tree[this.pwd()]) {
      this.tree[this.pwd()] = {};
    }
  },
  popd: function() { 
    this.dirs.pop(); 
  },
  sizes: function() {
    let sizes = {};
    Object.keys(this.tree)
      .forEach((k) => {
        const size = Object.values(this.tree[k]).reduce((a,v)=>a+v,0);
        k.split(' ').map((_,i,a) => a.slice(0,i+1)).forEach((k) => {
          if (sizes[k]) {
            sizes[k] += size;
            return;
          }
          sizes[k] = size;
        })
      });
    return sizes;
  }
};
document.querySelector(selector).innerText.split('\n')
  .filter((l) => l !== '' && !l.startsWith('$ ls') & !l.startsWith('dir'))
  .map((l) => l.split(' ')).forEach((l) => {
    if (l[0] === '$') {
      if (l[1] !== 'cd') return;
      if (l[2] === '..' && fs.dirname() === '/') return;
      if (l[2] === '..') {
        fs.popd();
        return
      }
      fs.pushd(l[2]);
      return;
    }
    fs.tree[fs.pwd()] = Object.fromEntries([...Object.entries(fs.tree[fs.pwd()]), [l[1], parseInt(l[0])]]);
  });
Object.entries(fs.sizes())
  .filter(([_, size]) => size <= 100000)
  .map(([_,size]) => size)
  .reduce((a,v)=>a+v,0);
```

Don't refresh the page!

## Part 2

Easy! 
We mostly have this solved since we can get unique direcory sizes already. 
Simply get the sizes, filter for sizes that are at least the space we need, sort by size, and return the directory name of the first (lowest sized) entry.

```js
fs.du = function() { return this.sizes()['/']; }
fs.spaceNeeded = function() { return (70000000 - 30000000 - this.du()) * -1 }
Object.entries(fs.sizes())
  .filter(([_, size]) => size >= fs.spaceNeeded())
  .sort((a, b) => a[1] === b[1] ? 0 : a[1] < b[1] ? -1 : 1)[0][1];
```