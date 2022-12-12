module Day9Shared exposing (HeadPosition(..), Motion(..), TailPosition(..), move, parseMovements)

import Math.Vector2 as V exposing (Vec2)
import Parser as P exposing ((|.), (|=), DeadEnd, Parser, Step(..))


type HeadPosition
    = Head Vec2


type TailPosition
    = Tail Vec2


type Dir
    = Left
    | Right
    | Up
    | Down


type Motion
    = Mov Dir Int


move : ( TailPosition, HeadPosition ) -> Motion -> ( TailPosition, HeadPosition )
move ( Tail tail, Head head ) (Mov dir n) =
    let
        incr =
            toFloat n

        moveTail : Vec2 -> Vec2 -> TailPosition
        moveTail newHeadVec newTailRelativeVec =
            if V.distance tail newHeadVec > 2 then
                Tail (V.add newHeadVec newTailRelativeVec)

            else
                Tail tail
    in
    case dir of
        Left ->
            V.add (V.vec2 -incr 0) head
                |> (\newHeadVec -> ( moveTail newHeadVec (V.vec2 1 0), Head newHeadVec ))

        Right ->
            V.add (V.vec2 incr 0) head
                |> (\newHeadVec -> ( moveTail newHeadVec (V.vec2 -1 0), Head newHeadVec ))

        Up ->
            V.add (V.vec2 0 incr) head
                |> (\newHeadVec -> ( moveTail newHeadVec (V.vec2 0 -1), Head newHeadVec ))

        Down ->
            V.add (V.vec2 0 -incr) head
                |> (\newHeadVec -> ( moveTail newHeadVec (V.vec2 0 1), Head newHeadVec ))


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
    P.succeed Mov
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
