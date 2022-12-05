import { readFileSync } from 'fs';

const priority = (char: string) =>
  'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    .split('')
    .indexOf(char) + 1;

// part 1
function p1(input: string) {
  return input.split('\n').reduce((acc, cur) => {
    const items = cur.split('');
    const [c1, c2] = [
      items.slice(0, items.length / 2),
      items.slice(items.length / 2),
    ];
    const itemInboth = c1.find((item1) => c2.find((item2) => item1 === item2));
    if (!itemInboth) {
      throw new Error('Item not found in both rucksacks');
    }
    return acc + priority(itemInboth);
  }, 0);
}

// part 2
function p2(input: string) {
  return input
    .split('\n')
    .reduce(
      (groups: string[][], line: string) => {
        const lastGroup = groups.slice(-1)[0];
        return lastGroup.length < 3
          ? [...groups.slice(0, -1), [...lastGroup, line]]
          : [...groups, [line]];
      },
      [[]] as string[][],
    )
    .reduce((acc: number, cur: string[]) => {
      const letter = cur[0]
        .split('')
        .find((grp0Letter) =>
          cur[1]
            .split('')
            .find(
              (grp1Letter) =>
                grp0Letter === grp1Letter &&
                cur[2]
                  .split('')
                  .find((grp2Letter) => grp0Letter === grp2Letter),
            ),
        );
      if (!letter) {
        throw new Error('Group without matching letter');
      }
      return acc + priority(letter);
    }, 0);
}

// run
const input: string = readFileSync(__dirname + '/input.txt', {
  encoding: 'utf-8',
});

// part 1
// 8243
console.log(p1(input));

// part 2
// 2631
console.log(p2(input));
