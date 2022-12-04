module Day2Part2 exposing (run)

import Day2Game exposing (Mov(..), OppoTurn(..), Outcome(..))


type MyTurn
    = MyTurn Outcome


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
        parseOutcome : String -> Maybe Outcome
        parseOutcome char =
            case char of
                "X" ->
                    Just Loose

                "Y" ->
                    Just Draw

                "Z" ->
                    Just Win

                _ ->
                    Nothing

        parseMov : String -> Maybe Mov
        parseMov char =
            case char of
                "A" ->
                    Just Rock

                "B" ->
                    Just Paper

                "C" ->
                    Just Scissors

                _ ->
                    Nothing
    in
    turns
        |> Maybe.andThen
            (\list ->
                case String.split " " line of
                    [ oppoMovLetter, outcomeLetter ] ->
                        Maybe.map2
                            (\oppoMov outcome ->
                                Turn ( OppoTurn oppoMov, MyTurn outcome ) :: list
                            )
                            (parseMov oppoMovLetter)
                            (parseOutcome outcomeLetter)

                    _ ->
                        Nothing
            )


playGame : List Turn -> Int
playGame list =
    list
        |> List.foldl
            (\(Turn ( OppoTurn oppoMov, MyTurn outcome )) points ->
                case outcome of
                    Loose ->
                        points + Day2Game.outcomeToPoints Loose + Day2Game.movToPoints (Day2Game.toLoose oppoMov)

                    Draw ->
                        points + Day2Game.outcomeToPoints Draw + Day2Game.movToPoints oppoMov

                    Win ->
                        points + Day2Game.outcomeToPoints Win + Day2Game.movToPoints (Day2Game.toWin oppoMov)
            )
            0
