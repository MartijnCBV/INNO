module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Page.Home as Home
import Page.Search as Search
import Url
import Html exposing (Html)

import Route
import Page
import Model exposing (Model, Msg(..))


-- MAIN


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }


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
          }
      , key = key
      , url = url
      }
    , Cmd.none
    )


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateQuery newQuery ->
            ( { model | query = newQuery }
            , Cmd.none
            )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key ( Url.toString url )
                    )
                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        ResultClicked res ->
            ( { model | currentResult = res }
            , Cmd.none
            )


-- VIEW


view : Model -> Document Msg
view model =
    case Route.fromUrl model.url of
        Just Route.Home ->
            Page.view "Home" Home.view model

        Just Route.Search ->
            Page.view "Search" Search.view model

        Just Route.Result ->
            Page.view "Home" Home.view model

        Nothing ->
            Page.view "Home" Home.view model


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
