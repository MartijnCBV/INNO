module View exposing (view)

import Model
import Route
import Page
import Page.Home as Home
import Page.Search as Search


-- VIEW


view : Model.Model -> Model.Document Model.Msg
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

