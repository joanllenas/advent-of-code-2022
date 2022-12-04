module Day2Game exposing (Mov(..), OppoTurn(..), Outcome(..), movToPoints, outcomeToPoints, toLoose, toWin)


type Mov
    = Rock
    | Paper
    | Scissors


type Outcome
    = Win
    | Draw
    | Loose


type OppoTurn
    = OppoTurn Mov


movToPoints : Mov -> number
movToPoints mov =
    case mov of
        Rock ->
            1

        Paper ->
            2

        Scissors ->
            3


outcomeToPoints : Outcome -> number
outcomeToPoints outcome =
    case outcome of
        Loose ->
            0

        Draw ->
            3

        Win ->
            6


toWin : Mov -> Mov
toWin mov =
    case mov of
        Rock ->
            Paper

        Paper ->
            Scissors

        Scissors ->
            Rock


toLoose : Mov -> Mov
toLoose mov =
    case mov of
        Rock ->
            Scissors

        Paper ->
            Rock

        Scissors ->
            Paper
