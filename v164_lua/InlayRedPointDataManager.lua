local InlayRedPointDataManager = {}

function InlayRedPointDataManager:GetInlayDataMgr()
  return self.mInlayDataMgr
end

function InlayRedPointDataManager:GetEquipDataMgr()
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager()
  end
  return nil
end

function InlayRedPointDataManager:AllStoneCellAndEquipTypeDic()
  return ClientTable.cfg_EquipCell_cellManager:GetStoneCellDic()
end

function InlayRedPointDataManager:AllStoneCellDic()
  if self.mAllStoneCellDic == nil then
    self.mAllStoneCellDic = {}
  end
  return self.mAllStoneCellDic
end

function InlayRedPointDataManager:AllStoneDic()
  if self.mAllStoneDic == nil then
    self.mAllStoneDic = {}
  end
  return self.mAllStoneDic
end

function InlayRedPointDataManager:InlayRedPointCodeDic()
  if self.mStoneRedPointCodeDic == nil then
    self.mStoneRedPointCodeDic = {}
  end
  return self.mStoneRedPointCodeDic
end

function InlayRedPointDataManager:Init(data)
  self.mInlayDataMgr = data.inlayDataMgr
  self:InitParam()
  self:BindNetMsg()
end

function InlayRedPointDataManager:InitParam()
  self.eventContainer = EventContainer(EventManager)
  self.orgionLevel = 1
  self.isInitialized = false
end

function InlayRedPointDataManager:BindNetMsg()
  self.eventContainer:Regist(Event.Bag_ResBagChange, self.BagChangedCallBack, self)
  self.eventContainer:Regist(Event.Bag_ResBagInfo, self.BagInfoInitializedCallBack, self)
  self.eventContainer:Regist(Event.Equip_StonePosChange, self.StonePosChangeCallBack, self)
  self.eventContainer:Regist(Event.PutOnSuit, self.PutOnSuitCallBack, self)
  self.eventContainer:Regist(Event.TakeOffSuit, self.TakeOffSuitCallBack, self)
end

function InlayRedPointDataManager:Initialize()
  self:InitializeStoneInfo()
  self:InitializeStoneCellInfo()
  self:RefreshAllStoneCellState()
end

function InlayRedPointDataManager:InitializeStoneInfo()
  if self.mAllStoneDic == nil then
    return
  end
  local level, curCount
  for i, v in pairs(BagInfoData.TotalItems) do
    if v.tblItem ~= nil then
      level = self:GetStoneLevel(v.tblItem)
      if level ~= 0 then
        if self:AllStoneDic()[v.tblItem.type] == nil then
          self:AllStoneDic()[v.tblItem.type] = {}
        end
        curCount = self:AllStoneDic()[v.tblItem.type][level]
        if curCount == nil then
          self:AllStoneDic()[v.tblItem.type][level] = 1
        else
          self:AllStoneDic()[v.tblItem.type][level] = curCount + 1
        end
      end
    end
  end
end

function InlayRedPointDataManager:InitializeStoneCellInfo()
  for i, cellList in pairs(self:AllStoneCellAndEquipTypeDic()) do
    for i2, v in pairs(cellList) do
      self:AllStoneCellDic()[v.inlayIndex] = v
    end
  end
end

function InlayRedPointDataManager:BagInfoInitializedCallBack()
  if self.isInitialized then
    return
  end
  self.isInitialized = true
  self:Initialize()
end

function InlayRedPointDataManager:BagChangedCallBack(msgId, data)
  if data == nil then
    return
  end
  local isNeedRefresh, level, lastLevel
  if data.showItems ~= nil then
    for i, v in pairs(data.showItems) do
      if v and v.cfg_item then
        if self:AllStoneDic()[v.tblItem.type] == nil then
          self:AllStoneDic()[v.tblItem.type] = {}
        end
        lastLevel = self:AllStoneDic()[v.tblItem.type][level]
        if lastLevel == nil then
          self:AllStoneDic()[v.tblItem.type][level] = 1
          isNeedRefresh = true
        else
          self:AllStoneDic()[v.tblItem.type][level] = lastLevel + 1
        end
      end
    end
  end
  if data.removeItems ~= nil then
    for i, v in pairs(data.removeItems) do
      if v and v.cfg_item then
        level = self:GetStoneLevel(v.cfg_item)
        lastLevel = 0
        if self:AllStoneDic()[v.tblItem.type] then
          lastLevel = self:AllStoneDic()[v.tblItem.type][level]
        end
        if lastLevel == 1 then
          isNeedRefresh = true
        end
        self:AllStoneDic()[v.tblItem.type][level] = 0 < lastLevel and lastLevel - 1 or 0
      end
    end
  end
  if isNeedRefresh then
    self:RefreshAllStoneCellState()
  end
end

function InlayRedPointDataManager:StonePosChangeCallBack()
  local curState, needCallRedPoint
  for i, cellList in pairs(self:AllStoneCellAndEquipTypeDic()) do
    for i, v in pairs(cellList) do
      curState = self:InlayRedPointCodeDic()[v.inlayIndex]
      if curState == EStoneCellStateCode.Lock and not self:GetStoneCellLockState(v.inlayIndex) then
        needCallRedPoint = self:RefreshStoneCellStateByCellInfo(v)
      end
    end
  end
  if needCallRedPoint then
    self:Call()
  end
end

