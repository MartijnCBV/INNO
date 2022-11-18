module Page.Search exposing (..)

import Debug
import Html exposing (..)

import Model
import RemoteData


-- VIEW


view : Model.Model -> Html Model.Msg
view model =
    case model.queryResp of
        RemoteData.NotAsked -> text "Initialising."

        RemoteData.Loading -> text "Loading."

        RemoteData.Failure err -> text ("Error: " ++ Debug.toString err)

        RemoteData.Success news -> viewResults model news


viewResults : Model.Model -> Model.QueryResp -> Html Model.Msg
viewResults model queryResp =
    h1 [] [ text (queryResp.req ++ " " ++  queryResp.query) ]