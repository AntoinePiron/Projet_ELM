module MyTypes exposing (..)

type Inst
    = Forward Int
    | Left Int
    | Right Int
    | Repeat Int (List Inst)

type alias Cursor = 
    { x : Float
    , y : Float
    , a : Float
    }

type alias InstStruct =
    { cmd : String
    , step : Int
    }

type MyEvent
  = Change String
  | Validate