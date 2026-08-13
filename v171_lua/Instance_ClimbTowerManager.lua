local Instance_ClimbTowerManager = {}

function Instance_ClimbTowerManager:RefreshLevel(tblData)
  if tblData == nil then
    return
  end
  self.rewardFinish = tblData.rewardFinish
  local data, reword, currtierid, giftinde, combinHigth = self:GetData(tblData.level, tblData.rewardFinish)
  self.showData = data
  self.towerData = table.DeepCopy(data)
  table.sort(data, function(a, b)
    return a.id > b.id
  end)
  local datass
  datass = {
    data = data,
    data,
    index = tblData.level,
    currtierid = currtierid,
    combinHigth = combinHigth
  }
  datass.currreword = reword
  EventManager.Dispatch(Event.ClimbTowerCurrnLevel, datass)
end

function Instance_ClimbTowerManager:RefreshRoweinfo(tblData)
  if not IsNil(tblData) then
    return
  end
end

function Instance_ClimbTowerManager:GetData(index, rewardFinish)
  local combineItems = {}
  local currtierid = 1
  local index = index
  local giftIndex = -1
  local combineTbl = ClientTable.cfg_Activity_climbTowerManager:GetDic()
  if combineTbl == nil then
    CS.Unity.Debug.LogError("cfg_Activity_climbTower\232\161\168\228\184\141\229\173\152\229\156\168")
    return nil
  end
  local currreword = {}
  local tblItem = {}
  for i = 1, #combineTbl do
    tblItem = table.DeepCopy(combineTbl[i])
    if tblItem ~= nil and ConditionManager.Check4D(tblItem.condition) then
      if tblItem.reward ~= nil then
        local rewarddata = string.split(tblItem.reward, "&")
        for j = 1, #rewarddata do
          local reward = rewarddata[j]
          local rewardItem = string.split(reward, "#")
          if rewardItem ~= nil then
            local item = {}
            item.itemid = tonumber(rewardItem[1])
            item.count = tonumber(rewardItem[2])
            if tblItem.reworditems == nil then
              tblItem.reworditems = {}
            end
            table.insert(tblItem.reworditems, item)
          end
        end
      end
      if tblItem.modle == nil then
        local models = ClientTable.cfg_Monster_monsterManager:TryGetValue(tonumber(tblItem.monsterID))
        if models then
          tblItem.model = models.model
        end
      end
      if tblItem.islock then
        tblItem.islock = {}
      end
      tblItem.islock = {}
      if tblItem.id == index + 1 then
        tblItem.islock = 1
      elseif tblItem.id > index + 1 then
        tblItem.islock = 2
      else
        tblItem.islock = 3
        tblItem.isreward = self:GetDataReward(tblItem.id)
      end
      if index == #combineTbl then
        tblItem.isreward = self:GetDataReward(tblItem.id)
      end
      table.insert(combineItems, tblItem)
    end
  end
  for i = 1, #combineItems do
    if combineItems[i].islock and combineItems[i].id >= index + 1 and combineItems[i].flag == 1 then
      if combineItems[i].reworditems[1] then
        currreword = combineItems[i].reworditems[1]
        currtierid = combineItems[i].id
      end
      break
    elseif combineItems[i].islock and combineItems[i].id == #combineItems and combineItems[i].flag == 1 then
      if combineItems[i].reworditems[1] then
        currreword = combineItems[i].reworditems[1]
        currtierid = combineItems[i].id
      end
      break
    end
  end
  if 0 < #combineItems then
    local item = {}
    item.head = true
    item.id = #combineItems + 1
    table.insert(combineItems, item)
  end
  return combineItems, currreword, currtierid, giftIndex, #combineTbl
end

function Instance_ClimbTowerManager:GetDataReward(index)
  if self.rewardFinish == nil then
    return false
  end
  for _, value in ipairs(self.rewardFinish) do
    if value == index then
      return true
    end
  end
  return false
end

function Instance_ClimbTowerManager:GetSingleTowerDataById(id)
  if self.towerData == nil or id == nil then
    return
  end
  return self.towerData[id]
end

function Instance_ClimbTowerManager:GetIndexFromShowDataById(id, combineHight)
  if self.showData == nil or id == nil then
    return 1
  end
  if id == combineHight then
    return 1
  end
  for i, v in ipairs(self.showData) do
    if v.id == id then
      return i
    end
  end
  return 1
end

return Instance_ClimbTowerManager
