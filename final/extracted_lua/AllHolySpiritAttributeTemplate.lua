local AllHolySpiritAttributeTemplate = {}

function AllHolySpiritAttributeTemplate:Init()
  self:InitControls()
end

function AllHolySpiritAttributeTemplate:InitControls()
  self.attributeName = self:GetControl("text_Cur")
  self.attributeValue = self:GetControl("text_Next")
end

function AllHolySpiritAttributeTemplate:Refresh(data, ui)
  if data == nil then
    return
  end
  self.data = data
  self.parent = ui
  self:RefreshAttributeData()
end

function AllHolySpiritAttributeTemplate:RefreshAttributeData()
  local attributeStr = RoleEquipUtility.GetEquipattributeStrByTbl(self.data, "holySpirit")
  if attributeStr ~= nil and attributeStr ~= "" then
    if string.contains(attributeStr, "+") then
      local attributeTab = string.split(attributeStr, "+")
      self.attributeName:SetText(attributeTab[1])
      self.attributeValue:SetText("+" .. attributeTab[2])
    end
  else
    self:UIControl():SetActive(false)
  end
end

return AllHolySpiritAttributeTemplate
