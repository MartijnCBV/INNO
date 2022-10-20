module CSSWrapper exposing (..)

import Html exposing (Attribute)
import Html.Attributes as Attr


class : List String -> Attribute msg
class classes =
    Attr.class ( String.join " " classes )


logo = "logo"
mw = "mw"
search_icon = "search-icon"
filter_icon = "filter-icon"
header = "header"
bg_image = "bg-image"
mp_text = "mp-text"
mp_span = "mp-span"
mp_s_button = "mp-s-button"
mp_s = "mp-s"
hidden = "hidden"
wh_full_mw_fit = "wh-full-mw-fit"
p_7 = "p-7"
pt_10 = "pt-10"
pb_7 = "pb-7"
px_7 = "px-7"
p_15x = "p-15px"
mx_7 = "mx-7"
ml_7 = "ml-7"
mt_32px = "mt-32px"

material_icons = "material-icons"
