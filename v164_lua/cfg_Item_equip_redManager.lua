local cfg_Item_equip_redManager = {}

function cfg_Item_equip_redManager:GetName()
  return "cfg_Item_equip_redManager"
end

function cfg_Item_equip_redManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_red")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_redManager, TableManagerBase)

function cfg_Item_equip_redManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_equip_redManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

cfg_Item_equip_redManager.EquipOverlapBaseAttributeList = nil
cfg_Item_equip_redManager.BaseAttributeNameList = {
  [1] = "minimumPhysBaseDmg",
  [2] = "maximumPhysBaseDmg",
  [3] = "minimumWizBaseDmg",
  [4] = "maximumWizBaseDmg",
  [5] = "minimumCurseBaseDmg",
  [6] = "maximumCurseBaseDmg",
  [7] = "defenseBase",
  [8] = "maximumHealth",
  [9] = "career_maximumHealth"
}

function cfg_Item_equip_redManager:GetEquipOverlapBaseAttribute(equipData)
  if equipData == nil then
    return
  end
  local equipOverlapBaseAttributeInfoList = self:GetBaseAttribute(equipData)
  if type(equipOverlapBaseAttributeInfoList) ~= "table" or next(equipOverlapBaseAttributeInfoList) == nil then
    return
  end
  return equipOverlapBaseAttributeInfoList[1]
end

function cfg_Item_equip_redManager:GetAttributeViewInfoList(equipData)
  if equipData == nil then
    return
  end
  local equipOverlapBaseAttributeInfoList = self:GetBaseAttribute(equipData)
  if type(equipOverlapBaseAttributeInfoList) ~= "table" or next(equipOverlapBaseAttributeInfoList) == nil then
    return
  end
  local nowAttributeList = equipOverlapBaseAttributeInfoList[1].attributeViewInfoList
  local nextAttributeList = equipOverlapBaseAttributeInfoList[2] ~= nil and equipOverlapBaseAttributeInfoList[2].attributeViewInfoList
  local attributeViewInfoList, attributeName = {}
  if type(nextAttributeList) == "table" then
    for k, v in pairs(nextAttributeList) do
      local attributeViewInfo = table.clone(v)
      attributeViewInfo.nextValue = attributeViewInfo.curValue
      if type(nowAttributeList) == "table" and nowAttributeList[k] ~= nil then
        attributeViewInfo.curValue = nowAttributeList[k].curValue
      else
        attributeName, attributeViewInfo.curValue = self:GetDefaultAttribute(k)
      end
      attributeViewInfo.isUp = true
      table.insert(attributeViewInfoList, attributeViewInfo)
    end
  else
    for k, v in pairs(nowAttributeList) do
      local attributeViewInfo = table.clone(v)
      attributeViewInfo.nextValue = "\196\144\195\163 \196\145\225\186\167y c\225\186\165p"
      table.insert(attributeViewInfoList, attributeViewInfo)
    end
  end
  return attributeViewInfoList
end

function cfg_Item_equip_redManager:GetBaseAttribute(equipData)
  if equipData == nil or equipData.tblEquip == nil then
    return
  end
  local overlapBaseAttributeList = {}
  local itemId = equipData.tblEquip.id
  local excellence = equipData:GetExcellenceCount()
  local subType = equipData.tblEquip.subType
  local cellType = equipData.tblEquip.cellType
  local equipLevel = equipData.tblEquip.needLevel
  local equipOverlapBaseAttributeInfo = self:GetBaseAttributeByItemId(itemId, excellence, equipLevel)
  if equipOverlapBaseAttributeInfo ~= nil then
    table.insert(overlapBaseAttributeList, equipOverlapBaseAttributeInfo)
    local nextTbl = self:GetBaseAttributeByItemId(itemId, excellence + 1, equipLevel)
    if nextTbl ~= nil then
      table.insert(overlapBaseAttributeList, nextTbl)
    end
    return overlapBaseAttributeList
  end
  local equipOverlapBaseAttributeInfo = self:GetBaseAttributeByEquipType(subType, cellType, excellence, equipLevel)
  if equipOverlapBaseAttributeInfo ~= nil then
    table.insert(overlapBaseAttributeList, equipOverlapBaseAttributeInfo)
    local nextTbl = self:GetBaseAttributeByEquipType(subType, cellType, excellence + 1, equipLevel)
    if nextTbl ~= nil then
      table.insert(overlapBaseAttributeList, nextTbl)
    end
    return overlapBaseAttributeList
  end
