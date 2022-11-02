module Model exposing (..)

import Browser

import Browser.Navigation as Nav
import Url
import Html exposing (Html)


-- MODEL


type alias Model =
    { results : Results
    , tags : Tags
    , query : Query
    , currentResult : Result
    , key : Nav.Key
    , url : Url.Url
    }


type alias Document msg =
    { title : String
    , body : List (Html msg)
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
        , subject : Subject
        , description : Description
        , contactData : ContactData
        , metaData : MetaData
        }


type alias Results =
    List Result


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


type ContactData =
    ContactData


type MetaData =
    MetaData


type alias Query =
    String
