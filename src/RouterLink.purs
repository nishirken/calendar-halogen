module RouterLink (Slot, slotId, component) where

import Prelude

import Component.Link (link)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect.Class (class MonadEffect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events (onClick)
import Routing.Hash (setHash)
import Type.Prelude (Proxy(..))
import Web.Event.Event (preventDefault)
import Web.UIEvent.MouseEvent (MouseEvent, toEvent)

type Slot id = H.Slot (Const Void) Void id

slotId = Proxy :: Proxy "routerLink"

type Input =
  { hash :: String
  , text :: String
  }

data Action = LinkClick String MouseEvent | InputReceived Input

type State = Input

type Component m = MonadEffect m => H.Component (Const Unit) Input Unit m

component :: forall m. Component m
component = H.mkComponent
  { initialState: identity
  , render
  , eval: H.mkEval H.defaultEval { handleAction = handleAction, receive = receive }
  }
  where
    render s =
      link
      [ onClick (LinkClick s.hash) ]
      [ HH.text s.text ]

    handleAction :: Action -> H.HalogenM State Action () Unit m Unit
    handleAction (InputReceived input) = H.modify_ $ const input
    handleAction (LinkClick hash event) =
      H.liftEffect do
        preventDefault $ toEvent event
        setHash hash

    receive :: Input -> Maybe Action
    receive input = Just $ InputReceived input
