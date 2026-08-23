TransitionId = {
  NullTransition = enum(0),
  TtoR = enum(),
  RtoT = enum(),
  TtoS = enum(),
  StoT = enum(),
  WtoS = enum(),
  StoW = enum(),
  StoF = enum()
}
StateID = {
  NullStateID = enum(0),
  TaskUIStateID = enum(),
  RedFortUIStateID = enum(),
  SiegeUIStateID = enum(),
  WSiegeUIStateID = enum(),
  FourPartyRivalryUIStateID = enum()
}
FSMState = class()

function FSMState:ctor()
  self.map = {}
  self:Init()
end

function FSMState:Init()
  self.stateId = StateID.NullStateID
end

function FSMState:AddTransition(trans, id)
  self.map[trans] = id
end

function FSMState:DeleteTransition(trans)
  self.map[trans] = nil
end

function FSMState:GetOutputState(trans)
  return self.map[trans]
end

function FSMState:DoBeforeEntering()
end

function FSMState:DoBeforeLeaving()
end

function FSMState:Reason()
end

function FSMState:Act()
end

MainLeftTaskUIState = class(FSMState)

function MainLeftTaskUIState:ctor(mainUI)
  self.mainUI = mainUI
  self.map = {}
  self:Init()
end

function MainLeftTaskUIState:Init()
  self.stateId = StateID.TaskUIStateID
end

function MainLeftTaskUIState:DoBeforeEntering()
  EventManager.Dispatch(Event.Task_SetTaskPanelHide, false)
end

function MainLeftTaskUIState:DoBeforeLeaving()
  EventManager.Dispatch(Event.Task_SetTaskPanelHide, true)
end

MainLeftRedFortUIState = class(FSMState)

function MainLeftRedFortUIState:Init()
  self.stateId = StateID.RedFortUIStateID
end

function MainLeftRedFortUIState:DoBeforeEntering()
  UIManager.Show(UIID.Activity_RedfortTaskUI)
end

function MainLeftRedFortUIState:DoBeforeLeaving()
  UIManager.Hide(UIID.Activity_RedfortTaskUI)
end

MainLeftSiegeUIState = class(FSMState)

function MainLeftSiegeUIState:Init()
  self.stateId = StateID.SiegeUIStateID
end

function MainLeftSiegeUIState:DoBeforeEntering()
  EventManager.Dispatch(Event.OpenSiegeTaskUI)
end

function MainLeftSiegeUIState:DoBeforeLeaving()
  UIManager.Hide(UIID.Activity_SiegefortTaskUI)
end

MainLeftWolffortTaskUIState = class(FSMState)

function MainLeftWolffortTaskUIState:Init()
  self.stateId = StateID.WSiegeUIStateID
end

function MainLeftWolffortTaskUIState:DoBeforeEntering()
  EventManager.Dispatch(Event.MainActivityWolffortTaskUI)
end

function MainLeftWolffortTaskUIState:DoBeforeLeaving()
  UIManager.Hide(UIID.Activity_WolffortTaskUI)
end

FourPartyRivalryTaskUIState = class(FSMState)

function FourPartyRivalryTaskUIState:ctor(_mainUI)
  FSMState.ctor(self)
  self.mainUI = _mainUI
  self:Init()
end

function FourPartyRivalryTaskUIState:Init()
  self.stateId = StateID.FourPartyRivalryUIStateID
end

function FourPartyRivalryTaskUIState:DoBeforeEntering()
  self.mainUI:EnterFourPartyRivalryScene()
end

function FourPartyRivalryTaskUIState:DoBeforeLeaving()
  self.mainUI:QuitFourPartyRivalryScene()
end
