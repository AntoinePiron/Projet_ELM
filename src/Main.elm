module Main exposing(main)
-- Elm packages import
import Browser
import Html exposing (Html, div, input, text, button, p)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onInput, onClick)
import Svg exposing (Svg, svg)
import Svg.Attributes exposing (width, height, viewBox)
import SingleSlider exposing (..)
-- Import of our files
import MyTypes exposing (..)
import MyParser exposing (..)
import DrawingZone exposing (..)

-- MAIN
main : Program () Model MyEvent
main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL
type alias Model =
  { content : String
  , lineList : List (Svg MyEvent)
  , drawingColor : String
  , singleSlider : SingleSlider.SingleSlider MyEvent
  , lineThickness : Float
  }
  
init : Model
init =
  { content = "" 
  , lineList = []
  , drawingColor = "red"
  , singleSlider = SingleSlider.init
      { min = 0.1
      , max = 5
      , value = 1
      , step = 0.1
      , onChange = SingleSliderChange
      }
  , lineThickness = 1
  }

-- UPDATE
update : MyEvent -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      { model | content = newContent }

    Validate ->
      { model | lineList = case blockParser model.content of
                            Err _ ->
                              []

                            Ok expr -> 
                              (Tuple.second (progCursorToSvg expr (Cursor 250 250 0) [] model.drawingColor (String.fromFloat model.lineThickness)))
      }
    
    ModifyColor newColor ->
      let new = { model | drawingColor = newColor}
      in update Validate new

    SingleSliderChange str ->
      let new = { content = model.content , lineList = model.lineList, drawingColor = model.drawingColor, singleSlider = SingleSlider.update str model.singleSlider, lineThickness = str}
      in update Validate new



-- VIEW
view : Model -> Html MyEvent
view model =
  div [class "app"]
    [ div [class "mainTitle"] 
      [ text("Projet Elm")
      , div [class "subtitles"] [text("Par Tristan Devin, Salma Aziz-Alaoui, Yasser Issam, Antoine Piron")]
      ]
    , div [class "sectionTitle"] [text("Type in your code below:")]
    , input [ placeholder "example: [Repeat 360 [Forward 1, Left 1]]", value model.content, onInput Change, class "userInput" ] []
    , div [ class "settings"] 
        [ p [class "sectionTitle"] [text "Cursor Settings : "]
        , div [ class "colors"] 
          [ p [class "littleSettingsTitle"] [text "Line color : "]
          , button [onClick (ModifyColor "green"),class "colorButtons" ] [ text "Green" ]
          , button [onClick (ModifyColor "red"),class "colorButtons" ] [ text "Red" ]
          , button [onClick (ModifyColor "blue"),class "colorButtons" ] [ text "Blue" ]
          ]
        , div [class "strokeWidth"] 
          [ p [class "littleSettingsTitle"] [text ("Line thickness : ")]
          , div [class "mySlider"] [ SingleSlider.view model.singleSlider ]
          ]
      ]
    , button [ onClick Validate, class "drawButton" ] [ text "Draw" ]
    , svg [viewBox "0 0 500 700", width "500", height "500"] 
      model.lineList
    , div [class "version"] [text ("V1.0 finalisée le 25/12/2021 🎅")]
    ]
