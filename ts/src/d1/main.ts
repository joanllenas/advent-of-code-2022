import { readFileSync } from 'fs';

function d1p1(input: string) {
  return input
    .split('\n')
    .reduce((acc, cur) => {
      return cur === ''
        ? [...acc, 0]
        : acc.length > 0
        ? [
            ...acc.slice(0, acc.length - 1),
            acc[acc.length - 1] + parseInt(cur, 10),
          ]
        : [parseInt(cur, 10)];
    }, [] as number[])
    .sort((a, b) => a - b)
    .reverse()[0];
}

// Day 1, part 1
// 67658
console.log(d1p1(readFileSync('src/d1/input.txt', { encoding: 'utf-8' })));
