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


text_2xl : String
text_2xl = "text-2xl"


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


py_3 : String
py_3 = "py-3"


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


border_b : String
border_b = "border-b"


border_c_grey : String
border_c_grey = "border-c-grey"


border_solid : String
border_solid = "border-solid"


grid : String
grid = "grid"


grid_cols_5 : String
grid_cols_5 = "grid-cols-5"


grid_cols_7 : String
grid_cols_7 = "grid-cols-7"


col_span_2 : String
col_span_2 = "col-span-2"


col_span_4 : String
col_span_4 = "col-span-4"


row_span_3 : String
row_span_3 = "row-span-3"


bg_c_grey : String
bg_c_grey = "bg-c-grey"


w_full : String
w_full = "w-full"


mb_3 : String
mb_3 = "mb-3"


text_white : String
text_white = "text-white"


font_bold : String
font_bold = "font-bold"


py_7 : String
py_7 = "py-7"


bg_c_brown : String
bg_c_brown = "bg-c-brown"


py_13px : String
py_13px = "py-13px"


inline_block : String
inline_block = "inline-block"


h_full : String
h_full = "h-full"


max_w_fit : String
max_w_fit = "max-w-fit"


w_400px : String
w_400px = "w-400px"


py_15px : String
py_15px = "py-15px"


text_xl : String
text_xl = "text-xl"


border_transparent : String
border_transparent = "border-transparent"


focus_border_transparent : String
focus_border_transparent = "focus:border-transparent"


float_left : String
float_left = "float-left"


bg_c_red : String
bg_c_red = "bg-c-red"


float_right : String
float_right = "float-right"

border : String
border = "border"


border_c_red : String
border_c_red = "border_c_red"


p_10px : String
p_10px = "p-10px"


sort_option : String
sort_option = "sort-option"


text_c_red : String
text_c_red = "text-c-red"


dropdown_content : String
dropdown_content = "dropdown-content"


col_span_3 : String
col_span_3 = "col-span-3"


mt_6 : String
mt_6 = "mt-6"


mb_4 : String
mb_4 = "mb-4"


m_auto : String
m_auto = "m-auto"


type_icon : String
type_icon = "type-icon"
