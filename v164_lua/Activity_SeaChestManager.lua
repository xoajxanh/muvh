local Activity_SeaChestManager = {}

function Activity_SeaChestManager:Init()
end

function Activity_SeaChestManager:ReasherNet(tblData)
  local rewardpond = {}
  local itemInfos = {}
  if tblData.rewardPond then
    local total = 0
    for i, v in ipairs(tblData.rewardPond) do
      local data = ClientTable.cfg_SeaChest_rewardManager:TryGetValue(tonumber(v))
      if data then
        if tblData.setp == 1 or tblData.setp == 2 then
          total = data.weight0 + total
        elseif tblData.setp == 3 or tblData.setp == 4 then
          total = data.weight1 + total
        end
      end
      table.insert(rewardpond, {
        id = tonumber(v),
        total = total,
        data = data
      })
    end
    local totals = 1
    for i, v in ipairs(rewardpond) do
      if tblData.setp == 1 or tblData.setp == 2 then
        if i == #rewardpond then
          v.probability = totals
        else
          v.probability = tonumber(string.format("%.4f", v.data.weight0 / total))
          totals = totals - v.probability
        end
      elseif tblData.setp == 3 or tblData.setp == 4 then
        if i == #rewardpond then
          v.probability = totals
        else
          v.probability = tonumber(string.format("%.4f", v.data.weight1 / total))
          totals = totals - v.probability
        end
      end
    end
    for i, v in ipairs(tblData.itemInfos) do
      table.insert(itemInfos, v)
    end
  end
  local datainfo = {
    rewardpond = rewardpond,
    setp = tblData.setp,
    setp = tblData.setp,
    type = tblData.type,
    itemInfos = itemInfos,
    rewardConfigId = tblData.rewardConfigId
  }
  self.treasureData = datainfo
  EventManager.Dispatch(Event.Activity_SeaChestDatechange, datainfo)
end

function Activity_SeaChestManager:GetData(index, rewardFinish)
end

function Activity_SeaChestManager:GetDataRewardTitle(datatitle)
  local title = {}
  local titledata = ClientTable.cfg_Ui_wordManager:GetSeaChestTab()
  if titledata then
    local titledataList = string.split(titledata, "&")
    if titledataList then
      for i, v in ipairs(titledataList) do
        local temp = string.split(v, "#")
        if 2 <= #temp then
          local iteminfo = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(temp[1]))
          if iteminfo and ConditionManager.Check4D(iteminfo.transCondition) then
            local counts = BagInfoData:GetItemTotalCountByItemIdFromIndexDic(tonumber(temp[1]))
            if counts and 0 < counts then
              local data = {
                itemid = temp[1],
                name = temp[2]
              }
              table.insert(title, data)
            else
              for i, v in ipairs(datatitle.itemConfigId) do
                if tonumber(temp[1]) == tonumber(v) then
                  local data = {
                    itemid = temp[1],
                    name = temp[2]
                  }
                  table.insert(title, data)
                end
              end
            end
          end
        end
      end
    end
  end
  EventManager.Dispatch(Event.Activity_SeaChestTitledata, title)
  return title
end

function Activity_SeaChestManager:GetTreasureDataForIndex(index)
  if self.treasureData then
    local data = self.treasureData.rewardpond[index].data
    if self.treasureData.setp == 1 or self.treasureData.setp == 2 then
      local databox = ClientTable.cfg_Box_boxManager:GetTabListByIdAndCondition(data.boxId)
      return databox
    else
      local databox = ClientTable.cfg_Box_boxManager:GetTabListByIdAndCondition(data.boxdId)
      return databox
    end
  end
end

return Activity_SeaChestManager
