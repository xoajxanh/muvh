Activity_IndexData = {}
local this = Activity_IndexData
this.ActivityTableData = {}
this.maxActivityCount = 0
this.activityNum = 0
this.actives = {}
this.findBackData = {}
this.phases = {}
this.HuoLongLaiXiCount = {}

function Activity_IndexData.Init()
  this.maxActivityCount = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2530002))
  this.Activity_IndexDataInit()
end

function Activity_IndexData.SortActives(activityA, activityB)
  local aActive = ClientTable.cfg_Activity_livelyManager:TryGetValue(activityA.activeId)
  local bActive = ClientTable.cfg_Activity_livelyManager:TryGetValue(activityB.activeId)
  local timescountA = aActive.times == activityA.completeTimes and 100 or 0
  local timescountB = bActive.times == activityB.completeTimes and 100 or 0
  if timescountA ~= timescountB then
    return timescountA < timescountB
  end
  return aActive.sort < bActive.sort
end

function Activity_IndexData.InitData(msg)
  this.ResetData()
  this.activityNum = msg.active
  this.actives = msg.actives
  this.findBackData = msg.finds
  this.phases = msg.phases
  table.sort(this.actives, this.SortActives)
  UIManager.Show(UIID.Activity_IndexUI)
end

function Activity_IndexData.UpdateActiveInfo(msg)
  local isSort = true
  this.activityNum = this.activityNum + msg.add
  for i = 1, #this.actives do
    if this.actives[i].activeId == msg.activeId then
      this.actives[i] = msg
      isSort = false
    end
  end
  if isSort then
    table.insert(this.actives, msg)
    table.sort(this.actives, this.SortActives)
  end
  EventManager.Dispatch(Event.ActivityTaskUpdate)
end

function Activity_IndexData.UpdateFindData(finds, msg)
  for i = 1, #finds do
    if finds[i].id == msg.id then
      finds[i] = msg
    end
  end
end

function Activity_IndexData.UpdateFindInfo(msg)
  this.UpdateFindData(this.findBackData, msg)
  EventManager.Dispatch(Event.ActivityFindBackUpdate)
end

function Activity_IndexData.IsHasPhases(phases)
  for i = 1, #this.phases do
    if phases == this.phases[i] then
      return true
    end
  end
  return false
end

function Activity_IndexData.SetPhases(phases)
  table.insert(this.phases, phases)
end

function Activity_IndexData.ResetData()
  this.activityNum = 0
  this.actives = {}
  this.phases = {}
  this.findBackData = {}
end

function Activity_IndexData.Activity_IndexDataInit()
  local cfg = ClientTable.cfg_Activity_indexManager:GetDic()
  for i, v in pairs(cfg) do
    if v.indexLine ~= 0 then
      table.insert(this.ActivityTableData, v)
    end
  end
  table.sort(this.ActivityTableData, function(a, b)
    return a.indexLine < b.indexLine
  end)
end

function Activity_IndexData.Activity_activeTb(data)
  this.HuoLongLaiXiCount = data
  EventManager.Dispatch(Event.ActiveTbUpdate)
end

function Activity_IndexData.CurrentActiveValue(data)
  if data.active and data.phases then
    this.activityNum = data.active
    this.phases = data.phases
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.dayGoal,
      state = true
    })
  end
end

this.Init()