end

function cfg_Item_equip_redManager:GetBaseAttributeByItemId(itemId, excellence, equipLevel)
  if type(itemId) ~= "number" or type(excellence) ~= "number" or type(equipLevel) ~= "number" then
    return
  end
  self:TryInitEquipOverlapBaseAttributeList()
  if self.EquipOverlapBaseAttributeList == nil or self.EquipOverlapBaseAttributeList[itemId] == nil or self.EquipOverlapBaseAttributeList[itemId][excellence] == nil then
    return
  end
  return self.EquipOverlapBaseAttributeList[itemId][excellence][equipLevel]
end

function cfg_Item_equip_redManager:GetBaseAttributeByEquipType(subType, cellType, excellence, equipLevel)
  if type(subType) ~= "number" or type(cellType) ~= "number" or type(excellence) ~= "number" or type(equipLevel) ~= "number" then
    return
  end
  self:TryInitEquipOverlapBaseAttributeList()
  local machFormat = tostring(subType) .. "#" .. tostring(cellType)
  if self.EquipOverlapBaseAttributeList == nil or self.EquipOverlapBaseAttributeList[machFormat] == nil or self.EquipOverlapBaseAttributeList[machFormat][excellence] == nil then
    return
  end
  return self.EquipOverlapBaseAttributeList[machFormat][excellence][equipLevel]
end

function cfg_Item_equip_redManager:TryInitEquipOverlapBaseAttributeList()
  if self.EquipOverlapBaseAttributeList == nil or RoleUtility.GetBasicCareer(RoleManager.me.career) ~= self.career then
    self.career = RoleUtility.GetBasicCareer(RoleManager.me.career)
    self.EquipOverlapBaseAttributeList = {}
    local tblList = self:GetDic()
    for k, v in pairs(tblList) do
      if v.itemId > 0 and self.EquipOverlapBaseAttributeList[v.itemId] == nil then
        self.EquipOverlapBaseAttributeList[v.itemId] = {}
      end
      if string.isNullOrEmpty(v.redEquipType) == false and self.EquipOverlapBaseAttributeList[v.redEquipType] == nil then
        self.EquipOverlapBaseAttributeList[v.redEquipType] = {}
      end
      local overlapAttributeInfo = {}
      overlapAttributeInfo.configTbl = v
      overlapAttributeInfo.attributeViewInfoList = self:GetAttributeViewInfo(v.id)
      if v.itemId > 0 then
        if self.EquipOverlapBaseAttributeList[v.itemId][v.numberEntry] == nil then
          self.EquipOverlapBaseAttributeList[v.itemId][v.numberEntry] = {}
        end
        self.EquipOverlapBaseAttributeList[v.itemId][v.numberEntry][v.equipLevel] = overlapAttributeInfo
      end
      if string.isNullOrEmpty(v.redEquipType) == false then
        if self.EquipOverlapBaseAttributeList[v.redEquipType][v.numberEntry] == nil then
          self.EquipOverlapBaseAttributeList[v.redEquipType][v.numberEntry] = {}
        end
        self.EquipOverlapBaseAttributeList[v.redEquipType][v.numberEntry][v.equipLevel] = overlapAttributeInfo
      end
    end
  end
end

