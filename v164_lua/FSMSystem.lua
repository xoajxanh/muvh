require("GamePlay/FSMSystem/FSMState")
FSMSystem = class()

function FSMSystem:ctor()
  self:Init()
end

function FSMSystem:Init()
  self.states = {}
  self.currentStateId = nil
  self.currentState = nil
end

function FSMSystem:SetState(stateId)
  for i, v in ipairs(self.states) do
    if v.stateId == stateId then
      self.currentState:DoBeforeLeaving()
      self.currentState = v
      self.currentStateId = v.stateId
      self.currentState:DoBeforeEntering()
      break
    end
  end
end

function FSMSystem:AddState(state)
  if #self.states == 0 then
    self.currentState = state
    self.currentStateId = state.stateId
    table.insert(self.states, state)
    return
  end
  table.insert(self.states, state)
end

function FSMSystem:DeleteState(stateId)
  for i, v in ipairs(self.states) do
    if v.stateId == stateId then
      table.remove(self.states, i)
    end
  end
end

function FSMSystem:PerformTransition(trans)
  local id = self.currentState:GetOutputState(trans)
  if not id then
    return
  end
  for i, v in ipairs(self.states) do
    if v.stateId == id then
      self.currentState:DoBeforeLeaving()
      self.currentState = v
      self.currentStateId = v.stateId
      self.currentState:DoBeforeEntering()
      break
    end
  end
end
