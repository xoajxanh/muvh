local cfg_Item_tipsManager = {}

function cfg_Item_tipsManager:GetName()
  return "cfg_Item_tipsManager"
end

function cfg_Item_tipsManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_tips")
  end
  return self.dic
end

setmetatable(cfg_Item_tipsManager, TableManagerBase)

function cfg_Item_tipsManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_tipsManager:GetContentByItemTipsID(itemTipsID)
  if itemTipsID == nil or itemTipsID == 0 then
    return ""
  end
  return self:TryGetValue(itemTipsID).content
end

return cfg_Item_tipsManager
