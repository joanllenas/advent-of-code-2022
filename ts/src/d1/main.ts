import { readFileSync } from 'fs';

function totalCaloriesPerElfDesc(input: string): number[] {
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
    .reverse();
}

function d1p1(input: string) {
  return totalCaloriesPerElfDesc(input)[0];
}

function d1p2(input: string) {
  return totalCaloriesPerElfDesc(input)
    .slice(0, 3)
    .reduce((n1, n2) => n1 + n2);
}

const input: string = readFileSync(__dirname + '/input.txt', {
  encoding: 'utf-8',
});

// part 1
// 67658
console.log(d1p1(input));

// part 2
// 200158
console.log(d1p2(input));
