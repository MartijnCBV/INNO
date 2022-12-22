module Model exposing (..)

import Browser

import Browser.Navigation
import Model.QueryResp
import Url
import Html
import RemoteData
import Model.Entity


-- MODEL


type alias Model =
    { query : Query
    , key : Browser.Navigation.Key
    , url : Url.Url
    , queryResp : RemoteData.WebData Model.QueryResp.QueryResp
    , currentEntity : Model.Entity.Entity
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
    | QueryRespReceived (RemoteData.WebData Model.QueryResp.QueryResp)
    | QueryEntity Query
