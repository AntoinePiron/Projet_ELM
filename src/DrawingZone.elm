module DrawingZone exposing (..)
import Svg exposing (Svg, line)
import Svg.Attributes exposing (x1, x2, y1, y2, stroke, style)
import MyTypes exposing (..)


{--Méthode dessinant une ligne entre les deux curseurs rentré en argument--}
getSvgLine : Cursor -> Cursor -> String -> String -> (Cursor, Cursor) -> (Svg MyEvent, (Cursor,Cursor))
getSvgLine a b color thickness minmax =
    let myline = line [ x1 (String.fromFloat a.x), y1 (String.fromFloat a.y), x2 (String.fromFloat b.x), y2 (String.fromFloat b.y), stroke color, style ("stroke:"++ color ++";stroke-width:"++thickness)] [] 
    in (myline, minmax)

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
        (Left v) -> Cursor (c.x) (c.y) (changeAngle(c.a - (toFloat v)))
        (Right v) -> Cursor (c.x) (c.y) (changeAngle(c.a + (toFloat v)))
        _ -> c

{-- 
Méthode qui tranforme une suite d'instruction en une liste d'élément svg
Cette métode prend en paramètre une programmation (qui nous provient du parser),
un curseur qui définit la position initiale, une liste d'élément svg (initialement vide), 
une couleur et une épaisseur sous forme de tuple pour alléger les appels récursifs 
un tuple de curseur pour avoir les positions min et max
--}
progCursorToSvg : List Inst -> Cursor -> List (Svg MyEvent) -> (String, String) -> (Cursor, Cursor) -> (Cursor, List (Svg MyEvent))
progCursorToSvg prog curs list attr minmax=
    case prog of
        [] -> (curs, list)
        Repeat n bloc::subprog ->
            if n > 0 then
                let rp = Repeat (n - 1) bloc
                in 
                    let cp = progCursorToSvg bloc curs list attr minmax
                    in progCursorToSvg (rp::subprog) (Tuple.first cp) (Tuple.second cp) attr minmax
            else
                progCursorToSvg subprog curs list attr minmax
        inst::subprog ->
            let cp = changeCursor curs inst
            in case inst of
                (Forward _) -> 
                    let 
                        res = (getSvgLine curs cp (Tuple.first attr) (Tuple.second attr) minmax)
                        conc = (Tuple.first res)::list
                    in progCursorToSvg subprog cp conc attr minmax
                _ ->
                    progCursorToSvg subprog cp list attr minmax

        