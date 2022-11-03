module Asset exposing (..)

import Html exposing (Attribute)
import Html.Attributes as Attr


type alias Image =
    String


imageSrc : Image -> Attribute msg
imageSrc url =
    Attr.src url


image : String -> Image
image filename =
    ("/assets/images/" ++ filename)


bgBuilding : Image
bgBuilding =
    image "bg-building.svg"


logo : Image
logo =
    image "logo.svg"


databaseIcon : Image
databaseIcon =
    image "database_icon.svg"


fileIcon : Image
fileIcon =
    image "file_icon.svg"


infographicIcon : Image
infographicIcon =
    image "infographic_icon.svg"
