module Page exposing (view)

import Browser
import Html
import Html.Attributes


import Model
import Css
import Asset
import Route

view : String -> ( Model.Model -> Html.Html msg ) -> Model.Model -> Browser.Document msg
view title content model =
    { title = title
    , body =
        [ appHeader
        , Html.main_ [] [ content model ]
        ]
    }


appHeader : Html.Html msg
appHeader =
    Html.header [ Css.class [ Css.pb_7 ] ]
        [ Html.div [ Css.class [ Css.header ] ]
            [ Html.div [ Css.class [ Css.mw ] ]
                [ Html.div [ Css.class [ Css.px_7 ] ]
                    [ Html.a [ Route.href Route.Home ]
                        [ Html.img [ Html.Attributes.alt "Provincie Utrecht logo", Css.class [ Css.logo ], Asset.imageSrc Asset.logo ] []
                        ]
                    ]
                ]
            ]
        ]
