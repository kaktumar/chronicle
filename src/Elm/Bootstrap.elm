-- Elm wrapper over http://getbootstrap.com/components/
module Bootstrap where

import String

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HE


type Context
  = Primary
  | Success
  | Info
  | Warning
  | Danger

contextClassSuffix : Maybe Context -> String
contextClassSuffix c' =
  case c' of
    Nothing -> "default"
    Just c  -> String.toLower <| toString c

-- Panel with heading
panel : Html -> Html -> Html
panel = panel' Nothing


panel' : Maybe Context -> Html -> Html -> Html
panel' ctx' title content =
  div [ classList  [("panel", True), ("panel-" ++ contextClassSuffix ctx', True)] ]
  [ div [ class "panel-heading" ] [ title ]
  , div [ class "panel-body" ] [ content ]
  ]