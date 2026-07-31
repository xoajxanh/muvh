local cfg_Bone_mixManager = {}

function cfg_Bone_mixManager:GetName()
  return "cfg_Bone_mixManager"
end

function cfg_Bone_mixManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Bone_mix")
  end
  return self.dic
end

setmetatable(cfg_Bone_mixManager, TableManagerBase)

function cfg_Bone_mixManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Bone_mixManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Bone_mixManager:GetId(itemId)
  if itemId == nil then
    return 0
  end
  for i, v in pairs(self:GetDic()) do
    if type(v.itemId) == "number" and v.itemId == itemId then
      return v.id
    elseif type(v.itemId) == "table" and table.contains(v.itemId, itemId) then
      return v.id
    end
  end
end

function cfg_Bone_mixManager:IsContainThisItemId(itemId)
  if itemId == nil then
    return false
  end
  for i, v in pairs(self:GetDic()) do
    if type(v.itemId) == "number" and v.itemId == itemId then
      return true
    elseif type(v.itemId) == "table" and table.contains(v.itemId, itemId) then
      return true
    end
  end
  return false
end

return cfg_Bone_mixManager
