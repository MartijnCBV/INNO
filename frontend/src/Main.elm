module Main exposing (main)

import Browser
import Browser.Navigation
import Url
import Model
import View
import Update
import RemoteData


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
    ( { results = []
      , tags = []
      , query = ""
      , currentResult = Model.Result_
          { title = ""
          , tags = []
          , subject = ""
          , description = Model.Description
              { longDescription = ""
              , shortDescription = ""
              }
          }
      , key = key
      , url = url
      , queryResp = RemoteData.NotAsked
      }
    , Cmd.none
    )


-- SUBSCRIPTIONS


subscriptions : Model.Model -> Sub Model.Msg
subscriptions _ =
    Sub.none
