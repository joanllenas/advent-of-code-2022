module Day7Part1 exposing (run)

import Day7Shared exposing (File(..))
import Dict
import Shared


run : String -> String
run input =
    case Day7Shared.parseCommands input of
        Ok cmds ->
            cmds
                |> Day7Shared.buildFileSystem
                |> Day7Shared.calculateDirSizes
                |> Dict.toList
                |> List.filter (\( _, size ) -> size <= 100000)
                |> List.foldl (\( _, size ) acc -> acc + size) 0
                |> Debug.toString

        Err err ->
            Shared.parserErrorToString err
