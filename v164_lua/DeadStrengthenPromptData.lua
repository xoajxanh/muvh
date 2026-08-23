local DeadStrengthenPromptData = {}
DeadStrengthenPromptData.StrongerTbl = nil
DeadStrengthenPromptData.AnalysisState = nil

function DeadStrengthenPromptData:RefreshData(commonData)
  if self:AnalysisData(commonData) == false then
    return
  end
end

function DeadStrengthenPromptData:AnalysisData(commonData)
  self.AnalysisState = false
  if type(commonData) ~= "table" then
    return false
  end
  self.StrongerTbl = commonData.strongerTbl
  if self.StrongerTbl == nil and type(commonData.id) == "number" then
    self.StrongerTbl = ClientTable.cfg_StrongerManager:TryGetValue(commonData.id)
  end
  if self.StrongerTbl == nil then
    return false
  end
  self.AnalysisState = true
  return true
end

function DeadStrengthenPromptData:GetOrder()
  if self.StrongerTbl == nil or type(self.StrongerTbl.order) ~= "number" then
    return 0
  end
  return self.StrongerTbl.order
end

function DeadStrengthenPromptData:IsShow()
  if self.StrongerTbl == nil then
    return false
  end
  if string.isNullOrEmpty(self.StrongerTbl.condition) then
    return true
  end
  return ConditionManager.Check4D(self.StrongerTbl.condition)
end

return DeadStrengthenPromptData
