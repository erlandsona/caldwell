module Main.View exposing (template)

-- Libraries

import Date exposing (Date, day, month)
import Date.Extra.Config.Config_en_us as C_en_us
import Date.Extra.Format exposing (format)
import Date.Extra.I18n.I_en_us exposing (dayOfMonthWithSuffix, monthName)
import FontAwesome.Brand as Social
import FontAwesome.Web as Icon
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.CssHelpers exposing (withNamespace)


-- Source

import Bio.View as Bio
import Constants
    exposing
        ( caldwellCalendar
        , homepage
        )
import Server exposing (Gig)
import Types exposing (..)


{ id, class } =
    withNamespace homepage


template : List Gig -> Html Msg
template gigs =
    main_ [ class [ Main ] ]
        [ section [ id Home ]
            [ socialLink "facebook" "CaldwellBand" Social.facebook_square
            , socialLink "twitter" "caldwell_band" Social.twitter_square
            , socialLink "instagram" "caldwell_band" Social.instagram
            , socialLink "reverbnation" "caldwellband" Icon.star
            ]
        , section [ id About ] Bio.template
        , section [ id Shows ] [ caldwellCalendar_ gigs ]
        , section [ id Music ]
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
        , section [ id Contact ]
            [ h2 [] [ text (toString Contact) ]
            , fadingHr
            , a [ href "mailto:booking@caldwell.band" ] [ text "booking@caldwell.band" ]
            ]
        ]


caldwellCalendar_ : List Gig -> Html a
caldwellCalendar_ gigs =
    node caldwellCalendar
        []
        [ h2 [] [ text (toString Shows) ]
        , fadingHr
        , ul [ class [ Gigs ] ] <|
            List.intersperse fadingHr <|
                List.map (gigToElmHtml) gigs
        ]


gigToElmHtml : Gig -> Html a
gigToElmHtml { gigDate, gigVenue } =
    li [ class [ Types.Gig ] ] <|
        List.map
            (\string ->
                span [] [ text string ]
            )
            [ dayStringer gigDate
            , gigVenue
            , format C_en_us.config "%l:%M%P" gigDate
            ]


dayStringer : Date -> String
dayStringer date =
    (monthName <| month date)
        ++ " "
        ++ (dayOfMonthWithSuffix False <| day date)


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
        [ href <| "https://www." ++ siteDomain ++ ".com/" ++ userName
        , target "_blank"
        , rel "noopener"
        ]
        [ icon ]
