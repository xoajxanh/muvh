AnniversaryActivity_NewCharacterData = {}
AnniversaryActivity_NewCharacterData.canGet = false
AnniversaryActivity_NewCharacterData.taskInfoTbl = nil

function AnniversaryActivity_NewCharacterData.SetNewCharacterData(data)
  if data and data.rewardCreateRole then
    AnniversaryActivity_NewCharacterData.canGet = data.rewardCreateRole
  end
  if AnniversaryActivity_NewCharacterData.taskInfoTbl == nil and data ~= nil then
    AnniversaryActivity_NewCharacterData.taskInfoTbl = {}
    local tbl = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", data.groupId)
    for i = 1, #tbl do
      local info = ClientTable.cfg_Commerce_1Manager:TryGetValue(tbl[i].commerceId)
      if info and ConditionManager.Check(tbl[i].condition) then
        local goalInfo = ClientTable.cfg_Task_goalManager:TryGetValue(tonumber(info.goals))
        local giftInfo = ClientTable.cfg_Gift_giftManager:TryGetValue(tonumber(info.giftId))
        local boxInfo
        if giftInfo and giftInfo.reward then
          boxInfo = ConfigManager.FindConfigs("cfg_Box_box", "boxId", giftInfo.reward)
        end
        local infoTbl = {
          viewInfo = info,
          goalInfo = goalInfo,
          giftInfo = giftInfo,
          boxInfo = boxInfo
        }
        table.insert(AnniversaryActivity_NewCharacterData.taskInfoTbl, infoTbl)
      end
    end
  end
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.AnniversaryActivity_chuangjue
  })
end

function AnniversaryActivity_NewCharacterData.GetGiftItemData()
  local showData = ClientTable.cfg_Commerce_globalManager:TryGetValue(127004).effect
  if not showData then
    return
  end
  return string.split(showData, "#")
end

function AnniversaryActivity_NewCharacterData.CheckRedPoint()
  if AnniversaryActivity_NewCharacterData.canGet == false then
    return false
  end
  if next(AnniversaryActivity_NewCharacterData.taskInfoTbl) == nil then
    return false
  end
  for _, v in pairs(AnniversaryActivity_NewCharacterData.taskInfoTbl) do
    if RoleManager.me.level >= v.goalInfo.goalCount and RechargeData.GetCount(v.giftInfo.countKey) == 0 then
      return true
    end
  end
  return false
end
