module Auth.AuthForm (Slot, slotId, component) where

import Prelude

import Auth.Hint as Hint
import Component.Button as Button
import Component.Input as Input
import Data.Const (Const)
import Data.Either (Either(..))
import Data.Int (fromString)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect)
import Formless as F
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Models (AuthCreds(..))
import Type.Prelude (Proxy(..))
import Utils (getInputValue)
import Web.Event.Event (Event)
import Web.UIEvent.MouseEvent (MouseEvent)
import Prim.Row (Union)

type Slot id = H.Slot (Const Void) Void id

type Slots = ( authHint :: Hint.Slot Unit )

slotId = Proxy :: Proxy "authForm"

type Fetch = AuthCreds -> Effect Unit

type Common = (
  buttonText :: String
  , fetch :: Fetch
  , hintText :: String
  , hintLinkHash :: String
  , hintLinkText :: String
)

type Input = Record Common

type State =
  { loading :: Boolean
  , actions :: { | Form (F.FieldAction Action) }
  , fields :: { | Form F.FieldState }
-- , formActions :: F.FormAction (Form F.FieldState) Action
--  , formState :: F.FormState
  | Common
  }

type Form :: (Type -> Type -> Type -> Type) -> Row Type
type Form f =
  ( email     :: f String String String
  , password :: f String String String
  )

type FormInputs = { | Form F.FieldInput }

type FormResult = { | Form F.FieldInput }

type Output = { successMessage :: String, result :: FormResult }

type FormContext = F.FormContext (Form F.FieldState) (Form (F.FieldAction Action)) Input Action

type FormlessAction = F.FormlessAction (Form F.FieldState)

data Action =
  Submit MouseEvent
  | Receive FormContext
  | Eval FormlessAction

component :: forall m. MonadEffect m => H.Component (Const Unit) Input Output m
component = F.formless { liftAction: Eval } $ H.mkComponent
  { initialState
  , render
  , eval: H.mkEval H.defaultEval { handleAction = handleAction, receive = Just <<< Receive, handleQuery = handleQuery }
  }
  where
    initialState :: FormContext -> State
    initialState { input: { buttonText, fetch, hintText, hintLinkHash, hintLinkText }, actions, fields, formActions, formState } = {
      loading: false
      , buttonText
      , fetch
      , hintText
      , hintLinkHash
      , hintLinkText
      , actions
      , fields
--      , formActions
    }

    render :: State -> H.ComponentHTML Action Slots m
    render s =
      HH.div
      [ HP.class_ $ H.ClassName "auth-form" ]
      [ emailInput s
      , passwordInput s
      , button s
      , HH.slot_ Hint.slotId unit Hint.component { text: s.hintText, linkText: s.hintLinkText, linkHash: s.hintLinkHash }
      ]
      
    emailInput s =
      Input.input
      [ HP.placeholder "Email", HP.type_ HP.InputEmail, HP.value s.fields.email.value, HE.onValueInput s.actions.email.handleChange, HP.class_ $ H.ClassName "auth-form__input" ]

    passwordInput s =
      Input.input
      [ HP.placeholder "Password", HP.type_ HP.InputPassword, HP.value s.fields.password.value, HE.onValueInput s.actions.password.handleChange, HP.class_ $ H.ClassName "auth-form__input" ]

    button s =
      Button.button
      Nothing
      s.buttonText
      [ (HP.disabled s.loading), (HP.type_ HP.ButtonSubmit), HE.onClick Submit, HP.class_ $ H.ClassName "auth-form__button" ]

    updateInputState :: Event -> (State -> String -> State) -> H.HalogenM State Action Slots (F.FormOutput (Form F.FieldState) Output) m Unit
    updateInputState ev f = do
      val <- H.liftEffect $ getInputValue ev
      case val of
        Just x -> H.modify_ \s -> f s x
        Nothing -> pure unit

    --handleAction :: Action -> H.HalogenM State Action Slots (F.FormOutput (Form F.FieldState) Output) m Unit
    handleAction action = case action of
      Submit _ -> do
        H.modify_ \s -> s { loading = true }
        fetch' <- H.gets \s -> s.fetch
        creds <- H.gets \s -> { email: s.email, password: s.password }
        H.liftEffect $ fetch' $ AuthCreds creds
        H.modify_ _ { loading = false }
      Receive context -> H.put context
      Eval action -> F.eval action
    
    handleQuery = do
      let
        validation :: { | Form F.FieldValidation }
        validation =
          { email: Right
          , password: Right
          }

        handleSuccess :: FormResult -> H.HalogenM _ _ _ _ _ Unit
        handleSuccess result = do
          let
            output :: Output
            output = { successMessage: "Got a cat!", result }
          F.raise output

      F.handleSubmitValidate handleSuccess F.validate validation

