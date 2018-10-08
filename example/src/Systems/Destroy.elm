module Systems.Destroy exposing (update)

import Components exposing (Destroy)
import Context exposing (Context)
import Ecs exposing (Ecs, EntityId)


update : ( Ecs, Context ) -> ( Ecs, Context )
update =
    Ecs.iterateDestroyEntities updateEntity


updateEntity :
    EntityId
    -> Destroy
    -> ( Ecs, Context )
    -> ( Ecs, Context )
updateEntity entityId destroy ( ecs, context ) =
    if context.time >= destroy.time then
        ( Ecs.destroyEntity entityId ecs, context )

    else
        ( ecs, context )
