module View exposing (view)

import Model
import Route
import Page
import Page.Home
import Page.Search
import Page.Entity


-- VIEW


view : Model.Model -> Model.Document Model.Msg
view model =
    case Route.fromUrl model.url of
        Just Route.Home ->
            Page.view "Home" Page.Home.view model

        Just Route.Search ->
            Page.view "Search" Page.Search.view model

        Just Route.Entity ->
            Page.view "Entity" Page.Entity.view model

        Nothing ->
            Page.view "Home" Page.Home.view model

