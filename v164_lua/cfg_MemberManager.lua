local cfg_MemberManager = {}

function cfg_MemberManager:GetName()
  return "cfg_MemberManager"
end

function cfg_MemberManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Member")
  end
  return self.dic
end

setmetatable(cfg_MemberManager, TableManagerBase)

function cfg_MemberManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_MemberManager:GetExpList()
  if self.expList == nil then
    self.expList = {}
    local index = 1
    local curId = 100
    local sumExp = 0
    local vipInfo
    while curId ~= 0 do
      vipInfo = self:TryGetValue(curId)
      sumExp = sumExp + vipInfo.vipExp
      self.expList[index] = {
        id = vipInfo.id,
        sumVipExp = sumExp
      }
      curId = vipInfo.nextLevel
      index = index + 1
    end
  end
  return self.expList
end

return cfg_MemberManager
