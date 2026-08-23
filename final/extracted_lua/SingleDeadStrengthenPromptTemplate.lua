local SingleDeadStrengthenPromptTemplate = {}
SingleDeadStrengthenPromptTemplate.DeadStrengthenPromptData = nil

function SingleDeadStrengthenPromptTemplate:Init()
  self:BindEvents()
end

function SingleDeadStrengthenPromptTemplate:BindEvents()
  self:UIControl():SetOnClick(self, function()
    self:StrengthenBtnOnClick()
  end)
end

function SingleDeadStrengthenPromptTemplate:StrengthenBtnOnClick()
  if self.DeadStrengthenPromptData == nil or self.DeadStrengthenPromptData.StrongerTbl == nil or string.isNullOrEmpty(self.DeadStrengthenPromptData.StrongerTbl.event) then
    return
  end
  if tonumber(self.DeadStrengthenPromptData.StrongerTbl.event) == DeadStrengthenPromptFuncType.OpenPanel and string.isNullOrEmpty(self.DeadStrengthenPromptData.StrongerTbl.parameter) == false then
    NavigationUtility.ClickNavigationByNavId(tonumber(self.DeadStrengthenPromptData.StrongerTbl.parameter))
    UIManager.Hide(UIID.Tip_StrongerUI)
  end
end

function SingleDeadStrengthenPromptTemplate:Refresh(data, ui)
  if self:AnalysisParams(data) == false then
    return
  end
  ui:SetSprite("Atlas_Common", self.DeadStrengthenPromptData.StrongerTbl.picture, self:UIControl())
end

function SingleDeadStrengthenPromptTemplate:AnalysisParams(data)
  if data == nil or data.StrongerTbl == nil then
    return false
  end
  self.DeadStrengthenPromptData = data
  return true
end

return SingleDeadStrengthenPromptTemplate
