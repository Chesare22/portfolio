module UI.Palette exposing (..)

import Css exposing (..)


type alias Palette =
    { c050 : Color
    , c100 : Color
    , c200 : Color
    , c300 : Color
    , c400 : Color
    , c500 : Color
    , c600 : Color
    , c700 : Color
    , c800 : Color
    , c900 : Color
    }


primary : Palette
primary =
    Palette
        (hex "f9e6f0")
        (hex "f2c0db")
        (hex "ec97c3")
        (hex "e870ab")
        (hex "e45397")
        (hex "e43c83")
        (hex "d2397e")
        (hex "bb3676")
        (hex "a5336f")
        (hex "7d2d61")


secondary : Palette
secondary =
    Palette
        (hex "e5eeff")
        (hex "c4d8f2")
        (hex "a9bcdb")
        (hex "8ba1c4")
        (hex "748db2")
        (hex "5d79a1")
        (hex "4e6b8f")
        (hex "3e5778")
        (hex "2f4561")
        (hex "1c3049")


grey : Palette
grey =
    Palette
        (hex "fafafa")
        (hex "f5f5f5")
        (hex "eeeeee")
        (hex "e0e0e0")
        (hex "bdbdbd")
        (hex "9e9e9e")
        (hex "757575")
        (hex "616161")
        (hex "424242")
        (hex "212121")
