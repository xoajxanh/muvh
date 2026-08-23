local CurHolySpiritAttributeTemplates = {}

function CurHolySpiritAttributeTemplates:Init()
  self:InitControls()
end

function CurHolySpiritAttributeTemplates:InitControls()
  self.attributeName = self:GetControl("text_Cur")
  self.attributeValue = self:GetControl("text_Next")
end

function CurHolySpiritAttributeTemplates:Refresh(data, ui)
  if data == nil then
    return
  end
  self.data = data
  self.parent = ui
  self:RefreshShowState()
end

function CurHolySpiritAttributeTemplates:RefreshShowState()
  local attributeStr = RoleEquipUtility.GetEquipattributeStrByTbl(self.data, "holySpirit")
  if attributeStr ~= nil and attributeStr ~= "" then
    if string.contains(attributeStr, "+") then
      local attributeTab = string.split(attributeStr, "+")
      self.attributeName:SetText(attributeTab[1])
      local nowStage, totalStage = HolySpiritPointData.GetPointStageById(self.data.serverInfo.id)
      if self.data.serverInfo.active then
        self.attributeValue:SetText(string.GetColorText("+" .. attributeTab[2], ItemQuality2ColorDic[5]))
      elseif HolySpiritPointData.GetLastPointState(self.data.serverInfo.id) then
        local color = nowStage >= self.data.sort and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[21]
        self.attributeValue:SetText(string.GetColorText("+" .. attributeTab[2], color))
      else
        self.attributeValue:SetText(string.GetColorText("+" .. attributeTab[2], ItemQuality2ColorDic[21]))
      end
    end
  else
    self:UIControl():SetActive(false)
  end
end

return CurHolySpiritAttributeTemplates
