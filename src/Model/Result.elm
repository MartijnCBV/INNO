module Model.Result exposing (..)

import Model.Tag exposing (Tags)


type Result =
    Result
        { title : Title
        , tags : Tags
        }


type alias  Results =
    List Result


type alias Title =
    String
