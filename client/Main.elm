module Site exposing (main)

-- Libs

import Array exposing (fromList, get)
import Css exposing (num, opacity)
import Css.Helpers
import Debug
import Date exposing (Date)
import Http
import Html exposing (Html, Attribute, header, node, span, text)
import Html.CssHelpers exposing (withNamespace)
import Html.Events exposing (onClick, onWithOptions, Options)
import Html.Lazy as LHtml
import Json.Decode exposing (decodeValue, int, keyValuePairs, maybe, string, succeed)
import Json.Encode exposing (Value)
import Maybe exposing (withDefault)
import Maybe.Extra exposing (unpack)
import Navigation as Nav exposing (Location, programWithFlags)
import Scroll exposing (Direction(..), direction)
import String exposing (toLower)
import Time exposing (Time)
import UrlParser as Url exposing (oneOf, s)


-- Modules

import Constants exposing (..)
import Main.View as Main
import Nav.View as Nav
import Model exposing (Model)
import Ports exposing (..)
import Server exposing (Gig, getV1Shows, decodeGig)
import Types exposing (..)


-- Source


type alias Initializer =
    { cachedGigs : Maybe Value
    , now : Time
    }


decodedGigs : Value -> List Gig
decodedGigs json =
    case (decodeValue (decodeGig |> keyValuePairs) json) of
        Ok shows ->
            List.map (\( msg, location ) -> (Debug.log msg) location) shows

        Err msg ->
            Debug.log msg []


decodeLocalStorageGigs : Maybe Value -> List Gig
decodeLocalStorageGigs =
    unpack (\() -> Debug.log "No shows in local storage." []) decodedGigs


init : Initializer -> Location -> ( Model, Cmd Action )
init { cachedGigs, now } location =
    let
        today =
            Date.fromTime now

        gigs =
            (decodeLocalStorageGigs cachedGigs)

        _ =
            List.map (Debug.log "Gig Date:" << .gigDate) gigs

        _ =
            Debug.log "Today:" today

        initialHistory =
            [ parse location ]

        initialPage =
            withDefault Home (List.head initialHistory)

        _ =
            Debug.log "initialPage:" initialPage

        model =
            { history = initialHistory
            , currentPage = initialPage
            , scrolling = False
            , scrollTargets = []
            , nav = Closed
            , today = today
            , shows = gigs
            , showPrevious = False
            }
    in
        model
            ! [ locationToScroll location |> snapIntoView
              , Http.send ShowResponse getV1Shows
              , postInit scrollTargetNames
              ]


locationToScroll : Location -> String
locationToScroll =
    (++) "."
        << Css.Helpers.identifierToString homepage
        << Main
        << parse


querySelector : Page -> String
querySelector =
    (++) "."
        << Css.Helpers.identifierToString homepage
        << Main


scrollTargetNames : List ClassName
scrollTargetNames =
    List.map querySelector pages


parse : Location -> Page
parse location =
    withDefault Home (Url.parsePath urlParser location)


urlParser : Url.Parser (Page -> a) a
urlParser =
    oneOf <|
        List.map
            (\page ->
                Url.map page (s (page |> toString |> toLower))
            )
            pages


{ id, class, classList } =
    withNamespace homepage


view : Model -> Html Action
view model =
    let
        not : Switch -> Switch
        not navState =
            case navState of
                Open ->
                    Closed

                Closed ->
                    Open

        clickWithStopProp : Action -> Attribute Action
        clickWithStopProp action =
            -- Options stopProp prevDefault
            onWithOptions "click" (Options True False) (succeed action)

        { currentPage, nav } =
            model

        _ =
            Debug.log "TOP LEVEL: Rendered!" ()
    in
        node container
            [ onClick (ToggleNav Closed)
            ]
            [ node caldwellBackground [] []
            , node blackOverlay
                (case model.currentPage of
                    Home ->
                        []

                    _ ->
                        [ styles [ opacity (num 0.9) ] ]
                )
                []
            , header [ clickWithStopProp (ToggleNav <| not model.nav) ]
                [ span [] [ text "C" ]
                , text "aldwell"
                , LHtml.lazy2 Nav.template currentPage nav
                ]
            , LHtml.lazy Main.template model
            ]


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        ScrollTo page ->
            (if Home == page then
                { model
                    | scrolling = False
                    , nav = Open
                }
             else
                { model
                    | scrolling = False
                    , nav = Closed
                }
            )
                ! [ Nav.modifyUrl <|
                        if page == Home then
                            "/"
                        else
                            urlFrom page
                  , querySelector page |> easeIntoView
                  ]

        UpdateUrlWith page ->
            (if Home == page then
                { model | nav = Open }
             else
                { model | nav = Closed }
            )
                ! [ Nav.modifyUrl <|
                        if page == Home then
                            "/"
                        else
                            urlFrom page
                  ]

        From location ->
            let
                currentPage =
                    parse location

                _ =
                    Debug.log "CurrentPage:" currentPage
            in
                if currentPage == model.currentPage then
                    model ! []
                else
                    { model
                        | history = currentPage :: model.history
                        , currentPage = currentPage
                    }
                        ! []

        ToggleNav newState ->
            { model | nav = newState } ! []

        TogglePreviousShows ->
            let
                newModel =
                    { model | showPrevious = not model.showPrevious }

                _ =
                    Debug.log "showPrevious" newModel.showPrevious
            in
                update GetPageTops newModel

        ShowResponse response ->
            case response of
                Ok shows ->
                    -- let
                    --     _ =
                    --         List.map (Debug.log "Gig Date:" << .gigDate) shows
                    -- in
                    { model | shows = shows } ! []

                Err msg ->
                    let
                        _ =
                            Debug.log "Shows Reponse" <| toString msg
                    in
                        model ! []

        ScrollBar move ->
            if model.scrolling then
                let
                    indexedPageTops =
                        List.indexedMap (\idx px -> ( idx, px )) model.scrollTargets
                in
                    Scroll.handle
                        -- when scrollTop > 10px, send Darken message
                        (List.map
                            (\( idx, px ) ->
                                let
                                    pageArr =
                                        fromList pages

                                    topPage =
                                        withDefault Home <| get idx <| pageArr

                                    bottomPage =
                                        withDefault About <| get (idx + 1) <| pageArr
                                in
                                    Scroll.onCrossOver px <|
                                        if Scroll.Up == direction move then
                                            update (UpdateUrlWith topPage)
                                            -- get  0 (fromList [0,5,3]) == Just 0
                                        else
                                            update (UpdateUrlWith bottomPage)
                            )
                            indexedPageTops
                        )
                        move
                        model
            else
                model ! []

        Stop v ->
            { model | scrolling = True } ! []

        SetPageTops scrollTargets ->
            { model | scrollTargets = scrollTargets } ! []

        GetPageTops ->
            model
                ! [ getScrollTargets scrollTargetNames ]


urlFrom : Page -> String
urlFrom =
    toString >> toLower


main : Program Initializer Model Action
main =
    programWithFlags From
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Action
subscriptions _ =
    Sub.batch
        [ scroll ScrollBar
        , scrollStart Stop
        , setScrollTargets SetPageTops
        ]
