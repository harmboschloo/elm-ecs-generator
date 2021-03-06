module EcsV2e_EntityOperation exposing
    ( builder
    , entityOperationFoldA
    , entityOperationFoldABC
    , entityOperationInsertA
    , foldA
    , foldABC
    , insertA
    , insertAB
    , insertB
    , insertC
    , label
    , selectA
    , selectAB
    , selectABC
    , selectAInsertA
    , selectB
    , selectBA
    , selectC
    , selectCBA
    )

import Data exposing (A, B, C)
import V2e_EntityOperation.Ecs as Ecs
import V2e_EntityOperation.Ecs.Components3 as Components
import V2e_EntityOperation.Ecs.EntityComponents as EntityComponents
import V2e_EntityOperation.Ecs.EntityOperation as EntityOperation
import V2e_EntityOperation.Ecs.Singletons1 as Singletons


label : String
label =
    "Ecs v2e EntityOperation"


type alias Components =
    Components.Components3 Int A B C


type alias Singletons =
    Singletons.Singletons1 Int


type alias Specs =
    { lastEntityId : Ecs.SingletonSpec Int Singletons
    , components : Ecs.MultiComponentSpec Int Components
    , a : Ecs.ComponentSpec Int Data.A Components
    , b : Ecs.ComponentSpec Int Data.B Components
    , c : Ecs.ComponentSpec Int Data.C Components
    }


specs : Specs
specs =
    Specs |> Singletons.specs |> Components.specs


type alias World =
    Ecs.World Int Components Singletons


newEntityId : World -> ( World, Int )
newEntityId world =
    Ecs.updateSingletonAndReturn specs.lastEntityId (\id -> id + 1) world


builder : Data.Builder World Int
builder =
    { empty = Ecs.emptyWorld specs.components (Singletons.init -1)
    , create = newEntityId >> Ecs.andInsertEntity
    , insertA =
        \a ( world, entityId ) ->
            ( Ecs.insertComponent specs.a entityId a world, entityId )
    , insertB =
        \b ( world, entityId ) ->
            ( Ecs.insertComponent specs.b entityId b world, entityId )
    , insertC =
        \c ( world, entityId ) ->
            ( Ecs.insertComponent specs.c entityId c world, entityId )
    }


insertA : Int -> A -> World -> World
insertA entityId a world =
    Ecs.insertComponent specs.a entityId a world


insertB : Int -> B -> World -> World
insertB entityId b world =
    Ecs.insertComponent specs.b entityId b world


insertC : Int -> C -> World -> World
insertC entityId c world =
    Ecs.insertComponent specs.c entityId c world


insertAB : Int -> A -> B -> World -> World
insertAB entityId a b world =
    case EntityOperation.start entityId world of
        Just op ->
            op
                |> EntityOperation.insertComponent specs.a a
                |> EntityOperation.insertComponent specs.b b
                |> EntityOperation.end

        Nothing ->
            world


selectA : World -> List ( Int, A )
selectA world =
    EntityComponents.foldr specs.a (\id a list -> ( id, a ) :: list) [] world


selectB : World -> List ( Int, B )
selectB world =
    EntityComponents.foldr specs.b (\id b list -> ( id, b ) :: list) [] world


selectC : World -> List ( Int, C )
selectC world =
    EntityComponents.foldr specs.c (\id c list -> ( id, c ) :: list) [] world


type alias AB =
    { a : A
    , b : B
    }


selectAB : World -> List ( Int, AB )
selectAB world =
    EntityComponents.foldr2 specs.a specs.b (\id a b list -> ( id, AB a b ) :: list) [] world


type alias BA =
    { b : B
    , a : A
    }


selectBA : World -> List ( Int, BA )
selectBA world =
    EntityComponents.foldr2 specs.b specs.a (\id b a list -> ( id, BA b a ) :: list) [] world


type alias ABC =
    { a : A
    , b : B
    , c : C
    }


selectABC : World -> List ( Int, ABC )
selectABC world =
    EntityComponents.foldr3 specs.a specs.b specs.c (\id a b c list -> ( id, ABC a b c ) :: list) [] world


selectAInsertA : A -> World -> World
selectAInsertA a world =
    entityOperationFoldA (\_ -> entityOperationInsertA a) world


type alias CBA =
    { c : C
    , b : B
    , a : A
    }


selectCBA : World -> List ( Int, CBA )
selectCBA world =
    EntityComponents.foldr3 specs.c specs.b specs.a (\id c b a list -> ( id, CBA c b a ) :: list) [] world


foldA : (Int -> A -> World -> World) -> World -> World
foldA fn world =
    EntityComponents.foldl specs.a fn world world


foldABC : (Int -> A -> B -> C -> World -> World) -> World -> World
foldABC fn world =
    EntityComponents.foldl3 specs.a specs.b specs.c fn world world


type alias EntityOperation =
    EntityOperation.EntityOperation Int Components Singletons


entityOperationFoldA : (A -> EntityOperation -> EntityOperation) -> World -> World
entityOperationFoldA fn world =
    EntityOperation.foldl specs.a fn world


entityOperationFoldABC : (A -> B -> C -> EntityOperation -> EntityOperation) -> World -> World
entityOperationFoldABC fn world =
    EntityOperation.foldl3 specs.a specs.b specs.c fn world


entityOperationInsertA : A -> EntityOperation -> EntityOperation
entityOperationInsertA a entityOperation =
    EntityOperation.insertComponent specs.a a entityOperation
