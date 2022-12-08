module Day5Part1 exposing (run)

import Day5Shared exposing (Crate(..))
import Shared


run : String -> String
run input =
    case Day5Shared.parseCrates input of
        Ok crates ->
            crates
                |> List.map
                    (\(Crate { rowIndex, colIndex } letter) ->
                        letter ++ "( row: " ++ String.fromInt rowIndex ++ ", " ++ "col: " ++ String.fromInt colIndex ++ ")"
                    )
                |> String.join " -- "

        Err err ->
            Shared.parserErrorToString err
