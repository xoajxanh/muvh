local cfg_Map_transferManager = {}

function cfg_Map_transferManager:GetName()
  return "cfg_Map_transferManager"
end

function cfg_Map_transferManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Map_transfer")
  end
  return self.dic
end

setmetatable(cfg_Map_transferManager, TableManagerBase)

function cfg_Map_transferManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Map_transferManager:TryGetPosTbl(tbl)
  if tbl == nil or string.isNullOrEmpty(tbl.position) then
    return nil
  end
  local result = TableParse.SplitStringToIntListList(tbl.position, "#", "-")
  if result == nil or table.count(result) == 0 then
    return
  end
  local newTbl = {}
  for i, v in pairs(result) do
    if v and table.count(v) > 1 then
      table.insert(newTbl, {
        x = v[1],
        y = v[2]
      })
    end
  end
  return newTbl
end

function cfg_Map_transferManager:TryGetRandomPos(tbl)
  local posTbl = self:TryGetPosTbl(tbl)
  if posTbl == nil then
    return
  end
  local tblCount = table.count(posTbl)
  if tblCount == 0 then
    return
  end
  local selectIndex = Mathf.Random(1, tblCount)
  return posTbl[selectIndex]
end

function cfg_Map_transferManager:GetGroupIdByTransferId(id)
  if type(id) ~= "number" or id == nil then
    return nil
  end
  for i, dic in pairs(self:GetDic()) do
    if id == dic.id then
      return dic.groupId
    end
  end
  return nil
end

return cfg_Map_transferManager
