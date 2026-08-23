local cfg_Activity_climbTowerManager = {}

function cfg_Activity_climbTowerManager:GetName()
  return "cfg_Activity_climbTowerManager"
end

function cfg_Activity_climbTowerManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Activity_climbTower")
  end
  return self.dic
end

setmetatable(cfg_Activity_climbTowerManager, TableManagerBase)

function cfg_Activity_climbTowerManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Activity_climbTowerManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Activity_climbTowerManager:GetMostterd(id)
  local len = 0
  local mosterid = ""
  local data = self:TryGetValue(id, "id")
  if data and data.monsterID then
    local str = string.split(data.monsterID, "#")
    len = #str
    if 1 <= len then
      mosterid = str[1]
    end
  end
  return tonumber(mosterid), len
end

function cfg_Activity_climbTowerManager:GetMostterReward(id)
  local mosterid = {}
  local data = self:TryGetValue(id, "id")
  if data and data.reward then
    local str = string.split(data.reward, "&")
    if str then
      for i, v in pairs(str) do
        local strss = string.split(v, "#")
        if strss then
          local tbs = {}
          tbs.itemId = strss[1]
          tbs.count = strss[2]
          table.insert(mosterid, tbs)
        end
      end
    end
  end
  return mosterid
end

return cfg_Activity_climbTowerManager
