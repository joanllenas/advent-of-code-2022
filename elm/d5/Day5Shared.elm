module Day5Shared exposing (Crate(..), Operation(..), Program(..), parseProgram)

import Array exposing (Array)
import Parser as P
    exposing
        ( (|.)
        , (|=)
        , DeadEnd
        , Parser
        , Step(..)
        , Trailing(..)
        )


type Crate
    = Crate { rowIndex : Int, colIndex : Int } String


type Operation
    = Op { amount : Int, fromCol : Int, toCol : Int }


type Program
    = Prg (Array Crate) (List Operation)


programParser : Parser Program
programParser =
    P.loop (Prg Array.empty [])
        (\((Prg crates ops) as prg) ->
            P.oneOf
                [ P.succeed (\crate -> Prg (Array.push crate crates) ops)
                    |= crateParser
                    |> P.map Loop
                , P.succeed (\op -> Prg crates (op :: ops))
                    |= operationParser
                    |> P.map Loop
                , P.succeed prg
                    |. P.chompIf (always True)
                    |> P.map Loop
                , P.succeed (Prg crates (List.reverse ops))
                    |. P.end
                    |> P.map Done
                ]
        )


crateParser : Parser Crate
crateParser =
    P.succeed (\( row, col ) letter -> Crate { rowIndex = row - 1, colIndex = (col - 1) // 4 } letter)
        |= P.getPosition
        |. P.symbol "["
        |= (P.getChompedString <| P.chompIf Char.isUpper)
        |. P.symbol "]"


operationParser : Parser Operation
operationParser =
    P.succeed (\amount from to -> Op { amount = amount, fromCol = from, toCol = to })
        |. P.token "move "
        |= P.int
        |. P.token " from "
        |= P.int
        |. P.token " to "
        |= P.int


parseProgram : String -> Result (List DeadEnd) Program
parseProgram input =
    P.run programParser input
