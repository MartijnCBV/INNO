module Page.Search exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model exposing (Model, Msg(..))
import CSSWrapper as S


-- VIEW


view : Model -> Html Msg
view model =
    h1 [] [ text "TEST" ]

