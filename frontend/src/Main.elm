module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--


import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)



-- MAIN


main =
  Browser.document { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


type alias Model = Int


init : () -> (Model, Cmd Msg)
init _ =
  (0, Cmd.none)


-- Subs

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


-- UPDATE


type Msg
  = Increment
  | Decrement


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increment ->
      (model + 1, Cmd.none)

    Decrement ->
      (model - 1, Cmd.none)



-- VIEW


view : Model -> Browser.Document Msg
view model =
  { title = "thitle"
  , body = 
      [
        div []
          [ button [ onClick Decrement ] [ text "-" ]
          , div [] [ text (String.fromInt model) ]
          , button [ onClick Increment ] [ text "+" ]
          ]
      ]
  }