function cfg_Item_equip_redManager:GetAttributeViewInfo(configId)
  local tbl = self:TryGetValue(configId)
  if tbl == nil then
    return
  end
  local attributeViewInfoList = {}
  local phyDmgAttribute = self:GetAttributeViewInfoByConfig({
    self.BaseAttributeNameList[1],
    self.BaseAttributeNameList[2]
  }, tbl)
  if phyDmgAttribute ~= nil then
    attributeViewInfoList[self.BaseAttributeNameList[1]] = phyDmgAttribute
  end
  local wizDmgAttribute = self:GetAttributeViewInfoByConfig({
    self.BaseAttributeNameList[3],
    self.BaseAttributeNameList[4]
  }, tbl)
  if wizDmgAttribute ~= nil then
    attributeViewInfoList[self.BaseAttributeNameList[3]] = wizDmgAttribute
  end
  local curseDmgAttribute = self:GetAttributeViewInfoByConfig({
    self.BaseAttributeNameList[5],
    self.BaseAttributeNameList[6]
  }, tbl)
  if curseDmgAttribute ~= nil then
    attributeViewInfoList[self.BaseAttributeNameList[5]] = curseDmgAttribute
  end
  local attributeViewInfo
  for k = 7, #self.BaseAttributeNameList do
    attributeViewInfo = self:GetAttributeViewInfoByConfig(self.BaseAttributeNameList[k], tbl)
    if attributeViewInfo ~= nil then
      attributeViewInfoList[self.BaseAttributeNameList[k]] = attributeViewInfo
    end
  end
  return attributeViewInfoList
end

function cfg_Item_equip_redManager:GetAttributeViewInfoByConfig(attributeName, configTbl)
  if type(configTbl) ~= "table" then
    return
  end
  local attributeNameFormat, attributeDes, attributeViewInfo, haveValue = nil, "", {}, false
  if type(attributeName) == "string" then
    attributeNameFormat = ClientTable.cfg_Ui_word_attributeManager:TryGetValue(attributeName)
    if type(configTbl[attributeName]) == "number" and 0 < configTbl[attributeName] then
      attributeDes = configTbl[attributeName]
    elseif type(configTbl[attributeName]) == "table" then
      for k, v in pairs(configTbl[attributeName]) do
        if type(v) == "table" and 2 <= #v and v[1] == RoleUtility.GetBasicCareer(RoleManager.me.career) then
          attributeDes = v[2]
        end
      end
    end
    if string.isNullOrEmpty(attributeDes) == false then
      haveValue = true
    end
  elseif type(attributeName) == "table" then
    for k, v in pairs(attributeName) do
      if attributeNameFormat == nil or string.isNullOrEmpty(attributeNameFormat.redEquipeTipsUI) then
        attributeNameFormat = ClientTable.cfg_Ui_word_attributeManager:TryGetValue(v)
      end
      if type(configTbl[v]) == "number" then
        if string.isNullOrEmpty(attributeDes) == false then
          attributeDes = attributeDes .. " ~ "
        end
        attributeDes = attributeDes .. tostring(configTbl[v])
      end
      if 0 < configTbl[v] then
        haveValue = true
      end
    end
  end
  if string.isNullOrEmpty(attributeNameFormat.redEquipeTipsUI) or string.isNullOrEmpty(attributeDes) or haveValue == false then
    return
  end
  attributeViewInfo.name = attributeNameFormat.redEquipeTipsUI
  attributeViewInfo.curValue = attributeDes
  return attributeViewInfo
end

function cfg_Item_equip_redManager:GetDefaultAttribute(attributeName)
  if type(attributeName) ~= "string" then
    return
  end
  local attributeNameFormat, attributeValueDes = ClientTable.cfg_Ui_word_attributeManager:TryGetValue(attributeName), "0"
  if attributeNameFormat == nil or string.isNullOrEmpty(attributeNameFormat.redEquipeTipsUI) then
    return
  end
  if attributeName == "minimumPhysBaseDmg" or attributeName == "minimumWizBaseDmg" or attributeName == "minimumCurseBaseDmg" then
    attributeValueDes = "0 ~ 0"
  end
  return attributeNameFormat.redEquipeTipsUI, attributeValueDes
end

function cfg_Item_equip_redManager:ResetEquipOverlapBaseAttributeList()
  self.EquipOverlapBaseAttributeList = nil
end

return cfg_Item_equip_redManager
