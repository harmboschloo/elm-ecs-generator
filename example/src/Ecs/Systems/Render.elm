module Ecs.Systems.Render exposing (view)

import Ecs exposing (Ecs, EntityId)
import Ecs.Components exposing (Display, Position)
import Html exposing (Html, div)
import Html.Attributes exposing (style)


width : Float
width =
    400


height : Float
height =
    400


px : Int -> String
px value =
    String.fromInt value ++ "px"


view : Ecs -> Html msg
view ecs =
    div
        [ style "position" "relative"
        , style "width" (round width |> px)
        , style "height" (round height |> px)
        , style "background-color" "#aaaaff"
        ]
        (Ecs.processEntities2 Ecs.position Ecs.display viewEntity ( ecs, [] )
            |> Tuple.second
        )


viewEntity :
    EntityId
    -> Position
    -> Display
    -> ( Ecs, List (Html msg) )
    -> ( Ecs, List (Html msg) )
viewEntity entityId position display ( ecs, elements ) =
    ( ecs
    , div
        [ style "position" "absolute"
        , style "width" "6px"
        , style "height" "6px"
        , style "left" (position.x * width - 3 |> round |> px)
        , style "top" (position.y * height - 3 |> round |> px)
        , style "background-color" display.color
        ]
        []
        :: elements
    )
