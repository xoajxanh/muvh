local cfg_Seal_SealManager = {}

function cfg_Seal_SealManager:GetName()
  return "cfg_Seal_SealManager"
end

function cfg_Seal_SealManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Seal_Seal")
  end
  return self.dic
end

setmetatable(cfg_Seal_SealManager, TableManagerBase)

function cfg_Seal_SealManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Seal_SealManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Seal_SealManager:GetCurBaseCarrer()
  if self.baseCarrer == nil then
    if RoleManager.me == nil then
      return nil
    end
    self.baseCarrer = RoleUtility.GetBasicCareer(RoleManager.me.career)
  end
  return self.baseCarrer
end

function cfg_Seal_SealManager:ResetBaseCarrer()
  self.baseCarrer = nil
end

function cfg_Seal_SealManager:MaxIdAndTypeDic()
  return self.mMaxIdAndTypeDic
end

function cfg_Seal_SealManager:MinIdAndTypeDic()
  return self.mMinIdAndTypeDic
end

function cfg_Seal_SealManager:SealListAndTypeDic()
  return self.mSealListAndTypeDic
end

function cfg_Seal_SealManager:TryGetSealListByType(_type)
  if RoleManager.me == nil then
    return nil
  end
  if self.mSealListAndTypeDic == nil then
    self:InitSealTblData()
  end
  if self:SealListAndTypeDic()[self:GetCurBaseCarrer()] == nil then
    return nil
  end
  return self:SealListAndTypeDic()[self:GetCurBaseCarrer()][_type]
end

function cfg_Seal_SealManager:TryGetMaxIdByType(_type)
  if self.mMaxIdAndTypeDic == nil then
    self:InitSealTblData()
  end
  if self:MaxIdAndTypeDic()[self:GetCurBaseCarrer()] == nil then
    return nil
  end
  return self:MaxIdAndTypeDic()[self:GetCurBaseCarrer()][_type]
end

function cfg_Seal_SealManager:TryGetMinIdByType(_type)
  if self.mMinIdAndTypeDic == nil then
    self:InitSealTblData()
  end
  if self:MinIdAndTypeDic()[self:GetCurBaseCarrer()] == nil then
    return nil
  end
  return self:MinIdAndTypeDic()[self:GetCurBaseCarrer()][_type]
end

function cfg_Seal_SealManager:InitSealTblData()
  if self:GetDic() == nil then
    return
  end
  local type, carrerTbl, career
  self.mSealListAndTypeDic = {}
  self.mMaxIdAndTypeDic = {}
  self.mMinIdAndTypeDic = {}
  for i, v in pairs(self:GetDic()) do
    type = v.tab
    if type and not string.isNullOrEmpty(v.career) then
      carrerTbl = string.split(v.career, "#")
      if table.count(carrerTbl) > 0 then
        career = tonumber(carrerTbl[1])
        if self:SealListAndTypeDic()[career] == nil then
          self:SealListAndTypeDic()[career] = {}
        end
        if self:SealListAndTypeDic()[career][type] == nil then
          self:SealListAndTypeDic()[career][type] = {}
        end
        table.insert(self:SealListAndTypeDic()[career][type], v.id)
        if self:MaxIdAndTypeDic()[career] == nil then
          self:MaxIdAndTypeDic()[career] = {}
        end
        if self:MaxIdAndTypeDic()[career][type] == nil or self:MaxIdAndTypeDic()[career][type] < v.id then
          self:MaxIdAndTypeDic()[career][type] = v.id
        end
        if self:MinIdAndTypeDic()[career] == nil then
          self:MinIdAndTypeDic()[career] = {}
        end
        if self:MinIdAndTypeDic()[career][type] == nil or self:MinIdAndTypeDic()[career][type] > v.id then
          self:MinIdAndTypeDic()[career][type] = v.id
        end
      end
    end
  end
end

