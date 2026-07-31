local SuitManager = {}
SuitManager.SuitDic = nil
SuitManager.TraversalSequenceTbl = {
  EquipCellType.NORMAL,
  EquipCellType.GEM,
  EquipCellType.ARCHANGEL,
  EquipCellType.HONGZHUANG,
  EquipCellType.ARCHANGEL_BLESS,
  EquipCellType.ARCHANGEL_CHRISTMAS,
  EquipCellType.BINGJIAN_SPRINGFESTIVAL,
  EquipCellType.BINGJIAN_DianYi,
  EquipCellType.BINGJIAN_BeachParty,
  EquipCellType.BINGJIAN_YuanTianYueBai
}

function SuitManager:Init()
  self:RegisterSuitDic()
  self:RigisterBingJianSuitDic()
end

function SuitManager:RegisterSuitDic()
  self.SuitDic = self.SuitDic or {}
  self.SuitDic[EquipCellType.NORMAL] = LuaClass.SuitEquipList_Normal:New()
  self.SuitDic[EquipCellType.HONGZHUANG] = LuaClass.SuitEquipList_HongZhuang:New()
  self.SuitDic[EquipCellType.GEM] = LuaClass.SuitEquipList_Gem:New()
  self.SuitDic[EquipCellType.SHENGHUN] = LuaClass.SuitEquipList_HolySpirit:New()
end

function SuitManager:RigisterBingJianSuitDic()
  self.SuitDic = self.SuitDic or {}
  for i, v in pairs(ClientTable.cfg_Item_equip_bingjianManager:GetDic()) do
    if v.cellType then
      self.SuitDic[v.cellType] = LuaClass.SuitEquipList_BingJian:New(v.cellType)
    end
  end
end

function SuitManager:InitSuitList()
  if type(self.SuitDic) ~= "table" then
    return
  end
  for k, v in pairs(self.SuitDic) do
    setmetatable(v, LuaClass.SuitEquipList_Base)
  end
end

function SuitManager:RefreshAllData(data)
  self:ClearData()
  if type(data) ~= "table" then
    return
  end
  for k, v in pairs(data) do
    self:RefreshSingleSuitItem(v, EquipOperationType.PUT_ON)
  end
  for k, v in pairs(self.SuitDic) do
    v:ReCalculateRecommendData()
  end
  self:ReCalculateEquipSpecialEffectDes()
end

function SuitManager:ClearData()
  if type(self.SuitDic) == "table" then
    for k, v in pairs(self.SuitDic) do
      v:ClearData()
    end
  end
end

function SuitManager:RefreshSingleData(data)
  if data == nil then
    return
  end
  if data.items ~= nil then
    self:RefreshSingleSuitItem(data.items, EquipOperationType.PUT_ON)
    self:CalculateIntensifySuitRecommendEquip(data.items)
    EventManager.Dispatch(Event.PutOnSuit, data)
  end
  if data.remove ~= nil then
    self:RefreshSingleSuitItem(data.remove, EquipOperationType.TAKE_OFF)
    self:CalculateIntensifySuitRecommendEquip(data.remove)
    EventManager.Dispatch(Event.TakeOffSuit, data)
  end
  self:ReCalculateEquipSpecialEffectDes()
end

function SuitManager:RefreshSingleSuitItem(data, equipOperationType)
  if data == nil or equipOperationType == nil then
    return
  end
  if equipOperationType == EquipOperationType.PUT_ON then
    self:AddEquip(data)
  elseif equipOperationType == EquipOperationType.TAKE_OFF then
    self:RemoveEquip(data)
  end
end

function SuitManager:AddEquip(data)
  if data == nil then
    return
  end
  for k, v in pairs(self.SuitDic) do
    local suitEquipList = v
    suitEquipList:TryAddItem(data)
  end
end

function SuitManager:RemoveEquip(data)
  if data == nil then
    return
  end
  for k, v in pairs(self.SuitDic) do
    local suitEquipList = v
    suitEquipList:TryRemoveItem(data)
  end
end

function SuitManager:BagItemChange()
  for k, v in pairs(self.SuitDic) do
    v:ReCalculateRecommendData()
  end
end

function SuitManager:CalculateIntensifySuitRecommendEquip(serverItemData)
  local cellTbl = ClientTable.cfg_EquipCell_cellManager:GetCellTblByServerItemData(serverItemData)
  if cellTbl == nil then
    return
  end
  local suitEquipList = self:GetSingleSuit(cellTbl.cellType)
  if suitEquipList == nil then
    return
  end
  suitEquipList:ReCalculateRecommendData()
end

function SuitManager:RefreshSuitTypeState()
  self:GetBingJianDataMgr():RefreshSuitTypeState()
end

function SuitManager:GetSingleSuit(equipSuitType)
  if equipSuitType == nil then
    return
  end
  return self.SuitDic[equipSuitType]
end

function SuitManager:GetSingleEquip(equipSuitType, equipIndex)
  local suitEquipList = self:GetSingleSuit(equipSuitType)
  if suitEquipList == nil then
    return
  end
  return suitEquipList:GetEquipDataByGridIndex(equipIndex)
end

function SuitManager:GetSingleEquipByEquipIndex(equipIndex)
  local equipCellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(equipIndex)
  if equipCellTbl == nil or equipCellTbl.cellType <= 0 then
    return
  end
  return self:GetSingleEquip(equipCellTbl.cellType, equipIndex)
end

function SuitManager:GetSuitList()
  local suitList = {}
  for k, v in pairs(EquipCellType) do
    local suit = self:GetSingleSuit(v)
    if suit ~= nil and suit:HaveEquip() then
      suitList[v] = suit
    end
  end
  return suitList
