KillMonsterCardData = {}
local this = KillMonsterCardData
this.surplusTime = 0
this.totalTime = 0
this.crossSurplusTime = 0
this.crossTotalTime = 0
this.openType = nil
this.state = 2
this.localState = 2
this.crossState = 2

function KillMonsterCardData.AddBuff(data)
  this.RefreshData(data)
  RoleManager.me:InitHeadUI()
  EventManager.Dispatch(Event.RefreshKillMonsterCardData)
end

function KillMonsterCardData.RemoveBuff(data)
  this.RefreshData(data)
  RoleManager.me:InitHeadUI()
  EventManager.Dispatch(Event.RefreshKillMonsterCardData)
end

function KillMonsterCardData.SwitchBuff(data)
  this.RefreshData(data)
  if this.IsOpenState() then
    RoleManager.me:SetHookCardAutoFightHookStart(true)
  else
    RoleManager.me:SetHookCardAutoFightHookStart(false)
  end
  RoleManager.me:InitHeadUI()
  EventManager.Dispatch(Event.RefreshKillMonsterCardData)
end

function KillMonsterCardData.ChangeData(data)
  this.RefreshData(data)
  RoleManager.me:InitHeadUI()
  EventManager.Dispatch(Event.RefreshKillMonsterCardData)
end

function KillMonsterCardData.RefreshData(data)
  this.totalTime = data.totalTime
  this.surplusTime = data.endTime
  this.localState = data.state
  if this.localState == KillMonsterCardType.Open then
    this.openType = UnitType.KillMonster
  end
  RoleManager.me:EnableKillMonsterEffect(this.IsOpenState())
end

function KillMonsterCardData.AddCrossBuff(data)
  this.RefreshCrossData(data)
  RoleManager.me:InitHeadUI()
  EventManager.Dispatch(Event.RefreshKillMonsterCardData)
end

function KillMonsterCardData.RemoveCrossBuff(data)
  this.RefreshCrossData(data)
  RoleManager.me:InitHeadUI()
  EventManager.Dispatch(Event.RefreshKillMonsterCardData)
end

function KillMonsterCardData.SwitchCrossBuff(data)
  this.RefreshCrossData(data)
  if this.IsOpenState() then
    RoleManager.me:SetHookCardAutoFightHookStart(true)
  else
    RoleManager.me:SetHookCardAutoFightHookStart(false)
  end
  RoleManager.me:InitHeadUI()
  EventManager.Dispatch(Event.RefreshKillMonsterCardData)
end

function KillMonsterCardData.ChangeCrossData(data)
  this.RefreshCrossData(data)
  RoleManager.me:InitHeadUI()
  EventManager.Dispatch(Event.RefreshKillMonsterCardData)
end

function KillMonsterCardData.RefreshCrossData(data)
  this.crossTotalTime = data.totalTime
  this.crossSurplusTime = data.endTime
  this.crossState = data.state
  if this.crossState == KillMonsterCardType.Open then
    this.openType = UnitType.KillMonsterCross
  end
  RoleManager.me:EnableKillMonsterEffect(this.IsOpenState())
end

function KillMonsterCardData.GetOpenStateType()
  return this.openType
end

function KillMonsterCardData.ResetData()
  this.totalTime = 0
  this.surplusTime = 0
  this.crossSurplusTime = 0
  this.crossTotalTime = 0
  this.state = 2
  this.localState = 2
  this.crossState = 2
end

function KillMonsterCardData.IsOpenState()
  this.state = this.localState == KillMonsterCardType.Open or this.crossState == KillMonsterCardType.Open
  return this.state
end

function KillMonsterCardData.SetState(state)
  this.localState = state
  this.crossState = state
end

function KillMonsterCardData.IsHasSurplusTime()
  if this.IsOpenState() then
    local surplusTime = false and this.crossSurplusTime or this.surplusTime
    return surplusTime - Time.GetServerTime() > 0
  else
    local totalTime = false and this.crossTotalTime or this.totalTime
    return 0 < totalTime
  end
end

function KillMonsterCardData.GetSurplusTimeInterval()
  local surplusTime = false and this.crossSurplusTime or this.surplusTime
  return surplusTime
end

function KillMonsterCardData.GetTotalTime()
  local totalTime = false and this.crossTotalTime or this.totalTime
  return totalTime
end
