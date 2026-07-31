SpaceCrackUtility = {}

function SpaceCrackUtility:StructureRankRewardData(_rewardConfigList)
  if _rewardConfigList == nil or table.count(_rewardConfigList) == 0 then
    return
  end
  local rankRewardInfoData, rewardList, rankLimit, rankText = {}
  for i, v in pairs(_rewardConfigList) do
    rewardList = TableParse:SpliteStringToItemCountList(v.showReward)
    if rewardList and table.count(rewardList) > 0 then
      rankLimit = TableParse:SplitStringToIntList(v.rank, "#")
      if rankLimit and table.count(rankLimit) > 1 then
        if rankLimit[1] ~= rankLimit[2] and tonumber(rankLimit[1]) < tonumber(rankLimit[2]) then
          rankText = "H\225\186\161ng" .. tonumber(rankLimit[1]) .. "~" .. tonumber(rankLimit[2]) .. "0"
        elseif rankLimit[1] == rankLimit[2] then
          rankText = "H\225\186\161ng" .. rankLimit[1] .. "0"
        end
        rankRewardInfoData[i] = {
          id = v.id,
          reward = rewardList,
          minRank = rankLimit[1],
          maxRank = rankLimit[2],
          rankText = rankText
        }
      end
    end
  end
  return rankRewardInfoData
end

function SpaceCrackUtility:StructureOtherRewardData(_id)
  if _id == nil then
    return
  end
  local config = ClientTable.cfg_Activity_globalManager:TryGetValue(_id)
  if config == nil then
    return
  end
  local rewardList = TableParse:SplitStringToIntList(config.effect, "#")
  if rewardList == nil or next(rewardList) == nil then
    return
  end
  return rewardList
end

function SpaceCrackUtility:StructureTranScriptRewardData(_rewardText)
  if string.isNullOrEmpty(_rewardText) then
    return nil
  end
  local rewardList = string.split(_rewardText, "&")
  if rewardList == nil or next(rewardList) == nil then
    return nil
  end
  local rewardTab, itemData = {}
  for i, v in ipairs(rewardList) do
    local reward = string.split(v, "#")
    itemData = {
      itemId = tonumber(reward[1]),
      count = tonumber(reward[2])
    }
    table.insert(rewardTab, itemData)
  end
  return rewardTab
end

function SpaceCrackUtility:CheckInSpaceCrackMap(_mapId)
  if _mapId == nil then
    return false
  end
  if _mapId == SpaceCrackMapData.CommonMapId or _mapId == SpaceCrackMapData.LastMapId then
    return true
  end
  return false
end

function SpaceCrackUtility:CheckRefreshCondition()
  if ConditionManager.Check4D(QuickFind:GetSpaceCrackDataManager().m_RefreshConditionOne) or ConditionManager.Check4D(QuickFind:GetSpaceCrackDataManager().m_RefreshConditionTwo) then
    return true
  end
  return false
end
