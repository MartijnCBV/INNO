module Model.QueryResp exposing (..)

import Model.DiscoveryEntity
import Model.Entity
import Json.Decode


type alias DiscoveryQueryResp =
    { searchCount : Int
    , value : Model.DiscoveryEntity.DiscoveryEntities
    }


type alias EntityQueryResp
    = Model.Entity.Entity


discoveryQueryRespDecoder : Json.Decode.Decoder DiscoveryQueryResp
discoveryQueryRespDecoder =
    Json.Decode.map2 DiscoveryQueryResp
        ( Json.Decode.field "@search.count" Json.Decode.int )
        ( Json.Decode.field "value" Model.DiscoveryEntity.discoveryEntitiesDecoder )


entityQueryRespDecoder : Json.Decode.Decoder EntityQueryResp
entityQueryRespDecoder =
    Json.Decode.field "entity" Model.Entity.entityDecoder