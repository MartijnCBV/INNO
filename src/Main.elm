module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Url
import Model exposing (Model, Msg(..), ContactData, MetaData, Description)
import View exposing (view)
import Update exposing (update)


-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


-- MODEL


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { results = []
      , tags = []
      , query = ""
      , currentResult = Model.Result
          { title = ""
          , tags = []
          , subject = ""
          , description = Description
              { longDescription = ""
              , shortDescription = ""
              }
          , contactData = ContactData
          , metaData = MetaData
          }
      , key = key
      , url = url
      }
    , Cmd.none
    )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
