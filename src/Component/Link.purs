module Component.Link where

import DOM.HTML.Indexed (HTMLa)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties (IProp)

link :: forall w i. Array (IProp HTMLa i) -> Array (HH.HTML w i) -> HH.HTML w i
link = HH.element (H.ElemName "wired-link")

