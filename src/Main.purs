module Main where

import Data.Maybe
import Prelude
import Web.HTML

import Effect (Effect)
import Effect.Console (log)
import Effect.Exception (throw)
import Web.DOM (Document, Element)
import Web.DOM.Document (createElement, toNonElementParentNode)
import Web.DOM.Document as D
import Web.DOM.Element (setAttribute, toEventTarget, toNode)
import Web.DOM.Node (appendChild, setTextContent)
import Web.DOM.NonElementParentNode (getElementById)
import Web.Event.Event (Event, target)
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.HTML.Event.EventTypes (input)
import Web.HTML.HTMLDocument (toDocument)
import Web.HTML.HTMLInputElement (fromEventTarget, value)
import Web.HTML.Window (document)

type InputProps = { onInput :: Maybe String -> Effect Unit }

inputEl :: Document -> InputProps -> Effect Element
inputEl doc {onInput} = do
  el <- createElement "input" doc
  let
    getInputTarget :: Event -> Maybe HTMLInputElement
    getInputTarget event = do
      target' <- target event
      fromEventTarget target'
  listener <- eventListener $ \event -> do
     let inputTarget = getInputTarget event
     case inputTarget of
        Just inputTarget' -> do
          val <- value inputTarget'
          onInput $ Just val
        Nothing -> onInput Nothing 

  addEventListener input listener true (toEventTarget el)
  pure el

textEl :: Document -> Effect Element
textEl doc = do
  el <- createElement "div" doc
  setAttribute "style" "background: lightblue; width: 200px; height: 100px; margin-top: 20px;" el
  pure el

headerEl :: Document -> Effect Element
headerEl doc = do
  el <- createElement "h4" doc
  setTextContent "Hello" (toNode el)
  pure el

main :: Effect Unit
main = do
  w <- window
  doc <- document w
  ctr <- getElementById "root" $ toNonElementParentNode $ toDocument doc

  case ctr of
    Nothing -> throw "Container not found"
    Just ctr' -> do
      textEl' <- textEl $ toDocument doc
      headerEl' <- headerEl $ toDocument doc
      let
        handleInput :: Maybe String -> Effect Unit
        handleInput (Just str) = setTextContent str (toNode textEl')
        handleInput Nothing = pure unit
      inputEl' <- inputEl (toDocument doc) { onInput: handleInput }
      appendChild (toNode headerEl') (toNode ctr')
      appendChild (toNode inputEl') (toNode ctr')
      appendChild (toNode textEl') (toNode ctr')
