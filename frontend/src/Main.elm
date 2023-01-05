module Main exposing (main)

import Browser
import Browser.Navigation
import Url
import Model
import View
import Update
import RemoteData
import Model.DiscoveryEntity


-- MAIN


main : Program () Model.Model Model.Msg
main =
    Browser.application
        { init = init
        , update = Update.update
        , view = View.view
        , subscriptions = subscriptions
        , onUrlChange = Model.UrlChanged
        , onUrlRequest = Model.LinkClicked
        }


-- MODEL


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model.Model, Cmd Model.Msg )
init _ url key =
    ( { query = ""
      , key = key
      , url = url
      , queryResp = RemoteData.NotAsked
      , currentEntity = RemoteData.NotAsked
      , sortType = Model.DiscoveryEntity.Relevance
      , dropdownShown = False
      , currentDiscoveryEntity = initDiscoveryEntity
      }
    , Cmd.none
    )


initDiscoveryEntity : Model.DiscoveryEntity.DiscoveryEntity
initDiscoveryEntity =
    { objectType = ""
    , updateTime = 0
    , name = ""
    , searchScore = 0
    ,guid = ""
    }


-- SUBSCRIPTIONS


subscriptions : Model.Model -> Sub Model.Msg
subscriptions _ =
    Sub.none