function cfg_Seal_SealManager:TryGetSealAttributeTbl(_id, _minType)
  if _id == nil or RoleManager.me == nil then
    return nil
  end
  local attrebuteTbl = {}
  local curTbl, nextTbl
  local curValue = ""
  local nextValue = ""
  local curMaxValue = ""
  local nextMaxValue = ""
  curTbl = self:TryGetValue(_id)
  if curTbl then
    local maxId = self:TryGetMaxIdByType(curTbl.tab)
    if maxId == _id then
    end
    nextTbl = self:TryGetValue(_id + 1)
  elseif _minType then
    local minId = self:TryGetMinIdByType(_minType)
    nextTbl = self:TryGetValue(minId)
  end
  curValue = curTbl ~= nil and curTbl.maximumHealth or 0
  nextValue = nextTbl ~= nil and nextTbl.maximumHealth or 0
  if curValue ~= 0 or nextValue ~= 0 then
    local temp = {}
    temp.name = "HP"
    temp.curValue = tostring(curValue) or ""
    temp.nextValue = tostring(nextValue) or ""
    temp.isUp = curValue < nextValue
    temp.nextIsNil = nextTbl == nil
    table.insert(attrebuteTbl, temp)
  end
  curValue = curTbl ~= nil and curTbl.minimumPhysBaseDmg or 0
  curMaxValue = curTbl ~= nil and curTbl.maximumPhysBaseDmg or 0
  nextValue = nextTbl ~= nil and nextTbl.minimumPhysBaseDmg or 0
  nextMaxValue = nextTbl ~= nil and nextTbl.maximumPhysBaseDmg or 0
  if curValue ~= 0 or curMaxValue ~= 0 or nextValue ~= 0 or nextMaxValue ~= 0 then
    local temp = {}
    temp.name = "T\225\186\165n c\195\180ng"
    temp.curValue = tostring(curValue) .. "-" .. tostring(curMaxValue) or ""
    temp.nextValue = tostring(nextValue) .. "-" .. tostring(nextMaxValue) or ""
    temp.isUp = curMaxValue < nextMaxValue
    temp.nextIsNil = nextTbl == nil
    table.insert(attrebuteTbl, temp)
  end
  curValue = curTbl ~= nil and curTbl.minimumWizBaseDmg or 0
  curMaxValue = curTbl ~= nil and curTbl.maximumWizBaseDmg or 0
  nextValue = nextTbl ~= nil and nextTbl.minimumWizBaseDmg or 0
  nextMaxValue = nextTbl ~= nil and nextTbl.maximumWizBaseDmg or 0
  if curValue ~= 0 or curMaxValue ~= 0 or nextValue ~= 0 or nextMaxValue ~= 0 then
    local temp = {}
    temp.name = "C\195\180ng ph\195\169p"
    temp.curValue = tostring(curValue) .. "-" .. tostring(curMaxValue) or ""
    temp.nextValue = tostring(nextValue) .. "-" .. tostring(nextMaxValue) or ""
    temp.isUp = curMaxValue < nextMaxValue
    temp.nextIsNil = nextTbl == nil
    table.insert(attrebuteTbl, temp)
  end
  curValue = curTbl ~= nil and curTbl.minimumCurseBaseDmg or 0
  curMaxValue = curTbl ~= nil and curTbl.maximumCurseBaseDmg or 0
  nextValue = nextTbl ~= nil and nextTbl.minimumCurseBaseDmg or 0
  nextMaxValue = nextTbl ~= nil and nextTbl.maximumCurseBaseDmg or 0
  if curValue ~= 0 or curMaxValue ~= 0 or nextValue ~= 0 or nextMaxValue ~= 0 then
    local temp = {}
    temp.name = "T\225\186\165n C\195\180ng Nguy\225\187\129n R\225\187\167a "
    temp.curValue = tostring(curValue) .. "-" .. tostring(curMaxValue) or ""
    temp.nextValue = tostring(nextValue) .. "-" .. tostring(nextMaxValue) or ""
    temp.isUp = curMaxValue < nextMaxValue
    temp.nextIsNil = nextTbl == nil
    table.insert(attrebuteTbl, temp)
  end
  curValue = curTbl ~= nil and curTbl.defenseBase or 0
  nextValue = nextTbl ~= nil and nextTbl.defenseBase or 0
  if curValue ~= 0 or nextValue ~= 0 then
    local temp = {}
    temp.name = "Ph\195\178ng Th\225\187\167"
    temp.curValue = tostring(curValue) or ""
    temp.nextValue = tostring(nextValue) or ""
    temp.isUp = curValue < nextValue
    temp.nextIsNil = nextTbl == nil
    table.insert(attrebuteTbl, temp)
  end
  return attrebuteTbl
end

return cfg_Seal_SealManager
