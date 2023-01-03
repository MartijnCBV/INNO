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
import Route
import RemoteData
import CSSWrapper as S
import Model.Error


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

        RemoteData.Failure err -> text ( "Error: " ++ Model.Error.errorToString err )

        RemoteData.Success resp -> results model resp


results : Model.Model -> Model.QueryResp.QueryResp -> Html Model.Msg
results model resp =
    div []
        [ div [ S.class
                [ S.border_b
                , S.border_c_grey
                , S.border_solid
                ] ]
            [ span [] [ text ( ( String.fromInt resp.searchCount ) ++ " resultaten voor \"" ++ model.query ++ "\"" ) ]
            , div [ S.class [ S.float_right ] ] [ sortDropdown model ]
            ] --result info
        , div [] ( List.map result ( Model.DiscoveryEntity.sort resp.value model.sortType) ) -- results
        ]


result : Model.DiscoveryEntity.DiscoveryEntity -> Html Model.Msg
result discoveryEntity =
    a [ Route.href Route.Entity ] [ div [ S.class
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


sortDropdown : Model.Model -> Html Model.Msg
sortDropdown model =
    div []
        [ span [ S.class [ S.inline_block ] ] [ text "Sorteren op " ]
        , div [ S.class [ S.inline_block ] ]
            [ div [  onClick Model.UpdateDropdownShown, S.class [ S.inline_block ] ]
                [ sortSelectedText model.sortType
                , span [ S.class [ S.sort_option, S.text_c_red ] ] [ text ( if model.dropdownShown then "^  " else "v  " ) ]
                ]
            , div [ S.class [ dropdownShown model.dropdownShown, S.dropdown_content ] ]
                [ div [ onClick ( Model.UpdateSortType Model.DiscoveryEntity.Relevance ) ] [ sortSelectedText Model.DiscoveryEntity.Relevance ]
                , div [ onClick ( Model.UpdateSortType Model.DiscoveryEntity.Name ) ] [ sortSelectedText Model.DiscoveryEntity.Name ]
                , div [ onClick ( Model.UpdateSortType Model.DiscoveryEntity.DateAsc ) ] [ sortSelectedText Model.DiscoveryEntity.DateAsc ]
                , div [ onClick ( Model.UpdateSortType Model.DiscoveryEntity.DateDesc ) ] [ sortSelectedText Model.DiscoveryEntity.DateDesc ]
                ]
            ]
        ]


dropdownShown : Bool -> String
dropdownShown shown =
    if shown then "" else S.hidden


sortSelectedText : Model.DiscoveryEntity.SortType -> Html Model.Msg
sortSelectedText sortType =
    case sortType of
        Model.DiscoveryEntity.Relevance ->
            span [ S.class [ S.sort_option, S.text_c_red ] ] [ text "  Relevantie  " ]

        Model.DiscoveryEntity.Name ->
            span [ S.class [ S.sort_option, S.text_c_red ] ] [ text "  Naam  " ]

        Model.DiscoveryEntity.DateAsc ->
            span [ S.class [ S.sort_option, S.text_c_red ] ] [ text "  Datum ↑  " ]

        Model.DiscoveryEntity.DateDesc ->
            span [ S.class [ S.sort_option, S.text_c_red ] ] [ text "  Datum ↓  " ]


smallSearchBar : Model.Model -> Html Model.Msg
smallSearchBar model =
    div [ S.class
            [ S.bg_c_grey
            , S.w_full
            , S.mb_3
            ]
        ]
        [ div
            [ S.class
                [ S.mw
                , S.grid
                , S.grid_cols_7
                ]
            ]
            [ h1
                [ S.class
                    [ S.text_white
                    , S.text_2xl
                    , S.font_bold
                    , S.py_7
                    , S.col_span_2
                    ]
                ]
                [ span [ S.class
                    [ S.bg_c_brown
                    , S.px_7
                    , S.py_13px
                    , S.mx_7
                    , S.inline_block
                    ] ] [ text "Resultaten" ] ]
            , div
                [ S.class
                    [ S.py_7
                    , S.col_span_4
                    ]
                ]
                [ label [ for "searchbar", S.class [ S.hidden ] ] [ text "Zoek in data" ]
                , div
                    [ S.class
                        [ S.w_full
                        , S.h_full
                        , S.max_w_fit
                        ]
                    ]
                    [ input
                    [ S.class
                        [ S.w_400px
                        , S.ml_7
                        , S.px_7
                        , S.py_15px
                        , S.text_xl
                        , S.border_transparent
                        , S.focus_border_transparent
                        , S.float_left
                        ]
                    , id "searchbar"
                    , type_ "text"
                    , placeholder "Zoek in data"
                    , value model.query
                    , onInput Model.UpdateQuery
                    ] []
                    , button
                        [ type_ "button"
                        , S.class
                            [ S.bg_c_red
                            , S.float_right
                            , S.border
                            , S.border_c_red
                            ]
                        , onClick (Model.QueryQuery model.query)
                        ]
                        [ i [ S.class
                                [ S.material_icons
                                , S.text_white
                                , S.search_icon
                                , S.p_10px
                                ] ] [ text "search" ] ]
                    ]
                ]
        ] ]


filterBar : Model.Model -> Html Model.Msg
filterBar model =
    div [] []
