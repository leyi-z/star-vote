module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--


import Browser exposing (UrlRequest)
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, href)
import Url exposing (Url)
import Browser.Navigation as Nav



-- MAIN


main =
  Browser.application { init = init
                      , update = update
                      , view = view
                      , subscriptions = subscriptions
                      , onUrlRequest = onUrlRequest
                      , onUrlChange = onUrlChange
                      }



-- MODEL


type alias Model = 
  { numState : Int
  , url : Url
  , key : Nav.Key
  }


init : () -> Url -> Nav.Key -> (Model, Cmd Msg)
init _ url key =
  (
    { numState = 0
      , url = url
      , key = key
    }
  , Cmd.none)


-- Subs

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


-- Url stuff

onUrlRequest : UrlRequest -> Msg
onUrlRequest _ = Increment

onUrlChange : Url -> Msg
onUrlChange _ = Increment


-- UPDATE


type Msg
  = Increment
  | Decrement


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increment ->
      ( { model | numState = model.numState + 1 }, Cmd.none)

    Decrement ->
      ({ model | numState = model.numState - 1 }, Cmd.none)



-- VIEW


view : Model -> Browser.Document Msg
view model =
  { title = "thitle"
  , body = 
      [
        div centralStyle
        [ div []
          [ button [ onClick Decrement ] [ text "-" ]
          , div [] [ text (String.fromInt model.numState) ]
          , button [ onClick Increment ] [ text "+" ]
          ]
        , div []
          [
            text model.url.path
          ]
        , div []
          [ Html.a [href "https://www.example.com"] [ text "a link" ] ]
        ]
      ]
  }

-- Styles

centralStyle : List (Html.Attribute msg)
centralStyle =
  [ style "color" "#222"
  , style "background-color" "#888"
  , style "font-size" "18pt"
  , style "font-family" "arial"
  , style "text-align" "center"
  , style "padding-left" "10%"
  , style "padding-right" "10%"
  , style "padding-top" "40vh"
  , style "height" "60vh"
  ]