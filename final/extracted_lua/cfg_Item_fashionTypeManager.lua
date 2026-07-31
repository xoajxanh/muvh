local cfg_Item_fashionTypeManager = {}

function cfg_Item_fashionTypeManager:GetName()
  return "cfg_Item_fashionTypeManager"
end

function cfg_Item_fashionTypeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_fashionType")
  end
  return self.dic
end

setmetatable(cfg_Item_fashionTypeManager, TableManagerBase)

function cfg_Item_fashionTypeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_fashionTypeManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Item_fashionTypeManager:GetEquipCellByFashionType(equipCell)
  if self.EquipCellByFashionTypeDic == nil then
    self.EquipCellByFashionTypeDic = {}
    for i, v in pairs(self:GetDic()) do
      local tempS = string.split(v.equipSubType, "#")
      if tempS ~= nil then
        for i2, v2 in pairs(tempS) do
          self.EquipCellByFashionTypeDic[tonumber(v2)] = v.id
        end
      end
    end
  end
  return self.EquipCellByFashionTypeDic[equipCell]
end

return cfg_Item_fashionTypeManager
