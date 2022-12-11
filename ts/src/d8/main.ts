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

  const { left, right } = arr[rowIndex].reduce(
    (acc, cur, index) => {
      if (index < colIndex) {
        return { ...acc, left: acc.left && cur.height < height };
      } else if (index > colIndex) {
        return { ...acc, right: acc.right && cur.height < height };
      } else {
        return acc;
      }
    },
    { left: true, right: true },
  );

  const { top, bottom } = arr.reduce(
    (acc, cur, index) => {
      if (index < rowIndex) {
        return { ...acc, top: acc.top && cur[colIndex].height < height };
      } else if (index > rowIndex) {
        return { ...acc, bottom: acc.bottom && cur[colIndex].height < height };
      } else {
        return acc;
      }
    },
    { top: true, bottom: true },
  );

  return [left, right, top, bottom].includes(true);
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
    }, [] as Tree[][])
    .flat()
    .filter((tree) => tree.visible).length;
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
// 1681
console.log(p1(input));

// part 2
// ??
console.log(p2(input));
