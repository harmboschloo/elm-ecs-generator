module Components exposing
    ( Ai
    , KeyControlsMap
    , Motion
    , Position
    , Scale
    , ScaleAnimation
    , Sprite
    , Velocity
    )

import Data.Animation exposing (Animation)
import Data.KeyCode exposing (KeyCode)
import WebGL.Texture exposing (Texture)


type alias Ai =
    ()



type alias KeyControlsMap =
    { accelerate : KeyCode
    , decelerate : KeyCode
    , rotateLeft : KeyCode
    , rotateRight : KeyCode
    }


type alias Motion =
    { maxAcceleration : Float
    , maxDeceleration : Float
    , maxAngularAcceleration : Float
    , maxAngularVelocity : Float
    }


type alias Position =
    { x : Float
    , y : Float
    , angle : Float
    }


type alias Scale =
    Float


type alias ScaleAnimation =
    Animation


type alias Sprite =
    { texture : Texture
    , x : Float
    , y : Float
    , width : Float
    , height : Float
    , pivotX : Float
    , pivotY : Float
    }


type alias Velocity =
    { velocityX : Float
    , velocityY : Float
    , angularVelocity : Float
    }
