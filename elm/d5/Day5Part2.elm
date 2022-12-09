module Day5Part2 exposing (run)

import Day5Shared exposing (Crate(..), Operation(..), Program(..))
import Dict exposing (Dict)
import Shared


runProgram : Dict Int (List String) -> List Operation -> Dict Int (List String)
runProgram colsDict operations =
    case operations of
        [] ->
            colsDict

        (Op { amount, fromCol, toCol }) :: ops ->
            let
                newCols =
                    colsDict
                        |> Dict.get fromCol
                        |> Maybe.map (List.take amount)
                        |> Maybe.withDefault []

                dictWithNewCols =
                    colsDict
                        |> Dict.update toCol
                            (\maybeCols ->
                                maybeCols
                                    |> Maybe.map (\cols -> newCols ++ cols)
                            )

                dictRemoveOldCols =
                    dictWithNewCols
                        |> Dict.update fromCol
                            (\maybeCols ->
                                maybeCols
                                    |> Maybe.map (\cols -> List.drop amount cols)
                            )
            in
            runProgram dictRemoveOldCols ops


groupCrates : List Crate -> Dict Int (List String)
groupCrates crates =
    List.foldl
        (\(Crate { colIndex } letter) dict ->
            dict
                |> Dict.get colIndex
                |> Maybe.map (\list -> letter :: list)
                |> Maybe.andThen (\list -> Dict.insert colIndex list dict |> Just)
                |> Maybe.withDefault (Dict.insert colIndex [ letter ] dict)
        )
        Dict.empty
        crates


run : String -> String
run input =
    case Day5Shared.parseProgram input of
        Ok (Prg crates ops) ->
            runProgram (groupCrates crates) ops
                |> Dict.toList
                |> List.filterMap (\( _, list ) -> List.head list)
                |> String.join ""

        Err err ->
            Shared.parserErrorToString err