function InlayRedPointDataManager:PutOnSuitCallBack(msgId, data)
  if data == nil or data.position == nil then
    return
  end
  local isNeedCallRedPoint = false
  if self:AllStoneCellAndEquipTypeDic()[data.position] then
    for i, v in pairs(self:AllStoneCellAndEquipTypeDic()[data.position]) do
      if self:InlayRedPointCodeDic()[v.inlayIndex] == EStoneCellStateCode.NoEquip and self:RefreshStoneCellStateByCellInfo(v) then
        isNeedCallRedPoint = true
      end
    end
  elseif self:InlayRedPointCodeDic()[data.position] then
    isNeedCallRedPoint = self:RefreshStoneCellStateByCellInfo(self:AllStoneCellDic()[data.position])
  end
  if isNeedCallRedPoint then
    self:Call()
  end
end

function InlayRedPointDataManager:TakeOffSuitCallBack(msgId, data)
  if data == nil or data.position == nil then
    return
  end
  local isNeedCallRedPoint = false
  if self:AllStoneCellAndEquipTypeDic()[data.position] then
    for i, v in pairs(self:AllStoneCellAndEquipTypeDic()[data.position]) do
      if self:InlayRedPointCodeDic()[v.inlayIndex] ~= EStoneCellStateCode.NoEquip and self:RefreshStoneCellStateByCellInfo(v) then
        isNeedCallRedPoint = true
      end
    end
  elseif self:InlayRedPointCodeDic()[data.position] then
    isNeedCallRedPoint = self:RefreshStoneCellStateByCellInfo(self:AllStoneCellDic()[data.position])
  end
  if isNeedCallRedPoint then
    self:Call()
  end
end

function InlayRedPointDataManager:RefreshAllStoneCellState()
  local isNeedCallRedPoint
  for i, cellList in pairs(self:AllStoneCellAndEquipTypeDic()) do
    for i, v in pairs(cellList) do
      if self:RefreshStoneCellStateByCellInfo(v) then
        isNeedCallRedPoint = true
      end
    end
  end
  if isNeedCallRedPoint then
    self:Call()
  end
end

function InlayRedPointDataManager:RefreshStoneCellStateByCellInfo(_cellInfo)
  if _cellInfo == nil then
    return false
  end
  local lastState = self:InlayRedPointCodeDic()[_cellInfo.inlayIndex]
  local curState = self:GetStoneCellState(_cellInfo)
  self:InlayRedPointCodeDic()[_cellInfo.inlayIndex] = curState
  if lastState == nil or lastState < 0 ~= (curState < 0) then
    EventManager.Dispatch(Event.InlayCodeStateChanged, _cellInfo)
  end
  return lastState == nil or lastState < 0 ~= (curState < 0)
end

function InlayRedPointDataManager:GetStoneCellState(_cellInfo)
  if _cellInfo == nil then
    return EStoneCellStateCode.None
  end
  if _cellInfo.equipIndex == nil or _cellInfo.inlayIndex == nil then
    return EStoneCellStateCode.None
  end
  if self:GetEquipDataMgr() == nil then
    return EStoneCellStateCode.NoEquip
  end
  if self:GetEquipDataMgr():GetEquipDataByEquipIndex(_cellInfo.equipIndex) == nil then
    return EStoneCellStateCode.NoEquip
  end
  if self:GetStoneCellLockState(_cellInfo.inlayIndex) then
    return EStoneCellStateCode.Lock
  end
  return self:CheckCanInlay(_cellInfo)
end

function InlayRedPointDataManager:IsShowRedPoint()
  for i, v in pairs(self:InlayRedPointCodeDic()) do
    if self:IsShowRedPointByCell(i) then
      return true
    end
  end
  return false
end

function InlayRedPointDataManager:IsShowRedPointByCell(_cellIndex)
  return self:InlayRedPointCodeDic()[_cellIndex] and self:InlayRedPointCodeDic()[_cellIndex] > 0
end

function InlayRedPointDataManager:Call()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.forge_inlaid
  })
end

function InlayRedPointDataManager:GetStoneLevel(_itemTbl)
  if _itemTbl == nil or not self:IsStoneType(_itemTbl.type) then
    return 0
  end
  return _itemTbl.subType - _itemTbl.type * 100
end

function InlayRedPointDataManager:IsStoneType(_ItemType)
  return _ItemType == 11 or _ItemType == 12 or _ItemType == 13
end

function InlayRedPointDataManager:GetStoneCellLockState(_cellIndex)
  if self:GetInlayDataMgr() == nil then
    return true
  end
  local cellLockState = self:GetInlayDataMgr():GetCellInfoByStoneIndex(_cellIndex)
  return cellLockState == nil or cellLockState.state == 0
end

function InlayRedPointDataManager:CheckCanInlay(_cellInfo)
  local stoneItemData = self:GetEquipDataMgr():GetEquipDataByEquipIndex(_cellInfo.inlayIndex, EquipCellType.GEM)
  if stoneItemData == nil then
    for i, v in pairs(self:AllStoneDic()) do
      if v[self.orgionLevel] ~= nil and v[self.orgionLevel] > 0 then
        return EStoneCellStateCode.CanInlaid
      end
    end
    return EStoneCellStateCode.None
  end
  local stoneTbl = stoneItemData:GetItemTbl()
  if stoneTbl == nil then
    return EStoneCellStateCode.None
  end
  if self:AllStoneDic()[stoneTbl.type] == nil then
    return EStoneCellStateCode.None
  end
  local curStoneLevel = self:GetStoneLevel(stoneItemData.itemTbl)
  if self:AllStoneDic()[stoneTbl.type][curStoneLevel + 1] ~= nil and 0 < self:AllStoneDic()[stoneTbl.type][curStoneLevel + 1] then
    return EStoneCellStateCode.CanChange
  end
  return EStoneCellStateCode.None
end

return InlayRedPointDataManager
