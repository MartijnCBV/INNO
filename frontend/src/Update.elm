module Update exposing (update)

import Model exposing (Model, Msg(..))
import Browser
import Browser.Navigation as Nav
import Url


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
