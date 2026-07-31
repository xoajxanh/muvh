local Toggle_SingleToggleTemplate = {}
Toggle_SingleToggleTemplate.InputData = nil

function Toggle_SingleToggleTemplate:Init()
  self:InitControls()
  self:InitEvent()
end

function Toggle_SingleToggleTemplate:InitControls()
  self.control_name = self:GetControl("lab_name")
  self.control_condition = self:GetControl("lab_condition")
  self.control_background = self:GetControl("Background")
end

function Toggle_SingleToggleTemplate:InitEvent()
  self:UIControl():SetOnToggleChanged(self, self.ToggleChangeClick)
end

function Toggle_SingleToggleTemplate:ToggleChangeClick(control)
  if self.InputData ~= nil and self.InputData.toggleCallback ~= nil then
    self.InputData.toggleCallback(self.InputData, self:UIControl().toggle.isOn)
  end
end

function Toggle_SingleToggleTemplate:RefreshData(data)
  if self:AnalysisParams(data) == false then
    return
  end
  if self.control_name ~= nil and string.isNullOrEmpty(self.InputData.name) == false then
    self.control_name:SetText(self.InputData.name or "")
  end
  if self.control_condition ~= nil and string.isNullOrEmpty(self.InputData.conditionDes) == false then
    self.control_condition:SetText(self.InputData.conditionDes or "")
  end
  if type(self.InputData.isOn) == "boolean" then
    self:UIControl().toggle.isOn = self.InputData.isOn
    if self.InputData.isOn == true then
      self:ToggleChangeClick()
    end
  end
  self.control_background:SetActive(string.isNullOrEmpty(self.InputData.name) == false)
end

function Toggle_SingleToggleTemplate:AnalysisParams(data)
  if data == nil then
    return false
  end
  self.InputData = data
  return true
end

return Toggle_SingleToggleTemplate
