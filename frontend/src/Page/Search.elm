module Page.Search exposing (..)

import Html
import Html.Attributes
import Html.Events
import String
import List
import Date
import Time

import Model
import Model.QueryResp
import Model.DiscoveryEntity
import Route
import RemoteData
import Css
import Model.Error
import Asset


-- VIEW


view : Model.Model -> Html.Html Model.Msg
view model =
    Html.div []
        [ viewSmallSearchBar model
        , Html.div [ Css.class [ Css.grid, Css.grid_cols_7, Css.mw ] ]
            [ Html.div [ Css.class [ Css.col_span_2, Css.ml_7, Css.pr_7, Css.flex, Css.flex_col ] ] [ viewFilterBar model ]
            , Html.div [ Css.class [ Css.col_span_4 ] ] [ viewResults model ]
            ]
        ]


viewResults : Model.Model -> Html.Html Model.Msg
viewResults model =
    case model.queryResp of
        RemoteData.NotAsked -> Html.text "Initialising."

        RemoteData.Loading -> Html.text "Loading."

        RemoteData.Failure err -> Html.text ( "Error: " ++ Model.Error.errorToString err )

        RemoteData.Success resp -> viewResultsContent model resp


viewFilterBar : Model.Model -> Html.Html Model.Msg
viewFilterBar model =
        case model.queryResp of
            RemoteData.NotAsked -> Html.text "Initialising."

            RemoteData.Loading -> Html.text "Loading."

            RemoteData.Failure err -> Html.text ( "Error: " ++ Model.Error.errorToString err )

            RemoteData.Success resp -> viewFilterBarContent model resp


viewResultsContent : Model.Model -> Model.QueryResp.DiscoveryQueryResp -> Html.Html Model.Msg
viewResultsContent model resp =
    Html.div []
        [ Html.div [ Css.class [ Css.border_b, Css.border_c_grey, Css.border_solid ] ]
            [ Html.span [] [ Html.text
                ( String.fromInt
                ( List.length
                ( List.map viewResult
                ( Model.DiscoveryEntity.sort
                ( Model.DiscoveryEntity.removeExtensions model.extensionsNotShown
                ( Model.DiscoveryEntity.removeObjectTypes model.objectTypesNotShown
                ( Model.DiscoveryEntity.removeGlossaryItems resp.value ) ) ) model.sortType) ) ) ++ " resultaten voor \"" ++ model.query ++ "\"" ) ]
            , Html.div [ Css.class [ Css.float_right ] ] [ viewSortDropdown model ]
            ] --result info
        , Html.div []
            ( List.map viewResult
            ( Model.DiscoveryEntity.sort
            ( Model.DiscoveryEntity.removeExtensions model.extensionsNotShown
            ( Model.DiscoveryEntity.removeObjectTypes model.objectTypesNotShown
            ( Model.DiscoveryEntity.removeGlossaryItems resp.value ) ) ) model.sortType) ) -- results
        ]


viewResult : Model.DiscoveryEntity.DiscoveryEntity -> Html.Html Model.Msg
viewResult discoveryEntity =
    Html.a [ Route.href Route.Entity ]
        [ Html.div
            [ Css.class [ Css.border_b, Css.border_c_grey, Css.border_solid, Css.grid, Css.grid_cols_5 ]
            , Html.Attributes.id discoveryEntity.guid
            , Html.Events.onClick ( Model.QueryEntity discoveryEntity )
            ]
            [ Html.div [] [ Html.img [ Asset.getTypeIcon discoveryEntity.objectType, Css.class [ Css.m_auto, Css.type_icon ] ] [] ] -- type
            , Html.span [ Css.class [ Css.col_span_4, Css.text_2xl ] ] [ Html.text discoveryEntity.name ] -- name
            , Html.span [ Css.class [ Css.col_span_4, Css.py_3 ] ] [ Html.text ( "Laatst gewijzigd: " ++ ( Date.toIsoString ( Date.fromPosix Time.utc ( Time.millisToPosix discoveryEntity.updateTime ) ) ) ) ] -- date
            ]
        ]


viewSortDropdown : Model.Model -> Html.Html Model.Msg
viewSortDropdown model =
    Html.div []
        [ Html.span [ Css.class [ Css.inline_block ] ] [ Html.text "Sorteren op " ]
        , Html.div [ Css.class [ Css.inline_block ] ]
            [ Html.div [ Html.Events.onClick Model.UpdateDropdownShown, Css.class [ Css.inline_block ] ]
                [ sortSelectedText model.sortType
                , Html.span [ Css.class [ Css.sort_option, Css.text_c_red ] ] [ Html.text ( if model.dropdownShown then "^  " else "v  " ) ]
                ]
            , Html.div [ Css.class [ dropdownShown model.dropdownShown, Css.dropdown_content ] ]
                [ Html.div [ Html.Events.onClick ( Model.UpdateSortType Model.DiscoveryEntity.Relevance ) ] [ sortSelectedText Model.DiscoveryEntity.Relevance ]
                , Html.div [ Html.Events.onClick ( Model.UpdateSortType Model.DiscoveryEntity.Name ) ] [ sortSelectedText Model.DiscoveryEntity.Name ]
                , Html.div [ Html.Events.onClick ( Model.UpdateSortType Model.DiscoveryEntity.DateAsc ) ] [ sortSelectedText Model.DiscoveryEntity.DateAsc ]
                , Html.div [ Html.Events.onClick ( Model.UpdateSortType Model.DiscoveryEntity.DateDesc ) ] [ sortSelectedText Model.DiscoveryEntity.DateDesc ]
                ]
            ]
        ]


