module Page.Entity exposing (..)

import Html exposing (..)
import Html.Attributes
import Model.Error
import Model.Entity
import RemoteData
import CSSWrapper as S
import Asset
import Date
import Time
import String

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
        , div [ S.class [ S.bg_c_grey, S.r_corners, S.col_span_5, S.mt_6 ] ]
            [ div [ S.class [ S.mx_7 ] ] [ viewColumns model entity ]
            ]
        , div [ S.class [ S.bg_c_grey, S.r_corners, S.col_span_5, S.mt_6 ] ]
            [ div [ S.class [ S.mx_7 ] ]
                [ span [ S.class [ S.font_bold ] ] [ text "Locatie: " ]
                , a [ Html.Attributes.href entity.attributes.qualifiedName, S.class [ S.text_c_blue ] ] [ text entity.attributes.qualifiedName ]
                ]
            ]
        ]


viewGeneralInformation : Model.Model -> Model.Entity.Entity -> Html Model.Msg
viewGeneralInformation model entity =
    div [ S.class [ S.col_span_3 ] ]
        [ div [ S.class [ S.grid, S.grid_cols_5 ] ]
            [ div [ S.class [ S.mb_3 ] ] [ img [ Asset.getTypeIcon model.currentDiscoveryEntity.objectType ] [] ] --ICON
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
    div [ S.class [ S.col_span_2, S.bg_c_grey, S.r_corners ] ] [ div [ S.class [ S.ml_7, S.my_6 ] ]
        [ h1 [ S.class [ S.text_xl ] ] [ text "Kenmerken:" ]
        , div [] [ span [ S.class [ S.font_bold ] ] [ text "ID: " ], span [] [ text entity.guid ] ]
        , div [] [ span [ S.class [ S.font_bold ] ] [ text "Type: " ], span [] [ text model.currentDiscoveryEntity.objectType ] ]
        , div [] [ span [ S.class [ S.font_bold ] ] [ text "Bron: " ], span [] [ text entity.source ] ]
        -- , div [] [ span [ S.class [ S.font_bold ] ] [ text "Eigenaar: " ], span [] [ text entity.attributes.owner ] ]
        , div [] [ span [ S.class [ S.font_bold ] ] [ text "Gemaakt door: " ], span [] [ text entity.createdBy ] ]
        , div [] [ span [ S.class [ S.font_bold ] ] [ text "Gemaakt op: " ], span [] [ text ( viewTime entity.createTime ) ] ]
        , div [] [ span [ S.class [ S.font_bold ] ] [ text "Geüpdate door: " ], span [] [ text entity.updatedBy ] ]
        , div [] [ span [ S.class [ S.font_bold ] ] [ text "Geüpdate op: " ], span [] [ text ( viewTime entity.updateTime ) ] ]
        ] ] --REST


viewColumns : Model.Model -> Model.Entity.Entity -> Html Model.Msg
viewColumns model entity =
    if model.currentDiscoveryEntity.objectType == "Tables" then
        div [] [ span [ S.class [ S.font_bold ] ] [ text "Kolommen: " ], span [] [ text ( String.join ", " entity.columns ) ] ]
    else
        div [] []


viewTime : Int -> String
viewTime time =
    Date.toIsoString ( Date.fromPosix Time.utc ( Time.millisToPosix time ) )


viewEntityDescription : String -> String
viewEntityDescription description =
    if description == " " then "Er is geen omschrijving beschikbaar" else description

