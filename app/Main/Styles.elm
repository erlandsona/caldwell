module Main.Styles exposing (css)

-- Libraries

import Css exposing (..)
import Css.Elements exposing (..)
import Lib.CssHelpers exposing (prop)


-- Source

import Constants exposing (caldwellCalendar, gutterSize)
import Types exposing (..)
import Constants exposing (..)


css : List Snippet
css =
    [ class (Main ())
        [ position relative ]
    , class Section
        [ minHeight (vh 100)
        , width (pct 100)
        , maxWidth (px 768)
          -- Tablet Width
        , margin auto
        , prop "-webkit-overflow-scrolling" "touch"
        , padding4
            (Css.rem 7)
            -- Top
            (Css.rem <| gutterSize.numericValue * 3)
            -- Right
            zero
            -- Bottom
            gutterSize
          -- Left
        ]
    , class (Main Home)
        [ displayFlex
        , alignItems flexEnd
        , paddingBottom gutterSize
        , maxWidth (pct 100)
        , height (vh 70)
        ]
    , class (Main "socialLink")
        [ display inlineBlock
        , marginRight gutterSize
        , children
            [ i [ fontSize (Css.rem 1.5) ]
            ]
        ]
    , class (Main About)
        [ children
            [ h3 [ display inline ]
            , p
                [ prop "text-indent" "7%"
                , lineHeight (num 1.5)
                , marginBottom gutterSize
                ]
            ]
        ]
      -- , class (Main Shows)
    , selector caldwellCalendar
        [ display block
        , children
            [ h2
                [ textAlign center
                ]
            , fadingHr lightGrey
            ]
        ]
    , class Gigs
        [ children
            [ class Gig
                [ displayFlex
                , flexFlow2 row wrap
                , children
                    [ span
                        [ flex (num 2)
                        , textAlign left
                        , lastOfType
                            [ flex (num 1)
                            , textAlign right
                            ]
                        ]
                    ]
                ]
            , mediaQuery "screen and (max-width: 500px)"
                [ class Gig
                    [ justifyContent spaceAround
                    , children
                        [ span
                            [ flex initial
                            , nthChild "2"
                                [ order (num -1)
                                , flexBasis (pct 100)
                                , textAlign center
                                , marginBottom (px 17)
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , children [ fadingHr darkGrey ]
        ]
    , class (Main Music)
        [ children
            [ h2
                [ textAlign center
                ]
            , selector "iframe"
                [ width (pct 100) ]
            , fadingHr lightGrey
            , selector "fading-hr"
                [ nthOfType "1n+2"
                    [ backgroundColor darkGrey
                    , prop "background" <| "-webkit-gradient(linear, 0 0, 100% 0, from(black), to(black), color-stop(50%, " ++ darkGrey.value ++ "))"
                    ]
                ]
            ]
        ]
    , class (Main Contact)
        [ children
            [ h2
                [ textAlign center
                ]
            , fadingHr lightGrey
            , a
                [ display block
                , textAlign center
                ]
            ]
        ]
    ]


fadingHr : Color -> Snippet
fadingHr background =
    selector "fading-hr"
        [ display block
        , margin2 (px 20) zero
        , height (px 1)
        , width (pct 100)
        , backgroundColor background
        , prop "background" <| "-webkit-gradient(linear, 0 0, 100% 0, from(black), to(black), color-stop(50%, " ++ background.value ++ "))"
        ]
