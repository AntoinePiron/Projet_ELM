module DrawingZone exposing (..)
import Svg exposing (Svg, line)
import Svg.Attributes exposing (x1, x2, y1, y2, stroke)
import MyTypes exposing (..)

{--Méthode dessinant une ligne entre les deux curseurs rentré en argument--}
getSvgLine : Cursor -> Cursor -> Svg MyEvent
getSvgLine a b =
    line 
        [ x1 (String.fromFloat a.x)
        , y1 (String.fromFloat a.y)
        , x2 (String.fromFloat b.x)
        , y2 (String.fromFloat b.y)
        , stroke "red"
        ] [] 

{--Méthode permettant de modifier l'angle pour avoir a compris entre 0 et 360 --}
changeAngle : Float -> Float
changeAngle a = 
    if a < 0 then
        changeAngle (a + 360.0)
    else if a >= 360 then 
        changeAngle (a - 360.0)
    else 
        a

{-- Méthode qui actualise le curseur en fonction de l'instruction donnée --}
changeCursor : Cursor -> Inst -> Cursor
changeCursor c inst =
    case inst of
        (Forward v) -> let dx = toFloat v * (cos (c.a / 180.0 * pi))
                           dy = toFloat v * (sin (c.a / 180.0 * pi))
                        in Cursor (c.x+dx) (c.y+dy) c.a
        (Left v) -> Cursor (c.x) (c.y) (changeAngle(c.a + (toFloat v)))
        (Right v) -> Cursor (c.x) (c.y) (changeAngle(c.a - (toFloat v)))
        _ -> c

progCursorToSvg : List Inst -> Cursor -> List (Svg MyEvent) -> (Cursor, List (Svg MyEvent))
progCursorToSvg p c l=
    case p of
        [] -> (c, l)
        Repeat n bloc::subprog ->
            if n > 0 then
                let rp = Repeat (n - 1) bloc
                in 
                    let 
                        cp = progCursorToSvg bloc c l
                    in progCursorToSvg (rp::subprog) (Tuple.first cp) (Tuple.second cp) 
            else
                progCursorToSvg subprog c l
        inst::subprog ->
            let cp = changeCursor c inst
            in case inst of
                (Forward _) -> 
                    let conc = (getSvgLine c cp)::l
                    in progCursorToSvg subprog cp conc
                _ ->
                    progCursorToSvg subprog cp l

        