module Page.Search exposing (..)

import Html exposing (..)

import Model exposing (Model, Msg)


-- VIEW


view : Model -> Html Msg
view model =
    h1 [] [ text model.query ]

