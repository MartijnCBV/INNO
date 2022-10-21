module Page.Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model exposing (Model, Msg(..))
import CSSWrapper as S
import Route


-- VIEW


view : Model -> Html Msg
view model =
    div [ S.class [ S.bg_image ] ]
        [ h1 [ S.class [ S.pt_10, S.mp_text ] ]
            [ span [ S.class [ S.mp_span, S.p_7, S.mx_7 ] ] [ text "Zoek in data" ]
            ]
        , searchBar model
        ]


searchBar : Model -> Html Msg
searchBar model =
    div [ S.class [ S.mt_32px ] ]
        [ label
            [ for "searchbar"
            , type_ "text"
            , placeholder "Zoek in data"
            , S.class [ S.hidden ]
            ] []
        , div [ S.class [ S.wh_full_mw_fit ] ]
            [ input
                [ id "searchbar"
                , type_ "text"
                , placeholder "Zoek in data"
                , value model.query
                , onInput UpdateQuery
                , S.class [ S.mp_s, S.ml_7 ]
                ] []
            , a [ Route.href Route.Search ]
                [ button [ type_ "button", S.class [ S.mp_s_button ]  ]
                    [ i [ S.class [ S.search_icon, S.p_15x, S.material_icons ] ] [ text "search" ]
                    ]
                ]
            ]
        ]
