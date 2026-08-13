local Appear_CoutureData = {}

function Appear_CoutureData:Init()
  self:TextData()
end

function Appear_CoutureData:TextData()
end

function Appear_CoutureData:GetFashionInfo(type)
  if self.ShowFashionInfo == nil then
    return {}
  end
  return self.ShowFashionInfo[type]
end

function Appear_CoutureData:IsHaveFashionInfo()
  if self.ShowFashionInfo == nil then
    return false
  end
  for i, v in pairs(self.ShowFashionInfo) do
    if v ~= nil and 1 <= #v then
      return true
    end
  end
end

function Appear_CoutureData:RefreshData_ServerInfo(data)
  self.FashionInfoDic = {}
  if data == nil or data.info == nil then
    return
  end
  for i, v in pairs(data.info) do
    local FashionInfo = self:CreatFashionInfo(v)
    self.FashionInfoDic[v.position] = FashionInfo
  end
  self:RefreshShowFashionInfo()
  self:RefreshOperationFashion()
  EventManager.Dispatch(Event.Appear_CouturDataChange)
end

function Appear_CoutureData:RefreshOperationFashion()
  if self.FashionInfoDic == nil then
    return
  end
  for i, v in pairs(self.FashionInfoDic) do
    if v ~= nil and v.firstActive == true then
      EventManager.Dispatch(Event.Appear_OperationFashion, v, false)
    end
  end
end

function Appear_CoutureData:RefreshData_NeedActiveInfo(items, removeItem, isRefreshAll)
  if self.NeedActiveFashionInfoDic == nil then
    self.NeedActiveFashionInfoDic = {}
    self.ItemLidInfoDic = {}
  end
  if isRefreshAll then
    self.NeedActiveFashionInfoDic = {}
  end
  local ischange = false
  for i, v in pairs(items) do
    local ItemTable = ClientTable.cfg_Item_itemManager:TryGetValue(v.itemId)
    if ItemTable ~= nil and ItemTable.subType == 3100 then
      local tab = string.split(ItemTable.useParam, "#")
      if tab ~= nil and 2 <= #tab then
        local fashionId = tonumber(tab[2])
        self.NeedActiveFashionInfoDic[fashionId] = self:GetNeedActiveFashionInfo(fashionId)
        self.ItemLidInfoDic[v.id] = fashionId
        ischange = true
      end
    end
  end
  if removeItem ~= nil then
    for i, v in pairs(removeItem) do
      if self.ItemLidInfoDic[v] ~= nil then
        self.NeedActiveFashionInfoDic[self.ItemLidInfoDic[v]] = nil
        ischange = true
      end
    end
  end
  if ischange then
    self:RefreshShowFashionInfo()
  end
end

function Appear_CoutureData:RefreshShowFashionInfo()
  self.ShowFashionInfo = {}
  self.infoDic = {}
  if self.FashionInfoDic ~= nil then
    for i, v in pairs(self.FashionInfoDic) do
      if self.ShowFashionInfo[v.showType] == nil then
        self.ShowFashionInfo[v.showType] = {}
      end
      if self.infoDic[v.fashionId] == nil then
        self.infoDic[v.fashionId] = true
        table.insert(self.ShowFashionInfo[v.showType], v)
      end
    end
  end
  if self.NeedActiveFashionInfoDic ~= nil then
    for i, v in pairs(self.NeedActiveFashionInfoDic) do
      if self.ShowFashionInfo[v.showType] == nil then
        self.ShowFashionInfo[v.showType] = {}
      end
      if self.infoDic[v.fashionId] == nil then
        self.infoDic[v.fashionId] = true
        table.insert(self.ShowFashionInfo[v.showType], v)
      end
    end
  end
end

function Appear_CoutureData:GetNeedActiveFashionInfo(fashionID)
  local dataInfo = {
    position = fashionID,
    level = 0,
    isNeedActive = true
  }
  return self:CreatFashionInfo(dataInfo)
end

