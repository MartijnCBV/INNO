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

