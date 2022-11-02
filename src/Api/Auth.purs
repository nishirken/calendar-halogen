module Api.Auth where

import Prelude

import Affjax (Error, Response)
import Affjax.RequestBody as ARB
import Affjax.ResponseFormat as ARF
import Affjax.Web (Error(..), post, post_)
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Encode (encodeJson)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Models (AuthCreds)
import Url (mkUrl)

signin :: AuthCreds -> Aff (Either Error Unit)
signin creds = post_ (mkUrl true "/auth/signin") (Just $ ARB.Json $ encodeJson creds)

type UserResponse = { id :: Int, email :: String }

signup :: AuthCreds -> Aff (Either Error (Response UserResponse))
signup creds = do
  res <- post ARF.json (mkUrl true "/auth/signup") (Just $ ARB.Json $ encodeJson creds)
  pure (
    case res of
      Right res' -> case decodeJson res'.body of
                        Right decoded -> Right $ res' { body = decoded }
                        Left _ -> Left RequestFailedError
      Left err -> Left err
  )

