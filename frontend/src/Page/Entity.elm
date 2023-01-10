module Page.Entity exposing (..)

import Html
import Html.Attributes
import Model.Error
import Model.Entity
import RemoteData
import Css
import Asset
import Date
import Time
import String
import Html.Parser
import Html.Parser.Util
import Model

view : Model.Model -> Html.Html Model.Msg
view model =
    viewEntity model


viewEntity : Model.Model -> Html.Html Model.Msg
viewEntity model =
    case model.currentEntity of
        RemoteData.NotAsked -> Html.text "Initialising"

        RemoteData.Loading -> Html.text "loading"

        RemoteData.Failure err -> Html.text ( "Error: " ++ Model.Error.errorToString err )

        RemoteData.Success resp -> viewEntityInformation model resp


viewEntityInformation : Model.Model -> Model.Entity.Entity -> Html.Html Model.Msg
viewEntityInformation model entity =
    Html.div [ Css.class [ Css.mw, Css.grid, Css.grid_cols_5, Css.px_7 ] ]
        [ viewGeneralInformation model entity
        , viewAttributeInformation model entity
        , Html.div [ Css.class [ Css.bg_c_grey, Css.r_corners, Css.col_span_5, Css.mt_6 ] ]
            [ Html.div [ Css.class [ Css.mx_7 ] ] [ viewColumns model entity ]
            ]
        , Html.div [ Css.class [ Css.bg_c_grey, Css.r_corners, Css.col_span_5, Css.mt_6 ] ]
            [ Html.div [ Css.class [ Css.mx_7 ] ]
                [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Locatie: " ]
                , Html.a [ Html.Attributes.href entity.attributes.qualifiedName, Css.class [ Css.text_c_blue ] ] [ Html.text entity.attributes.qualifiedName ]
                ]
            ]
        ]


viewGeneralInformation : Model.Model -> Model.Entity.Entity -> Html.Html Model.Msg
viewGeneralInformation model entity =
    Html.div [ Css.class [ Css.col_span_3 ] ]
        [ Html.div [ Css.class [ Css.grid, Css.grid_cols_5 ] ]
            [ Html.div [ Css.class [ Css.mb_3 ] ] [ Html.img [ Asset.getTypeIcon model.currentDiscoveryEntity.objectType ] [] ] --ICON
            , Html.h1 [ Css.class
                [ Css.text_2xl
                , Css.col_span_4
                , Css.mt_6
                ] ] [ Html.text entity.attributes.name ] --TITLE
            ]
        , Html.div [ Css.class [ Css.mb_4 ] ] --DESC
            [ Html.h1 [ Css.class [ Css.text_xl ] ] [ Html.text "Omschrijving:" ]
            , Html.p [] ( textHtml ( viewEntityDescription entity.attributes.description ) )
            ]
        ]


viewAttributeInformation : Model.Model -> Model.Entity.Entity -> Html.Html Model.Msg
viewAttributeInformation model entity =
    Html.div [ Css.class [ Css.col_span_2, Css.bg_c_grey, Css.r_corners ] ] [ Html.div [ Css.class [ Css.ml_7, Css.my_6 ] ]
        [ Html.h1 [ Css.class [ Css.text_xl ] ] [ Html.text "Kenmerken:" ]
        , Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "ID: " ], Html.span [] [ Html.text entity.guid ] ]
        , Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Type: " ], Html.span [] [ Html.text model.currentDiscoveryEntity.objectType ] ]
        , Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Bron: " ], Html.span [] [ Html.text entity.source ] ]
        -- , div [] [ span [ Css.class [ Css.font_bold ] ] [ text "Eigenaar: " ], span [] [ text entity.attributes.owner ] ]
        , Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Gemaakt door: " ], Html.span [] [ Html.text entity.createdBy ] ]
        , Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Gemaakt op: " ], Html.span [] [ Html.text ( viewTime entity.createTime ) ] ]
        , Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Geüpdate door: " ], Html.span [] [ Html.text entity.updatedBy ] ]
        , Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Geüpdate op: " ], Html.span [] [ Html.text ( viewTime entity.updateTime ) ] ]
        ] ] --REST


viewColumns : Model.Model -> Model.Entity.Entity -> Html.Html Model.Msg
viewColumns model entity =
    if model.currentDiscoveryEntity.objectType == "Tables" then
        Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Kolommen: " ], Html.span [] [ Html.text ( String.join ", " entity.columns ) ] ]
    else
        Html.div [] []


viewTime : Int -> String
viewTime time =
    Date.toIsoString ( Date.fromPosix Time.utc ( Time.millisToPosix time ) )


viewEntityDescription : String -> String
viewEntityDescription description =
    if description == " " then
        "<div>Er is geen omschrijving beschikbaar<div>"
    else
        description


textHtml : String -> List (Html.Html msg)
textHtml t =
    case Html.Parser.run t of
        Ok nodes ->
            Html.Parser.Util.toVirtualDom nodes

        Err _ ->
            []

