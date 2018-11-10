module Ecs.Entity5 exposing (entity, components)

{-| ECS entities with 5 components.
-}

import Ecs.Internal exposing (ComponentSpec(..), EntitySpec(..))


{-| -}
entity :
    (Maybe component1 -> Maybe component2 -> Maybe component3 -> Maybe component4 -> Maybe component5 -> components)
    -> EntitySpec components
entity createComponents =
    EntitySpec { empty = createComponents Nothing Nothing Nothing Nothing Nothing }


{-| -}
components :
    (ComponentSpec components component1 -> ComponentSpec components component2 -> ComponentSpec components component3 -> ComponentSpec components component4 -> ComponentSpec components component5 -> componentSpecs)
    -> (Maybe component1 -> Maybe component2 -> Maybe component3 -> Maybe component4 -> Maybe component5 -> components)
    -> (components -> Maybe component1)
    -> (components -> Maybe component2)
    -> (components -> Maybe component3)
    -> (components -> Maybe component4)
    -> (components -> Maybe component5)
    -> componentSpecs
components createComponentSpecs createComponents get1 get2 get3 get4 get5 =
    createComponentSpecs
        (ComponentSpec
            { getComponent = get1
            , setComponent =
                \component data ->
                    createComponents
                        component
                        (get2 data)
                        (get3 data)
                        (get4 data)
                        (get5 data)
            }
        )
        (ComponentSpec
            { getComponent = get2
            , setComponent =
                \component data ->
                    createComponents
                        (get1 data)
                        component
                        (get3 data)
                        (get4 data)
                        (get5 data)
            }
        )
        (ComponentSpec
            { getComponent = get3
            , setComponent =
                \component data ->
                    createComponents
                        (get1 data)
                        (get2 data)
                        component
                        (get4 data)
                        (get5 data)
            }
        )
        (ComponentSpec
            { getComponent = get4
            , setComponent =
                \component data ->
                    createComponents
                        (get1 data)
                        (get2 data)
                        (get3 data)
                        component
                        (get5 data)
            }
        )
        (ComponentSpec
            { getComponent = get5
            , setComponent =
                \component data ->
                    createComponents
                        (get1 data)
                        (get2 data)
                        (get3 data)
                        (get4 data)
                        component
            }
        )
