module Update exposing (update)

import Model
import Browser
import Browser.Navigation
import Url
import Http
import RemoteData
import ServiceVars
import Model.QueryResp
import Model.Entity
import Model.DiscoveryEntity


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
                    , Browser.Navigation.pushUrl model.key ( Url.toString url )
                    )
                Browser.External href ->
                    ( model
                    , Browser.Navigation.load href
                    )

        Model.UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        Model.QueryQuery query ->
            ( { model | queryResp = RemoteData.NotAsked }
            , getQueryResp query
            )

        Model.QueryRespReceived res ->
            ( { model | queryResp = res }
            , Cmd.none
            )

        Model.QueryEntity discoveryEntity ->
            ( updateCurrentDiscoveryEntity discoveryEntity { model | currentEntity = RemoteData.NotAsked }
            , getCurrentEntity discoveryEntity.guid
            )

        Model.CurrentEntityReceived res ->
            ( { model | currentEntity = res }
            , Cmd.none
            )

        Model.UpdateSortType sortType ->
            ( updateDropdownShown { model | sortType = sortType }
            , Cmd.none
            )

        Model.UpdateDropdownShown ->
            ( updateDropdownShown model
            , Cmd.none
            )


updateCurrentDiscoveryEntity : Model.DiscoveryEntity.DiscoveryEntity -> Model.Model -> Model.Model
updateCurrentDiscoveryEntity discoveryEntity model =
    { model | currentDiscoveryEntity = discoveryEntity }


updateDropdownShown : Model.Model -> Model.Model
updateDropdownShown model =
    { model | dropdownShown = not model.dropdownShown }


-- HTTP


getQueryResp : Model.Query -> Cmd Model.Msg
getQueryResp query =
    Http.get
        { url = ServiceVars.discoveryEP ++ "?query=" ++ query
        , expect = Http.expectJson ( RemoteData.fromResult >> Model.QueryRespReceived ) Model.QueryResp.discoveryQueryRespDecoder
        }


getCurrentEntity : Model.Query -> Cmd Model.Msg
getCurrentEntity query =
    Http.get
        { url = ServiceVars.entityEP ++ "?query=" ++ query
        , expect = Http.expectJson ( RemoteData.fromResult >> Model.CurrentEntityReceived ) Model.QueryResp.entityQueryRespDecoder
        }

