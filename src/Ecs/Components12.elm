module Ecs.Components12 exposing (Components12, specs)

{-|

@docs Components12, specs

-}

import Dict exposing (Dict)
import Ecs.Internal
    exposing
        ( AllComponentsSpec(..)
        , ComponentSpec(..)
        )


{-| A container for 12 component types.
-}
type Components12 comparable a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12
    = Components12
        { dict1 : Dict comparable a1
        , dict2 : Dict comparable a2
        , dict3 : Dict comparable a3
        , dict4 : Dict comparable a4
        , dict5 : Dict comparable a5
        , dict6 : Dict comparable a6
        , dict7 : Dict comparable a7
        , dict8 : Dict comparable a8
        , dict9 : Dict comparable a9
        , dict10 : Dict comparable a10
        , dict11 : Dict comparable a11
        , dict12 : Dict comparable a12
        }


{-| Create all component specifications for 12 component types.
-}
specs :
    (AllComponentsSpec comparable (Components12 comparable a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)
     -> ComponentSpec comparable a1 (Components12 comparable a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)
     -> ComponentSpec comparable a2 (Components12 comparable a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)
     -> ComponentSpec comparable a3 (Components12 comparable a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)
     -> ComponentSpec comparable a4 (Components12 comparable a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)
     -> ComponentSpec comparable a5 (Components12 comparable a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)
     -> ComponentSpec comparable a6 (Components12 comparable a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)
     -> ComponentSpec comparable a7 (Components12 comparable a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)
     -> ComponentSpec comparable a8 (Components12 comparable a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)
     -> ComponentSpec comparable a9 (Components12 comparable a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)
     -> ComponentSpec comparable a10 (Components12 comparable a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)
     -> ComponentSpec comparable a11 (Components12 comparable a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)
     -> ComponentSpec comparable a12 (Components12 comparable a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12)
     -> specs
    )
    -> specs
