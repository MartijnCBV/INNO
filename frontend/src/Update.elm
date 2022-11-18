module Update exposing (update)

import Model
import Browser
import Browser.Navigation as Nav
import Url
import Http
import Json.Decode
import Json.Encode
import RemoteData


-- UPDATE


update : Model.Msg -> Model.Model -> ( Model.Model, Cmd Model.Msg )
update msg model =
    case msg of
        Model.UpdateQuery newQuery ->
            ( { model | query = newQuery }
            , Cmd.none
            )

        Model.LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key ( Url.toString url )
                    )
                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        Model.UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        Model.ResultClicked res ->
            ( { model | currentResult = res }
            , Cmd.none
            )

        Model.QueryQuery query ->
            ( model
            , getQueryResp query
            )

        Model.QueryRespReceived res ->
            ( { model | queryResp = res }
            , Cmd.none
            )


-- HTTP


getQueryResp : Model.Query -> Cmd Model.Msg
getQueryResp query =
    Http.post
        { url = "http://localhost:7071/api/QueryHttpTrigger"
        , body = Http.jsonBody ( queryEncoder query )
        , expect = Http.expectJson ( RemoteData.fromResult >> Model.QueryRespReceived ) queryRespDecoder
        }


queryRespDecoder : Json.Decode.Decoder Model.QueryResp
queryRespDecoder =
    Json.Decode.map2 Model.QueryResp
        (Json.Decode.field "query" Json.Decode.string)
        (Json.Decode.field "req" Json.Decode.string)


queryEncoder : Model.Query -> Json.Encode.Value
queryEncoder query =
    Json.Encode.object [ ( "query", Json.Encode.string query ) ]
