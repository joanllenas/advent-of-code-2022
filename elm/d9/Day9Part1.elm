module Day9Part1 exposing (run)

import Day9Shared exposing (Col(..), HeadPosition(..), Motion(..), Row(..), TailPosition(..))
import Shared


applyMotions : List Motion -> List TailPosition
applyMotions motions =
    let
        initialPosition =
            ( [ Tail (Col 0) (Row 0) ], [ Head (Col 0) (Row 0) ] )

        moveHead : Motion -> ( List TailPosition, List HeadPosition ) -> ( List TailPosition, List HeadPosition )
        moveHead motion ( tails, heads ) =
            ( tails, heads )
    in
    motions
        |> List.foldl moveHead initialPosition
        |> Tuple.first


run : String -> String
run input =
    case Day9Shared.parseMovements input of
        Ok motions ->
            motions
                --|> applyMotions
                |> Debug.toString

        Err err ->
            Shared.parserErrorToString err
