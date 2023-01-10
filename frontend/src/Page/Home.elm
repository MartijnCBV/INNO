module Page.Home exposing (..)

import Html
import Html.Attributes
import Html.Events

import Model
import Css
import Route


-- VIEW


view : Model.Model -> Html.Html Model.Msg
view model =
    Html.div [ Css.class [ Css.bg_image ] ]
        [ Html.div [ Css.class [ Css.mw ] ]
            [ Html.h1 [ Css.class [ Css.pt_10, Css.mp_text ] ] [ Html.span [ Css.class [ Css.mp_span, Css.p_7, Css.mx_7 ] ] [ Html.text "Zoek in datacatalogus" ] ]
            , searchBar model
            , Html.h1 [ Css.class [ Css.pt_10, Css.mp_text_small ] ] [ Html.span [ Css.class [ Css.mp_span_small, Css.p_15x, Css.mx_7, Css.mt_6 ] ] [ Html.text description ] ]
            ]
        ]


description : String
description = "Welkom op de data catalogus van de provincie Utrecht. Op deze pagina is er de mogelijkheid om te zoeken naar alle datasets en informatieproducten die binnen de organisatie beschikbaar zijn. Voer een zoekterm in, voeg filters toe op de resultaten en vindt de juiste dataset."


searchBar : Model.Model -> Html.Html Model.Msg
searchBar model =
    Html.div [ Css.class [ Css.mt_32px ] ]
        [ Html.label
            [ Html.Attributes.for "searchbar"
            , Html.Attributes.type_ "text"
            , Html.Attributes.placeholder "Zoek in datacatalogus"
            , Css.class [ Css.hidden ]
            ] []
        , Html.div [ Css.class [ Css.wh_full_mw_fit ] ]
            [ Html.input
                [ Html.Attributes.id "searchbar"
                , Html.Attributes.type_ "text"
                , Html.Attributes.placeholder "Zoek in datacatalogus"
                , Html.Attributes.value model.query
                , Html.Events.onInput Model.UpdateQuery
                , Css.class [ Css.mp_s, Css.ml_7 ]
                ] []
            , Html.a [ Route.href Route.Search ]
                [ Html.button [ Html.Attributes.type_ "button", Css.class [ Css.mp_s_button ], Html.Events.onClick (Model.QueryQuery model.query)  ]
                    [ Html.i [ Css.class [ Css.search_icon, Css.p_15x, Css.material_icons ] ] [ Html.text "search" ]
                    ]
                ]
            ]
        ]
