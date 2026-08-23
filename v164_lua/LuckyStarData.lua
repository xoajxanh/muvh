require("GamePlay/RedPoint/RedPointEnum")
LuckyStarData = {}
LuckyStarData.tabListData = {}
LuckyStarData.rewardDataList = {}
LuckyStarData.RedPointEnumId = {
  [ERedPointId.welfare_LuckyStar1] = 1,
  [ERedPointId.welfare_LuckyStar2] = 2,
  [ERedPointId.welfare_LuckyStar3] = 3,
  [ERedPointId.welfare_LuckyStar4] = 4
}
LuckyStarData.GroupEnumId = {
  [1] = ERedPointId.welfare_LuckyStar1,
  [2] = ERedPointId.welfare_LuckyStar2,
  [3] = ERedPointId.welfare_LuckyStar3,
  [4] = ERedPointId.welfare_LuckyStar4
}

function LuckyStarData:Init()
end

function LuckyStarData:RefreshData()
  self.tabListData = {}
  for i, v in pairs(ClientTable.cfg_Commerce_luckystarManager:GetDic()) do
    if ConditionManager.Check4D(v.showtime) and self.tabListData[v.group] == nil then
      self.tabListData[v.group] = v
    end
  end
end

function LuckyStarData:GetTabList()
  return self.tabListData
end

function LuckyStarData:SetRewardData(msg)
  if msg then
    self.rewardDataList[msg.id] = msg.lastStarList
  end
end

function LuckyStarData:ReqRewarData(data)
  local id = 0
  if ConditionManager.Check4D(data.opentime) then
    id = data.id
  else
    id = data.id - 1
  end
  local lastCfg = ClientTable.cfg_Commerce_luckystarManager:TryGetValue(id)
  if lastCfg and lastCfg.group == data.group then
    networkRequest.ReqLastStarInfo(lastCfg.id)
  end
end

function LuckyStarData:GetRewardData(data)
  if self.rewardDataList[data.id] then
    return self.rewardDataList[data.id]
  end
  return {}
end

function LuckyStarData:BuyReward(data)
  local rechargeCfg = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(data.rechargeid)
  local itemPrice = math.floor(rechargeCfg.rmb / 100)
  DataToCSharpMgr.Pay({
    amount = itemPrice,
    product_Id = rechargeCfg.id,
    product_name = rechargeCfg.name,
    BusinessPayType = BusinessPayType.Holiday_Prize
  })
  NetManager.Send(RechargeMessage.ReqDirectRepayInfo)
end

function LuckyStarData:CheckIsBought(data)
  local rechargeCfg = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(data.rechargeid)
  if rechargeCfg == nil then
    return true
  end
  return RefreshData.GetLimitCount(rechargeCfg.countKey) < 1
end

function LuckyStarData:RedPointRefresh(id)
  local cfg = self.tabListData[self.RedPointEnumId[id]]
  if cfg then
    if not ConditionManager.Check4D(cfg.showtime) or not ConditionManager.Check4D(cfg.deadline) then
      return false
    end
    if PlayerPrefs.GetInt("LuckyStar" .. tostring(QuickFind.LuaMainPlayerViewAttrData().id) .. "ID" .. cfg.id) == 1 then
      return false
    end
    return true
  end
  return false
end

function LuckyStarData:SetLuckyStarRed(data)
  if PlayerPrefs.GetInt("LuckyStar" .. tostring(QuickFind.LuaMainPlayerViewAttrData().id) .. "ID" .. data.id) ~= 1 then
    PlayerPrefs.SetInt("LuckyStar" .. tostring(QuickFind.LuaMainPlayerViewAttrData().id) .. "ID" .. data.id, 1)
  end
end

function LuckyStarData:Reset()
  self.tabListData = {}
  self.rewardDataList = {}
end

LuckyStarData:Init()
