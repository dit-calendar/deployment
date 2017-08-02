{-# LANGUAGE FlexibleContexts #-}

module Data.Repository.UserRepo where

import Prelude hiding ( head )
import Happstack.Foundation              ( update, HasAcidState )
import Control.Monad.IO.Class
import Data.List                         ( delete )

import Data.Domain.User                  ( User(..) )
import Data.Domain.Types                 ( EntryId )

import qualified Data.Repository.Acid.UserAcid       as UserAcid
import qualified Data.Repository.Acid.CalendarAcid   as CalendarAcid


updateUser :: (MonadIO m, HasAcidState m CalendarAcid.EntryList, HasAcidState m UserAcid.UserList) =>
     User -> String -> m ()
updateUser user newName =
    let updatedUser = user {name = newName} in
      update $ UserAcid.UpdateUser updatedUser

addCalendarEntryToUser :: (HasAcidState m UserAcid.UserList, MonadIO m) =>
    User -> EntryId -> m ()
addCalendarEntryToUser user entryId =
    let updatedUser = user {calendarEntries = calendarEntries user ++ [entryId]} in
        update $ UserAcid.UpdateUser updatedUser

deleteCalendarEntryFromUser :: (HasAcidState m UserAcid.UserList, MonadIO m) =>
                                   User -> EntryId -> m ()
deleteCalendarEntryFromUser user entryId =
    let updatedUser = user {calendarEntries = delete entryId (calendarEntries user)} in
        update $ UserAcid.UpdateUser updatedUser