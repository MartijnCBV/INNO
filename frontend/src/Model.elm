module Model exposing (..)

import Browser

import Browser.Navigation
import Model.QueryResp
import Url
import Html
import RemoteData
import Model.Entity
import Model.DiscoveryEntity


-- MODEL


type alias Model =
    { query : Query
    , key : Browser.Navigation.Key
    , url : Url.Url
    , queryResp : RemoteData.WebData Model.QueryResp.DiscoveryQueryResp
    , currentEntity : RemoteData.WebData Model.Entity.Entity
    , sortType : Model.DiscoveryEntity.SortType
    , dropdownShown : Bool
    , currentDiscoveryEntity : Model.DiscoveryEntity.DiscoveryEntity
    , objectTypeFilterShown : Bool
    , extensionFilterShown : Bool
    , glossaryTermFilterShown : Bool
    , objectTypesNotShown : List String
    , extensionsNotShown : List String
    }


type alias Query =
    String


type alias Document msg =
    { title : String
    , body : List (Html.Html msg)
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | UpdateQuery Query
    | QueryQuery Query
    | QueryRespReceived ( RemoteData.WebData Model.QueryResp.DiscoveryQueryResp )
    | QueryEntity Model.DiscoveryEntity.DiscoveryEntity
    | CurrentEntityReceived ( RemoteData.WebData Model.Entity.Entity )
    | UpdateSortType Model.DiscoveryEntity.SortType
    | UpdateDropdownShown
    | UpdateObjectTypeFilterShown
    | UpdateExtensionFilterShown
    | UpdateGlossaryTermFilterShown
    | UpdateObjectTypesNotShown ( List String )
    | AddObjectTypeNotShown String
    | RemoveObjectTypeNotShown String
    | UpdateExtensionsNotShown ( List String )
    | AddExtensionNotShown String
    | RemoveExtensionNotShown String