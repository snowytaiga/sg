# tsl
Taiga's simple language is an interpreted language

## Example
```
print_one_to_three

```
tag PrintOneToThree
  var x 0
  
  tag Loop
    add x, 1 -> x
  etag
 
  neq x, 3 then goto Loop
  
  return x
etag
```
