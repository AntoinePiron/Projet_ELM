module MyParser exposing(..)
import Parser exposing (Parser, (|.), (|=), succeed)
import Parser exposing (spaces)
import Parser exposing (int)
import Parser exposing (keyword)
import Parser exposing (oneOf)

import MyTypes exposing (..) 
import Parser exposing (sequence)
import Parser exposing (Trailing(..))
import Parser exposing (DeadEnd)
import Parser exposing (run)
import Parser exposing (lazy)

instruction : Parser Inst
instruction = 
  oneOf
    [ succeed Forward
        |. keyword "Forward"
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
    , succeed Repeat
        |. keyword "Repeat"
        |. spaces
        |= int
        |. spaces
        |= lazy (\_ -> block)
    ]

block : Parser (List Inst)
block = 
  sequence
  { start = "["
    , separator = ","
    , end = "]"
    , spaces = spaces
    , item = instruction
    , trailing = Optional -- demand a trailing semi-colon
    }

blockParser : String -> Result (List DeadEnd) (List Inst)
blockParser str = 
  run block str

