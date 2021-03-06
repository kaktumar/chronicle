module Chronicle.Controller where

import Signal exposing (Mailbox, mailbox)
import Debug exposing (log)
import Task exposing (Task, andThen)
import Task
import Http

import Util.Component exposing (updateInner, noRequest)
import Chronicle.Model exposing (Model)
import Chronicle.Data.Moment exposing (Moment)
import Chronicle.Components.Search as Search
import Chronicle.Components.MomentList as MomentList
import Chronicle.Components.MomentEditor as MomentEditor

-- Action

type Action
  = NoOp
  | Search      Search.Action
  | MomentList MomentList.Action
  | MomentEditor MomentEditor.Action

-- Update

update : Action -> Model -> (Model, Maybe Request)
update action model =
  case action of
    NoOp ->
      model
        |> noRequest
    Search a ->
      { model | search <- (Search.update a model.search) }
        |> noRequest
    MomentList a ->
      updateInner
        MomentList.update
        MomentListRequest
        (\m -> { model | momentList <- m })
        a
        model.momentList
    MomentEditor a ->
      updateInner
        MomentEditor.update
        MomentEditorRequest
        (\m -> { model | addMoment <- m })
        a
        model.addMoment

-- Request

type Request
  = MomentListRequest MomentList.Request
  | MomentEditorRequest MomentEditor.Request

initialRequest : Request
initialRequest = MomentListRequest MomentList.Reload

run : Request -> Task Http.Error Action
run r =
  case r of
    (MomentListRequest r') ->
      Task.map MomentList <| MomentList.run r'
    (MomentEditorRequest r') ->
      Task.map MomentList
      <| MomentEditor.run r' `andThen`
          (always <| MomentList.run MomentList.Reload)

actions : Mailbox Action
actions =
  mailbox NoOp
