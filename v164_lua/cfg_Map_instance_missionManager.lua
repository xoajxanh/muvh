local cfg_Map_instance_missionManager = {}

function cfg_Map_instance_missionManager:GetName()
  return "cfg_Map_instance_missionManager"
end

function cfg_Map_instance_missionManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Map_instance_mission")
  end
  return self.dic
end

setmetatable(cfg_Map_instance_missionManager, TableManagerBase)

function cfg_Map_instance_missionManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Map_instance_missionManager:TriggerMissionEvents(missionList)
  for k, v in pairs(missionList) do
    self:TriggerMissionEvent(v.id, v.state, v)
  end
end

function cfg_Map_instance_missionManager:TriggerMissionEvent(id, state, serverData)
  if type(id) ~= "number" or type(state) ~= "number" then
    return
  end
  local tbl = self:TryGetValue(id)
  if tbl == nil then
    return
  end
  local clientEventParam
  if state == ActivityStateInfo.Receive then
    clientEventParam = tbl.performance
  elseif state == ActivityStateInfo.Complete then
    clientEventParam = tbl.performancefinish
  end
  if clientEventParam == nil then
    return
  end
  local eventList = string.split(clientEventParam, "&")
  for k, v in pairs(eventList) do
    local params = string.split(v, "#")
    if 1 < #params then
      self:SingleMissionEventTrigger(tonumber(params[1]), params, serverData, tbl)
    end
  end
end

function cfg_Map_instance_missionManager:SingleMissionEventTrigger(eventType, params, serverData, tbl)
  if type(eventType) ~= "number" or type(params) ~= "table" then
    return
  end
  if eventType == MissionSceneEventType.ShowTipEffect then
    self:ShowTipEffect(params, serverData)
  elseif eventType == MissionSceneEventType.AddBlockPoint then
    self:AddBlockPoint(params, serverData)
  elseif eventType == MissionSceneEventType.RemoveBlockPoint then
    self:RemoveBlockPoint(params, serverData)
  elseif eventType == MissionSceneEventType.CameraToPoint then
    self:CameraToPoint(params, serverData)
  elseif eventType == MissionSceneEventType.CreateSceneEffect then
    self:CreateSceneEffect(params, serverData)
  elseif eventType == MissionSceneEventType.SwitchMainPlayerAnimator then
    self:PlayMainPlayerAnimation(params, serverData)
  elseif eventType == MissionSceneEventType.SwitchNpcAnimator then
    self:PlayNpcAnimation(params, serverData)
  elseif eventType == MissionSceneEventType.CameraShake then
    self:PlayCameraShake(params, serverData)
  elseif eventType == MissionSceneEventType.ReviveCountDown then
    self:ReviveCountDown(params, serverData, tbl)
  elseif eventType == MissionSceneEventType.TextCountDown then
    self:TextCountDown(params, serverData)
  else
    logWarning(string.format("no type function:%s", eventType))
  end
end

function cfg_Map_instance_missionManager:ShowTipEffect(paramsList, serverData)
  if #paramsList < 2 then
    return
  end
  local tipEffectParam = {}
  local activityGlobalTbl = ClientTable.cfg_Activity_globalManager:TryGetValue(tonumber(paramsList[2]))
  if activityGlobalTbl == nil or string.isNullOrEmpty(activityGlobalTbl.effect) then
    return
  end
  tipEffectParam.name = activityGlobalTbl.effect
  if 2 < #paramsList then
    tipEffectParam.effectTime = tonumber(paramsList[3])
  end
  TipUtility.ShowTipEffect(tipEffectParam)
end

function cfg_Map_instance_missionManager:CameraToPoint(paramsList, serverData)
  if #paramsList < 5 then
    logError("Thi\225\186\191u d\225\187\175 li\225\187\135u c\225\186\165u h\195\172nh \196\145i\225\187\131m m\225\187\165c ti\195\170u di chuy\225\187\131n c\225\187\167a camera.")
    return
  end
  local targetPoint, time, endWaitTime = Vector2(tonumber(paramsList[2]), tonumber(paramsList[3])), tonumber(paramsList[4]), tonumber(paramsList[5])
  gameMgr:GetSceneManager():GetCameraManager():CameraMovePoint({
    targetCell = targetPoint,
    time = time,
    endWaitTime = endWaitTime
  })
