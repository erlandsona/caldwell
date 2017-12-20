module Styles exposing (css)

-- Libraries

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, node)
import String.Extra exposing (clean)


-- Source

import Constants exposing (..)
import Lib.CssHelpers exposing (prop)
import Model exposing (Model)
import Main.Styles as Main
import Nav.Styles as Nav
import Types exposing (..)


css : Stylesheet
css =
    (stylesheet << namespace homepage) <|
        List.concat
            [ [ body
                    [ backgroundColor black
                    , color white
                    , overflow auto
                    , height (vh 100)
                    , fontFamily sansSerif
                    , fontFamilies [ "Josefin Sans" ]
                    , fontSize (pct 93)
                    , fontWeight (int 300)
                    ]
              , mediaQuery "screen and (max-width: 900px)"
                    [ body
                        [ fontSize (pct 83)
                        ]
                    ]
              , mediaQuery "screen and (max-width: 500px)"
                    [ body
                        [ fontSize (pct 70)
                        ]
                    ]
              , h1 [ fontSize (pct 250), fontWeight inherit ]
              , h2 [ fontSize (pct 240), fontWeight inherit ]
              , h3 [ fontSize (pct 225), fontWeight inherit ]
              , h4 [ fontSize (pct 200), fontWeight inherit ]
              , h5 [ fontSize (pct 175), fontWeight inherit ]
              , h6 [ fontSize (pct 150), fontWeight inherit ]
              , p [ fontSize (pct 135) ]
              , a
                    [ textDecoration none
                    , color inherit
                    ]
                -- , selector "::-webkit-scrollbar"
                --     [ width (em 0.6)
                --     ]
                -- , selector "::-webkit-scrollbar-track"
                --     [ prop "box-shadow" "inset 4px 0 0 0 black, inset -4px 0 0 0 black, inset 0 5px 0 0 black, inset 0 -5px 0 0 black"
                --     , backgroundColor white
                --     ]
                -- , selector "::-webkit-scrollbar-thumb"
                --     [ prop "background-color" "white"
                --     , borderRadius (em 1)
                --     ]
              , selector container
                    [ display block ]
              , selector caldwellBackground
                    [ backgroundColor black
                    , backgroundImage (url "/images/stairs.jpg")
                    , backgroundPosition2 (pct 50) (pct 27)
                    , backgroundRepeat noRepeat
                    , backgroundSize cover
                    , height (vh 100)
                    , width (vw 100)
                    , display block
                    , position fixed
                    , zIndex (int 0)
                    , prop "content" "''"
                    ]
              , selector blackOverlay
                    [ backgroundColor black
                    , height (vh 100)
                    , width (vw 100)
                    , opacity (num 0.7)
                    , display block
                    , position fixed
                    , zIndex (int 0)
                    , prop "content" "''"
                    , prop "transition" "opacity 0.7s"
                    ]
              ]
            , [ header
                    [ prop "user-select" "none"
                    , fontFamily cursive
                    , fontFamilies [ "Megrim" ]
                    , fontSize (pct 270)
                    , cursor pointer
                    , position fixed
                    , right zero
                      -- plus padding ends up being 68px
                      -- , width (pct 100)
                    , padding4 (gutterSize |*| Css.rem 2) gutterSize zero (Css.rem 0.5)
                    , borderBottomLeftRadius (px 30)
                    , backgroundColor (rgba 0 0 0 0.93)
                    , prop "box-shadow" "0px 0px 7px black, 0px 0px 37px black, 0px 0px 57px black, 0px 0px 77px black"
                    , prop "text-shadow" "0px 0px 7px white"
                    , zIndex (int 1)
                    , lineHeight (num 1.4)
                    , children
                        [ span
                            [ fontFamilies [ "Monoton" ]
                            , float left
                            ]
                        ]
                    ]
              ]
            , Nav.css
            , Main.css
            ]
