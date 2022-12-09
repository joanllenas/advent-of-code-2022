module Day7Part1 exposing (run)

import Day7Shared exposing (File(..))
import Dict exposing (Dict)
import Shared


calculateDirSizes : Dict String (List File) -> Dict String Int
calculateDirSizes directoryDict =
    let
        totalFilesSize : List File -> Int
        totalFilesSize files =
            List.foldl
                (\file acc ->
                    case file of
                        File _ size ->
                            size + acc

                        _ ->
                            acc
                )
                0
                files

        calculateDirSizes_ : String -> List File -> Dict String Int -> Dict String Int
        calculateDirSizes_ dirPath files dirSizesDict =
            Dict.insert dirPath (totalFilesSize files) dirSizesDict

        flattenDirSizes : String -> Dict String Int -> Int
        flattenDirSizes dirPath dict =
            dict
                |> Dict.filter
                    (\path _ ->
                        String.length path
                            > String.length dirPath
                            && String.left (String.length dirPath) path
                            == dirPath
                    )
                |> Dict.toList
                |> List.foldl (\( _, v ) size -> size + v) 0
    in
    Dict.foldl calculateDirSizes_ Dict.empty directoryDict
        |> (\dict -> Dict.map (\path size -> size + flattenDirSizes path dict) dict)


run : String -> String
run input =
    case Day7Shared.parseCommands input of
        Ok cmds ->
            cmds
                |> Day7Shared.buildFileSystem
                |> calculateDirSizes
                |> Dict.toList
                |> List.filter (\( _, size ) -> size <= 100000)
                |> List.foldl (\( _, size ) acc -> acc + size) 0
                |> Debug.toString

        Err err ->
            Shared.parserErrorToString err
