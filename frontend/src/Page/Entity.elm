module Page.Entity exposing (..)

import Html
import Html.Attributes
import Model.Error
import Model.Entity
import RemoteData
import Css
import Asset
import String
import Html.Util
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
        , viewColumnInformation model entity
        , viewQualifiedName entity
        ]


viewGeneralInformation : Model.Model -> Model.Entity.Entity -> Html.Html Model.Msg
viewGeneralInformation model entity =
    Html.div [ Css.class [ Css.col_span_3 ] ]
        [ viewTitle model entity
        , viewDescription entity
        ]


viewTitle : Model.Model -> Model.Entity.Entity -> Html.Html Model.Msg
viewTitle model entity =
    Html.div [ Css.class [ Css.grid, Css.grid_cols_5 ] ]
        [ Html.div [ Css.class [ Css.mb_3 ] ] [ Html.img [ Asset.getTypeIcon model.currentDiscoveryEntity.objectType ] [] ] --ICON
        , Html.h1 [ Css.class [ Css.text_2xl, Css.col_span_4, Css.mt_6] ] [ Html.text entity.attributes.name ] --TITLE
        ]


viewDescription : Model.Entity.Entity -> Html.Html Model.Msg
viewDescription entity =
    Html.div [ Css.class [ Css.mb_4 ] ]
        [ Html.h1 [ Css.class [ Css.text_xl ] ] [ Html.text "Omschrijving:" ]
        , Html.p [] ( Html.Util.textToHtml ( viewEntityDescription entity.attributes.description ) )
        ]


viewQualifiedName : Model.Entity.Entity -> Html.Html Model.Msg
viewQualifiedName entity =
    Html.div [ Css.class [ Css.bg_c_grey, Css.r_corners, Css.col_span_5, Css.mt_6 ] ]
        [ Html.div [ Css.class [ Css.mx_7 ] ]
            [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Locatie: " ]
            , Html.a [ Html.Attributes.href entity.attributes.qualifiedName, Css.class [ Css.text_c_blue ] ] [ Html.text entity.attributes.qualifiedName ]
            ]
        ]


viewColumns : Model.Model -> Model.Entity.Entity -> Html.Html Model.Msg
viewColumns model entity =
    if model.currentDiscoveryEntity.objectType == "Tables" then
        Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Kolommen: " ], Html.span [] [ Html.text ( String.join ", " entity.columns ) ] ]
    else
        Html.div [] []


viewColumnInformation : Model.Model -> Model.Entity.Entity -> Html.Html Model.Msg
viewColumnInformation model entity =
    Html.div [ Css.class [ Css.bg_c_grey, Css.r_corners, Css.col_span_5, Css.mt_6 ] ] [ Html.div [ Css.class [ Css.mx_7 ] ] [ viewColumns model entity ] ]


viewEntityDescription : String -> String
viewEntityDescription description =
    if description == " " then
        "<div>Er is geen omschrijving beschikbaar<div>"
    else
        description


viewAttributeInformation : Model.Model -> Model.Entity.Entity -> Html.Html Model.Msg
viewAttributeInformation model entity =
    Html.div [ Css.class [ Css.col_span_2, Css.bg_c_grey, Css.r_corners ] ] [ Html.div [ Css.class [ Css.ml_7, Css.my_6 ] ]
        [ Html.h1 [ Css.class [ Css.text_xl ] ] [ Html.text "Kenmerken:" ]
        , viewId entity
        , viewType model
        , viewSource entity
        , viewMadeBy entity
        , viewMadeOn entity
        , viewUpdatedBy entity
        , viewUpdatedOn entity
        ] ] --REST


viewId : Model.Entity.Entity -> Html.Html Model.Msg
viewId entity =
    Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "ID: " ], Html.span [] [ Html.text entity.guid ] ]


viewType : Model.Model -> Html.Html Model.Msg
viewType model =
    Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Type: " ], Html.span [] [ Html.text model.currentDiscoveryEntity.objectType ] ]

viewSource : Model.Entity.Entity -> Html.Html Model.Msg
viewSource entity =
    Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Bron: " ], Html.span [] [ Html.text entity.source ] ]

viewMadeBy : Model.Entity.Entity -> Html.Html Model.Msg
viewMadeBy entity =
    Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Gemaakt door: " ], Html.span [] [ Html.text entity.createdBy ] ]

viewMadeOn : Model.Entity.Entity -> Html.Html Model.Msg
viewMadeOn entity =
    Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Gemaakt op: " ], Html.span [] [ Html.text ( Html.Util.timeToString entity.createTime ) ] ]

viewUpdatedBy : Model.Entity.Entity -> Html.Html Model.Msg
viewUpdatedBy entity =
    Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Geüpdate door: " ], Html.span [] [ Html.text entity.updatedBy ] ]

viewUpdatedOn : Model.Entity.Entity -> Html.Html Model.Msg
viewUpdatedOn entity =
    Html.div [] [ Html.span [ Css.class [ Css.font_bold ] ] [ Html.text "Geüpdate op: " ], Html.span [] [ Html.text ( Html.Util.timeToString entity.updateTime ) ] ]

