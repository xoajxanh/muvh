local DeadStrengthenPromptDataManager = {}
DeadStrengthenPromptDataManager.StrengthenPromptDataList = nil
DeadStrengthenPromptDataManager.IsOn = nil

function DeadStrengthenPromptDataManager:InitOriginData()
  self:InitStrengthenPromptDataList()
end

function DeadStrengthenPromptDataManager:InitStrengthenPromptDataList()
  if self.StrengthenPromptDataList == nil then
    self.StrengthenPromptDataList = {}
  end
  local strongerTblList = ClientTable.cfg_StrongerManager:GetDic()
  if strongerTblList == nil or next(strongerTblList) == nil then
    return
  end
  local deadStrengthenPromptData
  for k, v in pairs(strongerTblList) do
    deadStrengthenPromptData = LuaClass.DeadStrengthenPromptData:New()
    deadStrengthenPromptData:RefreshData({strongerTbl = v})
    if deadStrengthenPromptData.AnalysisState then
      table.insert(self.StrengthenPromptDataList, deadStrengthenPromptData)
    end
  end
end

function DeadStrengthenPromptDataManager:CanShowPrompt()
  return self.IsOn == nil or self.IsOn == true
end

function DeadStrengthenPromptDataManager:HavePromptData()
  local dataList = self:GetDeadStrengthenPromptDataList()
  return dataList ~= nil and 0 < #dataList
end

function DeadStrengthenPromptDataManager:GetDeadStrengthenPromptDataList()
  if self.StrengthenPromptDataList == nil then
    self:InitOriginData()
  end
  if type(self.StrengthenPromptDataList) ~= "table" or next(self.StrengthenPromptDataList) == nil then
    return
  end
  local showData = {}
  for k, v in pairs(self.StrengthenPromptDataList) do
    local promptData = v
    if promptData:IsShow() then
      table.insert(showData, promptData)
    end
  end
  table.sort(showData, self.SortCompare)
  return showData
end

function DeadStrengthenPromptDataManager.SortCompare(leftPromptData, rightPromptData)
  return leftPromptData:GetOrder() < rightPromptData:GetOrder()
end

function DeadStrengthenPromptDataManager:ShowDeadStrengthenPromptPanel()
  if self:CanShowPrompt() and self:HavePromptData() then
    UIManager.Show(UIID.Tip_StrongerUI)
  end
end

function DeadStrengthenPromptDataManager:OnDestruct()
  self.IsOn = true
end

return DeadStrengthenPromptDataManager
