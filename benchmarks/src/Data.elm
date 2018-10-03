module Data exposing
    ( EcsApi
    , arrayEcsApi
    , createEntity
    , createEntity2
    , createEntity3
    , dictEcsApi
    , times
    )

import ArrayEcs
import DictEcs



-- APIS


type alias EcsApi ecs entityId componentType =
    { empty : ecs
    , createEntity : ecs -> ( ecs, entityId )
    , insertComponent : entityId -> componentType -> () -> ecs -> ecs
    , a : componentType
    , b : componentType
    , c : componentType
    }


arrayEcsApi : EcsApi ArrayEcs.Ecs ArrayEcs.EntityId (ArrayEcs.ComponentType ())
arrayEcsApi =
    { empty = ArrayEcs.empty
    , createEntity = ArrayEcs.createEntity
    , insertComponent = ArrayEcs.insertComponent
    , a = ArrayEcs.a
    , b = ArrayEcs.b
    , c = ArrayEcs.c
    }


dictEcsApi : EcsApi DictEcs.Ecs DictEcs.EntityId (DictEcs.ComponentType ())
dictEcsApi =
    { empty = DictEcs.empty
    , createEntity = DictEcs.createEntity
    , insertComponent = DictEcs.insertComponent
    , a = DictEcs.a
    , b = DictEcs.b
    , c = DictEcs.c
    }



-- CREATE ENTITIES


createEntity : EcsApi ecs entityId componentType -> componentType -> ecs -> ecs
createEntity api componentType ecs =
    let
        ( newEcs, entityId ) =
            api.createEntity ecs
    in
    api.insertComponent entityId componentType () newEcs


createEntity2 :
    EcsApi ecs entityId componentType
    -> componentType
    -> componentType
    -> ecs
    -> ecs
createEntity2 api componentType1 componentType2 ecs =
    let
        ( newEcs, entityId ) =
            api.createEntity ecs
    in
    newEcs
        |> api.insertComponent entityId componentType1 ()
        |> api.insertComponent entityId componentType2 ()


createEntity3 :
    EcsApi ecs entityId componentType
    -> componentType
    -> componentType
    -> componentType
    -> ecs
    -> ecs
createEntity3 api componentType1 componentType2 componentType3 ecs =
    let
        ( newEcs, entityId ) =
            api.createEntity ecs
    in
    newEcs
        |> api.insertComponent entityId componentType1 ()
        |> api.insertComponent entityId componentType2 ()
        |> api.insertComponent entityId componentType3 ()



-- HELPERS


times : Int -> (a -> a) -> a -> a
times count function value =
    if count <= 0 then
        value

    else
        times (count - 1) function (function value)