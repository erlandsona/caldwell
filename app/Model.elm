module Model exposing (..)

import Date exposing (Date)
import Server exposing (Gig)
import Types exposing (..)


type alias Model =
    { history : List Page
    , currentPage : Page
    , scrollTargets : List Float
    , scrolling : Bool
    , nav : Switch
    , shows : List Gig
    , showPrevious : Bool
    , today : Date
    }
