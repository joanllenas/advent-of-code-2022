module Day5Shared exposing (Crate(..), parseCrates)

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


cratesParser : Parser (List Crate)
cratesParser =
    P.loop []
        (\links ->
            P.oneOf
                [ P.succeed (\link -> link :: links)
                    |= crateParser
                    |> P.map Loop
                , P.succeed links
                    |. P.chompIf (always True)
                    |> P.map Loop
                , P.succeed (List.reverse links)
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


parseCrates : String -> Result (List DeadEnd) (List Crate)
parseCrates input =
    P.run cratesParser input
