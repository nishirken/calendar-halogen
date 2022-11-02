module Auth.Hint (Slot, slotId, component) where

import Prelude

import Data.Const (Const)
import Effect.Class (class MonadEffect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import RouterLink as R
import Type.Proxy (Proxy(..))

type Slot id = H.Slot (Const Void) Void id

type Slots = ( routerLink :: R.Slot Unit )

slotId = Proxy :: Proxy "authHint"

type Input = { text :: String, linkText :: String, linkHash :: String }

type State = Input

type Component m = H.Component (Const Void) Input Void m

component :: forall m. MonadEffect m => Component m
component = H.mkComponent
  { initialState: identity
  , render
  , eval: H.mkEval H.defaultEval
  }
  where
    render s = HH.div [ HP.class_ $ H.ClassName "auth-form__hint" ]
      [ HH.text s.text
      , HH.slot_ R.slotId unit R.component
        { hash: s.linkHash, text: s.linkText }
      ]
