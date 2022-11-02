module Routes where

import Prelude

import Control.Alt ((<|>))
import Routing.Match (Match, lit)

data AuthRoute = Signin | Signup

data Route = Auth AuthRoute | Week | NotFound

derive instance Eq AuthRoute
derive instance Ord AuthRoute
derive instance Eq Route
derive instance Ord Route

routing :: Match Route
routing =
  lit "/auth/signin" *> (pure $ Auth Signin)
  <|> lit "/auth/signup" *> (pure $ Auth Signup)
  <|> lit "/week" *> pure Week
  <|> lit "/404" *> pure NotFound

routes :: Route -> String
routes (Auth Signin) = "/auth/signin"
routes (Auth Signup) = "/auth/signup"
routes Week = "/week"
routes NotFound = "/404"

