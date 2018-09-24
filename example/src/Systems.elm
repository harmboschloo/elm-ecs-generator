module Systems exposing (update, view)

import Context exposing (Context)
import Ecs exposing (Ecs, EntityId)
import Html exposing (Html)
import Systems.Animation as Animation
import Systems.Collection as Collection
import Systems.Destroy as Destroy
import Systems.KeyControls as KeyControls
import Systems.MotionControl as MotionControl
import Systems.Movement as Movement
import Systems.Render as Render


update : Context -> Ecs -> ( Ecs, Context )
update context ecs =
    ( ecs, context )
        |> Destroy.update
        |> KeyControls.update
        |> MotionControl.update
        |> Movement.update
        |> Animation.update
        |> Collection.update


view : Context -> Ecs -> Html msg
view =
    Render.view