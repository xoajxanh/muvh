local cfg_Item_fashionLevelManager = {}

function cfg_Item_fashionLevelManager:GetName()
  return "cfg_Item_fashionLevelManager"
end

function cfg_Item_fashionLevelManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_fashionLevel")
  end
  return self.dic
end

setmetatable(cfg_Item_fashionLevelManager, TableManagerBase)

function cfg_Item_fashionLevelManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_fashionLevelManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Item_fashionLevelManager:GetTable_fashionId_Level(fashionId, level)
  if self.Fashion_Id_LevelDic == nil then
    self.Fashion_Id_LevelDic = {}
    for i, v in pairs(self:GetDic()) do
      if self.Fashion_Id_LevelDic[tonumber(v.fashionId)] == nil then
        self.Fashion_Id_LevelDic[tonumber(v.fashionId)] = {}
      end
      self.Fashion_Id_LevelDic[tonumber(v.fashionId)][tonumber(v.level)] = v
    end
  end
  if self.Fashion_Id_LevelDic[fashionId] == nil then
    return nil
  end
  return self.Fashion_Id_LevelDic[fashionId][level]
end

return cfg_Item_fashionLevelManager
