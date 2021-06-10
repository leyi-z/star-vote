module Main exposing (..)

import Browser exposing (UrlRequest)
import Html exposing (Html, button, div, text, input, form)
import Html.Events exposing (onClick, onSubmit, onInput)
import Html.Attributes exposing (style, href, placeholder, action, autofocus)
import Url exposing (Url)
import Url.Parser exposing ((</>))
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

type PageState = Lobby | Room

type Role = Host | Guest


type alias Model = 
  { url : Url
  , key : Nav.Key
  , status : PageState
  , role : Role
  , username : Maybe String -- the actual accepted username
  , lobbyUsernameInput : String -- contents of the username input text box
  , roomID : Maybe Int
  }


init : () -> Url -> Nav.Key -> (Model, Cmd Msg)
init _ url key =
  (
    { url = url
    , key = key
    , role = case parseRoomID url of
        Nothing -> Host
        Just _ -> Guest
    , status = Lobby
    , username = Nothing
    , lobbyUsernameInput = ""
    , roomID = Nothing
    }
  , Cmd.none)

-- parse room ID from URL
parseRoomID : Url -> Maybe Int
parseRoomID = Url.Parser.parse <|
  Url.Parser.s "rooms" </> Url.Parser.int



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
      ({ model | username = Just model.lobbyUsernameInput }, Cmd.none) -- here we actually need to validate with backend



-- VIEW


view : Model -> Browser.Document Msg
view model =
  { title = "Star Voter"
  , body = 
      [
        case model.status of
          Lobby -> viewLobby model
          Room -> viewRoom model
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

viewRoom : Model -> Html Msg
viewRoom model =
  text <| "We are now in a room, but this part is not yet implemented."


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
  , div [] 
    [ text <| "Room ID parsed out of URL: " ++ 
      case (parseRoomID model.url) of
        Just id -> String.fromInt id
        Nothing -> "NONE"
    ]
  , div [] 
    [ text <| "What is actually believed to be current Room ID: " ++ 
      case model.roomID of
        Just id -> String.fromInt id
        Nothing -> "NONE"
    ]
    , div [] 
    [ text <| "User role: " ++ 
      case model.role of
        Host -> "host"
        Guest -> "guest"
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