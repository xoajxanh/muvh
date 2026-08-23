local cfg_Item_stone_configManager = {}

function cfg_Item_stone_configManager:GetName()
  return "cfg_Item_stone_configManager"
end

function cfg_Item_stone_configManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_stone_config")
  end
  return self.dic
end

setmetatable(cfg_Item_stone_configManager, TableManagerBase)

function cfg_Item_stone_configManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_stone_configManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Item_stone_configManager:GetHaveGemEquipIndexOrderList()
  if self.mHaveGemEquipIndexOrderList == nil then
    self.mHaveGemEquipIndexOrderList = {}
    local data = self:TryGetValue(2)
    if string.isNullOrEmpty(data) == false then
      self.mHaveGemEquipIndexOrderList = string.split(data.stoneconfig, "#")
      for k = 1, #self.mHaveGemEquipIndexOrderList do
        self.mHaveGemEquipIndexOrderList[k] = tonumber(self.mHaveGemEquipIndexOrderList[k])
      end
    end
  end
  return self.mHaveGemEquipIndexOrderList
end

function cfg_Item_stone_configManager:GetGemChooseOrderList()
  if self.mGemChooseOrderList == nil then
    self.mGemChooseOrderList = {}
    local data = self:TryGetValue(1)
    if string.isNullOrEmpty(data) == false then
      local stoneTypeList = string.split(data.stoneconfig, "#")
      for k = 1, #stoneTypeList do
        self.mGemChooseOrderList[tonumber(stoneTypeList[k])] = k
      end
    end
  end
  return self.mGemChooseOrderList
end

return cfg_Item_stone_configManager
