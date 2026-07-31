local cfg_Box_boxManager = {}

function cfg_Box_boxManager:GetName()
  return "cfg_Box_boxManager"
end

function cfg_Box_boxManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Box_box")
  end
  return self.dic
end

setmetatable(cfg_Box_boxManager, TableManagerBase)

function cfg_Box_boxManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Box_boxManager:TryGetTabListByType(key, typeKey)
  return self:BaseGetTabListByType(key, typeKey)
end

function cfg_Box_boxManager:TryGetShowListByBoxId(boxId)
  local temp = {}
  local tab = self:BaseGetTabListByType(boxId, "boxId")
  if tab then
    for i, v in pairs(tab) do
      if string.isNullOrEmpty(v.condition) or ConditionManager.Check4D(v.condition) then
        table.insert(temp, v)
      end
    end
  end
  return temp
end

function cfg_Box_boxManager:GetItemIdByRewardBoxId(rewardBoxId)
  if rewardBoxId == nil then
    return nil
  end
  local dic = self:TryGetValue(rewardBoxId, "boxId")
  return dic and dic.itemId or nil
end

function cfg_Box_boxManager:GetTabListByIdAndCondition(boxId)
  if type(boxId) ~= "number" then
    return
  end
  local tblList = {}
  for i, tbl in pairs(self:GetDic()) do
    if tbl.boxId == boxId and (type(tbl.condition) ~= "table" or ConditionManager.Check4D(tbl.condition)) then
      table.insert(tblList, tbl)
    end
  end
  return tblList
end

return cfg_Box_boxManager
