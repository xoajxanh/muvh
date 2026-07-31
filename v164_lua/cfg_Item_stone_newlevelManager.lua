local cfg_Item_stone_newlevelManager = {}

function cfg_Item_stone_newlevelManager:GetName()
  return "cfg_Item_stone_newlevelManager"
end

function cfg_Item_stone_newlevelManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_stone_newlevel")
  end
  return self.dic
end

setmetatable(cfg_Item_stone_newlevelManager, TableManagerBase)

function cfg_Item_stone_newlevelManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_stone_newlevelManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

cfg_Item_stone_newlevelManager.StoneTypeDic = nil

function cfg_Item_stone_newlevelManager:TryInitStoneTypeDic()
  if self.StoneTypeDic ~= nil then
    return
  end
  self.StoneTypeDic = {}
  local dic = self:GetDic()
  for k, v in pairs(dic) do
    if self.StoneTypeDic[v.stonetype] == nil then
      self.StoneTypeDic[v.stonetype] = {}
    end
    if self.StoneTypeDic[v.stonetype][v.level] == nil then
      self.StoneTypeDic[v.stonetype][v.level] = v
    end
  end
end

function cfg_Item_stone_newlevelManager:GetGemTblByType(gemType, level)
  self:TryInitStoneTypeDic()
  local curLevel = level == nil and 0 or level
  return self.StoneTypeDic[gemType][curLevel]
end

return cfg_Item_stone_newlevelManager
