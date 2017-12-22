module Nav.View exposing (template)

-- Libs

import Css
    exposing
        ( opacity
        , transform
        , translate2
        , translate3d
        , zero
        , pct
        , property
        , width
        , solid
        , px
        , borderBottom2
        )
import Html exposing (..)
import Html.CssHelpers exposing (withNamespace)
import Html.Events exposing (onClick, onWithOptions, Options)
import Json.Decode exposing (succeed)


-- Source

import Constants exposing (..)
import Types exposing (..)


{ class } =
    withNamespace homepage


template : Page -> Switch -> Html Action
template currentPage nav =
    let
        navOpen =
            navState currentPage nav

        _ =
            Debug.log "NAV: Rendered!" ()
    in
        Html.nav
            [ styles
                (if navOpen then
                    [ transform (translate2 zero zero)
                    , transform (translate3d zero zero zero)
                    ]
                 else
                    [ property "transition-delay" "0.5s" ]
                )
            , class [ NavBar () ]
            , clickWithStopProp (ToggleNav Closed)
            ]
            (List.map (aTag currentPage) pages)


aTag : Page -> Page -> Html Action
aTag currentPage page =
    a
        [ class [ (NavBar "a") ]
        , onClick (ScrollTo page)
        , styles
            (if page == currentPage then
                [ borderBottom2 (px 1) solid
                , width (pct 110)
                ]
             else
                []
            )
        ]
        [ span [] [ text (toString page) ]
        ]


clickWithStopProp : Action -> Attribute Action
clickWithStopProp action =
    -- Options stopProp prevDefault
    onWithOptions "click" (Options True False) (succeed action)


navState : Page -> Switch -> Bool
navState currentPage nav =
    case currentPage of
        Home ->
            True

        _ ->
            case nav of
                Open ->
                    True

                Closed ->
                    False
