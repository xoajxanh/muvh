local OnHookSubTblTemplate = {}

function OnHookSubTblTemplate:Init()
  self.img_clickeffect = self:GetControl("img_clickeffect")
  self.name = self:GetControl("name")
  self.level = self:GetControl("level")
  self:UIControl():SetOnClick(self, self.OnClick)
end

function OnHookSubTblTemplate:Refresh(data)
  self.subdata = data
  if data == nil then
    return
  end
  if data.cfg_OnHook_Point_Tab ~= nil then
    self.subType = tonumber(data.cfg_OnHook_Point_Tab.subType)
  end
  if data.cfg_OnHook_Point_Tab ~= nil then
    local text = data.cfg_OnHook_Point_Tab.entryShow
    if ConditionManager.Check4D(data.cfg_OnHook_Point_Tab.entryCondition) == false then
      text = string.format("<color=red>%s</color>", text)
    end
    self.name:SetText(data.cfg_OnHook_Point_Tab.subTab)
    self.level:SetText(text)
  end
  self.img_clickeffect:SetActive(false)
end

function OnHookSubTblTemplate:OnClick()
  EventManager.Dispatch(Event.OnHookSubTblSelect, self.subType)
end

function OnHookSubTblTemplate:RefreshSelectActive(selectType)
  if selectType == nil or self.subType == nil then
    self.img_clickeffect:SetActive(false)
  end
  self.img_clickeffect:SetActive(tonumber(selectType) == tonumber(self.subType))
end

return OnHookSubTblTemplate
