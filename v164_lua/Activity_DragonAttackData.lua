Activity_DragonAttackData = {}
local this = Activity_DragonAttackData
this.activityStatus = nil
this.mapList = nil

function Activity_DragonAttackData.InitData(msg)
  this.activityStatus = msg.state
  this.mapList = msg.mapIds
end

function Activity_DragonAttackData.IsInDragonAttackMap()
  if not this.mapList then
    return
  end
  for i, v in pairs(this.mapList) do
    if SceneData.mapId == v then
      return true
    end
  end
end

function Activity_DragonAttackData.CheckActivityStatus(status)
  if not this.activityStatus then
    return
  end
  if this.activityStatus == status then
    return true
  else
    return false
  end
end

function Activity_DragonAttackData.IsInDragonAttackTime()
  local openActivityCond = ClientTable.cfg_Activity_overviewManager:TryGetValue(1008, "activityId").condition
  local isOpen = ConditionManager.Check4D(openActivityCond)
  return isOpen
end

function Activity_DragonAttackData.IsDragonAttackEffectOpen()
  if this.IsInDragonAttackMap() and this.IsInDragonAttackTime() then
    return true
  else
    return false
  end
end

function Activity_DragonAttackData.Init()
  this.ResetData()
end

function Activity_DragonAttackData.ResetData()
  this.activityStatus = nil
  this.mapList = nil
end
