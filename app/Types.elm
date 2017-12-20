module Types exposing (..)

-- Libs

import Http
import Navigation exposing (Location)


-- Source

import Server exposing (Gig)
import Scroll exposing (Move)


type Page
    = Home
    | About
    | Shows
    | Music
    | Contact


pages : List Page
pages =
    [ Home, About, Shows, Music, Contact ]


type Action
    = From Location
    | ScrollTo Page
    | Stop ()
    | UpdateUrlWith Page
    | ToggleNav Switch
    | TogglePreviousShows
    | GetPageTops
    | SetPageTops (List Float)
    | ShowResponse (Result Http.Error (List Gig))
      -- the message emitted by the input port
      -- brings a tuple with previous and current scroll values
    | ScrollBar Move



-- animation's tick
-- | Animate Animation.Msg


type CssClass page mod
    = Gigs
    | Gig
    | Section
    | Main page
    | NavBar mod


type alias ClassName =
    String


type Switch
    = Open
    | Closed
