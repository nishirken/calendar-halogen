module Component.Input where

import DOM.HTML.Indexed (HTMLinput)
import Halogen as H
import Halogen.HTML as HH

input :: forall w i. HH.Leaf HTMLinput w i
input attrs =
  HH.element
  (H.ElemName "wired-input")
  attrs
  []

