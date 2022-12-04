module Day2Part1 exposing (run)

import Day2Game exposing (Mov(..), OppoTurn(..), Outcome(..))


type MyTurn
    = MyTurn Mov


type Turn
    = Turn ( OppoTurn, MyTurn )


run : String -> String
run input =
    input
        |> String.lines
        |> List.foldl movParser (Just [])
        |> Maybe.map playGame
        |> Maybe.map String.fromInt
        |> Maybe.withDefault "--"


movParser : String -> Maybe (List Turn) -> Maybe (List Turn)
movParser line turns =
    let
        parseMov : String -> Maybe Mov
        parseMov char =
            case char of
                "A" ->
                    Just Rock

                "X" ->
                    Just Rock

                "B" ->
                    Just Paper

                "Y" ->
                    Just Paper

                "C" ->
                    Just Scissors

                "Z" ->
                    Just Scissors

                _ ->
                    Nothing
    in
    turns
        |> Maybe.andThen
            (\list ->
                case String.split " " line of
                    [ oppoMovLetter, myMovLetter ] ->
                        Maybe.map2
                            (\oppoMov myMov ->
                                Turn ( OppoTurn oppoMov, MyTurn myMov ) :: list
                            )
                            (parseMov oppoMovLetter)
                            (parseMov myMovLetter)

                    _ ->
                        Nothing
            )


playGame : List Turn -> Int
playGame list =
    list
        |> List.foldl
            (\(Turn ( OppoTurn oppoMov, MyTurn myMov )) points ->
                if Day2Game.movToPoints myMov - Day2Game.movToPoints oppoMov == 0 then
                    points + Day2Game.outcomeToPoints Draw + Day2Game.movToPoints myMov

                else if Day2Game.toWin oppoMov == myMov then
                    points + Day2Game.outcomeToPoints Win + Day2Game.movToPoints myMov

                else
                    points + Day2Game.outcomeToPoints Loose + Day2Game.movToPoints myMov
            )
            0
