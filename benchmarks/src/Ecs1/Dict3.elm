module Ecs1.Dict3 exposing
    ( Ecs, empty
    , EntityId, create, destroy, reset, size, activeSize, idToInt, intToId
    , get, insert, update, remove
    , iterate
    , ComponentSpec, componentSpecs
    , NodeSpec, nodeSpec1, nodeSpec2, nodeSpec3
    )

{-| Entitiy-Component-System.


# Model

@docs Ecs, empty


# Entities

@docs EntityId, create, destroy, reset, size, activeSize, idToInt, intToId


# Components

@docs Components, get, insert, update, remove


# Iterate Entities

@docs iterate


# Component Specs

@docs ComponentSpec, componentSpecs


# Node Specs

@docs NodeSpec, nodeSpec1, nodeSpec2, nodeSpec3

-}

import Dict exposing (Dict)



-- MODEL --


{-| -}
type Ecs c1 c2 c3
    = Ecs (Model c1 c2 c3)


type alias Model c1 c2 c3 =
    { container : Container c1 c2 c3
    , numberOfCreatedEntities : Int
    , destroyedEntities : List Int
    }


type alias Container c1 c2 c3 =
    { components1 : Dict Int c1
    , components2 : Dict Int c2
    , components3 : Dict Int c3
    }


{-| -}
empty : Ecs c1 c2 c3
empty =
    Ecs
        { container =
            { components1 = Dict.empty
            , components2 = Dict.empty
            , components3 = Dict.empty
            }
        , numberOfCreatedEntities = 0
        , destroyedEntities = []
        }



-- ENTITIES --


{-| -}
type EntityId
    = EntityId Int


{-| -}
create : Ecs c1 c2 c3 -> ( Ecs c1 c2 c3, EntityId )
create (Ecs model) =
    case model.destroyedEntities of
        [] ->
            ( Ecs
                { container = model.container
                , numberOfCreatedEntities = model.numberOfCreatedEntities + 1
                , destroyedEntities = model.destroyedEntities
                }
            , EntityId model.numberOfCreatedEntities
            )

        head :: tail ->
            ( Ecs
                { container = model.container
                , numberOfCreatedEntities = model.numberOfCreatedEntities
                , destroyedEntities = tail
                }
            , EntityId head
            )


{-| -}
destroy : EntityId -> Ecs c1 c2 c3 -> Ecs c1 c2 c3
destroy (EntityId entityId) (Ecs model) =
    Ecs
        { container = resetEntity entityId model.container
        , numberOfCreatedEntities = model.numberOfCreatedEntities
        , destroyedEntities = entityId :: model.destroyedEntities
        }


{-| -}
reset : EntityId -> Ecs c1 c2 c3 -> Ecs c1 c2 c3
reset (EntityId entityId) (Ecs model) =
    Ecs
        { container = resetEntity entityId model.container
        , numberOfCreatedEntities = model.numberOfCreatedEntities
        , destroyedEntities = model.destroyedEntities
        }


resetEntity : Int -> Container c1 c2 c3 -> Container c1 c2 c3
resetEntity entityId container =
    { components1 = Dict.remove entityId container.components1
    , components2 = Dict.remove entityId container.components2
    , components3 = Dict.remove entityId container.components3
    }


{-| -}
size : Ecs c1 c2 c3 -> Int
size (Ecs model) =
    model.numberOfCreatedEntities


{-| -}
activeSize : Ecs c1 c2 c3 -> Int
activeSize (Ecs model) =
    model.numberOfCreatedEntities - List.length model.destroyedEntities


{-| -}
idToInt : EntityId -> Int
idToInt (EntityId id) =
    id


{-| -}
intToId : Int -> Ecs c1 c2 c3 -> Maybe EntityId
intToId id ecs =
    if id < size ecs then
        Just (EntityId id)

    else
        Nothing



-- COMPONENTS --


