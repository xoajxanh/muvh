Instance_ClimbTowerUIData = {}
local this = Instance_ClimbTowerUIData

function Instance_ClimbTowerUIData:Init()
end

function Instance_ClimbTowerUIData:GetData()
  self.combineItems = {}
  local combineTbl = ConfigManager.GetConfigTable("cfg_Activity_climbTower")
  if combineTbl == nil then
    CS.Unity.Debug.LogError("cfg_Activity_climbTower\232\161\168\228\184\141\229\173\152\229\156\168")
    return nil
  end
  local tblItem, pageIndex
  for i = 1, #combineTbl do
    tblItem = combineTbl[i]
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
      tblItem.id = tblItem.monsterID
      table.insert(self.combineItems, tblItem)
    end
  end
  return self.combineItems
end
