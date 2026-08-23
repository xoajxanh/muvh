local cfg_Commerce_qiandaoManager = {}

function cfg_Commerce_qiandaoManager:GetName()
  return "cfg_Commerce_qiandaoManager"
end

function cfg_Commerce_qiandaoManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_qiandao")
  end
  return self.dic
end

setmetatable(cfg_Commerce_qiandaoManager, TableManagerBase)

function cfg_Commerce_qiandaoManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_qiandaoManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_qiandaoManager
