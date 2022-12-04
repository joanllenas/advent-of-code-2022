import { readFileSync } from 'fs';

const points = {
  movements: {
    rock: 1,
    paper: 2,
    scissors: 3,
  },
  outcome: {
    loose: 0,
    draw: 3,
    win: 6,
  },
};

type Movement = keyof typeof points.movements;
type Outcome = keyof typeof points.outcome;

const oppoMovDict: Record<string, Movement> = {
  A: 'rock',
  B: 'paper',
  C: 'scissors',
};

// { <winner key>: <looser key> }
const winLooseMovMap: Record<Movement, Movement> = {
  rock: 'scissors',
  paper: 'rock',
  scissors: 'paper',
};

// part 1
function d1p1(input: string) {
  const myMovDict: Record<string, Movement> = {
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
    if (points.movements[myMovement] - points.movements[oppoMovement] === 0) {
      gamePoints = points.outcome.draw;
    } else if (
      (myMovement === 'rock' && oppoMovement === winLooseMovMap['rock']) ||
      (myMovement === 'paper' && oppoMovement === winLooseMovMap['paper']) ||
      (myMovement === 'scissors' && oppoMovement === winLooseMovMap['scissors'])
    ) {
      gamePoints = points.outcome.win;
    } else {
      gamePoints = points.outcome.loose;
    }

    return acc + gamePoints + points.movements[myMovement];
  }, 0);
}

// part 2
function d1p2(input: string) {
  // { <looser key>: <winner key> }
  const looseWinMovMap: Record<Movement, Movement> = {
    rock: 'paper',
    paper: 'scissors',
    scissors: 'rock',
  };
  const myMovDict: Record<
    string,
    (oppoMov: Movement) => { o: Outcome; myMov: Movement }
  > = {
    X: (oppoMov) => ({ o: 'loose', myMov: winLooseMovMap[oppoMov] }),
    Y: (oppoMov) => ({ o: 'draw', myMov: oppoMov }),
    Z: (oppoMov) => ({ o: 'win', myMov: looseWinMovMap[oppoMov] }),
  };
  return input.split('\n').reduce((acc, cur) => {
    const [oppoLetter, myLetter] = cur.split(' ') as [
      keyof typeof oppoMovDict,
      keyof typeof myMovDict,
    ];
    const oppoMovement = oppoMovDict[oppoLetter];
    const myMovement = myMovDict[myLetter](oppoMovement);
    let gamePoints = points.outcome[myMovement.o];
    return acc + gamePoints + points.movements[myMovement.myMov];
  }, 0);
}

// run
const input: string = readFileSync(__dirname + '/input.txt', {
  encoding: 'utf-8',
});

// part 1
// 14375
console.log(d1p1(input));

// part 2
// 10274
console.log(d1p2(input));
