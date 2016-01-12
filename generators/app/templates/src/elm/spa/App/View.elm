module App.View (view) where

import Signal exposing (Address)

import Html exposing (Html, div, node, text)
import Html.Attributes exposing (class, rel, href, style, src)
import Hop

import App.Actions as Actions exposing (Action)
import App.Models exposing (Site)
import App.Components.Bootstrap exposing (navbar)
import App.Views.Home.View as HomeView
import App.Views.Counter.View as CounterView
import App.Views.Error.NotFound.View as NotFoundView
import App.Views.Error.Empty.View as EmptyView


view : Address Action -> Site -> Html
view address site =
  div [] [ pageView address site ]


navLinks : String -> Hop.Payload -> List (String, String, Bool)
navLinks view payload =
  [ ("home", "/", view == "home")
  , ("counter", "/counter", view == "counter")
  ]


sitePage : Address Action -> Site -> Html -> Html
sitePage address site content =
  div
    [ class "site" ]
    [ stylesheet "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
    , stylesheet "https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css"
    , stylesheet "/dist/main.css"
    , navbar address "Elm SPA Boilerplate" (navLinks site.view site.routerPayload)
    , div [ style [("margin-top", "49px")] ] []
    , content
    ]


pageView : Address Action -> Site -> Html
pageView address site =
  case site.view of
    "home" ->
      let
        homeAddress = Signal.forwardTo address Actions.HomeViewAction
      in
        HomeView.view homeAddress site.homeView
        |> sitePage address site

    "counter" ->
      let
        counterAddress = Signal.forwardTo address Actions.CounterViewAction
      in
        CounterView.view counterAddress site.counterView
        |> sitePage address site

    "notFound" ->
      NotFoundView.view
      |> sitePage address site

    _ ->
      EmptyView.view


stylesheet : String -> Html.Html
stylesheet href' =
  node "link" [ rel "stylesheet", href href' ] []


script : String -> Html.Html
script src' =
  node "script" [ src src' ] []
