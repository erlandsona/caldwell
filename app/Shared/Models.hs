{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Models where


import Data.Text
import Data.Time (UTCTime)
import Database.Persist.Sql
import Database.Persist.TH
import GHC.Generics

-- DB Models
share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Account json
    firstName Text
    lastName Text
    email Text
    UniqueEmail email
    deriving Show Generic

Gig json
    date UTCTime
    venue Text
    -- venueId VenueId
    deriving Show Generic

-- Venue json
--     name Text
--     -- locationId LocationId
--     deriving Show

-- Location json
--     -- Consider adding for Maps or something.
--     -- Maybe needs it's own model like Location
--     street Text
--     city Text
--     state Text
--     zip Integer
--     deriving Show
|]
