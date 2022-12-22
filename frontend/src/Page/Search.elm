module Page.Search exposing (..)

import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import List
import Date
import Time

import Model
import Model.QueryResp
import Model.DiscoveryEntity
import RemoteData
import CSSWrapper as S


-- VIEW


view : Model.Model -> Html Model.Msg
view model =
    div []
        [ smallSearchBar model
        , div [ S.class
            [ S.grid
            , S.grid_cols_7
            , S.mw
            ] ]
            [ div [ S.class [ S.col_span_2 ] ] [ filterBar model ]
            , div [ S.class [ S.col_span_4 ] ] [ viewResults model ]
            ]
        ]


viewResults : Model.Model -> Html Model.Msg
viewResults model =
    case model.queryResp of
        RemoteData.NotAsked -> text "Initialising."

        RemoteData.Loading -> text "Loading."

        RemoteData.Failure err -> text ("Error: " ++ Debug.toString err)

        RemoteData.Success resp -> results model resp


results : Model.Model -> Model.QueryResp.QueryResp -> Html Model.Msg
results model resp =
    div []
        [ div [ S.class
                [ S.border_b
                , S.border_c_grey
                , S.border_solid
                ] ]
            [ span [] [ text ( ( String.fromInt resp.searchCount ) ++ " resultaten voor " ++ model.query ) ]
            ] --result info
        , div [] ( List.map result resp.value ) -- results
        ]


result : Model.DiscoveryEntity.DiscoveryEntity -> Html Model.Msg
result discoveryEntity =
    a [  ] [ div [ S.class
                [ S.border_b
                , S.border_c_grey
                , S.border_solid
                , S.grid
                , S.grid_cols_5
                ]
            , id discoveryEntity.guid
            , onClick ( Model.QueryEntity discoveryEntity.guid )
            ]
            [ div [] [ text discoveryEntity.objectType ] -- type
            , span [ S.class
                    [ S.col_span_4
                    , S.text_2xl
                    ] ] [ text discoveryEntity.name ] -- name
            , span [ S.class
                    [ S.col_span_4
                    , S.py_3
                    ] ] [ text ( Date.toIsoString ( Date.fromPosix Time.utc ( Time.millisToPosix discoveryEntity.updateTime ) ) ) ] -- date
            ] ]


smallSearchBar : Model.Model -> Html Model.Msg
smallSearchBar model =
    h1 [] []


filterBar : Model.Model -> Html Model.Msg
filterBar model =
    div [] []
