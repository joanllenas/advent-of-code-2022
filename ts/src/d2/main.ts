import { readFileSync } from 'fs';

type Mov = 'rock' | 'paper' | 'scissors';
const movs: Mov[] = ['rock', 'paper', 'scissors'];
const movPoints = (mov: Mov) => [1, 2, 3][movIndex(mov)];
const movIndex = (mov: Mov) => movs.indexOf(mov);
const prevMovIndex = (index: number) =>
  index === 0 ? movs.length - 1 : index - 1;
const nextMovIndex = (index: number) =>
  index === movs.length - 1 ? 0 : index + 1;
const winnerMov = (mov: Mov) => movs[nextMovIndex(movIndex(mov))];
const looserMov = (mov: Mov) => movs[prevMovIndex(movIndex(mov))];

const outcomePoints = {
  loose: 0,
  draw: 3,
  win: 6,
};

type Outcome = keyof typeof outcomePoints;

const oppoMovDict: Record<string, Mov> = {
  A: 'rock',
  B: 'paper',
  C: 'scissors',
};

// part 1
function p1(input: string) {
  const myMovDict: Record<string, Mov> = {
    X: 'rock',
    Y: 'paper',
    Z: 'scissors',
  };
  return input.split('\n').reduce((acc, cur) => {
    const [oppoLetter, myLetter] = cur.split(' ') as [
      keyof typeof oppoMovDict,
      keyof typeof myMovDict,
    ];
    const myMovement = myMovDict[myLetter];
    const oppoMovement = oppoMovDict[oppoLetter];
    let gamePoints = 0;
    if (movPoints(myMovement) - movPoints(oppoMovement) === 0) {
      gamePoints = outcomePoints.draw;
    } else if (winnerMov(oppoMovement) === myMovement) {
      gamePoints = outcomePoints.win;
    } else {
      gamePoints = outcomePoints.loose;
    }

    return acc + gamePoints + movPoints(myMovement);
  }, 0);
}

// part 2
function p2(input: string) {
  const myMovDict: Record<
    string,
    (oppoMov: Mov) => { o: Outcome; myMov: Mov }
  > = {
    X: (oppoMov) => ({ o: 'loose', myMov: looserMov(oppoMov) }),
    Y: (oppoMov) => ({ o: 'draw', myMov: oppoMov }),
    Z: (oppoMov) => ({ o: 'win', myMov: winnerMov(oppoMov) }),
  };
  return input.split('\n').reduce((acc, cur) => {
    const [oppoLetter, myLetter] = cur.split(' ') as [
      keyof typeof oppoMovDict,
      keyof typeof myMovDict,
    ];
    const oppoMovement = oppoMovDict[oppoLetter];
    const myMovement = myMovDict[myLetter](oppoMovement);
    let gamePoints = outcomePoints[myMovement.o];
    return acc + gamePoints + movPoints(myMovement.myMov);
  }, 0);
}

// run
const input: string = readFileSync(__dirname + '/input.txt', {
  encoding: 'utf-8',
});

// part 1
// 14375
console.log(p1(input));

// part 2
// 10274
console.log(p2(input));
