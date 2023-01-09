module Model.Entity exposing (..)

import Json.Decode
import Json.Decode.Extra


type alias Entity =
    { typeName : String
    , attributes : Attributes
    , guid : String
    , createdBy : String
    , updatedBy : String
    , createTime : Int
    , updateTime : Int
    , source : String
    , columns : List String
    -- Labels
    }


type alias Attributes =
    { owner : String
    , isFile : Bool
    , qualifiedName : String -- SOURCE
    , description : String
    , name : String
    , contentType : String
    }


entityDecoder : Json.Decode.Decoder Entity
entityDecoder =
    Json.Decode.succeed Entity
        |> Json.Decode.Extra.andMap ( Json.Decode.field "typeName" Json.Decode.string )
        |> Json.Decode.Extra.andMap ( Json.Decode.field "attributes" noIsFileAttributeDecoder )
        |> Json.Decode.Extra.andMap ( Json.Decode.field "guid" Json.Decode.string )
        |> Json.Decode.Extra.andMap ( Json.Decode.field "createdBy" Json.Decode.string )
        |> Json.Decode.Extra.andMap ( Json.Decode.field "updatedBy" Json.Decode.string )
        |> Json.Decode.Extra.andMap ( Json.Decode.field "createTime" Json.Decode.int )
        |> Json.Decode.Extra.andMap ( Json.Decode.field "updateTime" Json.Decode.int )
        |> Json.Decode.Extra.andMap ( Json.Decode.field "source" Json.Decode.string )
        |> Json.Decode.Extra.andMap nullableColumnsDecoder


attributesDecoder : Json.Decode.Decoder Attributes
attributesDecoder =
    Json.Decode.map6 Attributes
        ( Json.Decode.field "owner" nullableStringDecoder )
        ( Json.Decode.field "isFile" Json.Decode.bool )
        ( Json.Decode.field "qualifiedName" Json.Decode.string )
        ( Json.Decode.field "userDescription" nullableStringDecoder )
        ( Json.Decode.field "name" Json.Decode.string )
        ( Json.Decode.field "contentType" nullableStringDecoder )


attributesTableDecoder : Json.Decode.Decoder Attributes
attributesTableDecoder =
    Json.Decode.map6 Attributes
        ( Json.Decode.field "owner" nullableStringDecoder )
        ( Json.Decode.succeed False )
        ( Json.Decode.field "qualifiedName" Json.Decode.string )
        ( Json.Decode.field "description" nullableStringDecoder )
        ( Json.Decode.field "name" Json.Decode.string )
        ( Json.Decode.succeed " " )


nullableStringDecoder : Json.Decode.Decoder String
nullableStringDecoder =
    Json.Decode.oneOf
    [ Json.Decode.null " "
    , Json.Decode.string
    ]


noIsFileAttributeDecoder : Json.Decode.Decoder Attributes
noIsFileAttributeDecoder =
    Json.Decode.oneOf
    [ attributesDecoder
    , attributesTableDecoder
    ]


columnsDecoder : Json.Decode.Decoder ( List String )
columnsDecoder =
    ( Json.Decode.field "relationshipAttributes"
        ( Json.Decode.field "columns"
            ( Json.Decode.list ( Json.Decode.field "displayText" Json.Decode.string ) )
        )
    )


nullableColumnsDecoder : Json.Decode.Decoder ( List String )
nullableColumnsDecoder =
    Json.Decode.oneOf
    [ columnsDecoder
    , Json.Decode.succeed []
    ]
