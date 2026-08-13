CrossRealmData = {}
local this = CrossRealmData
this.isCrossRealm = false
this.isOpenCrossRealm = false

function CrossRealmData.Init(data)
  this.isCrossRealm = data.canEnter
  this.isOpenCrossRealm = data.openRemote
  EventManager.Dispatch(Event.UpdateCrossRealmCondition)
end

function CrossRealmData.IsCrossRealm()
  local isOpen = ConditionManager.Check(GlobalConfig.GetGlobalConfig(11110001))
  return isOpen and this.isOpenCrossRealm
end

function CrossRealmData.IsOpenAtkList()
  local openCondition = ClientTable.cfg_Function_functionManager:TryGetValue(2200002).condition
  if openCondition == nil then
    openCondition = ""
  end
  local isOpen = ConditionManager.Check4D(openCondition)
  return isOpen
end

function CrossRealmData.IsOpenThree()
  local openCondition = ClientTable.cfg_Function_functionManager:TryGetValue(3000501).condition
  if openCondition == nil then
    openCondition = ""
  end
  local isOpen = ConditionManager.Check4D(openCondition)
  return isOpen
end
