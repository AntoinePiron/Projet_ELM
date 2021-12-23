module DrawingZone exposing (..)

type Inst
    = Forward Int
    | Left Int
    | Right Int
    | Repeat Int

type Prog = List Inst
type alias Cursor = 
    { x : Float
    , y : Float
    , a : Float
    }

printSvgTail : String
printSvgTail = "</svg>"
