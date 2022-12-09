import { readFileSync } from 'fs';

// part 1
function p1(input: string) {
  const index = input.split('').reduce((acc, _, index, arr) => {
    if (acc > -1) {
      return acc;
    } else if (new Set(arr.slice(index, index + 4)).size === 4) {
      return index;
    } else {
      return -1;
    }
  }, -1);
  return index + 4;
}

// part 2
function p2(input: string) {
  return '--';
}

// run
const input: string = readFileSync(__dirname + '/input.txt', {
  encoding: 'utf-8',
});

// part 1
// 1155
console.log(p1(input));

// part 2
// ??
console.log(p2(input));
