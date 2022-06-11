module Clock exposing (main)

import Browser
import Helpers.Ternary exposing (ifThenElse)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Task
import Time



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    , paused : Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0) False
    , Task.perform AdjustTimeZone Time.here
    )



-- Update


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | Toggle


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Toggle ->
            ( { model | paused = not model.paused }
            , Cmd.none
            )

        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.paused then
        Sub.none

    else
        Time.every 1000 Tick



-- View


view : Model -> Html Msg
view model =
    let
        timeData =
            { hour = Time.toHour model.zone model.time
            , minute = Time.toMinute model.zone model.time
            , second = Time.toSecond model.zone model.time
            }

        hour =
            doubleDigitString timeData.hour

        minute =
            doubleDigitString timeData.minute

        second =
            doubleDigitString timeData.second

        buttonText =
            if model.paused then
                "Resume"

            else
                "Pause"
    in
    div []
        [ h1 [] [ Html.text (hour ++ ":" ++ minute ++ ":" ++ second) ]
        , button [ onClick Toggle ] [ Html.text buttonText ]
        ]


doubleDigitString : Int -> String
doubleDigitString value =
    let
        stringValue =
            String.fromInt value
    in
    ifThenElse (value < 10) ("0" ++ stringValue) stringValue
