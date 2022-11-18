module Model exposing (..)

import Browser

import Browser.Navigation as Nav
import Url
import Html
import Http
import RemoteData


-- MODEL


type alias Model =
    { results : Results_
    , tags : Tags
    , query : Query
    , currentResult : Result_
    , key : Nav.Key
    , url : Url.Url
    , queryResp : RemoteData.WebData QueryResp
    }


type alias QueryResp =
    { query : String
    , req : String
    }


type alias Document msg =
    { title : String
    , body : List (Html.Html msg)
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | UpdateQuery Query
    | ResultClicked Result_
    | QueryQuery Query
    | QueryRespReceived (RemoteData.WebData QueryResp)


type Result_ =
    Result_
        { title : Title
        , tags : Tags
        , subject : Subject
        , description : Description
        }


type alias Results_ =
    List Result_


type alias Title =
    String


type alias Tag =
    String


type alias Tags =
    List Tag


type alias Subject =
    String


type Description =
    Description
        { longDescription : LongDescription
        , shortDescription : ShortDescription
        }


type alias LongDescription =
    String


type alias ShortDescription =
    String


-- TEMP
{-
type ContactData =
    ContactData


type MetaData =
    MetaData
-}


type alias Query =
    String
