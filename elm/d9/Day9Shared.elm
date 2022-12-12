module Day9Shared exposing (Col(..), HeadPosition(..), Motion(..), Row(..), TailPosition(..), parseMovements)

import Parser as P exposing ((|.), (|=), DeadEnd, Parser, Step(..))


type Row
    = Row Int


type Col
    = Col Int


type HeadPosition
    = Head Col Row


type TailPosition
    = Tail Col Row


type Dir
    = Left
    | Right
    | Up
    | Down


type Motion
    = Motion Dir Int


motionsParser : Parser (List Motion)
motionsParser =
    P.loop []
        (\motions ->
            P.oneOf
                [ P.succeed (\motion -> motion :: motions)
                    |= motionParser
                    |> P.map Loop
                , P.succeed motions
                    |. P.chompIf (always True)
                    |> P.map Loop
                , P.succeed (List.reverse motions)
                    |. P.end
                    |> P.map Done
                ]
        )


motionParser : Parser Motion
motionParser =
    P.succeed Motion
        |= directionParser
        |. P.spaces
        |= P.int


directionParser : Parser Dir
directionParser =
    P.oneOf
        [ P.token "L" |> P.map (always Left)
        , P.token "R" |> P.map (always Right)
        , P.token "U" |> P.map (always Up)
        , P.token "D" |> P.map (always Down)
        ]


parseMovements : String -> Result (List DeadEnd) (List Motion)
parseMovements input =
    P.run motionsParser input
