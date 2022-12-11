import { readFileSync } from 'fs';

// --------------------
//
// part 1
//
// --------------------

interface TreeVisibility {
  height: number;
  visible: boolean;
}

const isVisible = (
  arr: TreeVisibility[][],
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

function p1(input: string) {
  return input
    .split('\n')
    .map((line) =>
      line
        .split('')
        .map(
          (height) =>
            ({ height: parseInt(height), visible: false } as TreeVisibility),
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
    }, [] as TreeVisibility[][])
    .flat()
    .filter((tree) => tree.visible).length;
}

// --------------------
//
// part 2
//
// --------------------

interface TreeScore {
  height: number;
  score: number;
}

const treeScore = (
  arr: TreeScore[][],
  colIndex: number,
  rowIndex: number,
): number => {
  if (
    colIndex === 0 ||
    rowIndex === 0 ||
    colIndex === arr[0].length - 1 ||
    rowIndex === arr.length - 1
  ) {
    return 0;
  }

  const { height } = arr[rowIndex][colIndex];

  const left = arr[rowIndex].reduce((acc, cur, index) => {
    if (index < colIndex) {
      acc = cur.height >= height ? 1 : acc + 1;
    }
    return acc;
  }, 0);

  const right = arr[rowIndex].reduceRight((acc, cur, index) => {
    if (index > colIndex) {
      acc = cur.height >= height ? 1 : acc + 1;
    }
    return acc;
  }, 0);

  const top = arr.reduce((acc, cur, index) => {
    if (index < rowIndex) {
      acc = cur[colIndex].height >= height ? 1 : acc + 1;
    }
    return acc;
  }, 0);

  const bottom = arr.reduceRight((acc, cur, index) => {
    if (index > rowIndex) {
      acc = cur[colIndex].height >= height ? 1 : acc + 1;
    }
    return acc;
  }, 0);

  return [left, right, top, bottom].reduce((acc, cur) => acc * cur);
};

function p2(input: string) {
  return input
    .split('\n')
    .map((line) =>
      line
        .split('')
        .map((height) => ({ height: parseInt(height), score: 0 } as TreeScore)),
    )
    .reduce((acc, cur, rowIndex, arr) => {
      return [
        ...acc,
        cur.map((tree, colIndex) => ({
          ...tree,
          score: treeScore(arr, colIndex, rowIndex),
        })),
      ];
    }, [] as TreeScore[][])
    .flat()
    .map((tree) => tree.score)
    .sort((a, b) => a - b)
    .reverse()
    .at(0);
}

// --------------------
//
// run
//
// --------------------

const input: string = readFileSync(__dirname + '/input.txt', {
  encoding: 'utf-8',
});

// part 1
// 1681
console.log('p1', p1(input));

// part 2
// 201684
console.log('p2', p2(input));
