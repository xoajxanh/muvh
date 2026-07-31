local cfg_Game_gameguideManager = {}

function cfg_Game_gameguideManager:GetName()
  return "cfg_Game_gameguideManager"
end

function cfg_Game_gameguideManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Game_gameguide")
  end
  return self.dic
end

setmetatable(cfg_Game_gameguideManager, TableManagerBase)

function cfg_Game_gameguideManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Game_gameguideManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Game_gameguideManager:GetTabDic()
  local dataDic = {}
  for key, value in pairs(self:GetDic()) do
    if dataDic[value.type] == nil then
      dataDic[value.type] = {}
    end
    table.insert(dataDic[value.type], value)
  end
  for key, value in pairs(dataDic) do
    table.sort(value, function(a, b)
      if a.subtype and b.subtype then
        return a.subtype < b.subtype
      else
        return false
      end
    end)
  end
  return dataDic
end

function cfg_Game_gameguideManager:GetTabsBySubtype(_type, _subtype)
  local tabs = {}
  local dataDic = self:GetTabDic()
  for key, value in pairs(dataDic[_type]) do
    if _subtype == value.subtype then
      table.insert(tabs, value)
    end
  end
  table.sort(tabs, function(a, b)
    if a.id and b.id then
      return a.id < b.id
    else
      return false
    end
  end)
  return tabs
end

return cfg_Game_gameguideManager
