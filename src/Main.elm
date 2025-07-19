port module Main exposing (..)

import Browser
import Css exposing (..)
import Css.Global as Global
import Dict
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Material.Icons
import Material.Icons.Types exposing (Coloring(..))
import Svg.Styled
import Time
import UI.Palette



---- MODEL ----


type alias CarouselSlide =
    { name : String
    , image : String
    , url : String
    }


type alias Carousel =
    { title : String
    , slides : List CarouselSlide
    }


applications : Carousel
applications =
    { title = "Apps and Web Apps"
    , slides =
        [ { name = "MiObra"
          , image = "/images/MiObra.png"
          , url = "https://www.miobra.mx/"
          }
        , { name = "MiObra Export App"
          , image = "/images/MiObra Export App.png"
          , url = "https://apps.microsoft.com/detail/XPFF9W7DQL962Z"
          }
        , { name = "Dark Impala"
          , image = "/images/Dark Impala.png"
          , url = "https://darkimpala.com/"
          }
        , { name = "Petite Resort"
          , image = "/images/Petite Resort.png"
          , url = "https://www.petiteresort.mx/"
          }
        , { name = "Comportia"
          , image = "/images/Comportia.png"
          , url = "https://medium.com/soldai/comportia-una-idea-hecha-realidad-6bd77e542882"
          }
        ]
    }


cliHelpers : Carousel
cliHelpers =
    { title = "Small commands"
    , slides =
        [ { name = "Shuffle textlines"
          , image = ""
          , url = "https://github.com/Chesare22/shuffle-textlines.js"
          }
        , { name = "Sum-to"
          , image = ""
          , url = "https://github.com/Chesare22/sum-to"
          }
        , { name = "Mask"
          , image = ""
          , url = "https://github.com/Chesare22/mask"
          }
        ]
    }


libraries : Carousel
libraries =
    { title = "Libraries"
    , slides =
        [ { name = "Custom types"
          , image = ""
          , url = ""
          }
        , { name = "Controlled collumns"
          , image = ""
          , url = ""
          }
        , { name = "Parser combinators"
          , image = ""
          , url = ""
          }
        , { name = "ESLint config"
          , image = ""
          , url = ""
          }
        ]
    }


schoolProjects : Carousel
schoolProjects =
    { title = "School projects"
    , slides =
        [ { name = "MVC votes system"
          , image = ""
          , url = "https://github.com/Chesare22/Semestre-5/tree/arquitectura/Votes/src/main/java"
          }
        , { name = "Kardex"
          , image = ""
          , url = "https://github.com/Chesare22/Kardex"
          }
        , { name = "OOP School Projects"
          , image = ""
          , url = "https://github.com/Chesare22/OOP-school-projects"
          }
        , { name = "Timer-PIC18F4550"
          , image = ""
          , url = "https://github.com/Chesare22/Temporizador-PIC18F4550"
          }
        , { name = "Minesweeper"
          , image = ""
          , url = "https://github.com/Chesare22/Buscaminas-DIY"
          }
        , { name = "Cryptography algorythms"
          , image = ""
          , url = "https://github.com/Chesare22/cryprography-algorithms"
          }
        , { name = "Small search engine"
          , image = ""
          , url = "https://github.com/Chesare22/BRIW-Ada3-backend"
          }
        ]
    }


articles : Carousel
articles =
    { title = "Articles"
    , slides =
        [ { name = ""
          , image = ""
          , url = "https://medium.com/soldai/3-features-de-javascript-que-aprend%C3%AD-fuera-de-la-escuela-978e009c9201"
          }
        , { name = "Leetcode solution 2486"
          , image = ""
          , url = ""
          }
        , { name = "FP Article"
          , image = ""
          , url = "https://github.com/Chesare22/FP-Article"
          }
        ]
    }


miscelaneous : Carousel
miscelaneous =
    { title = "Miscelaneous"
    , slides =
        [ { name = "Fireship app in Elm"
          , image = ""
          , url = "https://github.com/Chesare22/Fireship-app-in-elm"
          }
        , { name = "My CV"
          , image = ""
          , url = "https://chesare22.github.io/"
          }
        , { name = "Blob Escape"
          , image = "/images/Blob Escape.png"
          , url = "https://yujikost.itch.io/blob-escape"
          }
        ]
    }


type Direction
    = Left
    | Right


type alias Model =
    { fonts : Fonts
    , movingCarousel : Maybe ( String, Direction )
    }


