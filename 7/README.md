# Day 7

## Part 1

This one was tricky and took a couple of dog walks. 
90% was generally straightforward, but properly shaping the tree and counting the sizes took some debugging.  

My first pass wanted an actual tree instead of indexing by full path, but moving back up the tree would have required many more moving pieces afaict, so I opted for a tree based on directory paths. 
My initial model to use "pushd/popd/dirs" style directory tracking was super helpful. 
We could entirely ignore the red-herring `dir`/`ls` and focus on the directory changes and file lists.  

I was _really_ stuck on adding sizes until I realized that directires were not uniquely named among the tree (duh!), just within their own directory. 
A small modificaiton to how I recorded total sizes fixed my issues.  

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