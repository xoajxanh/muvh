ItemConditon = class(ConditionBase)
setgetters(ItemConditon, {})
ItemConditon.comparatorMap = {
  [1] = function(self)
    local id = tonumber(self.param)
    return true
  end,
  [2] = function(self, equipeData)
    local intensify = tonumber(self.param)
    if equipeData == nil then
      return true
    else
      return equipeData.tblItem.type == EItemType.Equipe and intensify <= equipeData.intensify
    end
  end,
  [3] = function(self, equipeData)
    local additonal = tonumber(self.param)
    if equipeData == nil then
      return true
    else
      return equipeData.tblItem.type == EItemType.Equipe and additonal <= equipeData.additional
    end
  end,
  [4] = function(self, arg)
    if tonumber(self.param) then
      if BagInfoData:GetItemTotalCountByItemIdFromIndexDic(tonumber(self.param)) > 0 then
        return true
      end
      if ViewData.meData then
        for i, v in pairs(ViewData.meData.equipsData.Data) do
          if v.itemId == tonumber(self.param) then
            return true
          end
        end
        for i, v in pairs(ViewData.meData.equipsData.StoneData) do
          if v.itemId == tonumber(self.param) then
            return true
          end
        end
        for i, v in pairs(ViewData.meData.mountData.Mounts) do
          if v.itemId == tonumber(self.param) then
            return true
          end
        end
      end
      return false
    else
      local ids = self.param
      local id
      if arg == nil then
        for i = 1, #ids do
          if BagInfoData:GetItemTotalCountByItemIdFromIndexDic(tonumber(ids[i])) > 0 then
            return true
          end
        end
        return false
      elseif type(arg) == "number" then
        id = arg
      elseif type(arg) == "table" then
        id = arg.itemId
      end
      for i = 1, #ids do
        if ids[i] == id then
          return true
        end
      end
    end
  end,
  [5] = function(self, arg)
    local types
    if type(param) == "table" then
      types = self.param
    else
      types = string.stringToNumberArray(self.param, "$")
    end
    local targetType
    if arg == nil then
      return true
    elseif type(arg) == "number" then
      targetType = arg
    elseif type(arg) == "table" then
      targetType = arg.tblItem.subType
    end
    for i = 1, #types do
      if types[i] == targetType then
        return true
      end
    end
  end,
  [6] = function(self, arg)
    if arg == nil then
      return true
    else
      local excellenceAttrCnt = tonumber(self.param)
      return arg.excellence and excellenceAttrCnt <= table.count(arg.excellence)
    end
  end,
  [7] = function(self, arg)
    if arg == nil then
      return true
    else
      return arg.isSuit
    end
  end,
  [8] = function(self, arg)
    if ViewData.meData then
      for i, v in pairs(ViewData.meData.equipsData.Data) do
        if v.itemId == tonumber(self.param) then
          return true
        end
      end
      for i, v in pairs(ViewData.meData.equipsData.StoneData) do
        if v.itemId == tonumber(self.param) then
          return true
        end
      end
    end
    return false
  end,
  [9] = function(self, equipIndex)
    if type(equipIndex) ~= "number" then
      return false
    end
    local equipIndexData = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():GetEquipIndexData(equipIndex)
    local equipData = equipIndexData:GetEquipItemData()
    if equipData ~= nil and equipData:GetEquipTbl() ~= nil then
      return equipData:GetEquipTbl().equipClass >= tonumber(self.param)
    end
    return false
  end,
  [10] = function(self, equipTbl)
    if equipTbl == nil or type(equipTbl.equipClass) ~= "number" then
      return false
    end
    return equipTbl.equipClass > tonumber(self.param)
  end,
  [11] = function(self, equipTbl)
    if equipTbl == nil or type(equipTbl.equipClass) ~= "number" then
      return false
    end
    return equipTbl.equipClass >= tonumber(self.param)
  end,
  [12] = function(self, equipTbl)
    if equipTbl == nil or type(equipTbl.equipClass) ~= "number" then
      return false
    end
    return equipTbl.equipClass == tonumber(self.param)
  end,
  [13] = function(self, equipTbl)
    if equipTbl == nil or type(equipTbl.equipClass) ~= "number" then
      return false
    end
    return equipTbl.equipClass <= tonumber(self.param)
  end,
  [14] = function(self, equipTbl)
    if equipTbl == nil or type(equipTbl.equipClass) ~= "number" then
      return false
    end
    return equipTbl.equipClass < tonumber(self.param)
  end,
  [15] = function(self, equipTbl)
    if equipTbl == nil or type(equipTbl.equipClass) ~= "number" then
      return false
    end
    return equipTbl.equipClass ~= tonumber(self.param)
  end,
  [24] = function(self, arg)
    if tonumber(self.param) then
      if ViewData.meData then
        for i, v in pairs(ViewData.meData.equipsData.Data) do
          if v.itemId == tonumber(self.param) then
            return false
          end
        end
        for i, v in pairs(ViewData.meData.equipsData.StoneData) do
          if v.itemId == tonumber(self.param) then
            return false
          end
        end
        for i, v in pairs(ViewData.meData.mountData.Mounts) do
          if v.itemId == tonumber(self.param) then
            return false
          end
        end
      end
      local count = BagInfoData.GetItemTotalCountByItemId(tonumber(self.param))
      if 0 < count then
        return false
      end
      return true
    else
      local ids = self.param
      local id
      if arg == nil then
        return true
      elseif type(arg) == "number" then
        id = arg
      elseif type(arg) == "table" then
        id = arg.itemId
      end
      for i = 1, #ids do
        if ids[i] == id then
          return false
        end
      end
    end
  end,
  [30] = function(self)
    local equipData = RoleEquipUtility.GetConditionEquipData(RoleManager.me.data.equipsData.Data, ERoleEquipCondition.Normal)
    local wingInfo = equipData[3]
    if not equipData or not wingInfo then
      return false
    end
    return wingInfo.tblItem.quality > tonumber(self.param)
  end,
  [31] = function(self)
    local equipData = RoleEquipUtility.GetConditionEquipData(RoleManager.me.data.equipsData.Data, ERoleEquipCondition.Normal)
    local wingInfo = equipData[3]
    if not equipData or not wingInfo then
      return false
    end
    return wingInfo.tblItem.quality >= tonumber(self.param)
  end,
  [32] = function(self)
    local equipData = RoleEquipUtility.GetConditionEquipData(RoleManager.me.data.equipsData.Data, ERoleEquipCondition.Normal)
    local wingInfo = equipData[3]
    if not equipData or not wingInfo then
      return false
    end
    return wingInfo.tblItem.quality == tonumber(self.param)
  end,
  [33] = function(self)
    local equipData = RoleEquipUtility.GetConditionEquipData(RoleManager.me.data.equipsData.Data, ERoleEquipCondition.Normal)
    local wingInfo = equipData[3]
    if not equipData or not wingInfo then
      return false
    end
    return wingInfo.tblItem.quality < tonumber(self.param)
  end,
  [34] = function(self)
    local equipData = RoleEquipUtility.GetConditionEquipData(RoleManager.me.data.equipsData.Data, ERoleEquipCondition.Normal)
    local wingInfo = equipData[3]
    if not equipData or not wingInfo then
      return false
    end
    return wingInfo.tblItem.quality <= tonumber(self.param)
  end
}

function ItemConditon:Check(targetArg)
  return self:comparator(targetArg)
end
