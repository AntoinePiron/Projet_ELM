module Main exposing(..)

import Browser
import Html exposing (Html, div, input, text, button)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

-- MAIN
main : Program () Model MyEvent
main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL
type alias Model =
  { content : String
  , display : String
  }
init : Model
init =
  { content = "" 
  , display = ""
  }

-- UPDATE
type MyEvent
  = Change String
  | Validate
update : MyEvent -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      { model | content = newContent }

    Validate ->
      { model | display = model.content }

-- VIEW
view : Model -> Html MyEvent
view model =
  div []
    [ input [ placeholder "[Repeat 360 [Forward 1, Left 1]]", value model.content, onInput Change ] []
    , div [] [ text("Texte validé : " ++ model.display)] --Permet le retour à la ligne
    , button [ onClick Validate ] [ text "Draw" ]
    ]