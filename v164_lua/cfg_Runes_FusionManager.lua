local cfg_Runes_FusionManager = {}

function cfg_Runes_FusionManager:GetName()
  return "cfg_Runes_FusionManager"
end

function cfg_Runes_FusionManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Runes_Fusion")
  end
  return self.dic
end

setmetatable(cfg_Runes_FusionManager, TableManagerBase)

function cfg_Runes_FusionManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Runes_FusionManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Runes_FusionManager:GetRuneFusionTblById(id)
  local dic = self:GetDic()
  for i, v in pairs(dic) do
    if dic[i].id == id then
      return v
    end
  end
  return nil
end

function cfg_Runes_FusionManager:GetRuneFusionTbl(type, runesStage, runesLevel)
  local dic = self:GetDic()
  for i, v in pairs(dic) do
    if dic[i].type == type and dic[i].runesStage == runesStage and dic[i].runesLevel == runesLevel then
      return v
    end
  end
  return nil
end

function cfg_Runes_FusionManager:NewRuneFusionData()
  local runeFusionDataTbl = {}
  local dic = self:GetDic()
  for i, v in pairs(dic) do
    local type = dic[i].type
    local runesStage = dic[i].runesStage
    local runesLevel = dic[i].runesLevel
    if runeFusionDataTbl[type] == nil then
      runeFusionDataTbl[type] = {}
    end
    if runeFusionDataTbl[type][runesStage] == nil then
      runeFusionDataTbl[type][runesStage] = {
        runesLevelMax = dic[i].runesLevelMax
      }
    end
    if runeFusionDataTbl[type][runesStage][runesLevel] == nil then
      runeFusionDataTbl[type][runesStage][runesLevel] = {
        id = dic[i].id,
        nextId = dic[i].nextId,
        runesName = dic[i].runesName,
        needExp = dic[i].needExp
      }
    end
  end
  return runeFusionDataTbl
end

return cfg_Runes_FusionManager
