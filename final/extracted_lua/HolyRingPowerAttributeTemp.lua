local HolyRingPowerAttributeTemp = {}

function HolyRingPowerAttributeTemp:Init()
  self:InitControls()
end

function HolyRingPowerAttributeTemp:InitControls()
  self.text_AttributeName = self:GetControl("lab_atk")
  self.text_TotalAttribute = self:GetControl("lab_atk/text_atk")
  self.text_LastAttribute = self:GetControl("lab_atk/text_atknext")
end

function HolyRingPowerAttributeTemp:Refresh(data, ui)
  if data == nil then
    return
  end
  self.data = data
  self.parent = ui
  self:RefreshAttribute(data)
end

function HolyRingPowerAttributeTemp:RefreshAttribute(data)
  local holyRingAttributeMap = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingAttributeMap()
  local totalValue = holyRingAttributeMap[data.attributeName] or 0
  local lastValue = 0
  if data.type == HolyRingAttributeType.BasicAttributes then
    lastValue = data.lastAttribute ~= nil and string.format("+%d", MathUtility.GetRounding(data.lastAttribute)) or ""
  elseif data.type == HolyRingAttributeType.HoleAddition then
    totalValue = string.format("%s%s", MathUtility.FormatNum(totalValue / 10), "%")
    lastValue = data.lastAttribute ~= nil and string.format("+%s%s", MathUtility.FormatNum(data.lastAttribute / 10), "%") or ""
  end
  local nameStr = self:GetAttributeName()
  self.text_AttributeName:SetText(nameStr)
  self.text_TotalAttribute:SetText(totalValue)
  self.text_LastAttribute:SetText(lastValue)
end

function HolyRingPowerAttributeTemp:GetAttributeName()
  if self.data.type == HolyRingAttributeType.BasicAttributes then
    for i, v in pairs(HolyRingAttributeEnum) do
      if v.attributeConfigName == self.data.attributeName then
        return v.attributeName
      end
    end
  elseif self.data.type == HolyRingAttributeType.HoleAddition then
    return string.format("\195\148 Th\195\161nh Ho\195\160n Buff %s", self.data.attributeName)
  end
end

return HolyRingPowerAttributeTemp
