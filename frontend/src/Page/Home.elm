module Page.Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model
import CSSWrapper as S
import Route


-- VIEW


view : Model.Model -> Html Model.Msg
view model =
    div [ S.class [ S.bg_image ] ]
        [ div [ S.class [ S.mw ] ]
            [ h1 [ S.class [ S.pt_10, S.mp_text ] ] [ span [ S.class [ S.mp_span, S.p_7, S.mx_7 ] ] [ text "Zoek in datacatalogus" ] ]
            , searchBar model
            , h1 [ S.class [ S.pt_10, S.mp_text_small ] ] [ span [ S.class [ S.mp_span_small, S.p_15x, S.mx_7, S.mt_6 ] ] [ text description ] ]
            ]
        ]


description : String
description = "Welkom op de data catalogus van de provincie Utrecht. Op deze pagina is er de mogelijkheid om te zoeken naar alle datasets en informatieproducten die binnen de organisatie beschikbaar zijn. Voer een zoekterm in, voeg filters toe op de resultaten en vindt de juiste dataset."


searchBar : Model.Model -> Html Model.Msg
searchBar model =
    div [ S.class [ S.mt_32px ] ]
        [ label
            [ for "searchbar"
            , type_ "text"
            , placeholder "Zoek in datacatalogus"
            , S.class [ S.hidden ]
            ] []
        , div [ S.class [ S.wh_full_mw_fit ] ]
            [ input
                [ id "searchbar"
                , type_ "text"
                , placeholder "Zoek in datacatalogus"
                , value model.query
                , onInput Model.UpdateQuery
                , S.class [ S.mp_s, S.ml_7 ]
                ] []
            , a [ Route.href Route.Search ]
                [ button [ type_ "button", S.class [ S.mp_s_button ], onClick (Model.QueryQuery model.query)  ]
                    [ i [ S.class [ S.search_icon, S.p_15x, S.material_icons ] ] [ text "search" ]
                    ]
                ]
            ]
        ]