function Appear_CoutureData:CreatFashionInfo(data)
  local FashionInfo = {}
  FashionInfo.serverData = data
  FashionInfo.fashionId = data.position
  FashionInfo.fashionType = data.fashionType
  FashionInfo.overtime = data.overtime
  FashionInfo.crulUse = data.crulUse
  FashionInfo.isNeedActive = data.isNeedActive
  FashionInfo.firstActive = data.firstActive
  FashionInfo.nowTable = ClientTable.cfg_Item_fashionLevelManager:GetTable_fashionId_Level(data.position, data.level)
  FashionInfo.showType = FashionInfo.nowTable ~= nil and FashionInfo.nowTable.fashionType or -1
  FashionInfo.nextTable = ClientTable.cfg_Item_fashionLevelManager:GetTable_fashionId_Level(data.position, data.level + 1)
  FashionInfo.itemId = FashionInfo.nowTable ~= nil and FashionInfo.nowTable.itemId or 0
  FashionInfo.ItemTable = ClientTable.cfg_Item_itemManager:TryGetValue(FashionInfo.itemId)
  FashionInfo.ItemName = FashionInfo.ItemTable == nil and "" or FashionInfo.ItemTable.name
  FashionInfo.AttributeInfoList = self:GetAttribute(FashionInfo.nowTable, FashionInfo.nextTable)
  return FashionInfo
end

function Appear_CoutureData:GetAttribute(nowData, nextData)
  if nowData == nil then
    return
  end
  local career = RoleUtility.GetBasicCareer(RoleManager.me.career)
  local nowTableList = {}
  local attributeInfo = self:GetAttributeInfo()
  for i, v in pairs(attributeInfo) do
    local _name = v.name
    local _nowDes = ""
    local _nextDex = ""
    local nowMinValue = nowData[v.miniAtt] ~= nil and AttributeUtility.GetAttributeValue(nowData[v.miniAtt], career) or 0
    local nowMaxValue = nowData[v.maxiAtt] ~= nil and AttributeUtility.GetAttributeValue(nowData[v.maxiAtt], career) or 0
    local nextMinValue = nextData ~= nil and nextData[v.miniAtt] ~= nil and AttributeUtility.GetAttributeValue(nextData[v.miniAtt], career) or 0
    local nextMaxValue = nextData ~= nil and nextData[v.maxiAtt] ~= nil and AttributeUtility.GetAttributeValue(nextData[v.maxiAtt], career) or 0
    nowMinValue = self:GetAttributeEquipConstant(v.equipConstant, nowMinValue)
    nowMaxValue = self:GetAttributeEquipConstant(v.equipConstant, nowMaxValue)
    nextMinValue = self:GetAttributeEquipConstant(v.equipConstant, nextMinValue)
    nextMaxValue = self:GetAttributeEquipConstant(v.equipConstant, nextMaxValue)
    if nowMaxValue ~= 0 then
      _nowDes = nowMinValue .. " ~ " .. nowMaxValue
    else
      _nowDes = nowMinValue
    end
    if nextMaxValue ~= 0 then
      _nextDex = nextMinValue .. " ~ " .. nextMaxValue
    else
      _nextDex = nextMinValue
    end
    local attrInfo = {
      name = _name,
      nowDes = _nowDes,
      nextDex = _nextDex,
      nowMinValue = nowMinValue,
      nowMaxValue = nowMaxValue
    }
    if nowMinValue ~= 0 or nextMinValue ~= 0 or nowMaxValue ~= 0 or nextMaxValue ~= 0 then
      table.insert(nowTableList, attrInfo)
    end
  end
  return nowTableList
end

function Appear_CoutureData:GetAttributeEquipConstant(EquipConstant, nowNumber)
  if nowNumber == 0 then
    return nowNumber
  end
  local _EquipConstant = tonumber(EquipConstant)
  local _nowNumber = tonumber(nowNumber)
  if _EquipConstant == nil or _nowNumber == nil then
    return
  end
  if _EquipConstant == 1 then
    return nowNumber
  end
  local temp = math.floor(_nowNumber / _EquipConstant)
  return temp .. "%"
end

function Appear_CoutureData:GetAttributeInfo()
  if self.AttributeInfo == nil then
    self.AttributeInfo = {}
    local temp = ClientTable.cfg_Global_globalManager:TryGetValue(23)
    if temp ~= nil and temp.effect ~= nil then
      local strS = string.split(temp.effect, "&")
      for i, v in pairs(strS) do
        local nowStrS = string.split(v, "#")
        local InfoItem = {
          equipConstant = tonumber(nowStrS[1]),
          name = nowStrS[2],
          miniAtt = nowStrS[3],
          maxiAtt = nowStrS[4]
        }
        table.insert(self.AttributeInfo, InfoItem)
      end
    end
  end
  return self.AttributeInfo