{-| -}
get :
    EntityId
    -> ComponentSpec c1 c2 c3 component
    -> Ecs c1 c2 c3
    -> Maybe component
get (EntityId entityId) (ComponentSpec spec) (Ecs model) =
    Dict.get entityId (spec.getComponents model.container)


{-| -}
insert :
    EntityId
    -> ComponentSpec c1 c2 c3 component
    -> component
    -> Ecs c1 c2 c3
    -> Ecs c1 c2 c3
insert (EntityId entityId) (ComponentSpec spec) component (Ecs model) =
    Ecs
        { container =
            spec.updateComponents
                (\container -> Dict.insert entityId component container)
                model.container
        , numberOfCreatedEntities = model.numberOfCreatedEntities
        , destroyedEntities = model.destroyedEntities
        }


{-| -}
update :
    EntityId
    -> ComponentSpec c1 c2 c3 component
    -> (Maybe component -> Maybe component)
    -> Ecs c1 c2 c3
    -> Ecs c1 c2 c3
update (EntityId entityId) (ComponentSpec spec) updater (Ecs model) =
    Ecs
        { container =
            spec.updateComponents
                (\container -> Dict.update entityId updater container)
                model.container
        , numberOfCreatedEntities = model.numberOfCreatedEntities
        , destroyedEntities = model.destroyedEntities
        }


{-| -}
remove :
    EntityId
    -> ComponentSpec c1 c2 c3 component
    -> Ecs c1 c2 c3
    -> Ecs c1 c2 c3
remove (EntityId entityId) (ComponentSpec spec) (Ecs model) =
    Ecs
        { container =
            spec.updateComponents
                (\container -> Dict.remove entityId container)
                model.container
        , numberOfCreatedEntities = model.numberOfCreatedEntities
        , destroyedEntities = model.destroyedEntities
        }



-- ITERATE ENTITIES --


{-| -}
iterate :
    NodeSpec c1 c2 c3 node x
    -> (EntityId -> node -> ( Ecs c1 c2 c3, x ) -> ( Ecs c1 c2 c3, x ))
    -> ( Ecs c1 c2 c3, x )
    -> ( Ecs c1 c2 c3, x )
iterate (NodeSpec iterateNode) =
    iterateNode


iterate1 :
    (component1 -> node)
    -> ComponentSpec c1 c2 c3 component1
    -> (EntityId -> node -> ( Ecs c1 c2 c3, x ) -> ( Ecs c1 c2 c3, x ))
    -> ( Ecs c1 c2 c3, x )
    -> ( Ecs c1 c2 c3, x )
iterate1 createNode (ComponentSpec spec) callback ( Ecs model, x ) =
    Dict.foldl
        (\entityId c1 state ->
            callback (EntityId entityId) (createNode c1) state
        )
        ( Ecs model, x )
        (spec.getComponents model.container)


iterate2 :
    (component1 -> component2 -> node)
    -> ComponentSpec c1 c2 c3 component1
    -> ComponentSpec c1 c2 c3 component2
    -> (EntityId -> node -> ( Ecs c1 c2 c3, x ) -> ( Ecs c1 c2 c3, x ))
    -> ( Ecs c1 c2 c3, x )
    -> ( Ecs c1 c2 c3, x )
iterate2 createNode (ComponentSpec componentSpec1) (ComponentSpec componentSpec2) callback ( Ecs model, x ) =
    let
        components1 =
            componentSpec1.getComponents model.container

        components2 =
            componentSpec2.getComponents model.container
    in
    Dict.foldl
        (\entityId c1 state ->
            case Dict.get entityId components2 of
                Nothing ->
                    state

                Just c2 ->
                    callback
                        (EntityId entityId)
                        (createNode c1 c2)
                        state
        )
        ( Ecs model, x )
        components1


