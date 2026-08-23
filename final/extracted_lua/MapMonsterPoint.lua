local MapMonsterPoint = {}
MapMonsterPoint.PointTbl = nil
MapMonsterPoint.TransferMapTbl = nil
MapMonsterPoint.MonsterTbl = nil
MapMonsterPoint.AnalysisState = nil
MapMonsterPoint.mapId = nil

function MapMonsterPoint:RefreshData(mapMonsterPointId, mapId)
  if self:AnalysisParams(mapMonsterPointId, mapId) == false then
    return
  end
end

function MapMonsterPoint:AnalysisParams(mapMonsterPointId, mapId)
  self.AnalysisState = false
  self.mapId = mapId
  if type(mapMonsterPointId) ~= "number" then
    return false
  end
  self.PointTbl = ClientTable.cfg_OnHook_Point_ListManager:TryGetValue(mapMonsterPointId)
  if self.PointTbl == nil or string.isNullOrEmpty(self.PointTbl.transferId) then
    return false
  end
  self.MonsterTbl = ClientTable.cfg_Monster_monsterManager:TryGetValue(self.PointTbl.monsterId)
  self.TransferMapTbl = ClientTable.cfg_Map_transferManager:TryGetValue(self.PointTbl.transferId)
  if self.TransferMapTbl == nil then
    return false
  end
  self.AnalysisState = true
  return true
end

function MapMonsterPoint:ShowPoint()
  if string.isNullOrEmpty(self.PointTbl.condition) then
    return true
  end
  return ConditionManager.Check4D(self.PointTbl.condition)
end

function MapMonsterPoint:ShowHintEffect()
  local isShow = ConditionManager.Check4D(self.PointTbl.showcondition)
  return isShow, self.PointTbl.effParam
end

function MapMonsterPoint:RandomFindPoint()
  if self.mapId == nil or self.TransferMapTbl == nil then
    return
  end
  if self.PointTbl.click == MapMonsterPointFindType.FlyToPoint then
    PathFinderManager.FlyTransferScene(self.TransferMapTbl.id, nil, nil, nil, function()
      self:ArriveBehaviour()
    end)
  elseif self.PointTbl.click == MapMonsterPointFindType.WalkToPoint then
    local transferTbl = ClientTable.cfg_Map_transferManager:TryGetValue(self.TransferMapTbl.id)
    local transferGroudId = transferTbl.groupId
    local mapMapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(transferGroudId)
    if mapMapTbl ~= nil and ConditionManager.Check4D(mapMapTbl.enterCondition) == false then
      UIManager.Show(UIID.Instance_MemberUI, {
        npcConfigID = 1001006,
        param = {groupId = transferGroudId}
      })
    end
    PathFinderManager.JumpMapToMovePosByTransferId(self.TransferMapTbl.id, nil, nil, nil, function()
      self:ArriveBehaviour()
    end)
  end
end

function MapMonsterPoint:ArriveBehaviour()
  if self.PointTbl == nil or self.PointTbl.transfertype <= 0 then
    return
  end
  if self.PointTbl.transfertype == MapMonsterPointFindArriveBehaviour.AutoFight then
    RoleManager.me:SetAutoHookFight(true)
  end
end

function MapMonsterPoint:GetPointName()
  if self.PointTbl == nil or string.isNullOrEmpty(self.PointTbl.monsterList) then
    return "Ch\198\176a c\225\186\165u h\195\172nh t\195\170n"
  end
  return self.PointTbl.monsterList
end

function MapMonsterPoint:GetFindPointName()
  if self.PointTbl == nil or string.isNullOrEmpty(self.PointTbl.defenseBase) then
    return "\196\144\225\186\191n"
  end
  local color = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.monsterDamageAbsorptionShow) >= self.PointTbl.defenseBase and "#3CD937" or "#FF2323"
  return string.GetColorText(string.format("Ph\195\178ng Th\225\187\167 \196\145\225\187\129 c\225\187\173 %s", tostring(self.PointTbl.defenseBase)), color)
end

return MapMonsterPoint
