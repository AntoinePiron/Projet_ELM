module MyParser exposing(..)
import Parser exposing (Parser, (|.), (|=), succeed, symbol, float, spaces)

type alias Point =
  { x : Float
  , y : Float
  }

type Inst = Forward Int | Left Int | Right Int | Repeat Int 

point : Parser Point
point =
  succeed Point
    |. symbol "("
    |. spaces
    |= float
    |. spaces
    |. symbol ","
    |. spaces
    |= float
    |. spaces
    |. symbol ")"