module Model.QueryResp exposing (..)

import Model.DiscoveryEntity
import Json.Decode


type alias QueryResp =
    { searchCount : Int
    , value : Model.DiscoveryEntity.DiscoveryEntities
    }


queryRespDecoder : Json.Decode.Decoder QueryResp
queryRespDecoder =
    Json.Decode.map2 QueryResp
        ( Json.Decode.field "@search.count" Json.Decode.int )
        ( Json.Decode.field "value" Model.DiscoveryEntity.discoveryEntitiesDecoder )

