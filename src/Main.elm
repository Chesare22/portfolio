module Main exposing (..)

import Browser
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attributes



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


type alias Model =
    { carousels : List Carousel }


init : ( Model, Cmd Msg )
init =
    ( { carousels = [] }, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ Attributes.src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
