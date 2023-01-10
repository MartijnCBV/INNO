module Update exposing (update)

import Model
import Browser
import Browser.Navigation
import Url
import Http
import RemoteData
import ServiceVars
import Model.QueryResp
import List.Extra
import Model.DiscoveryEntity
import Model.Entity


-- UPDATE


update : Model.Msg -> Model.Model -> ( Model.Model, Cmd Model.Msg )
update msg model =
    case msg of
        Model.UpdateQuery newQuery ->
            updateQuery model newQuery

        Model.LinkClicked urlRequest ->
            linkClicked model urlRequest

        Model.UrlChanged url ->
            urlChanged model url

        Model.QueryQuery query ->
            queryQuery model query

        Model.QueryRespReceived resp ->
            queryRespReceived model resp

        Model.QueryEntity discoveryEntity ->
            queryEntity model discoveryEntity

        Model.CurrentEntityReceived resp ->
            currentEntityReceived model resp

        Model.UpdateSortType sortType ->
            updateSortType model sortType

        Model.UpdateDropdownShown ->
            updateDropdownShown model

        Model.UpdateObjectTypeFilterShown ->
            updateObjectTypeFilterShown model

        Model.UpdateGlossaryTermFilterShown ->
            updateGlossaryTermFilterShown model

        Model.UpdateObjectTypesNotShown strings ->
            updateObjectTypesNotShown model strings

        Model.AddObjectTypeNotShown string ->
            addObjectTypeNotShown model string

        Model.RemoveObjectTypeNotShown string ->
            removeObjectTypeNotShown model string

        Model.UpdateExtensionFilterShown ->
            updateExtensionFilterShown model

        Model.UpdateExtensionsNotShown strings ->
            updateExtensionsNotShown model strings

        Model.AddExtensionNotShown string ->
            addExtensionNotShown model string

        Model.RemoveExtensionNotShown string ->
            removeExtensionNotShown model string


updateQuery : Model.Model -> String -> ( Model.Model, Cmd Model.Msg )
updateQuery m e =
    ( { m | query = e }
    , Cmd.none
    )


linkClicked : Model.Model -> Browser.UrlRequest -> ( Model.Model, Cmd Model.Msg )
linkClicked m e =
    case e of
        Browser.Internal url ->
            ( m
            , Browser.Navigation.pushUrl m.key ( Url.toString url )
            )
        Browser.External href ->
            ( m
            , Browser.Navigation.load href
            )


urlChanged : Model.Model -> Url.Url -> ( Model.Model, Cmd Model.Msg )
urlChanged m e =
    ( { m | url = e }
    , Cmd.none
    )


queryQuery : Model.Model -> String -> ( Model.Model, Cmd Model.Msg )
queryQuery m e =
    ( { m | queryResp = RemoteData.NotAsked }
    , getQueryResp e
    )


queryRespReceived : Model.Model -> ( RemoteData.WebData Model.QueryResp.DiscoveryQueryResp ) -> ( Model.Model, Cmd Model.Msg )
queryRespReceived m e =
    ( resetExtensionsNotShown ( resetObjectTypesNotShown { m | queryResp = e } )
    , Cmd.none
    )


queryEntity: Model.Model -> Model.DiscoveryEntity.DiscoveryEntity -> ( Model.Model, Cmd Model.Msg )
queryEntity m e =
    ( updateCurrentDiscoveryEntity e { m | currentEntity = RemoteData.NotAsked }
    , getCurrentEntity e.guid
    )


currentEntityReceived : Model.Model -> ( RemoteData.WebData Model.Entity.Entity ) -> ( Model.Model, Cmd Model.Msg )
currentEntityReceived m e =
    ( { m | currentEntity = e }
    , Cmd.none
    )


updateSortType : Model.Model -> Model.DiscoveryEntity.SortType -> ( Model.Model, Cmd Model.Msg )
updateSortType m e =
    ( Tuple.first ( updateDropdownShown { m | sortType = e } )
    , Cmd.none
    )


updateDropdownShown : Model.Model -> ( Model.Model, Cmd Model.Msg )
updateDropdownShown m =
    ( { m | dropdownShown = not m.dropdownShown }
    , Cmd.none
    )


updateObjectTypeFilterShown : Model.Model -> ( Model.Model, Cmd Model.Msg )
updateObjectTypeFilterShown m =
    ( { m | objectTypeFilterShown = not m.objectTypeFilterShown }
    , Cmd.none
    )


updateExtensionFilterShown : Model.Model -> ( Model.Model, Cmd Model.Msg )
updateExtensionFilterShown m =
    ( { m | extensionFilterShown = not m.extensionFilterShown }
    , Cmd.none
    )


updateGlossaryTermFilterShown : Model.Model -> ( Model.Model, Cmd Model.Msg )
updateGlossaryTermFilterShown m =
    ( { m | glossaryTermFilterShown = not m.glossaryTermFilterShown }
    , Cmd.none
    )


updateObjectTypesNotShown : Model.Model -> ( List String ) -> ( Model.Model, Cmd Model.Msg )
updateObjectTypesNotShown m e =
    ( { m | objectTypesNotShown = e }
    , Cmd.none
    )


addObjectTypeNotShown : Model.Model -> String -> ( Model.Model, Cmd Model.Msg )
addObjectTypeNotShown m e =
    ( { m | objectTypesNotShown = ( List.Extra.unique ( e :: m.objectTypesNotShown ) ) }
    , Cmd.none
    )


removeObjectTypeNotShown : Model.Model -> String -> ( Model.Model, Cmd Model.Msg )
removeObjectTypeNotShown m e =
    ( { m | objectTypesNotShown = ( List.filter ( \x -> x /= e ) m.objectTypesNotShown ) }
    , Cmd.none
    )


updateExtensionsNotShown : Model.Model -> ( List String ) -> ( Model.Model, Cmd Model.Msg )
updateExtensionsNotShown m e =
    ( { m | extensionsNotShown = e }
    , Cmd.none
    )


addExtensionNotShown : Model.Model -> String -> ( Model.Model, Cmd Model.Msg )
addExtensionNotShown m e =
    ( { m | extensionsNotShown = ( List.Extra.unique ( e :: m.extensionsNotShown ) ) }
    , Cmd.none
    )


removeExtensionNotShown : Model.Model -> String  -> ( Model.Model, Cmd Model.Msg )
removeExtensionNotShown m e =
    ( { m | extensionsNotShown = ( List.filter ( \x -> x /= e ) m.extensionsNotShown ) }
    , Cmd.none
    )


updateCurrentDiscoveryEntity : Model.DiscoveryEntity.DiscoveryEntity -> Model.Model -> Model.Model
updateCurrentDiscoveryEntity discoveryEntity model =
    { model | currentDiscoveryEntity = discoveryEntity }


-- UPDATE UTIL


resetObjectTypesNotShown : Model.Model -> Model.Model
resetObjectTypesNotShown model =
    { model | objectTypesNotShown = [] }


resetExtensionsNotShown : Model.Model -> Model.Model
resetExtensionsNotShown model =
    { model | extensionsNotShown = [] }


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

