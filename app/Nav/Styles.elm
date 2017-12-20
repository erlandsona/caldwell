module Nav.Styles exposing (css)

-- Libraries

import Css exposing (..)
import Css.Elements exposing (..)
import Lib.CssHelpers exposing (prop)


-- Source

import Constants exposing (..)
import Types exposing (..)


css : List Snippet
css =
    [ class (NavBar ())
        [ displayFlex
        , flexDirection column
        , prop "justify-content" "space-around"
        , prop "align-items" "flex-end"
        , prop "transition" "0.3s"
        , prop "transition-timing-function" "cubic-bezier(0.93, -0.11, 0.4, 1.27)"
        , position fixed
        , right zero
        , cursor pointer
        , height (px 300)
        , margin4 (Css.rem 1) zero zero zero
        , fontSize initial
        , backgroundColor transparent
        , prop "-ms-transform" "translateX(110%)"
        , prop "transform" <| "translate3d(calc(100% + " ++ gutterSize.value ++ "), 0, 0)"
        , zIndex (int 1)
        ]
    , class (NavBar "a")
        [ cursor pointer
        , displayFlex
        , flexDirection column
        , position relative
        , flexGrow (int 1)
        , prop "justify-content" "flex-end"
        , textDecoration none
        , borderBottom3 (px 1) solid transparent
        , marginBottom (px 27)
        , prop "transition" "0.25s"
        , width (pct 0)
        , prop "white-space" "nowrap"
        , textAlign left
        , prop "direction" "rtl"
        , prop "text-shadow" "0px 0px 7px white"
        , fontSize (pct 175)
        , fontFamily sansSerif
        , fontFamilies [ "Megrim" ]
        , children
            [ span
                [ marginRight gutterSize ]
            ]
        ]
    , class (NavBar "handle")
        [ displayFlex
        , flexDirection column
        , prop "justify-content" "space-around"
        , prop "align-items" "center"
        , prop "transition" "0.3s"
        , position absolute
        , top (pct 47)
        , height (px <| dotSize * 3)
        , width (px <| dotSize * 3)
        , prop "right" "calc(110% + 1rem)"
        , children
            [ li
                [ width (px dotSize)
                , height (px dotSize)
                , backgroundColor white
                , prop "box-shadow" "0px 0px 7px white"
                , borderRadius (pct 50)
                ]
            ]
        ]
    ]


dotSize : Float
dotSize =
    13
