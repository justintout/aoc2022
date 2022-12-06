# Day 6

## Part 1

Man I know there's a fun regex solution to this...

Range the input, taking the next 4 characters and checking if they're unique by getting the length of a `Set` from the characters. Return the index plus four, since we want the index of the end of the marker.

```js
for (let i = 0; i < input.split('').length; i++) { 
    if (Array.from(new Set(input.slice(i, i+4))).length === 4) { 
        console.log(i+4, input.slice(i, i+4)); 
        break; 
    } 
}
```

## Part 2

Very easy given the design. Just bump 4 to 14.

I have a feeling this is going to rapidly devolve into a parser...

```js
for (let i = 0; i < input.split('').length; i++) { 
    if (Array.from(new Set(input.slice(i, i+14))).length === 14) { 
        console.log(i+14, input.slice(i, i+14)); 
        break; 
    }
}
```
