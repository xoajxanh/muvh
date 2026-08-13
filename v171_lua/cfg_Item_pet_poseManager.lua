local cfg_Item_pet_poseManager = {}

function cfg_Item_pet_poseManager:GetName()
  return "cfg_Item_pet_poseManager"
end

function cfg_Item_pet_poseManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_pet_pose")
  end
  return self.dic
end

setmetatable(cfg_Item_pet_poseManager, TableManagerBase)

function cfg_Item_pet_poseManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_pet_poseManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Item_pet_poseManager
