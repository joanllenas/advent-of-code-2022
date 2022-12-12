module Day9Part1 exposing (run)

import Day9Shared exposing (HeadPosition(..), Motion(..), TailPosition(..))
import List.Extra
import Math.Vector2 as V
import Shared


applyMotions : Motion -> ( List TailPosition, List HeadPosition ) -> ( List TailPosition, List HeadPosition )
applyMotions motion ( tails, heads ) =
    case ( tails, heads ) of
        ( t :: ts, h :: hs ) ->
            Day9Shared.move ( t, h ) motion
                |> Tuple.mapBoth (\tail -> tail :: t :: ts) (\head -> head :: h :: hs)

        _ ->
            ( tails, heads )


run : String -> String
run input =
    let
        initialPosition =
            ( [ Tail <| V.vec2 0 0 ], [ Head <| V.vec2 0 0 ] )
    in
    case Day9Shared.parseMovements input of
        Ok motions ->
            motions
                |> List.foldl applyMotions initialPosition
                |> Tuple.first
                |> List.map (\(Tail vec) -> V.toRecord vec)
                |> List.Extra.unique
                |> List.length
                |> Debug.toString

        Err err ->
            Shared.parserErrorToString err
