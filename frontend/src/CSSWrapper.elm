module CSSWrapper exposing (..)

import Html
import Html.Attributes


class : List String -> Html.Attribute msg
class classes =
    Html.Attributes.class ( String.join " " classes )


logo : String
logo = "logo"


mw : String
mw = "mw"


search_icon : String
search_icon = "search-icon"


filter_icon : String
filter_icon = "filter-icon"


header : String
header = "header"


bg_image : String
bg_image = "bg-image"


mp_text : String
mp_text = "mp-text"


mp_span : String
mp_span = "mp-span"


mp_s_button : String
mp_s_button = "mp-s-button"


mp_s : String
mp_s = "mp-s"


hidden : String
hidden = "hidden"


wh_full_mw_fit : String
wh_full_mw_fit = "wh-full-mw-fit"


p_7 : String
p_7 = "p-7"


pt_10 : String
pt_10 = "pt-10"


pb_7 : String
pb_7 = "pb-7"


px_7 : String
px_7 = "px-7"


p_15x : String
p_15x = "p-15px"


mx_7 : String
mx_7 = "mx-7"


ml_7 : String
ml_7 = "ml-7"


mt_32px : String
mt_32px = "mt-32px"


material_icons : String
material_icons = "material-icons"
