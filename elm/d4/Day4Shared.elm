module Day4Shared exposing (Ranges(..), parseRanges)

import Parser exposing ((|.), (|=), Parser, int, succeed, symbol)


type Ranges
    = Ranges ( Int, Int ) ( Int, Int )


rangesParser : Parser Ranges
rangesParser =
    succeed Ranges
        |= rangeParser
        |. symbol ","
        |= rangeParser


rangeParser : Parser ( Int, Int )
rangeParser =
    succeed Tuple.pair
        |= int
        |. symbol "-"
        |= int


parseRanges : List String -> Maybe (List Ranges)
parseRanges lines =
    lines
        |> List.map (Parser.run rangesParser >> Result.toMaybe)
        |> List.foldr (Maybe.map2 (\range list -> range :: list)) (Just [])
