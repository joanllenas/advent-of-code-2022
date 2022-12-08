module Day5Part1 exposing (run)

import Day5Shared exposing (Crate(..), Operation(..), Program(..))
import Shared



-- groupCrates : (List Crate, List (List Crate)) : (List Crate, List (List Crate))
-- groupCrates (crates1, crates2) =
--     case crates1 of
--         [] -> ([], crates2)
--         ((Crate {rowIndex, colIndex} letter) :: xs) ->
-- runProgram : Program -> Program
-- runProgram (Prg crates operations) =
--     case operations of
--         [] ->
--             Prg crates []
--         (Op { amount, fromCol, toCol }) :: ops ->
--             let
--                 postionedCrates =
--             in
--             runProgram (Prg postionedCrates ops)


run : String -> String
run input =
    case Day5Shared.parseProgram input of
        Ok program ->
            Debug.toString program

        Err err ->
            Shared.parserErrorToString err
