local CommercialRankingData = {}
CommercialRankingData.path = nil
CommercialRankingData.Index = 1
CommercialRankingData.itemRefrth = false
CommercialRankingData.MyRank = nil
CommercialRankingData.commerceId = nil
setmetatable(CommercialRankingData, LuaClass.CommerceActivity)

function CommercialRankingData:ActivityannouncementUI(data)
  self.commerceId = data.commerceId
  local EffectTbl = ClientTable.cfg_Commerce_globalManager:TryGetValue(311001, "id").effect
  local tableitem = string.split(EffectTbl, "&")
  local item = {}
  for i, v in ipairs(tableitem) do
    local itemnum = string.split(v, "#")[2]
    table.insert(item, itemnum)
  end
  self.CommercialRankingDataItemList = {}
  if data ~= nil then
    local rankdata = {}
    for i = 1, table.count(data.ranks) do
      rankdata[data.ranks[i].rank] = data.ranks[i]
    end
    local index = 1
    local rankbol = true
    for i = 1, 3 do
      local Rank = true
      if rankdata[i] ~= nil and table.count(rankdata[i]) > 0 and rankbol then
        if index == 1 and Rank then
          index, Rank, rankbol = self:ActivityRankData(rankdata[i], item, index, Rank, rankbol)
        end
        if index == 2 and Rank then
          index, Rank, rankbol = self:ActivityRankData(rankdata[i], item, index, Rank, rankbol)
        end
        if index == 3 and Rank then
          index, Rank, rankbol = self:ActivityRankData(rankdata[i], item, index, Rank, rankbol)
        end
      end
    end
    local count = 1
    for i, v in pairs(self.CommercialRankingDataItemList) do
      if table.count(v) > 0 then
        count = count + 1
      end
    end
    for i = count, table.count(self:ActivityRankItemUI()) do
      if rankdata[i] ~= nil then
        if rankdata[i].val >= tonumber(item[4]) then
          self:ActivityRank(rankdata[i])
        else
          self:ActivityRank({})
        end
      else
        self:ActivityRank({})
      end
    end
  end
  for i, v in pairs(self.CommercialRankingDataItemList) do
    if v.name == ViewData.meData.name and v.lid == ViewData.meData.id then
      v.equips = ViewData.meData.equipsData.Data
      v.appear = ForgeData.appearData[RoleManager.me.id]
    end
  end
  EventManager.Dispatch(Event.CommercialRanking)
end

function CommercialRankingData:ActivityRank(da)
  local da = da
  table.insert(self.CommercialRankingDataItemList, da)
end

function CommercialRankingData:ActivityRankData(data, item, index, Rank, rankbol)
  if data.val >= tonumber(item[index]) then
    self:ActivityRank(data)
    if index == 3 then
      rankbol = false
    else
      index = index + 1
      Rank = false
    end
  else
    self:ActivityRank({})
    if index == 3 then
      rankbol = false
    else
      index = index + 1
    end
  end
  return index, Rank, rankbol
end

function CommercialRankingData:ActivityannouncementRankUI()
  local Ranklist = {}
  for i = 1, 3 do
    local rewards = ClientTable.cfg_Ui_wordManager:TryGetValue("CommerceRank_" .. i).content
    table.insert(Ranklist, rewards)
  end
  return Ranklist
end

function CommercialRankingData:ActivityRankItemUI()
  local RankItemUI = {}
  local GivebackData = {}
  local cfgCommerce3 = ClientTable.cfg_Commerce_3Manager:GetDic()
  for i, v in pairs(cfgCommerce3) do
    if v.commerceId == self.commerceId then
      table.insert(RankItemUI, v)
    end
  end
  table.sort(RankItemUI, function(a, b)
    return a.id < b.id
  end)
  for i, v in pairs(RankItemUI) do
    local giftdata = ClientTable.cfg_Gift_giftManager:TryGetValue(v.giftId, "id")
    local boxdata = ConfigManager.FindConfigs("cfg_Box_box", "boxId", giftdata.reward)
    local itemdata = {}
    for i, v in ipairs(boxdata) do
      local item = ItemUtility.GenerateItemData(tonumber(v.itemId))
      if item == nil or item.tblItem == nil then
        return ""
      end
      item.count = tonumber(v.count)
      table.insert(itemdata, item)
    end
    table.insert(GivebackData, itemdata)
  end
  return GivebackData
end

return CommercialRankingData
