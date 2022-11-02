module Component.Button where

import Prelude

import DOM.HTML.Indexed (HTMLbutton)
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

type WiredButtonAttrs =
  { elevation :: Int -- from 1 to 5
  }

button :: forall w i. Maybe WiredButtonAttrs -> String -> HH.Leaf HTMLbutton w i
button wiredAttrs text htmlAttrs =
  HH.element
  (H.ElemName "wired-button")
  (htmlAttrs <> wiredAttrs')
  [ HH.text text ]
  where
    wiredAttrs' = case wiredAttrs of
      Just { elevation } -> [ HP.attr (H.AttrName "elevation") $ show elevation ]
      Nothing -> []