dropdownShown : Bool -> String
dropdownShown shown =
    if shown then
        ""
    else
        Css.hidden


sortSelectedText : Model.DiscoveryEntity.SortType -> Html.Html Model.Msg
sortSelectedText sortType =
    case sortType of
        Model.DiscoveryEntity.Relevance ->
            Html.span [ Css.class [ Css.sort_option, Css.text_c_red ] ] [ Html.text "  Relevantie  " ]

        Model.DiscoveryEntity.Name ->
            Html.span [ Css.class [ Css.sort_option, Css.text_c_red ] ] [ Html.text "  Naam  " ]

        Model.DiscoveryEntity.DateAsc ->
            Html.span [ Css.class [ Css.sort_option, Css.text_c_red ] ] [ Html.text "  Datum ↑  " ]

        Model.DiscoveryEntity.DateDesc ->
            Html.span [ Css.class [ Css.sort_option, Css.text_c_red ] ] [ Html.text "  Datum ↓  " ]


viewSmallSearchBar : Model.Model -> Html.Html Model.Msg
viewSmallSearchBar model =
    Html.div [ Css.class [ Css.bg_c_grey, Css.w_full, Css.mb_3 ] ]
        [ Html.div [ Css.class [ Css.mw, Css.grid, Css.grid_cols_7 ] ]
            [ viewTitle
            , Html.div [ Css.class [ Css.py_7, Css.col_span_4 ] ]
                [ viewSmallSearchBarLabel
                , Html.div [ Css.class [ Css.w_full, Css.h_full, Css.max_w_fit ] ]
                    [ viewSmallSearchBarInput model
                    , viewSmallSearchBarButton model
                    ]
                ]
            ]
        ]


viewTitle : Html.Html Model.Msg
viewTitle =
    Html.h1
        [ Css.class [ Css.text_white, Css.text_2xl, Css.font_bold, Css.py_7, Css.col_span_2 ] ]
        [ Html.span [ Css.class [ Css.bg_c_brown, Css.px_7, Css.py_13px, Css.mx_7, Css.inline_block ] ] [ Html.text "Resultaten" ] ]


viewSmallSearchBarLabel : Html.Html Model.Msg
viewSmallSearchBarLabel =
    Html.label [ Html.Attributes.for "searchbar", Css.class [ Css.hidden ] ] [ Html.text "Zoek in datacatalogus" ]


viewSmallSearchBarInput : Model.Model -> Html.Html Model.Msg
viewSmallSearchBarInput model =
    Html.input
        [ Css.class [ Css.w_400px, Css.ml_7, Css.px_7, Css.py_15px, Css.text_xl, Css.border_transparent, Css.focus_border_transparent, Css.float_left ]
        , Html.Attributes.id "searchbar"
        , Html.Attributes.type_ "text"
        , Html.Attributes.placeholder "Zoek in data"
        , Html.Attributes.value model.query
        , Html.Events.onInput Model.UpdateQuery
        ] []


viewSmallSearchBarButton : Model.Model -> Html.Html Model.Msg
viewSmallSearchBarButton model =
    Html.button
        [ Html.Attributes.type_ "button"
        , Css.class [ Css.bg_c_red, Css.float_right, Css.border, Css.border_c_red ]
        , Html.Events.onClick (Model.QueryQuery model.query)
        ] [ Html.i [ Css.class [ Css.material_icons, Css.text_white, Css.search_icon, Css.p_10px ] ] [ Html.text "search" ] ]


viewFilterBarContent : Model.Model -> Model.QueryResp.DiscoveryQueryResp -> Html.Html Model.Msg
viewFilterBarContent model resp =
    Html.div []
        [ Html.div [ Css.class [ Css.pb_3 ] ]
            [ filterBarObjectTypeButton model
            , viewFilterBarObjectTypeForm model resp
            ] -- object types
        , Html.div [ Css.class [ Css.pb_3 ] ]
            [ viewFilterBarExtensionButton model
            , viewFilterBarExtensionForm model resp
            ] -- extensions
        , Html.div [] [] -- glossary
        ]


