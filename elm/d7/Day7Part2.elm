module Day7Part2 exposing (run)

import Day7Shared exposing (File(..))
import Dict
import Shared


run : String -> String
run input =
    let
        totalSpace =
            70000000

        spaceToUpdate =
            30000000

        canUpdate ( size, usedSpace ) =
            totalSpace - (usedSpace - size) >= spaceToUpdate
    in
    case Day7Shared.parseCommands input of
        Ok cmds ->
            cmds
                |> Day7Shared.buildFileSystem
                |> Day7Shared.calculateDirSizes
                |> Dict.toList
                |> List.map Tuple.second
                |> List.sort
                |> (\sizes ->
                        List.maximum sizes
                            |> Maybe.map (\usedSpace -> List.map (\size -> ( size, usedSpace )) sizes)
                            |> Maybe.withDefault []
                   )
                |> List.filter canUpdate
                |> List.head
                |> Maybe.map (Tuple.first >> String.fromInt)
                |> Maybe.withDefault "--"

        Err err ->
            Shared.parserErrorToString err
