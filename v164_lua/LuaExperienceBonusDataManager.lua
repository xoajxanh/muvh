local LuaExperienceBonusDataManager = {}

function LuaExperienceBonusDataManager:AllExpViewDataTbl()
  if self.mAllExpViewTbl == nil then
    self.mAllExpViewTbl = {}
  end
  return self.mAllExpViewTbl
end

function LuaExperienceBonusDataManager:ExperienceBonusDataDic()
  if self.mExperienceBonusDataDic == nil then
    self.mExperienceBonusDataDic = {}
  end
  return self.mExperienceBonusDataDic
end

function LuaExperienceBonusDataManager:GetNeedShowExpId()
  local result = {}
  local data
  for i, v in pairs(self:AllExpViewDataTbl()) do
    if v and self:CheckIsShowUnit(v) then
      table.insert(result, v.id)
    end
  end
  return result
end

function LuaExperienceBonusDataManager:GetExperienceBonusData(id)
  return self:ExperienceBonusDataDic()[id]
end

function LuaExperienceBonusDataManager:GetTotalAddExpNum()
  return self.totalAddExpNum or 0
end

function LuaExperienceBonusDataManager:Init()
  self:InitParam()
  self:BindEvent()
  self:InitExperienceBonusData()
end

function LuaExperienceBonusDataManager:InitParam()
  self.eventContainer = EventContainer(EventManager)
end

function LuaExperienceBonusDataManager:BindEvent()
  self.eventContainer:Regist(Event.Role_MyLvChanged, self.CheckConditionCallBack, self)
  self.eventContainer:Regist(Event.MemberLevelChanged, self.CheckConditionCallBack, self)
end

function LuaExperienceBonusDataManager:InitExperienceBonusData()
  self.mAllExpViewTbl = {}
  self.mExperienceBonusDataDic = {}
  local dic = ClientTable.cfg_Route_expUpManager:GetDic()
  for i, v in pairs(dic) do
    if v then
      table.insert(self.mAllExpViewTbl, self:NewUnit(v))
      self.mExperienceBonusDataDic[v.id] = self:NewDataItem(v)
    end
  end
  table.sort(self.mAllExpViewTbl, function(a, b)
    return a ~= nil and b ~= nil and a.order < b.order
  end)
end

function LuaExperienceBonusDataManager:CheckConditionCallBack()
  local isNeedRefresh = false
  local isShow
  for i, v in pairs(self.mAllExpViewTbl) do
    if v and not v.isShow then
      isShow = ConditionManager.Check4D(v.condition)
      if isShow then
        v.isShow = true
        isNeedRefresh = true
      end
    end
  end
  if isNeedRefresh then
    EventManager.Dispatch(Event.ExperienceBonusStateChanged)
  end
end

function LuaExperienceBonusDataManager:InitExpAdditionData(data)
  if data and data.expAddition then
    self:RefreshExperienceBonus(data.expAddition)
  end
end

function LuaExperienceBonusDataManager:RefreshExpAdditionData(data)
  if data and data.expAddition then
    self:RefreshExperienceBonus(data.expAddition)
  end
end

function LuaExperienceBonusDataManager:RefreshExperienceBonus(tbl)
  local changedIndexList = {}
  for i, v in pairs(tbl) do
    if self.mExperienceBonusDataDic[v.id] ~= nil then
      self.mExperienceBonusDataDic[v.id].value = math.floor(v.rate / 100)
      self.mExperienceBonusDataDic[v.id].endTime = v.endTime
      table.insert(changedIndexList, i)
    end
  end
  if table.count(changedIndexList) > 0 then
    self:RefreshTotalValue()
    EventManager.Dispatch(Event.ExperienceBonusDataChanged)
  end
end

function LuaExperienceBonusDataManager:RefreshTotalValue()
  self.totalAddExpNum = 0
  for i, v in pairs(self.mAllExpViewTbl) do
    if v and self:CheckIsShowUnit(v) and self.mExperienceBonusDataDic[v.id] then
      self.totalAddExpNum = self.totalAddExpNum + self.mExperienceBonusDataDic[v.id].value
    end
  end
end

function LuaExperienceBonusDataManager:NewUnit(tbl)
  local result = {
    id = tbl.id,
    order = tbl.order or 0,
    ShowType = tbl.type2,
    condition = tbl.condition,
    isShow = false
  }
  if string.isNullOrEmpty(tbl.condition) then
    result.isShow = true
  else
    result.isShow = ConditionManager.Check4D(tbl.condition)
  end
  return result
end

function LuaExperienceBonusDataManager:NewDataItem(tbl)
  local result = {
    id = tbl.id,
    str = tbl.expUpType,
    value = 0,
    endTime = 0,
    behaviour = tbl.route,
    addShowType = tbl.type
  }
  return result
end

function LuaExperienceBonusDataManager:CheckIsShowUnit(data)
  if not data.isShow then
    return false
  end
  if data.ShowType == ExperienceBonusShowTypeEnum.Condition then
    return true
  elseif data.ShowType == ExperienceBonusShowTypeEnum.Time then
    local expData = self:ExperienceBonusDataDic()[data.id]
    if expData == nil or expData.endTime == 0 then
      return false
    end
    return 0 < TimeUtility.RefreshSec(expData.endTime / 1000)
  elseif data.ShowType == ExperienceBonusShowTypeEnum.Value then
    local expData = self:ExperienceBonusDataDic()[data.id]
    return expData and 0 < expData.value
  elseif data.ShowType == ExperienceBonusShowTypeEnum.AlwaysShow then
    return true
  end
end

function LuaExperienceBonusDataManager:OnDestruct()
  self:RunBaseFunction("OnDestruct")
end

return LuaExperienceBonusDataManager
