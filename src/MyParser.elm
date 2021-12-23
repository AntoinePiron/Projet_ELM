module MyParser exposing(..)
import Parser exposing (Parser, (|.), (|=), succeed, token, map, backtrackable, oneOf, chompIf)
import Parser exposing (run, DeadEnd)


keywordParser : String -> String -> Result (List DeadEnd) Bool
keywordParser check string =
  run (keyword check) string

keyword : String -> Parser Bool
keyword kwd =
  succeed identity
    |. backtrackable (token kwd)
    |= oneOf
        [ map (\_ -> True) (backtrackable (chompIf isVarChar))
        , succeed False
        ]
    
isVarChar : Char -> Bool
isVarChar char =
  Char.isAlphaNum char || char == '_'