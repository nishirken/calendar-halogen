module Models.Auth where

import Prelude

import Data.Argonaut.Core (jsonEmptyObject)
import Data.Argonaut.Decode (decodeJson, (.:))
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Encode ((:=), (~>))
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

newtype AuthCreds = AuthCreds { email :: String, password :: String }

derive instance authCredsGeneric :: Generic AuthCreds _

instance authCredsShow :: Show AuthCreds where
  show = genericShow

derive instance authCredsEq :: Eq AuthCreds

instance encodeAuthCreds :: EncodeJson AuthCreds where
  encodeJson (AuthCreds { email, password }) =
    "email" := email ~> "password" := password ~> jsonEmptyObject

instance decodeAuthCreds :: DecodeJson AuthCreds where
  decodeJson json = do
    obj <- decodeJson json
    email <- obj .: "email"
    password <- obj .: "password"
    pure $ AuthCreds { email, password }
