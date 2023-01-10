module Html.Util exposing (..)

import Html
import Html.Parser
import Html.Parser.Util
import Date
import Time


textToHtml : String -> List (Html.Html msg)
textToHtml t =
    case Html.Parser.run t of
        Ok nodes ->
            Html.Parser.Util.toVirtualDom nodes

        Err _ ->
            []


timeToString : Int -> String
timeToString t =
    Date.toIsoString ( Date.fromPosix Time.utc ( Time.millisToPosix t ) )