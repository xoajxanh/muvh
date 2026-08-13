local cfg_EffectsManager = {}

function cfg_EffectsManager:GetName()
  return "cfg_EffectsManager"
end

function cfg_EffectsManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Effects")
  end
  return self.dic
end

setmetatable(cfg_EffectsManager, TableManagerBase)

function cfg_EffectsManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

cfg_EffectsManager.ComplexDataTblList = nil

function cfg_EffectsManager:TryGetComplexData(id)
  if self.ComplexDataTblList == nil then
    self.ComplexDataTblList = {}
  end
  local complexData = self.ComplexDataTblList[id]
  if complexData ~= nil then
    return complexData
  end
  local tbl = self:TryGetValue(id)
  if tbl == nil then
    return
  end
  local complexData = {}
  complexData.Id = id
  if string.isNullOrEmpty(tbl.rotation) == false then
    local coordinates = string.split(tbl.rotation, "#")
    if type(coordinates) == "table" and table.count(coordinates) >= 3 then
      complexData.Rotation = Vector3.New(tonumber(coordinates[1]) * 1.0E-4, tonumber(coordinates[2]) * 1.0E-4, tonumber(coordinates[3]) * 1.0E-4)
    end
  end
  if string.isNullOrEmpty(tbl.scale) == false then
    local coordinates = string.split(tbl.scale, "#")
    if type(coordinates) == "table" and table.count(coordinates) >= 3 then
      complexData.Scale = Vector3.New(tonumber(coordinates[1]) * 1.0E-4, tonumber(coordinates[2]) * 1.0E-4, tonumber(coordinates[3]) * 1.0E-4)
    end
  end
  complexData.prefabPath = self:GetEffectPath(tbl)
  complexData.tbl = tbl
  self.ComplexDataTblList[id] = complexData
  return complexData
end

function cfg_EffectsManager:GetEffectPath(tbl)
  if tbl == nil or type(tbl.fileType) ~= "number" or type(tbl.name) ~= "string" then
    return
  end
  local fileTypePath = SceneEffectPath[tbl.fileType]
  if string.isNullOrEmpty(fileTypePath) then
    return
  end
  return fileTypePath .. tbl.name .. ".prefab"
end

return cfg_EffectsManager
