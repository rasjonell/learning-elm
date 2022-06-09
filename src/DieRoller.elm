module DieRoller exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random



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


type Model
    = Loading
    | Result Die


type alias Die =
    { face1 : Int
    , face2 : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Random.generate NewFace getTwoDieValues
    )



-- Update


type Msg
    = Roll
    | NewFace Die


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.generate NewFace getTwoDieValues
            )

        NewFace newFace ->
            ( Result newFace
            , Cmd.none
            )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- View


view : Model -> Html Msg
view model =
    case model of
        Loading ->
            div [] []

        Result die ->
            div []
                [ h1 []
                    [ text ("Die 1: " ++ String.fromInt die.face1)
                    , br [] []
                    , text ("Die 2: " ++ String.fromInt die.face2)
                    , br [] []
                    , text ("Sum: " ++ String.fromInt (die.face1 + die.face2))
                    ]
                , button [ onClick Roll ] [ text "Roll" ]
                ]



-- Helpers


randomDieValue : Random.Generator Int
randomDieValue =
    Random.int 1 6


getTwoDieValues : Random.Generator Die
getTwoDieValues =
    Random.map2 Die randomDieValue randomDieValue
