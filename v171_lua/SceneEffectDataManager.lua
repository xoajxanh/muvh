local SceneEffectDataManager = {}
SceneEffectDataManager.ServerData = nil
SceneEffectDataManager.EffectList = nil
SceneEffectDataManager.RemoveList = nil
SceneEffectDataManager.FreeList = nil

function SceneEffectDataManager:Init()
  self.FreeList = {}
  self.EffectList = {}
end

function SceneEffectDataManager:RefreshData(serverData)
  if not self:AnalysisParams(serverData) then
    return
  end
  self:RemoveEffect(self.ServerData.mapEffectsRemovePoint)
  self:AddEffectList(self.ServerData.mapEffectsAddPoint)
end

function SceneEffectDataManager:AnalysisParams(serverData)
  if serverData == nil then
    return false
  end
  self.RemoveList = {}
  self.ServerData = serverData
  return true
end

function SceneEffectDataManager:RemoveEffect(removeList)
  if type(removeList) ~= "table" or next(removeList) == nil then
    return
  end
  local isRemove = false
  for k, v in pairs(removeList) do
    local effectData = self.EffectList[v.id]
    if effectData ~= nil then
      self.EffectList[v.id] = nil
      table.insert(self.FreeList, effectData)
      table.insert(self.RemoveList, v.id)
      isRemove = true
    end
  end
  if isRemove then
    EventManager.Dispatch(Event.Scene_EffectRemove)
  end
end

function SceneEffectDataManager:AddEffectList(addList)
  if type(addList) ~= "table" or next(addList) == nil then
    return
  end
  local effectData
  local isAdd = false
  local effectDataAddList = {}
  for k, v in pairs(addList) do
    effectData = self.EffectList[v.id]
    local nextId = next(self.FreeList)
    if effectData == nil and nextId then
      effectData = self.FreeList[nextId]
      self.FreeList[nextId] = nil
    end
    if effectData == nil then
      effectData = LuaClass.SceneEffectData:New()
    end
    isAdd = true
    effectData:RefreshData(v)
    if effectData.AnalysisState then
      self.EffectList[v.id] = effectData
      table.insert(effectDataAddList, effectData)
    end
  end
  if isAdd then
    EventManager.Dispatch(Event.Scene_EffectAdd, effectDataAddList)
  end
end

function SceneEffectDataManager:AddEffect(effectId, position, createCallBack, positionY)
  if effectId == nil or position == nil then
    return
  end
  local serverEffectPointData = {}
  serverEffectPointData.effectId = effectId
  serverEffectPointData.x = position.x
  serverEffectPointData.y = position.y
  serverEffectPointData.createCallBack = createCallBack
  serverEffectPointData.id = Time.GetServerTime()
  serverEffectPointData.positionY = positionY
  self:AddEffectList({serverEffectPointData})
  return serverEffectPointData.id
end

function SceneEffectDataManager:RemoveEffectById(id)
  local effectData = self.EffectList[id]
  if self.RemoveList == nil then
    self.RemoveList = {}
  end
  if effectData ~= nil then
    self.EffectList[id] = nil
    table.insert(self.FreeList, effectData)
    table.insert(self.RemoveList, id)
    EventManager.Dispatch(Event.Scene_EffectRemove)
  end
end

function SceneEffectDataManager:GetRemoveEffectIdList()
  return self.RemoveList
end

function SceneEffectDataManager:GetShowEffectList()
  return self.EffectList
end

return SceneEffectDataManager
