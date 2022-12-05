module Day4Part2 exposing (run)

import Day4Shared exposing (Ranges(..))
import Set


hasOverlappingRange : Ranges -> Bool
hasOverlappingRange (Ranges ( a1, a2 ) ( b1, b2 )) =
    (Set.fromList <| List.range a1 a2)
        |> Set.intersect (Set.fromList <| List.range b1 b2)
        |> Set.toList
        |> (\intersection -> List.length intersection > 0)


run : List String -> String
run lines =
    lines
        |> Day4Shared.parseRanges
        |> Maybe.map
            (\ranges ->
                List.map hasOverlappingRange ranges
                    |> List.filter ((==) True)
                    |> List.length
                    |> String.fromInt
            )
        |> Maybe.withDefault "Error parsing ranges"
