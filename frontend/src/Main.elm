module Main exposing (..)

import Browser exposing (UrlRequest)
import Html exposing (Html, button, div, text, input, form)
import Html.Events exposing (onClick, onSubmit, onInput)
import Html.Attributes exposing (style, href, placeholder, action, autofocus)
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

type RoomStatus =
  Lobby
  | Room Int

type Role = Host | Guest


type alias Model = 
  { url : Url
  , key : Nav.Key
  , status : RoomStatus
  , role : Role
  , username : Maybe String
  , lobbyUsernameInput : String
  }


init : () -> Url -> Nav.Key -> (Model, Cmd Msg)
init _ url key =
  (
    { url = url
    , key = key
    , role = Host
    , status = Lobby
    , username = Nothing
    , lobbyUsernameInput = ""
    }
  , Cmd.none)


-- Subs

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


-- Url stuff

onUrlRequest : UrlRequest -> Msg
onUrlRequest _ = EmptyMsg

onUrlChange : Url -> Msg
onUrlChange _ = EmptyMsg


-- UPDATE


type Msg =
  LobbyUsernameUpdate String
  | LobbyUsernameSubmit
  | EmptyMsg


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    EmptyMsg ->
      ( model , Cmd.none)

    LobbyUsernameUpdate s ->
      ({ model | lobbyUsernameInput = s }, Cmd.none)
    
    LobbyUsernameSubmit ->
      ({ model | username = Just model.lobbyUsernameInput }, Cmd.none)



-- VIEW


view : Model -> Browser.Document Msg
view model =
  { title = "Star Voter"
  , body = 
      [
        case model.status of
          Lobby -> viewLobby model
          Room id -> viewRoom model id
      ]
  }

viewLobby : Model -> Html Msg
viewLobby model = 
  div centralStyle
    [ div verticalPaddingStyle
      [
        text (
          case model.role of
            Host -> "you are about to create a room"
            Guest -> "you are about to join a room"
        )
      ]
    , form (verticalPaddingStyle++[onSubmit LobbyUsernameSubmit])
      [
        input 
          [ placeholder "choose a username", autofocus True, onInput LobbyUsernameUpdate ]
          []
      , button
          (buttonStyle)
          [ text "go" ]
      ]
    , debugInfo model
    ]

viewRoom : Model -> Int -> Html Msg
viewRoom model id =
  text <| "We are now in a room, but this part is not yet implemented. Room ID: " ++ (String.fromInt id)


debugInfo : Model -> Html Msg
debugInfo model =
  div verticalPaddingStyle
  [
    div [] [ text <| "Typed text: " ++ model.lobbyUsernameInput]
  , div [] 
    [ text <| "Username: " ++ 
      case model.username of
        Just s -> s
        Nothing -> "NO USERNAME YET"
    ]
  ]

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

verticalPaddingStyle =
  [  style "padding-top" "20pt"
  ,  style "padding-bottom" "20pt"
  ]

buttonStyle =
  [  style "margin-top" "10pt"
  ,  style "margin-bottom" "10pt"
  ,  style "margin-left" "10pt"
  ,  style "margin-right" "10pt"
  ]