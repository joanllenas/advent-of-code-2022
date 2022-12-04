port module Main exposing (main)

import Platform exposing (Program)


type alias OutputType =
    ( String, String )


port getInput : (String -> msg) -> Sub msg


port sendResult : OutputType -> Cmd msg


main : Program Flags Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    ()


type Msg
    = GotInput String


type alias Flags =
    ()


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( (), Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotInput input ->
            ( model, sendResult (calculate input) )


subscriptions : Model -> Sub Msg
subscriptions _ =
    getInput GotInput


calculate : String -> OutputType
calculate input =
    ( day1p1 input, day1p2 input )


day1p1 : String -> String
day1p1 input =
    input
        |> totalCaloriesPerElfDesc
        |> List.head
        |> Maybe.map String.fromInt
        |> Maybe.withDefault "--"



-- part 1
-- 67658


day1p2 : String -> String
day1p2 input =
    input
        |> totalCaloriesPerElfDesc
        |> List.take 3
        |> List.sum
        |> String.fromInt



-- part 2
-- 200158


totalCaloriesPerElfDesc : String -> List Int
totalCaloriesPerElfDesc input =
    input
        |> String.lines
        |> List.foldl caloriesAccumulator ( 0, [] )
        |> Tuple.second
        |> List.sort
        |> List.reverse


caloriesAccumulator : String -> ( Int, List Int ) -> ( Int, List Int )
caloriesAccumulator line ( n, list ) =
    case String.toInt line of
        Just num ->
            ( n + num, list )

        Nothing ->
            ( 0, n :: list )
