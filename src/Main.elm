module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Page.Home as Home
import Url
import Html exposing (Html)

import Model.Result as Res

import Route
import Page
import Model exposing (Model)


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
        , view = Page.view "Home" Home.view
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
        , currentResult = Res.Result
            { title = ""
            , tags = []
            }
        , key = key
        , url = url
        }
    , Cmd.none
    )


-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | UpdateQuery String


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


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
