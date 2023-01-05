module Asset exposing (..)

import Html
import Html.Attributes


type alias Image =
    String


imageSrc : Image -> Html.Attribute msg
imageSrc url =
    Html.Attributes.src url


image : String -> Image
image filename =
    ("../src/assets/images/" ++ filename)


getTypeIcon : String -> Html.Attribute msg
getTypeIcon name =
    case name of
        "Folders" -> imageSrc folderIcon

        "Tables" -> imageSrc databaseIcon

        _ -> imageSrc fileIcon


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


folderIcon : Image
folderIcon =
    image "folder_icon.svg"