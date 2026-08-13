local TransferStoneManager = {}
TransferStoneManager.costEquipDataList = nil
TransferStoneManager.costInfo = nil
TransferStoneManager.selectIndex = 0
TransferStoneManager.selectEquipData = nil
TransferStoneManager.changeEquipItemIdList = nil
TransferStoneManager.changeIndex = 0

function TransferStoneManager:SetCostInfo(costInfo)
  if self.costInfo == nil then
    self.costInfo = {}
  end
  if costInfo.ItemID then
    self.costInfo.itemId = tonumber(costInfo.ItemID)
    self.costInfo.count = 1
    self.costInfo.id = BagInfoData.GetItemByConfigID(self.costInfo.itemId).id
  end
end

function TransferStoneManager:SetSelectIndex(selectIndex)
  self.selectIndex = selectIndex
end

function TransferStoneManager:SetSelectEquipData()
  self.selectEquipData = self.costEquipDataList[self.selectIndex]
end

function TransferStoneManager:SetChangeIndex(changeIndex)
  self.changeIndex = changeIndex
end

function TransferStoneManager:IsCanTransferEquip(itemId)
  local transferEquip = ClientTable.cfg_Career_transfer_itemManager:GetItemInfo(self.costInfo.itemId, itemId)
  if transferEquip then
    return true
  end
  return false
end

function TransferStoneManager:GetCanTransferEquipDataList()
  if self.costEquipDataList then
    for i = #self.costEquipDataList, 1, -1 do
      table.remove(self.costEquipDataList)
    end
  else
    self.costEquipDataList = {}
  end
  local totalItems = BagInfoData.TotalItems
  for _, itemData in pairs(totalItems) do
    if ItemUtility.IsEquipType(itemData.tblItem.type) and self:IsCanTransferEquip(itemData.itemId) then
      table.insert(self.costEquipDataList, itemData)
    end
  end
  return self.costEquipDataList
end

function TransferStoneManager:GetSelectEquipData()
  return self.selectEquipData
end

function TransferStoneManager:GetChangeEquipItemIdList()
  self.changeEquipItemIdList = {}
  if self.costInfo and self.selectEquipData then
    local transferItem = ClientTable.cfg_Career_transfer_itemManager:GetItemInfo(self.costInfo.itemId, self.selectEquipData.itemId)
    if transferItem and transferItem.transferItemId then
      if type(transferItem.transferItemId) == "table" then
        self.changeEquipItemIdList = transferItem.transferItemId
      else
        table.insert(self.changeEquipItemIdList, transferItem.transferItemId)
        self.changeEquipItemIdList = {
          transferItem.transferItemId
        }
      end
    else
      logError("Kh\195\180ng t\195\172m th\225\186\165y itemId trong b\225\186\163ng Career_transfer_item", self.selectEquipData.itemId)
    end
  end
  return self.changeEquipItemIdList
end

function TransferStoneManager:GetChangeEquipTitle()
  local equipTitleList = {}
  if self.costInfo and self.selectEquipData then
    local transferItem = ClientTable.cfg_Career_transfer_itemManager:GetItemInfo(self.costInfo.itemId, self.selectEquipData.itemId)
    if transferItem and not string.isNullOrEmpty(transferItem.equipTitle) then
      equipTitleList = string.split(transferItem.equipTitle, "#")
    else
      table.insert(equipTitleList, "")
    end
  end
  return equipTitleList
end

function TransferStoneManager:GetChangeIndex()
  return self.changeIndex
end

function TransferStoneManager:GetSelectIndex()
  return self.selectIndex
end

function TransferStoneManager:GetReqTbl()
  if self.selectEquipData == nil then
    return nil
  end
  local tbl = {
    equipId = self.selectEquipData.id,
    itemId = self.changeEquipItemIdList[self.changeIndex],
    consumEquipId = self.costInfo.id
  }
  return tbl
end

function TransferStoneManager:GetCostItemInfo()
  return self.costInfo
end

function TransferStoneManager:DestroyData()
  self.costInfo = nil
  self.selectIndex = 0
  self.selectEquipData = nil
  self.changeEquipItemIdList = nil
  self.changeIndex = 0
end

return TransferStoneManager