viewFilter : ( String -> Bool -> Model.Msg ) -> List String -> String -> Html.Html Model.Msg
viewFilter f e s =
    Html.div []
        [ Html.input
            [ Html.Attributes.type_ "checkbox"
            , Html.Attributes.name s
            , Html.Attributes.id s
            , Html.Attributes.value s
            , Css.class [ Css.accent_c_red ]
            , Html.Events.onCheck ( f s)
            , Html.Attributes.checked ( not ( List.member s e ) )
            ] []
        , Html.label [ Html.Attributes.for s, Css.class [ Css.pl_3 ] ] [ Html.text s ]
        ]


onObjectTypeFilterCheck : String -> Bool -> Model.Msg
onObjectTypeFilterCheck s e =
    if not e then
        Model.AddObjectTypeNotShown s
    else
        Model.RemoveObjectTypeNotShown s


onExtensionFilterCheck : String -> Bool -> Model.Msg
onExtensionFilterCheck s e =
    if not e then
        Model.AddExtensionNotShown s
    else
        Model.RemoveExtensionNotShown s


viewFilterBarButtonIconPlus : Html.Html Model.Msg
viewFilterBarButtonIconPlus =
    Html.i [ Css.class [ Css.material_icons, Css.text_white, Css.filter_icon, Css.p_2px, Css.bg_c_red ] ] [ Html.text "add" ]


viewFilterBarButtonIconMinus : Html.Html Model.Msg
viewFilterBarButtonIconMinus =
    Html.i [ Css.class [ Css.material_icons, Css.text_c_red, Css.filter_icon, Css.p_2px, Css.bg_c_grey ] ] [ Html.text "remove" ]


filterBarObjectTypeButton : Model.Model -> Html.Html Model.Msg
filterBarObjectTypeButton model =
    if model.objectTypeFilterShown then
        Html.button
            [ Html.Attributes.type_ "button"
            , Css.class [ Css.border_b, Css.border_c_grey, Css.w_175px, Css.text_justify ]
            , Html.Events.onClick Model.UpdateObjectTypeFilterShown
            ]
            [ viewFilterBarButtonIconMinus
            , Html.span [ Css.class [ Css.pl_3, Css.text_xl ] ] [ Html.text "Type" ]
            ]
    else
        Html.button
            [ Html.Attributes.type_ "button"
            , Css.class [ Css.border_b, Css.border_c_grey, Css.w_175px, Css.text_justify ]
            , Html.Events.onClick Model.UpdateObjectTypeFilterShown
            ]
            [ viewFilterBarButtonIconPlus
            , Html.span [ Css.class [ Css.pl_3, Css.text_xl ] ] [ Html.text "Type" ]
            ]


viewFilterBarExtensionButton : Model.Model -> Html.Html Model.Msg
viewFilterBarExtensionButton model =
        if model.extensionFilterShown then
            Html.button
                [ Html.Attributes.type_ "button"
                , Css.class [ Css.border_b, Css.border_c_grey, Css.w_175px, Css.text_justify ]
                , Html.Events.onClick Model.UpdateExtensionFilterShown
                ]
                [ viewFilterBarButtonIconMinus
                , Html.span [ Css.class [ Css.pl_3, Css.text_xl ] ] [ Html.text "Extensie" ]
                ]
        else
            Html.button
                [ Html.Attributes.type_ "button"
                , Css.class [ Css.border_b, Css.border_c_grey, Css.w_175px, Css.text_justify ]
                , Html.Events.onClick Model.UpdateExtensionFilterShown
                ]
                [ viewFilterBarButtonIconPlus
                , Html.span [ Css.class [ Css.pl_3, Css.text_xl ] ] [ Html.text "Extensie" ]
                ]


viewFilterBarObjectTypeForm : Model.Model -> Model.QueryResp.DiscoveryQueryResp -> Html.Html Model.Msg
viewFilterBarObjectTypeForm model resp =
    if model.objectTypeFilterShown then
        Html.form []
            ( List.map ( viewFilter onObjectTypeFilterCheck model.objectTypesNotShown )
            ( Model.DiscoveryEntity.getObjectTypes
            ( Model.DiscoveryEntity.removeGlossaryItems resp.value ) ) )
    else
        Html.form [ Css.class [ Css.hidden ] ]
            ( List.map ( viewFilter onObjectTypeFilterCheck model.objectTypesNotShown )
            ( Model.DiscoveryEntity.getObjectTypes
            ( Model.DiscoveryEntity.removeGlossaryItems resp.value ) ) )


viewFilterBarExtensionForm : Model.Model -> Model.QueryResp.DiscoveryQueryResp -> Html.Html Model.Msg
viewFilterBarExtensionForm model resp =
        if model.extensionFilterShown then
            Html.form []
                ( List.map ( viewFilter onExtensionFilterCheck model.extensionsNotShown )
                ( Model.DiscoveryEntity.getExtensions
                ( Model.DiscoveryEntity.removeGlossaryItems resp.value ) ) )
        else
            Html.form [ Css.class [ Css.hidden ] ]
                ( List.map ( viewFilter onExtensionFilterCheck model.extensionsNotShown )
                ( Model.DiscoveryEntity.getExtensions
                ( Model.DiscoveryEntity.removeGlossaryItems resp.value ) ) )
