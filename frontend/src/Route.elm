module Route exposing (Route(..), href, fromUrl)

import Url.Parser
import Html
import Html.Attributes
import Url


type Route
    = Home
    | Search
    | Entity


routeParser : Url.Parser.Parser ( Route -> a ) a
routeParser =
    Url.Parser.oneOf
        [ Url.Parser.map Home Url.Parser.top
        , Url.Parser.map Search ( Url.Parser.s "search" )
        , Url.Parser.map Entity ( Url.Parser.s "entity" )
        ]


href : Route -> Html.Attribute msg
href target =
    Html.Attributes.href (routeToString target)

-- UNUSED
{-
replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key ( routeToString route )
-}


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
    |> Url.Parser.parse routeParser


routeToString : Route -> String
routeToString route =
    "#/" ++ String.join "/" (routeToPieces route)


routeToPieces : Route -> List String
routeToPieces route =
    case route of
        Home ->
            []

        Search ->
            [ "search" ]

        Entity ->
            [ "entity" ]
