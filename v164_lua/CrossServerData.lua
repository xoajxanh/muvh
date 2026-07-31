local CrossServerData = {}
CrossServerData.CrossServerKaLunTeCrossgomain = {}
CrossServerData.winBossItemTemp = {}
CrossServerData.failBoyItemTemp = {}
CrossServerData.PaoDianItemTemp = {}
CrossServerData.rewardFirScoreData = {}
CrossServerData.rewardSecScoreData = {}
CrossServerData.rewardThirdScoreData = {}
CrossServerData.rewardFourthRewardScoreData = {}
CrossServerData.rewardFifthRewardScoreData = {}
CrossServerData.rewardSeventhGomainData = {}

function CrossServerData:Init()
  self:InitUnionRewardData()
end

function CrossServerData:ProcessItem(rewardStr, itemTable)
  local function ProcessItemData(itemStr)
    local items = string.split(itemStr, "#")
    
    local item = ItemUtility.GenerateItemData(tonumber(items[1]))
    item.count = tonumber(items[2])
    return item
  end
  
  local rewardSple = string.split(rewardStr, "$")
  for i, v in ipairs(rewardSple) do
    local rewardValue = string.split(v, "_")
    local isOpen = ConditionManager.Check4D(rewardValue[1])
    if isOpen then
      local reward = string.split(rewardValue[2], "&")
      for n, m in ipairs(reward) do
        itemTable[#itemTable + 1] = ProcessItemData(m)
      end
    end
  end
end

function CrossServerData:ProcessRewardItem(rewardStr, itemTable)
  local function ProcessItemData(itemStr)
    local items = string.split(itemStr, "#")
    
    local item = ItemUtility.GenerateItemData(tonumber(items[1]))
    item.count = tonumber(items[2])
    return item
  end
  
  local reward = string.split(rewardStr, "&")
  for i, v in ipairs(reward) do
    itemTable[#itemTable + 1] = ProcessItemData(v)
  end
end

function CrossServerData:InitUnionRewardData()
  self.winBossItemTemp = {}
  self.failBoyItemTemp = {}
  self.PaoDianItemTemp = {}
  local rewardBoss = ClientTable.cfg_Activity_globalManager:TryGetValue(400209, "id").effect
  local rewardWinAuction = ClientTable.cfg_Activity_globalManager:TryGetValue(400208, "id").effect
  local rewardLostBoy = ClientTable.cfg_Activity_globalManager:TryGetValue(400210, "id").effect
  self:ProcessItem(rewardBoss, self.winBossItemTemp)
  self:ProcessItem(rewardWinAuction, self.failBoyItemTemp)
  self:ProcessItem(rewardLostBoy, self.PaoDianItemTemp)
  self.rewardFirScoreData = {}
  self.rewardSecScoreData = {}
  self.rewardThirdScoreData = {}
  self.rewardFourthRewardScoreData = {}
  self.rewardFifthRewardScoreData = {}
  local firReward = ClientTable.cfg_Activity_globalManager:TryGetValue(400230, "id").effect
  local secReward = ClientTable.cfg_Activity_globalManager:TryGetValue(400231, "id").effect
  local thirdReward = ClientTable.cfg_Activity_globalManager:TryGetValue(400232, "id").effect
  local fourthReward = ClientTable.cfg_Activity_globalManager:TryGetValue(400233, "id").effect
  local fifthReward = ClientTable.cfg_Activity_globalManager:TryGetValue(400234, "id").effect
  self:ProcessItem(firReward, self.rewardFirScoreData)
  self:ProcessItem(secReward, self.rewardSecScoreData)
  self:ProcessItem(thirdReward, self.rewardThirdScoreData)
  self:ProcessItem(fourthReward, self.rewardFourthRewardScoreData)
  self:ProcessItem(fifthReward, self.rewardFifthRewardScoreData)
  self.rewardSeventhGomainData = {}
  local GomainReward = ClientTable.cfg_Activity_globalManager:TryGetValue(400207, "id").effect
  self:ProcessItem(GomainReward, self.rewardSeventhGomainData)
end

function CrossServerData:ReturnCrossServer()
  return self.winBossItemTemp, self.failBoyItemTemp, self.PaoDianItemTemp
end

function CrossServerData:ReturnCrossServerSort()
  return self.rewardFirScoreData, self.rewardSecScoreData, self.rewardThirdScoreData, self.rewardFourthRewardScoreData, self.rewardFifthRewardScoreData, self.rewardSixthRewardScoreData, self.rewardSeventhRewardScoreData
end

function CrossServerData:ReturnCrossServerGomian()
  return self.rewardSeventhGomainData
end

local itemtime, itemLevel, itemdes

function CrossServerData:ReturnCrossServeritemtime()
  local openActivityCond = ClientTable.cfg_Activity_overviewManager:TryGetValue(4002, "activityId").preTime
  local timeShow = ClientTable.cfg_Ui_wordManager:TryGetValue("Activity_kalunte_7", "id").content
  local isOpen = ConditionManager.Check4D(openActivityCond)
  if isOpen then
    itemtime = string.GetColorText(timeShow, ItemQuality2ColorDic[5])
    self.TimeBol = true
  else
    itemtime = string.GetColorText(timeShow, ItemQuality2ColorDic[7])
    self.TimeBol = false
  end
  return itemtime
end

function CrossServerData:ReturnCrossServerGomianItemLevel()
  local timeShowLevel = ClientTable.cfg_Ui_wordManager:TryGetValue("Activity_kalunte_8", "id").content
  local activityInlevel = string.split(timeShowLevel, "#")
  local tbl = ClientTable.cfg_Character_levelManager:TryGetValue(tonumber(activityInlevel[2]))
  if tonumber(activityInlevel[2]) <= ViewData.meData.level then
    itemLevel = string.GetColorText(tbl.name, ItemQuality2ColorDic[5])
    self.LevelBol = true
  else
    itemLevel = string.GetColorText(tbl.name, ItemQuality2ColorDic[7])
    self.LevelBol = false
  end
  return itemLevel
end

function CrossServerData:ReturnCrossServerGomianitemdes()
  if itemdes == nil then
    itemdes = ClientTable.cfg_Ui_wordManager:TryGetValue("Activity_kalunte_6", "id").content
    return itemdes
  end
  return itemdes
end

CrossServerData.RankListAll = {}

function CrossServerData:InitRankData(data)
  self.RankListAll = {}
  if data then
    for i, v in ipairs(data.ranks) do
      if v.name == ViewData.meData.name and v.lid == ViewData.meData.id then
        v.equips = ViewData.meData.equipsData.Data
        v.appear = ForgeData.appearData[RoleManager.me.id]
      end
    end
    self.RankListAll = data.ranks
    EventManager.Dispatch(Event.Rank_CrossServerKalunte)
  end
end

function CrossServerData:ReturnCrossServerGomianitem()
  if self.RankListAll ~= nil then
    return self.RankListAll
  end
  return self.RankListAll
end

return CrossServerData
