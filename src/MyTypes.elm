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

type MyEvent
  = Change String
  | Validate
  | ModifyColor String