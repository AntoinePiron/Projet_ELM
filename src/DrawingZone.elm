module DrawingZone exposing (..)

import Svg exposing (Svg, line)
import Svg.Attributes exposing (x1, x2, y1, y2, stroke, style)

import MyTypes exposing (..)

getSvgLine : Cursor -> Cursor -> String -> String -> Svg MyEvent
getSvgLine a b color thickness =
    line 
        [ x1 (String.fromFloat a.x)
        , y1 (String.fromFloat a.y)
        , x2 (String.fromFloat b.x)
        , y2 (String.fromFloat b.y)
        , stroke color
        , style ("stroke:"++ color ++";stroke-width:"++thickness)
        ] 
        [] 


getMinMaxCoordinates : List Inst -> Cursor ->(Cursor, Cursor) -> (Cursor, (Cursor, Cursor))
getMinMaxCoordinates prog currCurs curs = 
    case prog of
        [] -> (currCurs, curs)
        Repeat n bloc::subprog ->
            if n > 0 then
                let rp = Repeat (n - 1) bloc
                in 
                    let cp = getMinMaxCoordinates bloc currCurs curs
                    in getMinMaxCoordinates (rp::subprog) (Tuple.first cp) (Tuple.second cp)
            else
                getMinMaxCoordinates subprog currCurs curs
        inst::subprog ->
            let cp = changeCursor currCurs inst
            in case inst of
                (Forward _) -> 
                    let 
                        xmin =  if currCurs.x < (Tuple.first curs).x then 
                                    currCurs.x 
                                else if cp.x < (Tuple.first curs).x then 
                                    cp.x 
                                else 
                                    (Tuple.first curs).x
                        ymin =  if currCurs.y < (Tuple.first curs).y then 
                                    currCurs.y
                                else if cp.y < (Tuple.first curs).y then 
                                    cp.y
                                else 
                                    (Tuple.first curs).y
                        xmax =  if currCurs.x > (Tuple.second curs).x then 
                                    currCurs.x 
                                else if cp.x > (Tuple.second curs).x then 
                                    cp.x 
                                else 
                                    (Tuple.second curs).x
                        ymax =  if currCurs.y > (Tuple.second curs).y then 
                                    currCurs.y 
                                else if cp.y > (Tuple.second curs).y then 
                                    cp.y 
                                else 
                                    (Tuple.second curs).y
                        newMinMax = (Cursor xmin ymin 0, Cursor xmax ymax 0)    
                    in getMinMaxCoordinates subprog cp newMinMax
                _ ->
                    getMinMaxCoordinates subprog cp curs

changeAngle : Float -> Float
changeAngle a = 
    if a < 0 then
        changeAngle (a + 360.0)
    else if a >= 360 then 
        changeAngle (a - 360.0)
    else 
        a

changeCursor : Cursor -> Inst -> Cursor
changeCursor c inst =
    case inst of
        (Forward v) -> let dx = toFloat v * (cos (c.a / 180.0 * pi))
                           dy = toFloat v * (sin (c.a / 180.0 * pi))
                        in Cursor (c.x+dx) (c.y+dy) c.a
        (Left v) -> Cursor (c.x) (c.y) (changeAngle(c.a - (toFloat v)))
        (Right v) -> Cursor (c.x) (c.y) (changeAngle(c.a + (toFloat v)))
        _ -> c

progCursorToSvg : List Inst -> Cursor -> List (Svg MyEvent) -> (String, String)-> (Cursor, List (Svg MyEvent))
progCursorToSvg prog curs list attr =
    case prog of
        [] -> (curs, list)
        Repeat n bloc::subprog ->
            if n > 0 then
                let rp = Repeat (n - 1) bloc
                in 
                    let cp = progCursorToSvg bloc curs list attr 
                    in progCursorToSvg (rp::subprog) (Tuple.first cp) (Tuple.second cp) attr 
            else
                progCursorToSvg subprog curs list attr 
        inst::subprog ->
            let cp = changeCursor curs inst
            in case inst of
                (Forward _) -> 
                    let 
                        conc = (getSvgLine curs cp (Tuple.first attr) (Tuple.second attr))::list
                    in progCursorToSvg subprog cp conc attr 
                _ ->
                    progCursorToSvg subprog cp list attr

        