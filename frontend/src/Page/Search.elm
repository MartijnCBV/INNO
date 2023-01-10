module Page.Search exposing (..)

import Html exposing (..)
import Html.Attributes
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
import Asset


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
            [ div [ S.class [ S.col_span_2, S.ml_7, S.pr_7, S.flex, S.flex_col ] ] [ viewFilterBar model ]
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


viewFilterBar : Model.Model -> Html Model.Msg
viewFilterBar model =
        case model.queryResp of
            RemoteData.NotAsked -> text "Initialising."

            RemoteData.Loading -> text "Loading."

            RemoteData.Failure err -> text ( "Error: " ++ Model.Error.errorToString err )

            RemoteData.Success resp -> filterBar model resp


results : Model.Model -> Model.QueryResp.DiscoveryQueryResp -> Html Model.Msg
results model resp =
    div []
        [ div [ S.class
                [ S.border_b
                , S.border_c_grey
                , S.border_solid
                ] ]
            [ span [] [ text ( String.fromInt
                ( List.length
                ( List.map result
                ( Model.DiscoveryEntity.sort
                ( Model.DiscoveryEntity.removeObjectTypes model.objectTypesNotShown
                ( Model.DiscoveryEntity.removeGlossaryItems resp.value ) ) model.sortType) ) ) ++ " resultaten voor \"" ++ model.query ++ "\"" ) ]
            , div [ S.class [ S.float_right ] ] [ sortDropdown model ]
            ] --result info
        , div []
            ( List.map result
                ( Model.DiscoveryEntity.sort
                ( Model.DiscoveryEntity.removeObjectTypes model.objectTypesNotShown
                ( Model.DiscoveryEntity.removeGlossaryItems resp.value ) ) model.sortType) ) -- results
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
            , Html.Attributes.id discoveryEntity.guid
            , onClick ( Model.QueryEntity discoveryEntity )
            ]
            [ div [] [ img [ Asset.getTypeIcon discoveryEntity.objectType, S.class [ S.m_auto, S.type_icon ] ] [] ] -- type
            , span [ S.class
                    [ S.col_span_4
                    , S.text_2xl
                    ] ] [ text discoveryEntity.name ] -- name
            , span [ S.class
                    [ S.col_span_4
                    , S.py_3
                    ] ] [ text ( "Laatst gewijzigd: " ++ ( Date.toIsoString ( Date.fromPosix Time.utc ( Time.millisToPosix discoveryEntity.updateTime ) ) ) ) ] -- date
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
                [ label [ Html.Attributes.for "searchbar", S.class [ S.hidden ] ] [ text "Zoek in data" ]
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
                    , Html.Attributes.id "searchbar"
                    , Html.Attributes.type_ "text"
                    , Html.Attributes.placeholder "Zoek in data"
                    , Html.Attributes.value model.query
                    , onInput Model.UpdateQuery
                    ] []
                    , button
                        [ Html.Attributes.type_ "button"
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


filterBar : Model.Model -> Model.QueryResp.DiscoveryQueryResp -> Html Model.Msg
filterBar model resp =
    div []
        [ div [ S.class [ S.pb_3 ] ]
            [ filterBarObjectTypeButton model
            , filterBarObjectTypeForm model resp
            ] -- object types
        , div [] [] -- glossary
        ]


filter : Model.Model -> String -> Html Model.Msg
filter model s =
    div []
        [ input
            [ Html.Attributes.type_ "checkbox"
            , Html.Attributes.name s
            , Html.Attributes.id s
            , Html.Attributes.value s
            , S.class [ S.accent_c_red ]
            , onCheck ( onFilterCheck s)
            , Html.Attributes.checked ( not ( List.member s model.objectTypesNotShown ) )
            ] []
        , label [ Html.Attributes.for s, S.class [ S.pl_3 ] ] [ text s ]
        ]


onFilterCheck : String -> Bool -> Model.Msg
onFilterCheck s e =
    if not e then
        Model.AddObjectTypeNotShown s
    else
        Model.RemoveObjectTypeNotShown s


filterBarObjectTypeButton : Model.Model -> Html Model.Msg
filterBarObjectTypeButton model =
    if model.objectTypeFilterShown then
        button
            [ Html.Attributes.type_ "button"
            , S.class [ S.border_b, S.border_c_grey, S.w_175px, S.text_justify ]
            , onClick Model.UpdateObjectTypeFilterShown
            ]
            [ i [ S.class [ S.material_icons, S.text_c_red, S.filter_icon, S.p_2px, S.bg_c_grey ] ] [ text "remove" ]
            , span [ S.class [ S.pl_3, S.text_xl ] ] [ text "Type" ]
            ]
    else
        button
            [ Html.Attributes.type_ "button"
            , S.class [ S.border_b, S.border_c_grey, S.w_175px, S.text_justify ]
            , onClick Model.UpdateObjectTypeFilterShown
            ]
            [ i [ S.class [ S.material_icons, S.text_white, S.filter_icon, S.p_2px, S.bg_c_red ] ] [ text "add" ]
            , span [ S.class [ S.pl_3, S.text_xl ] ] [ text "Type" ]
            ]


filterBarObjectTypeForm : Model.Model -> Model.QueryResp.DiscoveryQueryResp -> Html Model.Msg
filterBarObjectTypeForm model resp =
    if model.objectTypeFilterShown then
        form []
            ( List.map ( filter model )
            ( Model.DiscoveryEntity.getObjectTypes
            ( Model.DiscoveryEntity.removeGlossaryItems resp.value ) ) )
    else
        form [ S.class [ S.hidden ] ]
            ( List.map ( filter model )
            ( Model.DiscoveryEntity.getObjectTypes
            ( Model.DiscoveryEntity.removeGlossaryItems resp.value ) ) )