type alias Fonts =
    { dinLight : String
    , dinRegular : String
    , dinBold : String
    , regloBold : String
    }


type alias Flags =
    { fonts : Fonts }


carousels : List Carousel
carousels =
    [ applications ]


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { fonts = flags.fonts
      , movingCarousel = Nothing
      }
    , Cmd.none
    )



---- PORTS ----


port scrollCarousel : ( String, Float ) -> Cmd msg



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.movingCarousel of
        Nothing ->
            Sub.none

        Just ( carouselTitle, direction ) ->
            Time.every 100 (MoveCarousel carouselTitle direction)



---- UPDATE ----


type Msg
    = StartMoving String Direction
    | StopMoving
    | MoveCarousel String Direction Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartMoving carouselTitle direction ->
            ( { model | movingCarousel = Just ( carouselTitle, direction ) }, Cmd.none )

        StopMoving ->
            ( { model | movingCarousel = Nothing }, Cmd.none )

        MoveCarousel carouselTitle direction _ ->
            ( model
            , scrollCarousel
                ( carouselTitle
                , case direction of
                    Right ->
                        20

                    Left ->
                        -20
                )
            )



---- VIEW ----


type FontExtension
    = Woff
    | Otf
    | Ttf


type alias LocalFontfaceParams =
    { name : String
    , url : String
    , extension : FontExtension
    }


localFontface : List Style -> LocalFontfaceParams -> Global.Snippet
localFontface styles { name, url, extension } =
    Global.selector "@font-face"
        ([ fontFamilies [ name ]
         , property "src"
            ("local(\""
                ++ name
                ++ "\"),"
                ++ "url(\""
                ++ url
                ++ "\") format(\""
                ++ (case extension of
                        Woff ->
                            "woff"

                        Otf ->
                            "opentype"

                        Ttf ->
                            "truetype"
                   )
                ++ "\")"
            )
         ]
            ++ styles
        )


view : Model -> Html Msg
view model =
    styled div
        [ maxWidth (pct 100)
        , padding2 zero (rem 1)
        ]
        []
        (List.concat
            [ [ Global.global
                    [ localFontface [ fontWeight (int 300) ]
                        { name = "DIN"
                        , url = model.fonts.dinLight
                        , extension = Woff
                        }
                    , localFontface [ fontWeight (int 400) ]
                        { name = "DIN"
                        , url = model.fonts.dinRegular
                        , extension = Woff
                        }
                    , localFontface [ fontWeight (int 700) ]
                        { name = "DIN"
                        , url = model.fonts.dinBold
                        , extension = Woff
                        }
                    , localFontface [ fontWeight (int 700) ]
                        { name = "Reglo"
                        , url = model.fonts.regloBold
                        , extension = Otf
                        }
                    ]
              , h1 [] [ text "César's Portfolio" ]
              ]
            , carousels
                |> List.map viewCarousel
                |> List.concat
            ]
        )


viewCarousel : Carousel -> List (Html Msg)
viewCarousel carousel =
    [ h2 [] [ text carousel.title ]

    -- Carousel wrapper
    , styled div
        [ position relative
        , overflow hidden
        ]
        []
        -- Carousel controls
        [ styled div
            [ position absolute
            , zIndex (int 100)
            , left (pct 100)
            , transform (translateX (pct -100))
            , width (rem 8)
            , height (pct 100)
            , backgroundImage (linearGradient2 toRight (stop UI.Palette.grey.c050) (stop UI.Palette.grey.c400) [])
            , opacity (num 0.98)
            , property "display" "grid"
            , property "place-items" "center"
            ]
            [ Events.onMouseEnter (StartMoving carousel.title Right)
            , Events.onMouseLeave StopMoving
            ]
            [ Svg.Styled.fromUnstyled (Material.Icons.keyboard_arrow_right 30 Inherit)
            ]

        -- Carousel track
        , styled div
            [ displayFlex
            , alignItems flexStart
            , property "column-gap" "1rem"
            , position relative
            , zIndex (int 50)
            , width (pct 100)
            , overflowX scroll
            , overflowY hidden
            ]
            [ Attributes.id carousel.title ]
            (carousel.slides |> List.map viewSlide)
        ]
    ]


viewSlide : CarouselSlide -> Html Msg
viewSlide { name, image } =
    styled div
        [ position relative
        ]
        []
        [ styled img
            [ width (rem 17.5)
            , property "object-fit" "cover"
            ]
            [ Attributes.src image ]
            []
        , styled p
            [ position absolute
            ]
            []
            [ text name ]
        ]



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
