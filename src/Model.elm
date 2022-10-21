module Model exposing (..)

import Browser

import Model.Result as Res
import Model.Query as Query
import Model.Tag as Tag
import Browser.Navigation as Nav
import Url


type alias Model =
    { results : Res.Results
    , tags : Tag.Tags
    , query : Query.Query
    , currentResult : Res.Result
    , key : Nav.Key
    , url : Url.Url
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | UpdateQuery String