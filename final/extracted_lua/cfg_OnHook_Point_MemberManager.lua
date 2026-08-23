local cfg_OnHook_Point_MemberManager = {}

function cfg_OnHook_Point_MemberManager:GetName()
  return "cfg_OnHook_Point_MemberManager"
end

function cfg_OnHook_Point_MemberManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_OnHook_Point_Member")
  end
  return self.dic
end

setmetatable(cfg_OnHook_Point_MemberManager, TableManagerBase)

function cfg_OnHook_Point_MemberManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_OnHook_Point_MemberManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_OnHook_Point_MemberManager
