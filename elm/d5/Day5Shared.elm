module Day5Shared exposing (crateToString, parseCrates)

import Parser as P
    exposing
        ( (|.)
        , (|=)
        , DeadEnd
        , Parser
        , Step(..)
        )


type Crate
    = Crate { rowIndex : Int, colIndex : Int } String


cratesRowParser : Parser (List Crate)
cratesRowParser =
    P.loop [] cratesRowParserHelp


cratesRowParserHelp : List Crate -> Parser (Step (List Crate) (List Crate))
cratesRowParserHelp crates =
    P.oneOf
        [ P.succeed
            (\( row, col ) letter ->
                Loop (Crate { rowIndex = row - 1, colIndex = (col - 1) // 4 } letter :: crates)
            )
            |= P.getPosition
            |= crateParser
        , P.succeed (Done (List.reverse crates))
            |. P.token "\n"
        , whitespace |> P.map (\_ -> Loop crates)
        ]


crateParser : Parser String
crateParser =
    P.succeed identity
        |. P.symbol "["
        |. whitespace
        |= (P.getChompedString <| P.chompIf Char.isUpper)
        |. whitespace
        |. P.symbol "]"


whitespace : Parser ()
whitespace =
    P.chompWhile ((==) ' ')


parseCrates : String -> Result (List DeadEnd) (List Crate)
parseCrates input =
    P.run cratesRowParser input


crateToString : Crate -> String
crateToString (Crate { rowIndex, colIndex } letter) =
    String.join "" [ "row:", String.fromInt rowIndex, ", col:", String.fromInt colIndex, ") ", letter ]
