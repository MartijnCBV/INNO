module Page.Entity exposing (..)

import Html exposing (..)
import Model.Error
import Model.Entity
import RemoteData
import CSSWrapper as S
import Asset

import Model

view : Model.Model -> Html Model.Msg
view model =
    viewEntity model


viewEntity : Model.Model -> Html Model.Msg
viewEntity model =
    case model.currentEntity of
        RemoteData.NotAsked -> text "Initialising"

        RemoteData.Loading -> text "loading"

        RemoteData.Failure err -> text ( "Error: " ++ Model.Error.errorToString err )

        RemoteData.Success resp -> viewEntityInformation model resp


viewEntityInformation : Model.Model -> Model.Entity.Entity -> Html Model.Msg
viewEntityInformation model entity =
    div [ S.class [ S.mw, S.grid, S.grid_cols_5, S.px_7 ] ]
        [ viewGeneralInformation model entity
        , viewAttributeInformation model entity
        ]


viewGeneralInformation : Model.Model -> Model.Entity.Entity -> Html Model.Msg
viewGeneralInformation model entity =
    div [ S.class [ S.col_span_3 ] ]
        [ div [ S.class [ S.grid, S.grid_cols_5 ] ]
            [ div [ S.class [ S.mb_3 ] ] [ img [ Asset.imageSrc Asset.fileIcon ] [] ] --ICON
            , h1 [ S.class
                [ S.text_2xl
                , S.col_span_4
                , S.mt_6
                ] ] [ text entity.attributes.name ] --TITLE
            ]
        , div [ S.class [ S.mb_4 ] ] --DESC
            [ h1 [ S.class [ S.text_xl ] ] [ text "Omschrijving:" ]
            , p [] [ text ( viewEntityDescription entity.attributes.description ) ]
            ]
        ]


viewAttributeInformation : Model.Model -> Model.Entity.Entity -> Html Model.Msg
viewAttributeInformation model entity =
    div [ S.class [ S.col_span_2 ] ] [ text "TEST" ] --REST


viewEntityDescription : String -> String
viewEntityDescription description =
    if description == " " then "Er is geen omschrijving beschikbaar" else description

