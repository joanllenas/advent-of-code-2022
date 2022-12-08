module Day5Part1 exposing (run)

import Day5Shared
import Shared


run : String -> String
run input =
    case Day5Shared.parseProgram input of
        Ok program ->
            Debug.toString program

        Err err ->
            Shared.parserErrorToString err
