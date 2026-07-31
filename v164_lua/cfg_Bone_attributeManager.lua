local cfg_Bone_attributeManager = {}

function cfg_Bone_attributeManager:GetName()
  return "cfg_Bone_attributeManager"
end

function cfg_Bone_attributeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Bone_attribute")
  end
  return self.dic
end

setmetatable(cfg_Bone_attributeManager, TableManagerBase)

function cfg_Bone_attributeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Bone_attributeManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Bone_attributeManager:GetAttrDesByServerData(data)
  if data == nil then
    return
  end
  local desTab
  local tblEquip = ClientTable.cfg_Item_equipManager:TryGetValue(data.itemId)
  if tblEquip == nil then
    return ""
  end
  if tblEquip.subType == EItemSubtype.SpecialSacredBone or tblEquip.subType == EItemSubtype.GeneralSacredBone then
    local attr = self:TryGetValue(tostring(data.itemId), "relationItem")
    if attr then
      local des = attr.valueOne ~= 0 and attr.valueOne or attr.valueTwo / 100
      desTab = string.format(attr.tipsShow, des)
    end
  else
    local group = {}
    for i, v in ipairs(data.boneSoulInfo) do
      local cfg = self:TryGetValue(v.configId)
      if cfg and not table.contains(group, cfg.attributeGroup) then
        table.insert(group, cfg.attributeGroup)
        local des = cfg.valueOne ~= 0 and v.attributeValue or v.attributeValue / 100
        desTab = string.format(cfg.tipsShow, des)
      end
    end
  end
  return desTab
end

function cfg_Bone_attributeManager:GetAttrDesBySacredBoneInfoData(data)
  if data == nil then
    return
  end
  local desTab
  local tblEquip = ClientTable.cfg_Item_equipManager:TryGetValue(data.itemInfo.itemId)
  if tblEquip.subType == EItemSubtype.SpecialSacredBone or tblEquip.subType == EItemSubtype.GeneralSacredBone then
    local attr = self:TryGetValue(tostring(data.itemInfo.itemId), "relationItem")
    if attr then
      local des = attr.valueOne ~= 0 and attr.valueOne or attr.valueTwo / 100
      desTab = string.format(attr.tipsShow, des)
    end
  else
    local group = {}
    for i, v in ipairs(data.itemInfo.boneSoulInfo) do
      local cfg = self:TryGetValue(v.configId)
      if cfg and not table.contains(group, cfg.attributeGroup) then
        table.insert(group, cfg.attributeGroup)
        if cfg.valueOne ~= 0 then
          local num = v.attributeValue
          desTab = string.format(cfg.tipsShow, num)
          if data.addition ~= 0 then
            desTab = desTab .. " \239\188\136+" .. num * data.addition / 10000 .. "\239\188\137"
          end
        else
          local num = v.attributeValue / 100
          desTab = string.format(cfg.tipsShow, num)
          if data.addition ~= 0 then
            desTab = desTab .. " \239\188\136+" .. num * data.addition / 10000 .. "%\239\188\137"
          end
        end
      end
    end
  end
  return desTab
end

function cfg_Bone_attributeManager:GetDesTabByServerData(itemInfo)
  local boneSoulInfo
  local desTab = {}
  local group = {}
  local tblEquip = ClientTable.cfg_Item_equipManager:TryGetValue(itemInfo.tblItem.id)
  if tblEquip.subType == EItemSubtype.SpecialSacredBone or tblEquip.subType == EItemSubtype.GeneralSacredBone then
    local attr = self:TryGetValue(tostring(itemInfo.tblItem.id), "relationItem")
    if attr then
      local des = attr.valueOne ~= 0 and attr.valueOne or attr.valueTwo / 100
      des = string.format(attr.tipsShow, des)
      table.insert(desTab, des)
    end
  elseif itemInfo.tblItem.serverInfo then
    boneSoulInfo = itemInfo.tblItem.serverInfo.boneSoulInfo
    for i, v in ipairs(boneSoulInfo) do
      local cfg = self:TryGetValue(v.configId)
      if cfg and not table.contains(group, cfg.attributeGroup) then
        table.insert(group, cfg.attributeGroup)
        local des = cfg.valueOne ~= 0 and v.attributeValue or v.attributeValue / 100
        des = string.format(cfg.tipsShow, des)
        table.insert(desTab, des)
      end
    end
  elseif itemInfo.serverInfo then
    boneSoulInfo = itemInfo.serverInfo.boneSoulInfo
    for i, v in ipairs(boneSoulInfo) do
      local cfg = self:TryGetValue(v.configId)
      if cfg and not table.contains(group, cfg.attributeGroup) then
        table.insert(group, cfg.attributeGroup)
        local des = cfg.valueOne ~= 0 and v.attributeValue or v.attributeValue / 100
        des = string.format(cfg.tipsShow, des)
        table.insert(desTab, des)
      end
    end
  else
    local attributeCfgList = self:GetTabListByType(itemInfo.tblItem.quality, "grade")
    for i, v in ipairs(attributeCfgList) do
      if not table.contains(group, v.attributeGroup) then
        table.insert(group, v.attributeGroup)
        local des
        if v.valueOne ~= 0 then
          des = v.valueOne
        elseif v.valueTwo > 100000 then
          des = (100000000 - v.valueTwo) / 10000 / 100
        else
          des = v.valueTwo / 100
        end
        des = string.format(v.tipsShow, des)
        table.insert(desTab, des)
      end
    end
  end
  return desTab
end

return cfg_Bone_attributeManager
