local ServerMonsterPoint = {}
ServerMonsterPoint.serverData = nil
ServerMonsterPoint.lid = nil
ServerMonsterPoint.monsterConfigTbl = nil
ServerMonsterPoint.position = nil
ServerMonsterPoint.buffList = nil
ServerMonsterPoint.mapBuffConfigList = nil
ServerMonsterPoint.isAlive = nil
ServerMonsterPoint.analysisState = nil

function ServerMonsterPoint:RefreshData(data)
  self.analysisState = self:AnalysisParams(data)
  if self.analysisState == false then
    return
  end
end

function ServerMonsterPoint:AnalysisParams(data)
  if data == nil or data.lid == nil or data.X == nil or data.Y == nil or type(data.buffIds) ~= "table" then
    return false
  end
  self.lid = data.lid
  self.monsterConfigTbl = ClientTable.cfg_Monster_monsterManager:TryGetValue(data.configId)
  if self.monsterConfigTbl == nil then
    return false
  end
  self.isAlive = data.state
  self.showName = data.showName
  self.position = Vector2(data.X, data.Y)
  self.buffList = {}
  self.mapBuffConfigList = {}
  local buffPictureConfig
  for k, v in pairs(data.buffIds) do
    local buffTbl = ClientTable.cfg_Buff_buffManager:TryGetValue(v)
    if buffTbl ~= nil then
      table.insert(self.buffList, buffTbl)
      if buffTbl.buffPicture and buffTbl.buffPicture > 0 then
        buffPictureConfig = ClientTable.cfg_Map_buffPictureManager:TryGetValue(buffTbl.buffPicture)
        if buffPictureConfig ~= nil then
          table.insert(self.mapBuffConfigList, buffPictureConfig)
        end
      end
    end
  end
  self.showType = data.showType
  return true
end

function ServerMonsterPoint:GetBigMapHeadShowState()
  if self.isAlive then
    return BigMapHeadShowType.NORMAL
  else
    if self.showType == 1 then
      return BigMapHeadShowType.GRAY
    elseif self.showType == 2 then
      return BigMapHeadShowType.DISABLE
    end
    return BigMapHeadShowType.DISABLE
  end
end

return ServerMonsterPoint
