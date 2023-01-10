module Model.DiscoveryEntity exposing (..)

import Json.Decode
import List.Extra


type alias DiscoveryEntity =
    { objectType : String
    , updateTime : Int
    , name : String
    , searchScore : Float
    , guid : String
    }


type alias DiscoveryEntities =
    List DiscoveryEntity


type SortType
    = Relevance
    | Name
    | DateAsc
    | DateDesc


-- SORT


sort : DiscoveryEntities -> SortType -> DiscoveryEntities
sort discoveryEntities sortType =
    case sortType of
        Relevance ->
            sortByRelevance discoveryEntities

        Name ->
            sortByName discoveryEntities

        DateAsc ->
            sortByDateAsc discoveryEntities

        DateDesc ->
            sortByDateDesc discoveryEntities


sortByRelevance : DiscoveryEntities -> DiscoveryEntities
sortByRelevance discoveryEntities =
    List.sortBy .searchScore discoveryEntities


sortByName : DiscoveryEntities -> DiscoveryEntities
sortByName discoveryEntities =
    List.sortBy .name discoveryEntities


sortByDateAsc : DiscoveryEntities -> DiscoveryEntities
sortByDateAsc discoveryEntities =
    List.sortBy .updateTime discoveryEntities


sortByDateDesc : DiscoveryEntities -> DiscoveryEntities
sortByDateDesc discoveryEntities =
    List.reverse ( sortByDateAsc discoveryEntities )


-- FILTER


isNotObjectType : String -> DiscoveryEntity -> Bool
isNotObjectType s e =
    s /= e.objectType


isObjectType : String -> DiscoveryEntity -> Bool
isObjectType s e =
    s == e.objectType


isObjectTypeIn : List String -> DiscoveryEntity -> Bool
isObjectTypeIn s e =
    not ( List.member e.objectType s )


getObjectTypes : DiscoveryEntities -> List String
getObjectTypes e =
    List.Extra.unique ( List.map .objectType e )


removeObjectType : String -> DiscoveryEntities -> DiscoveryEntities
removeObjectType s e =
    List.filter ( isNotObjectType s ) e


removeObjectTypes : List String -> DiscoveryEntities -> DiscoveryEntities
removeObjectTypes s e =
    List.filter ( isObjectTypeIn s ) e


removeGlossaryItems : DiscoveryEntities -> DiscoveryEntities
removeGlossaryItems e =
    removeObjectType "Glossary terms" e


getFileObjects : DiscoveryEntities -> DiscoveryEntities
getFileObjects e =
    List.filter ( isObjectType "Files" ) e


getLastElem : List a -> Maybe a
getLastElem a =
    List.head ( List.reverse a )


getExtension : DiscoveryEntity -> String
getExtension e =
    case getLastElem ( String.split "." e.name ) of
        Just a ->
            a

        Nothing ->
            ""


getExtensions : DiscoveryEntities -> List String
getExtensions e =
    List.filter ( \s -> s /= "" ) ( List.Extra.unique ( List.map getExtension ( getFileObjects e ) ) )


removeExtension : String -> DiscoveryEntities -> DiscoveryEntities
removeExtension s e =
    List.filter ( \a -> ( getExtension a ) /= s ) e


removeExtensions : List String -> DiscoveryEntities -> DiscoveryEntities
removeExtensions s e =
    List.filter ( \a -> not ( List.member ( getExtension a ) s ) ) e


-- DECODERS


discoveryEntityDecoder : Json.Decode.Decoder DiscoveryEntity
discoveryEntityDecoder =
    Json.Decode.map5 DiscoveryEntity
        ( Json.Decode.field "objectType" Json.Decode.string )
        ( Json.Decode.field "updateTime" Json.Decode.int )
        ( Json.Decode.field "name" Json.Decode.string )
        ( Json.Decode.field "@search.score" Json.Decode.float )
        ( Json.Decode.field "id" Json.Decode.string )


discoveryEntitiesDecoder : Json.Decode.Decoder DiscoveryEntities
discoveryEntitiesDecoder =
    Json.Decode.list discoveryEntityDecoder

