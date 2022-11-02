module Router (Slot, slotId, component) where

import Prelude

import Auth.SigninForm as Signin
import Auth.SignupForm as Signup
import Data.Const (Const)
import Data.Either (either)
import Data.List (singleton)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.Subscription (Listener)
import Halogen.Subscription as HS
import Routes (AuthRoute(..), Route(..), routes, routing)
import Routing.Hash (getHash, setHash)
import Routing.Match (runMatch)
import Routing.PushState (LocationState, PushStateInterface, makeInterface)
import Routing.Types (RoutePart(..))
import Type.Proxy (Proxy(..))

type Slot id = H.Slot (Const Void) Void id 

type Slots = ( signinForm :: Signin.Slot Unit, signupForm :: Signup.Slot Unit )

slotId = Proxy :: Proxy "router"

data Action = Initialize | LocationChanged LocationState String

type State =
  { currentRoute :: Route
  , currentHash :: String
  , locationState :: Maybe LocationState
  , pushStateInterface :: Maybe PushStateInterface
  }

component :: forall m. MonadEffect m => H.Component (Const Void) Unit Void m
component = H.mkComponent
  { initialState: \_ -> { currentRoute: Auth Signin, locationState: Nothing, pushStateInterface: Nothing, currentHash: "" }
  , render
  , eval: H.mkEval $ H.defaultEval
    { handleAction = handleAction
    , initialize = Just Initialize
    }
  }
  where
    render :: State -> H.ComponentHTML Action Slots m  
    render st = case st.currentRoute of
      Auth authRoute -> case authRoute of
        Signin -> HH.slot_ Signin.slotId unit Signin.component unit
        Signup -> HH.slot_ Signup.slotId unit Signup.component unit
      Week -> HH.div_ [ HH.text "Week" ]
      NotFound -> HH.div_ [ HH.text "404" ]

    handleAction Initialize = do
      { pushStateInterface, emitter } <- H.liftEffect do
        pushStateInterface <- makeInterface

        -- initial route
        setHash $ routes $ Auth Signin

        { emitter, listener } <- HS.create
        _ <- locationChangeNotify listener pushStateInterface
        pure { pushStateInterface, emitter }
      _ <- H.subscribe emitter
      H.modify_ _ { pushStateInterface = Just pushStateInterface }

    handleAction (LocationChanged locationState hash) = do
      let newRoute = hashToRoute hash
      _ <- H.modify_ _ { currentRoute = newRoute, currentHash = hash, locationState = Just locationState }
      pure unit

    locationChangeNotify :: Listener Action -> PushStateInterface -> Effect Unit
    locationChangeNotify listener { listen } = do
      _ <- listen $ \newLocationState -> do
        hash <- getHash
        HS.notify listener $ LocationChanged newLocationState $ hash
      pure unit

    hashToRoute :: String -> Route
    hashToRoute hash =
      either
      (const NotFound)
      identity
      $ runMatch routing (singleton $ Path hash)

