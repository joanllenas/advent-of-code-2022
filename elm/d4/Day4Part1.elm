module Day4Part1 exposing (run)

import Day4Shared exposing (Ranges(..))


hasFullyContainedRange : Ranges -> Bool
hasFullyContainedRange (Ranges ( a1, a2 ) ( b1, b2 )) =
    a1 <= b1 && a2 >= b2 || b1 <= a1 && b2 >= a2


run : List String -> String
run lines =
    lines
        |> Day4Shared.parseRanges
        |> Maybe.map
            (\ranges ->
                List.map hasFullyContainedRange ranges
                    |> List.filter ((==) True)
                    |> List.length
                    |> String.fromInt
            )
        |> Maybe.withDefault "Error parsing ranges"
