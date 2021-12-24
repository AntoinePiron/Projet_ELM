module Main exposing(..)
-- !!!!!!!!!!
-- Command to generate main.js file : elm make src/Main.elm --output=main.js
-- !!!!!!!!!!

import Browser
import Html exposing (Html, div, input, text, button)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onInput, onClick)
import MyParser exposing (..)
import DrawingZone exposing (..)
import Svg exposing (svg)
import Svg.Attributes exposing (width, height, viewBox)

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
      { model | display = case instParser model.content of
                            Err er ->
                              Debug.toString er

                            Ok expr ->
                              Debug.toString expr
      }

-- VIEW
view : Model -> Html MyEvent
view model =
  div [class "app"]
    [ div [class "mainTitle"] [
      text("Projet Elm"),
      div [class "subtitles"] [text("Par Tristan Devin, Salma Aziz-Alaoui, Yasser Issam, Antoine Piron")]
      ]
    , div [class "inputTitle"] [text("Type in your code below:")]
    , input [ placeholder "example: [Repeat 360 [Forward 1, Left 1]]", value model.content, onInput Change, class "userInput" ] []
    , div [] [ text(model.display)] --Permet le retour à la ligne
    , button [ onClick Validate, class "drawButton" ] [ text "Draw" ]
    , svg [viewBox "0 0 500 500", width "500", height "500"] []
    ]
