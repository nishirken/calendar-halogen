module Url where

import Prelude

import Affjax (URL)

-- builds url depenging on env
mkUrl :: Boolean -> String -> URL
mkUrl isDev path = if isDev then "http://localhost:8081" <> path else "/api" <> path
