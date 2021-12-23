module MyParser exposing(..)
import Parser exposing (Parser, (|.), (|=), succeed, token, andThen, problem, commit, map, backtrackable, oneOf, chompIf)
import Parser exposing (run, DeadEnd)


keywordParser : String -> String -> Result (List DeadEnd) ()
keywordParser check string =
  run (keyword check) string

keyword : String -> Parser ()
keyword kwd =
  succeed identity
    |. backtrackable (token kwd)
    |= oneOf
        [ map (\_ -> True) (backtrackable (chompIf isVarChar))
        , succeed False
        ]
    |> andThen (checkEnding kwd)

checkEnding : String -> Bool -> Parser ()
checkEnding kwd isBadEnding =
  if isBadEnding then
    problem ("expecting the `" ++ kwd ++ "` keyword")
  else
    commit ()

isVarChar : Char -> Bool
isVarChar char =
  Char.isAlphaNum char || char == '_'