module Main exposing (main)

import Assets exposing (Assets)
import Browser exposing (Document)
import Browser.Events
    exposing
        ( onAnimationFrameDelta
        , onKeyDown
        , onKeyUp
        )
import Ecs exposing (Ecs)
import Ecs.Entities as Entities
import Ecs.Systems as Systems
import Ecs.Systems.KeyControls as KeyControls
    exposing
        ( KeyChange
        , Keys
        , keyDownDecoder
        , keyUpDecoder
        )
import Html exposing (Html, text)
import Html.Events
import Json.Decode as Decode
import KeyCode exposing (KeyCode)
import WebGL.Texture as Texture exposing (Error)



-- MODEL --


type InitState
    = InitPending
    | InitError Error
    | InitOk Model


type alias Model =
    { ecs : Ecs
    , keys : Keys
    , deltaTime : Float
    , stepCount : Int
    , running : Bool
    }


init : () -> ( InitState, Cmd Msg )
init _ =
    ( InitPending
    , Assets.load AssetsReceived
    )


initModel : Assets -> Model
initModel assets =
    { ecs = Entities.init assets Ecs.init
    , keys = KeyControls.initKeys
    , deltaTime = 0
    , stepCount = 0
    , running = True
    }



-- UPDATE --


type Msg
    = AssetsReceived (Result Error Assets)
    | AnimationFrameStarted Float
    | KeyChanged KeyChange
    | KeyReleased KeyCode


update : Msg -> InitState -> ( InitState, Cmd Msg )
update msg state =
    case ( state, msg ) of
        ( InitPending, AssetsReceived (Err error) ) ->
            ( InitError error, Cmd.none )

        ( InitPending, AssetsReceived (Ok assets) ) ->
            ( InitOk (initModel assets), Cmd.none )

        ( InitError error, _ ) ->
            ( state, Cmd.none )

        ( InitOk model, _ ) ->
            updateInternal msg model
                |> Tuple.mapFirst InitOk

        _ ->
            ( state, Cmd.none )


updateInternal : Msg -> Model -> ( Model, Cmd Msg )
updateInternal msg model =
    case msg of
        AssetsReceived _ ->
            ( model, Cmd.none )

        AnimationFrameStarted deltaTimeMillis ->
            let
                deltaTime =
                    min (deltaTimeMillis / 1000) (1.0 / 30.0)
            in
            ( { model
                | ecs = Systems.update model.keys deltaTime model.ecs
                , deltaTime = deltaTime
                , stepCount = model.stepCount + 1
              }
            , Cmd.none
            )

        KeyChanged keyChange ->
            ( { model | keys = KeyControls.updateKeys keyChange model.keys }
            , Cmd.none
            )

        KeyReleased keyCode ->
            if keyCode == KeyCode.esc then
                ( { model | running = not model.running }
                , Cmd.none
                )

            else
                ( model, Cmd.none )



-- SUBSCRIPTIONS --


subscriptions : InitState -> Sub Msg
subscriptions state =
    case state of
        InitOk model ->
            if model.running then
                Sub.batch
                    [ onAnimationFrameDelta AnimationFrameStarted
                    , onKeyUp (Decode.map KeyChanged keyUpDecoder)
                    , onKeyDown (Decode.map KeyChanged keyDownDecoder)
                    , keyUpSubscription
                    ]

            else
                keyUpSubscription

        _ ->
            Sub.none


keyUpSubscription : Sub Msg
keyUpSubscription =
    onKeyUp (Decode.map KeyReleased Html.Events.keyCode)



-- VIEW --


view : InitState -> Document Msg
view state =
    { title = "Ecs Example"
    , body =
        case state of
            InitPending ->
                [ text "loading..." ]

            InitError error ->
                viewError error

            InitOk internalModel ->
                viewOk internalModel
    }


viewError : Error -> List (Html Msg)
viewError error =
    case error of
        Texture.LoadError ->
            [ text "could not load texture" ]

        Texture.SizeError width height ->
            [ text <|
                "could not load texture with size "
                    ++ String.fromInt width
                    ++ "x"
                    ++ String.fromInt height
            ]


viewOk : Model -> List (Html Msg)
viewOk model =
    [ text <|
        "stepCount: "
            ++ String.fromInt model.stepCount
            ++ " ( "
            ++ String.fromFloat model.deltaTime
            ++ ")"
    , text <|
        if model.running then
            " running"

        else
            " paused"
    , Systems.view model.ecs
    ]



-- MAIN --


main : Program () InitState Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
