module Main.View exposing (template)

-- Libraries

import Css exposing (Mixin, num, opacity)
import Date exposing (Date, day, month)
import Date.Extra.Compare exposing (Compare2(..), is)
import Date.Extra.Config.Config_en_us as C_en_us
import Date.Extra.Format exposing (format)
import Date.Extra.I18n.I_en_us exposing (dayOfMonthWithSuffix, monthName)
import FontAwesome.Brand as Social
import FontAwesome.Web as Icon
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.CssHelpers exposing (withNamespace)
import Html.Events exposing (onClick)
import String.Extra exposing (replace)


-- Source

import Bio.View as Bio
import Constants exposing (..)
import Model exposing (Model)
import Server exposing (Gig)
import Types exposing (..)


{ id, class } =
    withNamespace homepage


template : Model -> Html Action
template model =
    main_
        [ styles
            (if model.currentPage == Home then
                []
             else
                (if model.nav == Open then
                    [ opacity (num 0.25) ]
                 else
                    []
                )
            )
        , class [ Main () ]
        ]
        [ section [ class [ Section, Main Home ] ]
            [ socialLink "facebook" "CaldwellBand" Social.facebook_square
            , socialLink "twitter" "caldwell_band" Social.twitter_square
            , socialLink "instagram" "caldwell_band" Social.instagram
            , socialLink "reverbnation" "caldwellband" Icon.star
            ]
        , section [ class [ Section, Main About ] ] Bio.template
        , section [ class [ Section, Main Shows ] ] [ caldwellCalendar_ model ]
        , section [ class [ Section, Main Music ] ]
            [ h2 [] [ text (toString Music) ]
            , fadingHr
            , iframe
                [ seamless True
                , src <| soundCloudiFrameBaseUrl ++ "276527707" ++ soundCloudiFrameParams
                ]
                []
            , fadingHr
            , iframe
                [ seamless True
                , src <| soundCloudiFrameBaseUrl ++ "278360717" ++ soundCloudiFrameParams
                ]
                []
            , fadingHr
            , iframe
                [ seamless True
                , src <| soundCloudiFrameBaseUrl ++ "192483435" ++ soundCloudiFrameParams
                ]
                []
            ]
        , section [ class [ Section, Main Contact ] ]
            [ h2 [] [ text (toString Contact) ]
            , fadingHr
            , a [ href "mailto:booking@caldwell.band" ] [ text "booking@caldwell.band" ]
            ]
        ]


caldwellCalendar_ : Model -> Html Action
caldwellCalendar_ { showPrevious, shows, today } =
    let
        beforeOrAfter =
            if showPrevious then
                Before
            else
                SameOrAfter
    in
        node caldwellCalendar
            []
            [ h2 []
                [ text (toString Shows)
                , a [ onClick TogglePreviousShows ]
                    [ text
                        (if showPrevious then
                            "Upcoming"
                         else
                            "Previous"
                        )
                    ]
                ]
            , fadingHr
            , ul [ class [ Gigs ] ]
                ((if showPrevious then
                    List.reverse shows
                  else
                    shows
                 )
                    |> List.filter (.gigDate >> flip (is beforeOrAfter) today)
                    |> List.map (gigToElmHtml)
                    |> List.intersperse fadingHr
                )
            ]


gigToElmHtml : Gig -> Html a
gigToElmHtml { gigDate, gigVenue } =
    li [ class [ Types.Gig ] ]
        [ span [] [ text gigVenue ]
        , span [] [ text <| dayStringer gigDate ]
        ]


dayStringer : Date -> String
dayStringer date =
    (String.left 3 <| monthName <| month date)
        ++ " "
        ++ (dayOfMonthWithSuffix False <| day date)
        ++ " "
        ++ "`"
        ++ (String.right 2 <| toString <| Date.year date)
        ++ " "
        ++ replace ":00" "" (format C_en_us.config "%l:%M%P" date)


soundCloudiFrameBaseUrl : String
soundCloudiFrameBaseUrl =
    "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/"


soundCloudiFrameParams : String
soundCloudiFrameParams =
    "&amp;color=000000&amp;auto_play=false&amp;hide_related=true&amp;liking=false&amp;show_artwork=false&amp;show_comments=false&amp;show_user=false&amp;show_reposts=false"


fadingHr : Html a
fadingHr =
    node "fading-hr" [] []


socialLink : String -> String -> Html a -> Html a
socialLink siteDomain userName icon =
    a
        [ class [ Main "socialLink" ]
        , href <| "https://www." ++ siteDomain ++ ".com/" ++ userName
        , target "_blank"
        , rel "noopener"
        ]
        [ icon ]
