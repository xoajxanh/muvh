local cfg_Puzzle_jieshaoManager = {}

function cfg_Puzzle_jieshaoManager:GetName()
  return "cfg_Puzzle_jieshaoManager"
end

function cfg_Puzzle_jieshaoManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Puzzle_jieshao")
  end
  return self.dic
end

setmetatable(cfg_Puzzle_jieshaoManager, TableManagerBase)

function cfg_Puzzle_jieshaoManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Puzzle_jieshaoManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Puzzle_jieshaoManager:GetJieShaoDisplayeList(type)
  if type == nil or type ~= 1 and type ~= 2 then
    return
  end
  local displayTbl = {}
  local cfgTbl = self:GetDic()
  for i, v in ipairs(cfgTbl) do
    if string.contains(v.showTips, tostring(type)) then
      table.insert(displayTbl, v)
    end
  end
  return displayTbl
end

return cfg_Puzzle_jieshaoManager