end

function cfg_Map_instance_missionManager:CreateSceneEffect(paramsList, serverData)
  if #paramsList < 4 then
    return
  end
  local effectId, effectPosition = tonumber(paramsList[2]), Vector2(tonumber(paramsList[3]), tonumber(paramsList[4]))
  SceneUtility.AddSceneEffect(effectId, effectPosition)
end

function cfg_Map_instance_missionManager:PlayMainPlayerAnimation(paramsList, serverData)
  if #paramsList < 2 then
    return
  end
  local activityGlobalTbl = ClientTable.cfg_Activity_globalManager:TryGetValue(tonumber(paramsList[2]))
  if activityGlobalTbl == nil or string.isNullOrEmpty(activityGlobalTbl.effect) then
    return
  end
  RoleManager.me.model:PlayAnimation(activityGlobalTbl.effect)
end

function cfg_Map_instance_missionManager:AddBlockPoint(paramsList, serverData)
  if #paramsList < 2 then
    return
  end
  local activityGlobalTbl = ClientTable.cfg_Activity_globalManager:TryGetValue(tonumber(paramsList[2]))
  if activityGlobalTbl == nil or string.isNullOrEmpty(activityGlobalTbl.effect) then
    return
  end
  local pointStrList = string.split(activityGlobalTbl.effect, "_")
  for k, v in pairs(pointStrList) do
    local pointList = string.split(v, "#")
    if 1 < #pointList then
      Scene.AddTileType(Vector2(tonumber(pointList[1]), tonumber(pointList[2])), SceneTileType.Block)
    end
  end
end

function cfg_Map_instance_missionManager:RemoveBlockPoint(paramsList, serverData)
  if #paramsList < 2 then
    return
  end
  local activityGlobalTbl = ClientTable.cfg_Activity_globalManager:TryGetValue(tonumber(paramsList[2]))
  if activityGlobalTbl == nil or string.isNullOrEmpty(activityGlobalTbl.effect) then
    return
  end
  local pointStrList = string.split(activityGlobalTbl.effect, "_")
  for k, v in pairs(pointStrList) do
    local pointList = string.split(v, "#")
    if 1 < #pointList then
      Scene.RemoveTileType(Vector2(tonumber(pointList[1]), tonumber(pointList[2])), SceneTileType.Block)
    end
  end
end

function cfg_Map_instance_missionManager:PlayNpcAnimation(paramsList, serverData)
  if #paramsList < 3 then
    return
  end
  local npc = RoleManager.GetNpcByConfigId(tonumber(paramsList[2]))
  if npc == nil then
    return
  end
  local activityGlobalTbl = ClientTable.cfg_Activity_globalManager:TryGetValue(tonumber(paramsList[3]))
  if activityGlobalTbl == nil or string.isNullOrEmpty(activityGlobalTbl.effect) then
    return
  end
  RoleManager.me.model:PlayAnimation(activityGlobalTbl.effect)
end

function cfg_Map_instance_missionManager:PlayCameraShake(paramsList, serverData)
  if #paramsList < 3 then
    return
  end
  gameMgr:GetSceneManager():GetCameraManager():ShakeCamera({
    strength = tonumber(paramsList[2]),
    time = tonumber(paramsList[3] * 0.001)
  })
end

function cfg_Map_instance_missionManager:ReviveCountDown(paramsList, serverData, tbl)
  if #paramsList < 2 or serverData.endTime == nil then
    return
  end
  TipUtility.ShowReviveCountDown({
    bgName = paramsList[2],
    des = paramsList[3],
    endTime = serverData.endTime,
    roleReliveType = tonumber(tbl.param)
  })
end

function cfg_Map_instance_missionManager:TextCountDown(paramsList, serverData)
  if #paramsList < 1 or serverData.endTime == nil then
    return
  end
  TipUtility.ShowTextCountDown({
    textFormat = paramsList[2],
    endTime = serverData.endTime
  })
end

return cfg_Map_instance_missionManager