end

function Appear_CoutureData:GetShowCouturJson(type, isUninstall)
  local couturInfo = Appear_CoutureData:GetCouturJsonGloble(type)
  if couturInfo == nil then
    return
  end
  local temp = json.decode(ForgeData.appearData[RoleManager.me.id])
  for i, v in pairs(couturInfo) do
    temp[i] = v
  end
  local appear = json.encode(temp)
  return appear
end

function Appear_CoutureData:GetCouturJsonGloble(type)
  if self.CouturJsonGloble == nil then
    self.CouturJsonGloble = {}
    self.CouturJsonGloble[Appear_CoutureFashionTypeEnum.Armor] = ClientTable.cfg_Global_globalManager:GetCouturJsonGloble(24)
    self.CouturJsonGloble[Appear_CoutureFashionTypeEnum.WeaponR] = ClientTable.cfg_Global_globalManager:GetCouturJsonGloble(25)
    self.CouturJsonGloble[Appear_CoutureFashionTypeEnum.WeaponL] = ClientTable.cfg_Global_globalManager:GetCouturJsonGloble(26)
  end
  return self.CouturJsonGloble[type]
end

function Appear_CoutureData:GetAllAttributeInfo()
  if self.FashionInfoDic == nil then
    return {}
  end
  local AllAttributeInfoDic = {}
  local AllAttributeInfoList = {}
  for i, v in pairs(self.FashionInfoDic) do
    if v.AttributeInfoList ~= nil then
      for i_Att, v_Att in pairs(v.AttributeInfoList) do
        if AllAttributeInfoDic[v_Att.name] == nil then
          local data = {
            name = v_Att.name,
            min = v_Att.nowMinValue,
            max = v_Att.nowMaxValue
          }
          AllAttributeInfoDic[v_Att.name] = data
        else
          AllAttributeInfoDic[v_Att.name].min = AllAttributeInfoDic[v_Att.name].min + v_Att.nowMinValue
          AllAttributeInfoDic[v_Att.name].max = AllAttributeInfoDic[v_Att.name].max + v_Att.nowMaxValue
        end
      end
    end
  end
  for i, v in pairs(AllAttributeInfoDic) do
    table.insert(AllAttributeInfoList, v)
  end
  return AllAttributeInfoList
end

function Appear_CoutureData:IsCanChangeAppearance()
  if self.FashionInfoDic == nil then
    return true
  end
  for i, v in pairs(self.FashionInfoDic) do
    if v.crulUse == true then
      return false
    end
  end
  return true
end

function Appear_CoutureData:SetRoleEquipNormalPos(data)
  if data == nil or data.equipnormal == nil then
    return
  end
  self.RoleEquipNormalPos = json.decode(data.equipnormal)
  self.RoleEquipNormalPosDic = {}
  if self.RoleEquipNormalPos ~= nil then
    for i, v in pairs(self.RoleEquipNormalPos) do
      self.RoleEquipNormalPosDic[v] = true
    end
  end
end

function Appear_CoutureData:IsWearFshionType(fshionType)
  if fshionType == nil then
    return false
  end
  local fashionInfo = self:GetFashionInfo(fshionType)
  if fashionInfo == nil then
    return false
  end
  for i, v in pairs(fashionInfo) do
    if v.crulUse then
      return true
    end
  end
  return false
end

function Appear_CoutureData:IsConfineChangeAppearEquipCell(equipCell)
  local EquipCellTable = ClientTable.cfg_EquipCell_cellManager:TryGetValue(equipCell)
  if EquipCellTable == nil then
    return false
  end
  local fashionType = ClientTable.cfg_Item_fashionTypeManager:GetEquipCellByFashionType(equipCell)
  if fashionType == nil then
    fashionType = ClientTable.cfg_Item_fashionTypeManager:GetEquipCellByFashionType(EquipCellTable.basicPositionSetting)
  end
  return self:IsWearFshionType(fashionType)
end

function Appear_CoutureData:RefreshTimeLoop()
  if self.frequencyTime == nil then
    self.frequencyTime = 0
  end
  self.frequencyTime = self.frequencyTime - 0.1
end

return Appear_CoutureData
