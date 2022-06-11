module Helpers.Ternary exposing (..)

import Html exposing (a, b)


ifThenElse : Bool -> a -> a -> a
ifThenElse condition trueCase falseCase =
    if condition then
        trueCase

    else
        falseCase