iterate3 :
    (component1 -> component2 -> component3 -> node)
    -> ComponentSpec c1 c2 c3 component1
    -> ComponentSpec c1 c2 c3 component2
    -> ComponentSpec c1 c2 c3 component3
    -> (EntityId -> node -> ( Ecs c1 c2 c3, x ) -> ( Ecs c1 c2 c3, x ))
    -> ( Ecs c1 c2 c3, x )
    -> ( Ecs c1 c2 c3, x )
iterate3 createNode (ComponentSpec componentSpec1) (ComponentSpec componentSpec2) (ComponentSpec componentSpec3) callback ( Ecs model, x ) =
    let
        components1 =
            componentSpec1.getComponents model.container

        components2 =
            componentSpec2.getComponents model.container

        components3 =
            componentSpec3.getComponents model.container
    in
    Dict.foldl
        (\entityId c1 state ->
            case Dict.get entityId components2 of
                Nothing ->
                    state

                Just c2 ->
                    case Dict.get entityId components3 of
                        Nothing ->
                            state

                        Just c3 ->
                            callback
                                (EntityId entityId)
                                (createNode c1 c2 c3)
                                state
        )
        ( Ecs model, x )
        components1



-- SPECS --


{-| -}
type ComponentSpec c1 c2 c3 component
    = ComponentSpec
        { getComponents : Container c1 c2 c3 -> Dict Int component
        , updateComponents :
            (Dict Int component -> Dict Int component)
            -> Container c1 c2 c3
            -> Container c1 c2 c3
        }


{-| -}
componentSpecs :
    (ComponentSpec c1 c2 c3 c1
     -> ComponentSpec c1 c2 c3 c2
     -> ComponentSpec c1 c2 c3 c3
     -> a
    )
    -> a
componentSpecs createSpecs =
    createSpecs components1Spec components2Spec components3Spec


components1Spec : ComponentSpec c1 c2 c3 c1
components1Spec =
    ComponentSpec
        { getComponents = .components1
        , updateComponents =
            \updater container ->
                { components1 = updater container.components1
                , components2 = container.components2
                , components3 = container.components3
                }
        }


components2Spec : ComponentSpec c1 c2 c3 c2
components2Spec =
    ComponentSpec
        { getComponents = .components2
        , updateComponents =
            \updater container ->
                { components1 = container.components1
                , components2 = updater container.components2
                , components3 = container.components3
                }
        }


components3Spec : ComponentSpec c1 c2 c3 c3
components3Spec =
    ComponentSpec
        { getComponents = .components3
        , updateComponents =
            \updater container ->
                { components1 = container.components1
                , components2 = container.components2
                , components3 = updater container.components3
                }
        }



-- NODE SPECS --


type NodeSpec c1 c2 c3 node x
    = NodeSpec (IterateNode c1 c2 c3 node x)


type alias IterateNode c1 c2 c3 node x =
    (EntityId -> node -> ( Ecs c1 c2 c3, x ) -> ( Ecs c1 c2 c3, x ))
    -> ( Ecs c1 c2 c3, x )
    -> ( Ecs c1 c2 c3, x )


nodeSpec1 :
    (component1 -> node)
    -> ComponentSpec c1 c2 c3 component1
    -> NodeSpec c1 c2 c3 node x
nodeSpec1 createNode spec1 =
    NodeSpec (iterate1 createNode spec1)


nodeSpec2 :
    (component1 -> component2 -> node)
    -> ComponentSpec c1 c2 c3 component1
    -> ComponentSpec c1 c2 c3 component2
    -> NodeSpec c1 c2 c3 node x
nodeSpec2 createNode spec1 spec2 =
    NodeSpec (iterate2 createNode spec1 spec2)


nodeSpec3 :
    (component1 -> component2 -> component3 -> node)
    -> ComponentSpec c1 c2 c3 component1
    -> ComponentSpec c1 c2 c3 component2
    -> ComponentSpec c1 c2 c3 component3
    -> NodeSpec c1 c2 c3 node x
nodeSpec3 createNode spec1 spec2 spec3 =
    NodeSpec (iterate3 createNode spec1 spec2 spec3)