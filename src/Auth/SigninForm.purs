module Auth.SigninForm (Slot, slotId, component) where

import Prelude

import Api (signin)
import Auth.AuthForm as AuthForm
import Data.Const (Const)
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Effect.Class.Console (logShow)
import Halogen as H
import Halogen.Aff (runHalogenAff)
import Halogen.HTML as HH
import Models (AuthCreds)
import Type.Proxy (Proxy(..))
import Routes as R

type Slot id = H.Slot (Const Void) Void id 

type Slots = ( authForm :: AuthForm.Slot Unit )

slotId = Proxy :: Proxy "signinForm"

component :: forall m. MonadEffect m => H.Component (Const Void) Unit Void m
component = H.mkComponent
  { initialState: identity
  , render
  , eval: H.mkEval H.defaultEval
  }
  where
    render :: Unit -> H.ComponentHTML Unit Slots m
    render _ =
      HH.slot_
      AuthForm.slotId
      unit
      AuthForm.component
      { buttonText: "Sign in"
      , fetch
      , hintText: "Do not have an account yet?"
      , hintLinkText: "Sign up"
      , hintLinkHash: R.routes $ R.Auth R.Signup
      }

    fetch :: AuthCreds -> Effect Unit
    fetch creds = do
      res <- runHalogenAff $ signin creds
      logShow res

