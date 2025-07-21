port module Main exposing (..)

import Browser
import Browser.Events
import Css exposing (..)
import Css.Global as Global
import Dict
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Json.Decode as D
import Json.Encode as E
import Material.Icons
import Material.Icons.Types exposing (Coloring(..))
import Platform.Sub as Sub
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
          , image = "/images/JavaScript.png"
          , url = "https://github.com/Chesare22/shuffle-textlines.js"
          }
        , { name = "Sum-to"
          , image = "/images/JavaScript.png"
          , url = "https://github.com/Chesare22/sum-to"
          }
        , { name = "Mask"
          , image = "/images/Elixir.png"
          , url = "https://github.com/Chesare22/mask"
          }
        ]
    }


libraries : Carousel
libraries =
    { title = "Libraries"
    , slides =
        [ { name = "Custom types"
          , image = "/images/JavaScript.png"
          , url = ""
          }
        , { name = "Controlled collumns"
          , image = "/images/Ant Design.png"
          , url = ""
          }
        , { name = "Parser combinators"
          , image = "/images/php.png"
          , url = ""
          }
        , { name = "ESLint config"
          , image = "/images/ESLint.png"
          , url = ""
          }
        ]
    }


schoolProjects : Carousel
schoolProjects =
    { title = "School projects"
    , slides =
        [ { name = "MVC votes system"
          , image = "/images/Java.png"
          , url = "https://github.com/Chesare22/Semestre-5/tree/arquitectura/Votes/src/main/java"
          }
        , { name = "Kardex"
          , image = "/images/Elm.png"
          , url = "https://github.com/Chesare22/Kardex"
          }
        , { name = "OOP School Projects"
          , image = "/images/Java.png"
          , url = "https://github.com/Chesare22/OOP-school-projects"
          }
        , { name = "Timer-PIC18F4550"
          , image = "/images/PIC18F4550.png"
          , url = "https://github.com/Chesare22/Temporizador-PIC18F4550"
          }
        , { name = "Minesweeper"
          , image = "/images/Minesweeper.png"
          , url = "https://github.com/Chesare22/Buscaminas-DIY"
          }
        , { name = "Cryptography algorythms"
          , image = "/images/Python.png"
          , url = "https://github.com/Chesare22/cryprography-algorithms"
          }
        , { name = "Small search engine"
          , image = "/images/php.png"
          , url = "https://github.com/Chesare22/BRIW-Ada3-backend"
          }
        ]
    }


articles : Carousel
articles =
    { title = "Articles"
    , slides =
        [ { name = ""
          , image = "/images/JavaScript.png"
          , url = "https://medium.com/soldai/3-features-de-javascript-que-aprend%C3%AD-fuera-de-la-escuela-978e009c9201"
          }
        , { name = "Leetcode solution 2486"
          , image = "/images/LeetCode.png"
          , url = ""
          }
        , { name = "FP Article"
          , image = "/images/Elm.png"
          , url = "https://github.com/Chesare22/FP-Article"
          }
        ]
    }


miscelaneous : Carousel
miscelaneous =
    { title = "Miscelaneous"
    , slides =
        [ { name = "Fireship app in Elm"
          , image = "/images/Elm.png"
          , url = "https://github.com/Chesare22/Fireship-app-in-elm"
          }
        , { name = "My CV"
          , image = "/images/Elm.png"
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


type alias ScrollButtonsVisibility =
    { left : Bool
    , right : Bool
    }


type alias Model =
    { fonts : Fonts
    , movingCarousel : Maybe ( String, Direction )
    , scrollButtonsVisibilities : Dict.Dict String ScrollButtonsVisibility
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
    [ applications
    , cliHelpers
    , schoolProjects
    , articles
    , miscelaneous
    ]


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { fonts = flags.fonts
      , movingCarousel = Nothing
      , scrollButtonsVisibilities = Dict.empty
      }
    , requestScrollButtonsVisibility (carousels |> List.map .title)
    )



---- PORTS ----


port scrollCarousel : ( String, Float ) -> Cmd msg


port requestScrollButtonsVisibility : List String -> Cmd msg


port updateScrollButtonsVisibility : (E.Value -> msg) -> Sub msg



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ case model.movingCarousel of
            Nothing ->
                Sub.none

            Just ( carouselTitle, direction ) ->
                Time.every 100 (MoveCarousel carouselTitle direction)
        , Browser.Events.onResize (always (always RequestScrollButtonsVisibility))
        , updateScrollButtonsVisibility UpdateScrollButtonsVisibility
        ]



---- UPDATE ----


type Msg
    = StartMoving String Direction
    | StopMoving
    | MoveCarousel String Direction Time.Posix
    | RequestScrollButtonsVisibility
    | UpdateScrollButtonsVisibility E.Value


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

        RequestScrollButtonsVisibility ->
            ( model
            , requestScrollButtonsVisibility (carousels |> List.map .title)
            )

        UpdateScrollButtonsVisibility value ->
            ( { model
                | scrollButtonsVisibilities =
                    value
                        |> D.decodeValue decodeButtonVisibility
                        |> Result.withDefault model.scrollButtonsVisibilities
              }
            , Cmd.none
            )


decodeButtonVisibility : D.Decoder (Dict.Dict String ScrollButtonsVisibility)
decodeButtonVisibility =
    D.dict
        (D.map2 ScrollButtonsVisibility
            (D.field "left" D.bool)
            (D.field "right" D.bool)
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
                |> List.map (viewCarousel model.scrollButtonsVisibilities)
                |> List.concat
            ]
        )


isButtonVisible : String -> Direction -> Dict.Dict String ScrollButtonsVisibility -> Bool
isButtonVisible carouselId direction scrollButtonsVisibilities =
    scrollButtonsVisibilities
        |> Dict.get carouselId
        |> Maybe.map
            (case direction of
                Left ->
                    .left

                Right ->
                    .right
            )
        |> Maybe.withDefault False


viewCarousel : Dict.Dict String ScrollButtonsVisibility -> Carousel -> List (Html Msg)
viewCarousel scrollButtonsVisibilities carousel =
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
            , property "display"
                (if isButtonVisible carousel.title Right scrollButtonsVisibilities then
                    "grid"

                 else
                    "none"
                )
            , property "place-items" "center"
            ]
            [ Events.onMouseEnter (StartMoving carousel.title Right)
            , Events.onMouseLeave StopMoving
            ]
            [ Svg.Styled.fromUnstyled (Material.Icons.keyboard_arrow_right 30 Inherit)
            ]
        , styled div
            [ position absolute
            , zIndex (int 100)
            , left zero
            , width (rem 8)
            , height (pct 100)
            , backgroundImage (linearGradient2 toLeft (stop UI.Palette.grey.c050) (stop UI.Palette.grey.c400) [])
            , opacity (num 0.98)
            , property "display"
                (if isButtonVisible carousel.title Left scrollButtonsVisibilities then
                    "grid"

                 else
                    "none"
                )
            , property "place-items" "center"
            ]
            [ Events.onMouseEnter (StartMoving carousel.title Left)
            , Events.onMouseLeave StopMoving
            ]
            [ Svg.Styled.fromUnstyled (Material.Icons.keyboard_arrow_left 30 Inherit)
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
            , pseudoElement "-webkit-scrollbar" [ display none ]
            ]
            [ Attributes.id carousel.title
            , Events.on "scroll" (D.succeed RequestScrollButtonsVisibility)
            ]
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
