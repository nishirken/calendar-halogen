module Utils where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Web.Event.Event (Event)

foreign import unsafeInputValue :: forall a. (a -> Maybe a) -> (a -> Maybe a) -> (Maybe a -> Effect (Maybe a)) -> Event -> Effect (Maybe String)

getInputValue :: Event -> Effect (Maybe String)
getInputValue ev = unsafeInputValue (\x -> Just x) (const Nothing) (\x -> pure x) ev
