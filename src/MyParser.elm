module MyParser exposing(..)
import Parser exposing (Parser, (|.), (|=), succeed)
import Parser exposing (run, DeadEnd)
import Parser exposing (symbol)
import Parser exposing (spaces)
import Parser exposing (int)
import Parser exposing (keyword)
import DrawingZone exposing (Inst(..))
import Parser exposing (oneOf)
type Inst 
  = Forward Int
  | Repeat Int
  | Left Int
  | Right Int

instruction : Parser Inst
instruction = 
  oneOf
    [ succeed Forward
        |. keyword "Forward"
        |. spaces
        |= int
    , succeed Repeat
        |. keyword "Repeat"
        |. spaces
        |= int
    , succeed Left
        |. keyword "Left"
        |. spaces
        |= int
    , succeed Right
        |. keyword "Right"
        |. spaces
        |= int
    ]

instParser : String -> Result (List DeadEnd) Inst
instParser string =
  run instruction string