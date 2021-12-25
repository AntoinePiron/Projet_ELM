module MyParser exposing(..)
import Parser exposing (Parser, (|.), (|=), succeed)
import Parser exposing (run, DeadEnd)
import Parser exposing (symbol)
import Parser exposing (spaces)
import Parser exposing (int)
import Parser exposing (keyword)
import Parser exposing (oneOf)
import Parser exposing (getChompedString)
import Parser exposing (chompIf)
import Parser exposing (chompWhile)

import MyTypes exposing (..)

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
    ]

word : Parser String
word =
  getChompedString <|
    succeed ()
      |. chompIf Char.isAlphaNum
      |. chompWhile Char.isAlphaNum

instructionBloc : Parser InstStruct
instructionBloc = 
  succeed InstStruct
    |. symbol "["
    |. spaces
    |= word
    |. spaces
    |= int
    |. spaces
    |. symbol "]"

instBlocParser : String -> Result (List DeadEnd) InstStruct
instBlocParser string = 
  run instructionBloc string


instParser : String -> Result (List DeadEnd) Inst
instParser string =
  case instBlocParser string of
    Err er ->
      Result.Err er
    Ok expr ->
      run instruction (expr.cmd ++ " " ++ String.fromInt expr.step) 