port module Day5 exposing (main)

import Day5Part1
import Day5Part2
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
    -- ( "JDTMRWCQJ", "VHJDDCWRD" )
    ( Day5Part1.run input, Day5Part2.run input )
