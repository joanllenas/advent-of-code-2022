import { readFileSync } from 'fs';

interface Tree {
  height: number;
  visible: boolean;
}

const isVisible = (
  arr: Tree[][],
  colIndex: number,
  rowIndex: number,
): boolean => {
  if (
    colIndex === 0 ||
    rowIndex === 0 ||
    colIndex === arr[0].length - 1 ||
    rowIndex === arr.length - 1
  ) {
    return true;
  }
  const { height } = arr[rowIndex][colIndex];
  const top = arr[rowIndex - 1][colIndex];
  const bottom = arr[rowIndex + 1][colIndex];
  const left = arr[rowIndex][colIndex - 1];
  const right = arr[rowIndex][colIndex + 1];
  return [top, bottom, left, right].some((tree) => tree.height < height);
};

// part 1
function p1(input: string) {
  return input
    .split('\n')
    .map((line) =>
      line
        .split('')
        .map(
          (height) => ({ height: parseInt(height), visible: false } as Tree),
        ),
    )
    .reduce((acc, cur, rowIndex, arr) => {
      return [
        ...acc,
        cur.map((tree, colIndex) => ({
          ...tree,
          visible: isVisible(arr, colIndex, rowIndex),
        })),
      ];
    }, [] as Tree[][]);
  // .flat()
  // .filter((tree) => tree.visible).length;
}

// part 2
function p2(input: string) {
  return '--';
}

// run
const input: string = readFileSync(__dirname + '/test.txt', {
  encoding: 'utf-8',
});

// part 1
// ??
console.log(p1(input));

// part 2
// ??
console.log(p2(input));
