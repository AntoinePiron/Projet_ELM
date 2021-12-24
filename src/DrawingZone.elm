module DrawingZone exposing (..)

type Inst
    = Forward Int
    | Left Int
    | Right Int
    | Repeat Int
type alias Cursor = 
    { x : Float
    , y : Float
    , a : Float
    }

printSvgLine : Cursor -> Cursor -> String
printSvgLine a b =
    let 
        prefix =
            "<line"
        x1y1 = 
            " x1=\"" ++ String.fromFloat a.x ++ "\" y1=\"" ++ String.fromFloat a.y
        x2y2 = 
            "\" x2=\"" ++ String.fromFloat b.x ++ "\" y2=\"" ++ String.fromFloat b.y
        suffix = 
            "\" stroke=\"red\" />"
    in 
        prefix ++ x1y1 ++ x2y2 ++ suffix

printSvgTail : String
printSvgTail = "</svg>"

changeAngle : Float -> Float
changeAngle a = 
    if a < 0 then
        changeAngle (a+360.0)
    else if a >= 360 then 
        changeAngle (a-360.0)
    else 
        a