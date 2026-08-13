local cfg_Camp_detailManager = {}

function cfg_Camp_detailManager:GetName()
  return "cfg_Camp_detailManager"
end

function cfg_Camp_detailManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Camp_detail")
  end
  return self.dic
end

setmetatable(cfg_Camp_detailManager, TableManagerBase)

function cfg_Camp_detailManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Camp_detailManager:GetCoalitionIdList()
  if self.coalitionIdList == nil then
    self.coalitionIdList = {}
    local dic = self:GetDic()
    for k, v in pairs(dic) do
      table.insert(self.coalitionIdList, v.id)
    end
  end
  return self.coalitionIdList
end

return cfg_Camp_detailManager
