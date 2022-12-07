module Day5Part1 exposing (run)

import Day5Shared
import Shared


run : String -> String
run input =
    case Day5Shared.parseCrates input of
        Ok crates ->
            crates |> List.map Day5Shared.crateToString |> String.join ","

        Err err ->
            Shared.parserErrorToString err
