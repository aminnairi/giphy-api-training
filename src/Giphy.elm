-- IMPORTS


module Giphy exposing (main)

import Browser
import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (alt, src, style)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, string)


type Model
    = Loading
    | Loaded String
    | Failure
    | Initial


init : () -> ( Model, Cmd Message )
init _ =
    ( Initial, Cmd.none )


type Message
    = FetchRandomGif
    | DecodedGif (Result Http.Error String)


fetchRandomGif : Cmd Message
fetchRandomGif =
    Http.get
        { url = "https://api.giphy.com/v1/gifs/random?api_key=21ACF3O8aheAHC3nqagllLE2l5njdMSQ&tag=cat"
        , expect = Http.expectJson DecodedGif gifDecoder
        }


gifDecoder : Decoder String
gifDecoder =
    field "data" (field "images" (field "original" (field "url" string)))


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        FetchRandomGif ->
            ( Loading, fetchRandomGif )

        DecodedGif maybeGifUrl ->
            case maybeGifUrl of
                Ok gifUrl ->
                    ( Loaded gifUrl, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



-- view


view : Model -> Html Message
view model =
    case model of
        Initial ->
            div
                [ style "display" "flex"
                , style "width" "100vw"
                , style "height" "100vh"
                , style "justify-content" "center"
                , style "align-items" "center"
                ]
                [ button
                    [ onClick FetchRandomGif
                    , style "height" "50px"
                    , style "width" "200px"
                    , style "border" "none"
                    , style "background-color" "black"
                    , style "color" "white"
                    , style "text-transform" "uppercase"
                    ]
                    [ text "Load GIF" ]
                ]

        Loading ->
            div
                [ style "display" "flex"
                , style "justify-content" "center"
                , style "align-items" "center"
                , style "height" "100vh"
                , style "width" "100vw"
                ]
                [ text "Your GIF is loading..." ]

        Loaded gifUrl ->
            div
                [ style "display" "flex"
                , style "flex-direction" "column"
                , style "justify-content" "center"
                , style "align-items" "center"
                , style "height" "100vh"
                , style "width" "100vw"
                ]
                [ img
                    [ src gifUrl
                    , alt "some random gif"
                    , onClick FetchRandomGif
                    , style "height" "80vmin"
                    , style "width" "80vmin"
                    , style "object-fit" "cover"
                    , style "display" "block"
                    ]
                    []
                ]

        Failure ->
            div
                [ style "display" "flex"
                , style "flex-direction" "column"
                , style "justify-content" "center"
                , style "align-items" "center"
                , style "height" "100vh"
                , style "width" "100vw"
                ]
                [ text "Failed to find your GIF."
                , button [ onClick FetchRandomGif ] [ text "Retry?" ]
                ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.none



-- MAIN PROGRAM


main : Program () Model Message
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
