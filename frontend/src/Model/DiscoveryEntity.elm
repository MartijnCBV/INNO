module Model.DiscoveryEntity exposing (..)

import Json.Decode


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

