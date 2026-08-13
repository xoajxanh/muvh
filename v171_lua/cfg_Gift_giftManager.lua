local cfg_Gift_giftManager = {}

function cfg_Gift_giftManager:GetName()
  return "cfg_Gift_giftManager"
end

function cfg_Gift_giftManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Gift_gift")
  end
  return self.dic
end

setmetatable(cfg_Gift_giftManager, TableManagerBase)

function cfg_Gift_giftManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Gift_giftManager:CheckGiftCanGet(giftId)
  local flag = false
  local tbl = self:TryGetValue(giftId)
  if tbl then
    local count = RefreshData.GetLimitCount(tbl.countKey)
    local isShow = string.isNullOrEmpty(tbl.showCondition) or ConditionManager.Check4D(tbl.showCondition)
    flag = 0 < count and isShow
  end
  return flag
end

function cfg_Gift_giftManager:CheckGiftGetFinish(giftId)
  local flag = false
  local tbl = self:TryGetValue(giftId)
  if tbl then
    local count = RefreshData.GetLimitCount(tbl.countKey)
    flag = count <= 0
  end
  return flag
end

function cfg_Gift_giftManager:GetGiftRewardBoxTblList(giftId)
  local tbl = self:TryGetValue(giftId)
  if tbl == nil then
    return {}
  end
  local tempList = ClientTable.cfg_Box_boxManager:GetTabListByIdAndCondition(tbl.reward)
  if tempList == nil then
    return {}
  end
  return tempList
end

return cfg_Gift_giftManager
