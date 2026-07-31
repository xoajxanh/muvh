local BingJianData = {}
BingJianData.serverKeyDic = nil
BingJianData.canShowSuitTblList = nil

function BingJianData:Init(suitManager)
  self.suitManager = suitManager
  self:RigisterSerRecord()
end

function BingJianData:RigisterSerRecord()
  self.serverKeyDic = self.serverKeyDic or {}
  for i, v in pairs(ClientTable.cfg_Item_equip_bingjianManager:GetDic()) do
    if v.cellType then
      self.serverKeyDic[v.serverKey] = false
    end
  end
end

function BingJianData:RefreshSuitTypeState()
  local isRefresh, isOpen, recordData
  for serverKey, serRecord in pairs(self.serverKeyDic) do
    recordData = ServerDataRecordData.GetIntRecordData(serverKey)
    isOpen = recordData ~= nil and 0 < recordData
    if isOpen and serRecord ~= isOpen then
      serRecord = isOpen
      isRefresh = true
      local addTbl = ClientTable.cfg_Item_equip_bingjianManager:TryGetValue(serverKey, "serverKey")
      local isFind = false
      local index = table.count(self:GetCanShowSuitTblList()) + 1
      for i, tbl in ipairs(self:GetCanShowSuitTblList()) do
        if addTbl.cellType == tbl.cellType then
          isFind = true
          break
        end
        if addTbl.order < tbl.order then
          index = i
          break
        end
      end
      if isFind == false then
        table.insert(self:GetCanShowSuitTblList(), index, addTbl)
      end
    end
  end
  if isRefresh then
    EventManager.Dispatch(Event.ShowSuitTypeChange)
    EventManager.Dispatch(Event.Fuc_SingleRefresh, {
      FunctionSystemEnumId.BingJian
    })
  end
end

function BingJianData:GetFirstShowBingJianSuitType()
  local canShowBingJianTypeList = self:GetCanShowSuitTblList()
  if canShowBingJianTypeList and type(canShowBingJianTypeList[1]) == "table" then
    return canShowBingJianTypeList[1].cellType
  else
    return nil
  end
end

function BingJianData:GetCanShowSuitTblList()
  if self.canShowSuitTblList == nil then
    self.canShowSuitTblList = {}
  end
  return self.canShowSuitTblList
end

function BingJianData:GetShowBingjianSuitTypeListBySelectType(selectType)
  local canShowBingJianTypeList = self:GetCanShowSuitTblList()
  local showSuitTypeList = {}
  for i, v in ipairs(canShowBingJianTypeList) do
    local showSuitType = {
      suitType = v.cellType,
      isSelect = v.cellType == selectType
    }
    table.insert(showSuitTypeList, showSuitType)
  end
  return showSuitTypeList
end

function BingJianData:GetHasEquipBingJianSuitTypeList()
  local hasEquipBingJianSuitTypeList = {}
  for i, suitType in ipairs(ClientTable.cfg_Item_equip_bingjianManager:GetAllCellTypeList()) do
    local suit = self.suitManager:GetSingleSuit(suitType)
    if suit ~= nil and suit:HaveEquip() then
      table.insert(hasEquipBingJianSuitTypeList, suitType)
    end
  end
  table.sort(hasEquipBingJianSuitTypeList)
  return hasEquipBingJianSuitTypeList
end

function BingJianData:GetHasEquipBingjianSuitTypeListBySelectType(selectType)
  local hasEquipSuitTypeList = self:GetHasEquipBingJianSuitTypeList()
  local showSuitTypeList = {}
  for i, v in ipairs(hasEquipSuitTypeList) do
    local showSuitType = {
      suitType = v,
      isSelect = v == selectType
    }
    table.insert(showSuitTypeList, showSuitType)
  end
  return showSuitTypeList
end

return BingJianData
