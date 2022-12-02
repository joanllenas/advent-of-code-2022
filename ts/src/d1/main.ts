import { readFileSync } from 'fs';

const add = (n1: number, n2: number) => n1 + n2;

function d1p1() {
  const input = readFileSync('src/d1/input.txt', { encoding: 'utf-8' });
  const lines = input.split('\n');
  const groups = lines.reduce(
    (acc, cur) => {
      return cur === ''
        ? [...acc, []]
        : [
            ...acc.slice(0, acc.length - 1),
            [...acc[acc.length - 1], parseInt(cur, 10)],
          ];
    },
    [[]] as number[][],
  );

  const getIndex = (arr: number[]) => arr[0];
  const getCalories = (arr: number[]) => arr[1];

  const result = groups.reduce(
    (prev, cur, index) => {
      const curCalories = cur.reduce(add);
      return getIndex(prev) > -1
        ? curCalories > getCalories(prev)
          ? [index, curCalories]
          : prev
        : [index, cur.reduce(add)];
    },
    [-1, 0],
  );

  console.log(
    `Elf index ${getIndex(result)} has the most calories with ${getCalories(
      result,
    )} cal`,
  );
}

d1p1();
