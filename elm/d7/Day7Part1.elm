module Day7Part1 exposing (run)

import Day7Shared
import Shared


run : String -> String
run input =
    case Day7Shared.parseCommands input of
        Ok cmds ->
            cmds
                |> Debug.toString

        Err err ->
            Shared.parserErrorToString err
