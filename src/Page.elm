module Page exposing (..)

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes exposing (..)


import Model exposing (Model)
import CSSWrapper as S
import Asset
import Route

view : String -> ( Model -> Html msg) -> Model -> Document msg
view title content model =
    { title = title
    , body =
        [ appHeader
        , main_ [] [ content model ]
        ]
    }


appHeader : Html msg
appHeader =
    header [ S.class [ S.pb_7 ] ]
        [ div [ S.class [ S.header ] ]
            [ div [ S.class [ S.mw ] ]
                [ div [ S.class [ S.px_7 ] ]
                    [ a [ Route.href Route.Home ]
                        [ img [ alt "Provincie Utrecht logo", S.class [ S.logo ], Asset.imageSrc Asset.logo ] []
                        ]
                    ]
                ]
            ]
        ]