specs fn =
    fn
        (AllComponentsSpec
            { empty =
                Components12
                    { dict1 = Dict.empty
                    , dict2 = Dict.empty
                    , dict3 = Dict.empty
                    , dict4 = Dict.empty
                    , dict5 = Dict.empty
                    , dict6 = Dict.empty
                    , dict7 = Dict.empty
                    , dict8 = Dict.empty
                    , dict9 = Dict.empty
                    , dict10 = Dict.empty
                    , dict11 = Dict.empty
                    , dict12 = Dict.empty
                    }
            , clear =
                \entityId (Components12 components) ->
                    Components12
                        { dict1 = Dict.remove entityId components.dict1
                        , dict2 = Dict.remove entityId components.dict2
                        , dict3 = Dict.remove entityId components.dict3
                        , dict4 = Dict.remove entityId components.dict4
                        , dict5 = Dict.remove entityId components.dict5
                        , dict6 = Dict.remove entityId components.dict6
                        , dict7 = Dict.remove entityId components.dict7
                        , dict8 = Dict.remove entityId components.dict8
                        , dict9 = Dict.remove entityId components.dict9
                        , dict10 = Dict.remove entityId components.dict10
                        , dict11 = Dict.remove entityId components.dict11
                        , dict12 = Dict.remove entityId components.dict12
                        }
            , size =
                \(Components12 components) ->
                    Dict.size components.dict1
                        + Dict.size components.dict2
                        + Dict.size components.dict3
                        + Dict.size components.dict4
                        + Dict.size components.dict5
                        + Dict.size components.dict6
                        + Dict.size components.dict7
                        + Dict.size components.dict8
                        + Dict.size components.dict9
                        + Dict.size components.dict10
                        + Dict.size components.dict11
                        + Dict.size components.dict12
            }
        )
        (ComponentSpec
            { get = \(Components12 components) -> components.dict1
            , set =
                \dict (Components12 components) ->
                    Components12
                        { dict1 = dict
                        , dict2 = components.dict2
                        , dict3 = components.dict3
                        , dict4 = components.dict4
                        , dict5 = components.dict5
                        , dict6 = components.dict6
                        , dict7 = components.dict7
                        , dict8 = components.dict8
                        , dict9 = components.dict9
                        , dict10 = components.dict10
                        , dict11 = components.dict11
                        , dict12 = components.dict12
                        }
            }
        )
        (ComponentSpec
            { get = \(Components12 components) -> components.dict2
            , set =
                \dict (Components12 components) ->
                    Components12
                        { dict1 = components.dict1
                        , dict2 = dict
                        , dict3 = components.dict3
                        , dict4 = components.dict4
                        , dict5 = components.dict5
                        , dict6 = components.dict6
                        , dict7 = components.dict7
                        , dict8 = components.dict8
                        , dict9 = components.dict9
                        , dict10 = components.dict10
                        , dict11 = components.dict11
                        , dict12 = components.dict12
                        }
            }
        )
        (ComponentSpec
            { get = \(Components12 components) -> components.dict3
            , set =
                \dict (Components12 components) ->
                    Components12
                        { dict1 = components.dict1
                        , dict2 = components.dict2
                        , dict3 = dict
                        , dict4 = components.dict4
                        , dict5 = components.dict5
                        , dict6 = components.dict6
                        , dict7 = components.dict7
                        , dict8 = components.dict8
                        , dict9 = components.dict9
                        , dict10 = components.dict10
                        , dict11 = components.dict11
                        , dict12 = components.dict12
                        }
            }
        )
        (ComponentSpec
            { get = \(Components12 components) -> components.dict4
            , set =
                \dict (Components12 components) ->
                    Components12
                        { dict1 = components.dict1
                        , dict2 = components.dict2
                        , dict3 = components.dict3
                        , dict4 = dict
                        , dict5 = components.dict5
                        , dict6 = components.dict6
                        , dict7 = components.dict7
                        , dict8 = components.dict8
                        , dict9 = components.dict9
                        , dict10 = components.dict10
                        , dict11 = components.dict11
                        , dict12 = components.dict12
                        }
            }
        )
        (ComponentSpec
            { get = \(Components12 components) -> components.dict5
            , set =
                \dict (Components12 components) ->
                    Components12
                        { dict1 = components.dict1
                        , dict2 = components.dict2
                        , dict3 = components.dict3
                        , dict4 = components.dict4
                        , dict5 = dict
                        , dict6 = components.dict6
                        , dict7 = components.dict7
                        , dict8 = components.dict8
                        , dict9 = components.dict9
                        , dict10 = components.dict10
                        , dict11 = components.dict11
                        , dict12 = components.dict12
                        }
            }
        )
        (ComponentSpec
            { get = \(Components12 components) -> components.dict6
            , set =
                \dict (Components12 components) ->
                    Components12
                        { dict1 = components.dict1
                        , dict2 = components.dict2
                        , dict3 = components.dict3
                        , dict4 = components.dict4
                        , dict5 = components.dict5
                        , dict6 = dict
                        , dict7 = components.dict7
                        , dict8 = components.dict8
                        , dict9 = components.dict9
                        , dict10 = components.dict10
                        , dict11 = components.dict11
                        , dict12 = components.dict12
                        }
            }
        )
        (ComponentSpec
            { get = \(Components12 components) -> components.dict7
            , set =
                \dict (Components12 components) ->
                    Components12
                        { dict1 = components.dict1
                        , dict2 = components.dict2
                        , dict3 = components.dict3
                        , dict4 = components.dict4
                        , dict5 = components.dict5
                        , dict6 = components.dict6
                        , dict7 = dict
                        , dict8 = components.dict8
                        , dict9 = components.dict9
                        , dict10 = components.dict10
                        , dict11 = components.dict11
                        , dict12 = components.dict12
                        }
            }
        )
        (ComponentSpec
            { get = \(Components12 components) -> components.dict8
            , set =
                \dict (Components12 components) ->
                    Components12
                        { dict1 = components.dict1
                        , dict2 = components.dict2
                        , dict3 = components.dict3
                        , dict4 = components.dict4
                        , dict5 = components.dict5
                        , dict6 = components.dict6
                        , dict7 = components.dict7
                        , dict8 = dict
                        , dict9 = components.dict9
                        , dict10 = components.dict10
                        , dict11 = components.dict11
                        , dict12 = components.dict12
                        }
            }
        )
        (ComponentSpec
            { get = \(Components12 components) -> components.dict9
            , set =
                \dict (Components12 components) ->
                    Components12
                        { dict1 = components.dict1
                        , dict2 = components.dict2
                        , dict3 = components.dict3
                        , dict4 = components.dict4
                        , dict5 = components.dict5
                        , dict6 = components.dict6
                        , dict7 = components.dict7
                        , dict8 = components.dict8
                        , dict9 = dict
                        , dict10 = components.dict10
                        , dict11 = components.dict11
                        , dict12 = components.dict12
                        }
            }
        )
        (ComponentSpec
            { get = \(Components12 components) -> components.dict10
            , set =
                \dict (Components12 components) ->
                    Components12
                        { dict1 = components.dict1
                        , dict2 = components.dict2
                        , dict3 = components.dict3
                        , dict4 = components.dict4
                        , dict5 = components.dict5
                        , dict6 = components.dict6
                        , dict7 = components.dict7
                        , dict8 = components.dict8
                        , dict9 = components.dict9
                        , dict10 = dict
                        , dict11 = components.dict11
                        , dict12 = components.dict12
                        }
            }
        )
        (ComponentSpec
            { get = \(Components12 components) -> components.dict11
            , set =
                \dict (Components12 components) ->
                    Components12
                        { dict1 = components.dict1
                        , dict2 = components.dict2
                        , dict3 = components.dict3
                        , dict4 = components.dict4
                        , dict5 = components.dict5
                        , dict6 = components.dict6
                        , dict7 = components.dict7
                        , dict8 = components.dict8
                        , dict9 = components.dict9
                        , dict10 = components.dict10
                        , dict11 = dict
                        , dict12 = components.dict12
                        }
            }
        )
        (ComponentSpec
            { get = \(Components12 components) -> components.dict12
            , set =
                \dict (Components12 components) ->
                    Components12
                        { dict1 = components.dict1
                        , dict2 = components.dict2
                        , dict3 = components.dict3
                        , dict4 = components.dict4
                        , dict5 = components.dict5
                        , dict6 = components.dict6
                        , dict7 = components.dict7
                        , dict8 = components.dict8
                        , dict9 = components.dict9
                        , dict10 = components.dict10
                        , dict11 = components.dict11
                        , dict12 = dict
                        }
            }
        )
