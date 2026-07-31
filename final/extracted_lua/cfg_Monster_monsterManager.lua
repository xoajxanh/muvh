local cfg_Monster_monsterManager = {}

function cfg_Monster_monsterManager:GetName()
  return "cfg_Monster_monsterManager"
end

function cfg_Monster_monsterManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Monster_monster")
  end
  return self.dic
end

setmetatable(cfg_Monster_monsterManager, TableManagerBase)

function cfg_Monster_monsterManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Monster_monsterManager:GetPositionUi(data)
  local x = 0
  local y = 0
  local z = 0
  if data == nil or data.positionUi == nil or data.positionUi == "" then
    return x, y, z
  end
  local posList = string.split(data.positionUi, "#")
  if #posList == 3 then
    if tonumber(posList[1]) then
      x = tonumber(posList[1])
    end
    if tonumber(posList[2]) then
      y = tonumber(posList[2])
    end
    if tonumber(posList[3]) then
      z = tonumber(posList[3])
    end
  end
  return x, y, z
end

return cfg_Monster_monsterManager
