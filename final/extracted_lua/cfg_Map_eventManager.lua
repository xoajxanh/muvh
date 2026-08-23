local cfg_Map_eventManager = {}

function cfg_Map_eventManager:GetName()
  return "cfg_Map_eventManager"
end

function cfg_Map_eventManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Map_event")
  end
  return self.dic
end

setmetatable(cfg_Map_eventManager, TableManagerBase)

function cfg_Map_eventManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Map_eventManager:GetTransEffectConfigData(id)
  if self.mTransEffectConfigData == nil then
    self.mTransEffectConfigData = {}
  end
  if self.mTransEffectConfigData[id] ~= nil then
    return self.mTransEffectConfigData[id]
  end
  local tbl = self:TryGetValue(id)
  if tbl == nil then
    return
  end
  local configData = {}
  configData.name = tbl.resName
  configData.rotation = string.isNullOrEmpty(tbl.rotation) == false and TableParse:SplitStringToVectorData(tbl.rotation, "#", 1.0E-4) or Vector3.zero
  configData.scale = tbl.scale ~= 0 and tbl.scale * 1.0E-4 or 1
  self.mTransEffectConfigData[id] = configData
  return configData
end

return cfg_Map_eventManager
