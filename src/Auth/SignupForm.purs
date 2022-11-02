module Auth.SignupForm (Slot, slotId, component) where

import Prelude

import Auth.AuthForm as AuthForm
import Data.Const (Const)
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Halogen as H
import Halogen.HTML as HH
import Models (AuthCreds)
import Routes as R
import Type.Proxy (Proxy(..))

type Slot id = H.Slot (Const Void) Void id 

type Slots = ( authForm :: AuthForm.Slot Unit )

slotId = Proxy :: Proxy "signupForm"

component :: forall m. MonadEffect m => H.Component (Const Void) Unit Void m
component = H.mkComponent
  { initialState: identity
  , render
  , eval: H.mkEval H.defaultEval
  }
  where
    render :: Unit -> H.ComponentHTML Unit Slots m
    render _ =
      HH.div_ [
        HH.slot_
        AuthForm.slotId
        unit
        AuthForm.component
        { buttonText: "Sign up"
        , fetch
        , hintText: "Already have an account?"
        , hintLinkText: "Sign in"
        , hintLinkHash: R.routes $ R.Auth R.Signin
        }
      ]

    fetch :: AuthCreds -> Effect Unit
    fetch creds = pure unit
