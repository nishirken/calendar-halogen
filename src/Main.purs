module Main where

import Prelude

import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (error, throwError)
import Effect.Class (class MonadEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)
import Router as Router
import Web.DOM.ParentNode (QuerySelector(..))

type Slots = ( router :: Router.Slot Unit )

rootComponent :: forall m. MonadEffect m => H.Component (Const Void) Unit Void m
rootComponent = H.mkComponent
  { initialState: const unit
  , render
  , eval: H.mkEval H.defaultEval
  }
  where
    render :: Unit -> H.ComponentHTML Unit Slots m
    render _ =
      HH.slot_
        Router.slotId
        unit
        Router.component
        unit

main :: Effect Unit
main = do
  HA.runHalogenAff do
    container <- HA.selectElement $ QuerySelector "#root"
    case container of
      Just ctr -> runUI rootComponent unit ctr
      Nothing -> throwError $ error "No container has been found"

