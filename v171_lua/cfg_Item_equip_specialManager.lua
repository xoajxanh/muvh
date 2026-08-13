local cfg_Item_equip_specialManager = {}

function cfg_Item_equip_specialManager:GetName()
  return "cfg_Item_equip_specialManager"
end

function cfg_Item_equip_specialManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_special")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_specialManager, TableManagerBase)

function cfg_Item_equip_specialManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_equip_specialManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Item_equip_specialManager:GetIdsAndsubtypeDic()
  if self.mIdsAndsubtypeDic == nil then
    self:InitializeTblInfo()
  end
  return self.mIdsAndsubtypeDic
end

function cfg_Item_equip_specialManager:InitializeTblInfo()
  self.mIdsAndsubtypeDic = {}
  for i, v in pairs(self:GetDic()) do
    if v then
      self:InitializeIdsInfo(v)
    end
  end
end

function cfg_Item_equip_specialManager:InitializeIdsInfo(info)
  if self.mIdsAndsubtypeDic[info.subType] == nil then
    self.mIdsAndsubtypeDic[info.subType] = {}
  end
  table.insert(self.mIdsAndsubtypeDic[info.subType], info.id)
end

function cfg_Item_equip_specialManager:GetIdsBySubtype(subType)
  if subType == nil then
    return nil
  end
  return self:GetIdsAndsubtypeDic()[subType]
end

function cfg_Item_equip_specialManager:GetMeetIdsBySubtype(subType, tblEquip)
  local ids = self:GetIdsBySubtype(subType)
  if ids == nil then
    return nil
  end
  local tbl
  local result = {}
  for i, v in pairs(ids) do
    tbl = self:TryGetValue(v)
    if tbl and (tbl.conditionShow == nil or tbl.conditionShow == "" or ConditionManager.Check4D(tbl.conditionShow, tblEquip)) then
      table.insert(result, tbl.id)
    end
  end
  return result
end

function cfg_Item_equip_specialManager:GetSpecialStrById(id)
  local tbl = self:TryGetValue(id)
  if tbl then
    return tbl.description
  end
  return nil
end

function cfg_Item_equip_specialManager:GetSpecialStrByIds(ids)
  if ids == nil or next(ids) == nil then
    return nil
  end
  local result, fix
  local staging = {}
  for i, v in pairs(ids) do
    fix = self:GetSpecialStrById(v)
    if fix ~= nil then
      for i, strItem in pairs(staging) do
        if strItem == fix then
          goto lbl_35
        end
      end
      table.insert(staging, fix)
    end
    ::lbl_35::
  end
  result = table.concat(staging, "\n")
  return result
end

function cfg_Item_equip_specialManager:GetSuffixById(id)
  local tbl = self:TryGetValue(id)
  if tbl then
    return tbl.skillName
  end
  return nil
end

function cfg_Item_equip_specialManager:GetSuffixStrByIds(ids)
  if ids == nil or next(ids) == nil then
    return ""
  end
  local result, fix
  for i, v in pairs(ids) do
    fix = self:GetSuffixById(v)
    if fix ~= nil then
      if result == nil then
        result = fix
      else
        result = result .. fix
      end
    end
  end
  return result
end

return cfg_Item_equip_specialManager
