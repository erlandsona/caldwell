port module Ports exposing (..)

import Types exposing (ClassName)
import Scroll exposing (Move)


-- Cmd's -> JS


port postInit : List ClassName -> Cmd action


port getScrollTargets : List ClassName -> Cmd action


port easeIntoView : ClassName -> Cmd action


port snapIntoView : ClassName -> Cmd action



-- Sub's <- JS


port scroll : (Move -> action) -> Sub action


port scrollStart : (() -> action) -> Sub action


port setScrollTargets : (List Float -> action) -> Sub action
