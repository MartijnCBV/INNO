module Page.Entity exposing (..)

import Html exposing (..)
import Debug
import RemoteData

import Model

view : Model.Model -> Html Model.Msg
view model =
    viewEntity model


viewEntity : Model.Model -> Html Model.Msg
viewEntity model =
    case model.currentEntity of
        RemoteData.NotAsked -> text "Initialising"

        RemoteData.Loading -> text "loading"

        RemoteData.Failure err -> text ( "Error: " ++ Debug.toString err )

        RemoteData.Success resp -> text ( Debug.toString resp )