end

function SuitManager:GetFirstSuit(shieldSuitType)
  for k, v in pairs(self.TraversalSequenceTbl) do
    local suit = self:GetSingleSuit(v)
    if suit ~= nil and suit:HaveEquip() and table.contains(shieldSuitType, v) == false then
      return suit
    end
  end
end

function SuitManager:GetSuitTypeByItemId(id)
  if type(id) ~= "number" then
    return
  end
  local equipCellTbl = ClientTable.cfg_Item_equipManager:GetItemEquipCellTbl(id)
  if equipCellTbl == nil then
    return
  end
  return equipCellTbl.cellType
end

function SuitManager:GetSuitTypeByEquipCellId(id)
  if type(id) ~= "number" then
    return
  end
  local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(id)
  if cellTbl == nil then
    return
  end
  return cellTbl.cellType
end

function SuitManager:GetEquipDataListByItemId(id)
  if type(id) ~= "number" then
    return
  end
  local equipTbl = ClientTable.cfg_Item_equipManager:TryGetValue(id)
  if equipTbl == nil or string.isNullOrEmpty(equipTbl.equipPosition) then
    return
  end
  local replacePosition = ClientTable.cfg_Global_globalManager:GetConfigReplacePosition(equipTbl.equipPosition)
  replacePosition = replacePosition == nil and equipTbl.equipPosition or replacePosition.replacePosition
  local equipPositionList = string.split(replacePosition, "#")
  if #equipPositionList <= 0 then
    return
  end
  for i = 1, #equipPositionList do
    equipPositionList[i] = tonumber(equipPositionList[i])
  end
  return self:GetEquipDataListByEquipIndexList(equipPositionList)
end

function SuitManager:GetEquipDataListByEquipIndexList(equipIndexList)
  if type(equipIndexList) ~= "table" or type(self.SuitDic) ~= "table" then
    return
  end
  local equipList = {}
  local suitEquipList = {}
  for k, v in pairs(self.SuitDic) do
    suitEquipList = v:GetEquipDataByGridIndexList(equipIndexList)
    if suitEquipList ~= nil and next(suitEquipList) ~= nil then
      table.combine(equipList, suitEquipList)
    end
  end
  return equipList
end

function SuitManager:GetBingJianDataMgr()
  if self.mBingJianDataMgr == nil then
    self.mBingJianDataMgr = LuaClass.BingJianData:New(self)
  end
  return self.mBingJianDataMgr
end

function SuitManager:CheckHaveSuit()
  for k, v in pairs(EquipCellType) do
    local suit = self:GetSingleSuit(v)
    if v ~= EquipCellType.NORMAL and suit ~= nil and suit:HaveEquip() then
      return true
    end
  end
  return false
end

function SuitManager:CheckHaveSuitByType(suitType)
  if suitType == nil then
    return false
  end
  local suitList = self:GetSingleSuit(suitType)
  return suitList ~= nil and suitList:HaveEquip()
end

function SuitManager:CheckIsHongZhuang(_position)
  local cfg_EquipCell = ClientTable.cfg_EquipCell_cellManager:TryGetValue(_position)
  if cfg_EquipCell and cfg_EquipCell.cellType == EquipCellType.HONGZHUANG then
    return true
  end
  return false
end

function SuitManager:CheckIsBingjian(_position)
  local cfg_EquipCell = ClientTable.cfg_EquipCell_cellManager:TryGetValue(_position)
  if cfg_EquipCell then
    local bingJianTypeList = ClientTable.cfg_Item_equip_bingjianManager:GetAllCellTypeList()
    if table.contains(bingJianTypeList, cfg_EquipCell.cellType) then
      return true
    end
  end
  return false
end

SuitManager.EquipSpecialEffectDic = nil
SuitManager.EquipSpecialEffectDicIsDirty = true

function SuitManager:InitEquipSpecialEffectDes()
  if self.EquipSpecialEffectDicIsDirty == false then
    return
  end
  self.EquipSpecialEffectDicIsDirty = false
  self.EquipSpecialEffectDic = {}
  for k, v in pairs(self.SuitDic) do
    if type(v.EquipList) == "table" then
      for equipIndex, equipData in pairs(v.EquipList) do
        self:AddEquipSpecialEffectDesBySuitEquipData(equipData)
      end
    end
  end
end

function SuitManager:AddEquipSpecialEffectDesBySuitEquipData(suitEquipData)
  if type(suitEquipData:GetEquipSpecialTblList()) == "table" then
    for k1, specialEffectTbl in pairs(suitEquipData:GetEquipSpecialTblList()) do
      if string.isNullOrEmpty(specialEffectTbl.display) == false then
        local skillDes = self.EquipSpecialEffectDic[specialEffectTbl.displayskill]
        if string.isNullOrEmpty(skillDes) == false then
          skillDes = skillDes .. "\n"
        else
          skillDes = ""
        end
        if type(specialEffectTbl.displayskill) == "table" and table.count(specialEffectTbl.displayskill) > 1 then
          for i, v in pairs(specialEffectTbl.displayskill) do
            self.EquipSpecialEffectDic[v] = skillDes .. specialEffectTbl.display
          end
        else
          self.EquipSpecialEffectDic[specialEffectTbl.displayskill] = skillDes .. specialEffectTbl.display
        end
      end
    end
  end
end

function SuitManager:ReCalculateEquipSpecialEffectDes()
  self.EquipSpecialEffectDicIsDirty = true
end

function SuitManager:GetSkillSpecialEffectDes(skillId)
  self:InitEquipSpecialEffectDes()
  return self.EquipSpecialEffectDic[skillId]
end

return SuitManager
