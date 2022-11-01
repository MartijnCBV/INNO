module Model exposing (..)

import Browser

import Browser.Navigation as Nav
import Url


-- MODEL


type alias Model =
    { results : Results
    , tags : Tags
    , query : Query
    , currentResult : Result
    , key : Nav.Key
    , url : Url.Url
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | UpdateQuery String
    | ResultClicked Result


type Result =
    Result
        { title : Title
        , tags : Tags
        }


type alias  Results =
    List Result


type alias Title =
    String


type alias Tag =
    String


type alias Tags =
    List Tag


type alias Query =
    String
