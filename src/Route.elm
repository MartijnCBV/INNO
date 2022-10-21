module Route exposing (..)

import Url.Parser as Parser exposing ((</>), (<?>), Parser, map, oneOf, s, top)
import Html exposing (Attribute)
import Html.Attributes as Attr
import Browser.Navigation as Nav
import Url


type Route
    = Home
    | Search
    | Result


routeParser : Parser ( Route -> a ) a
routeParser =
    oneOf
        [ map Home top
        , map Search ( s "search" )
        , map Result ( s "result" )
        ]


href : Route -> Attribute msg
href target =
    Attr.href (routeToString target)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key ( routeToString route )


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse routeParser


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

        Result ->
            [ "result" ]
