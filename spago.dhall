{-
Welcome to a Spago project!
You can edit this file as you like.

Need help? See the following resources:
- Spago documentation: https://github.com/purescript/spago
- Dhall language tour: https://docs.dhall-lang.org/tutorials/Language-Tour.html

When creating a new Spago project, you can use
`spago init --no-comments` or `spago init -C`
to generate this file without the comments in this block.
-}
{ name = "my-project"
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-web"
  , "argonaut-codecs"
  , "argonaut-core"
  , "arrays"
  , "console"
  , "const"
  , "control"
  , "css"
  , "debug"
  , "dom-indexed"
  , "effect"
  , "either"
  , "exceptions"
  , "foreign"
  , "halogen"
  , "halogen-css"
  , "halogen-formless"
  , "halogen-subscriptions"
  , "halogen-vdom"
  , "lists"
  , "maybe"
  , "newtype"
  , "prelude"
  , "routing"
  , "typelevel-prelude"
  , "unsafe-coerce"
  , "uri"
  , "web-dom"
  , "web-events"
  , "web-html"
  , "web-uievents"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
