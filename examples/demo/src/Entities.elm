module Entities exposing
    ( createAiShip
    , createPlayerShip
    , createStar
    , init
    )

import Assets exposing (Assets, Spritesheet)
import Collision.Shape as Shape
import Components
    exposing
        ( Ai
        , KeyControlsMap
        , Motion
        , Position
        , Scale
        , ScaleAnimation
        , Sprite
        , Velocity
        )
import Components.CollisionShape as CollisionShape exposing (CollisionShape)
import Components.Controls exposing (Controls, controls)
import Components.DelayedOperations as DelayedOperations
    exposing
        ( DelayedOperations
        )
import Data.Animation as Animation
import Data.KeyCode as KeyCode
import Ecs exposing (Ecs)
import Global exposing (Global)
import Random exposing (Generator)
import Utils exposing (times)



-- INIT --


init : ( Global, Ecs ) -> ( Global, Ecs )
init state =
    state
        |> times 10 createAiShip
        |> createPlayerShip
        |> times 30 createStar



-- CREATE ENTITIES --


shipMotion : Motion
shipMotion =
    { maxAcceleration = 600
    , maxDeceleration = 400
    , maxAngularAcceleration = 20
    , maxAngularVelocity = 5
    }


createPlayerShip : ( Global, Ecs ) -> ( Global, Ecs )
createPlayerShip ( global1, ecs ) =
    let
        assets =
            Global.getAssets global1

        world =
            Global.getWorld global1

        ( angle, global2 ) =
            Global.randomStep angleGenerator global1

        ( entityId, global3 ) =
            Global.addEntity global2
    in
    ( global3
    , ecs
        |> setShipComponents
            entityId
            assets.sprites.playerShip
            { x = world.width / 2
            , y = world.height / 2
            , angle = angle
            }
        |> Ecs.insert .keyControlsMap
            entityId
            { accelerate = KeyCode.arrowUp
            , decelerate = KeyCode.arrowDown
            , rotateLeft = KeyCode.arrowLeft
            , rotateRight = KeyCode.arrowRight
            }
    )


createAiShip : ( Global, Ecs ) -> ( Global, Ecs )
createAiShip ( global1, ecs ) =
    let
        assets =
            Global.getAssets global1

        world =
            Global.getWorld global1

        ( position, global2 ) =
            Global.randomStep (positionGenerator world) global1

        ( entityId, global3 ) =
            Global.addEntity global2
    in
    ( global3
    , ecs
        |> setShipComponents
            entityId
            assets.sprites.aiShip
            position
        |> Ecs.insert .ai entityId ()
    )


setShipComponents :
    Ecs.EntityId
    -> Sprite
    -> Position
    -> Ecs
    -> Ecs
setShipComponents entityId sprite position =
    Ecs.insert .sprite entityId sprite
        >> Ecs.insert .position entityId position
        >> Ecs.insert .controls entityId (controls 0 0)
        >> Ecs.insert .motion entityId shipMotion
        >> Ecs.insert .velocity entityId (Velocity 0 0 0)
        >> Ecs.insert .collisionShape
            entityId
            (CollisionShape
                (Shape.circle 30)
                CollisionShape.shipScoop
            )


createStar : ( Global, Ecs ) -> ( Global, Ecs )
createStar ( global1, ecs ) =
    let
        assets =
            Global.getAssets global1

        world =
            Global.getWorld global1

        time =
            Global.getTime global1

        ( position, global2 ) =
            Global.randomStep (positionGenerator world) global1

        ( delay, global3 ) =
            Global.randomStep (Random.float 0 1) global2

        ( entityId, global4 ) =
            Global.addEntity global3
    in
    ( global4
    , ecs
        |> Ecs.insert .sprite entityId assets.sprites.star
        |> Ecs.insert .position entityId position
        |> Ecs.insert .velocity entityId (Velocity 0 0 (pi / 4))
        |> Ecs.insert .scale entityId 0
        |> Ecs.insert .scaleAnimation
            entityId
            (Animation.animation
                { startTime = time
                , duration = 0.5
                , from = 0
                , to = 1
                }
                |> Animation.delay delay
            )
        |> Ecs.update .delayedOperations
            entityId
            (DelayedOperations.add
                (time + delay + 0.5)
                (DelayedOperations.InsertCollisionShape
                    (CollisionShape Shape.point CollisionShape.starCenter)
                )
            )
    )



-- GENERATORS --


positionGenerator : Global.World -> Generator Position
positionGenerator world =
    Random.map3 Position
        (Random.float 0 world.width)
        (Random.float 0 world.height)
        angleGenerator


angleGenerator : Generator Float
angleGenerator =
    Random.float 0 (2 * pi)
