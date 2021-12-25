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
import Svg exposing (Svg, svg)
import Svg.Attributes exposing (width, height, viewBox)
import MyTypes exposing (..)

-- MAIN
main : Program () Model MyEvent
main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL
type alias Model =
  { content : String
  , lineList : List (Svg MyEvent)
  }
init : Model
init =
  { content = "" 
  , lineList = []
  }

-- UPDATE
update : MyEvent -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      { model | content = newContent }

    Validate ->
      { model | lineList = case instParser model.content of
                            Err _ ->
                              []

                            Ok expr ->
                              (Tuple.second (progCursorToSvg [expr] (Cursor 250 250 0) []))
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
    , button [ onClick Validate, class "drawButton" ] [ text "Draw" ]
    , svg 
      [viewBox "0 0 500 500", width "500", height "500"] 
      model.lineList
    ]
