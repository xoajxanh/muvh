local HolyRingInformationAttributeTemp = {}

function HolyRingInformationAttributeTemp:Init()
  self:InitControls()
end

function HolyRingInformationAttributeTemp:InitControls()
  self.text_AttributeName = self:GetControl("lab_atk")
  self.text_TotalAttribute = self:GetControl("lab_atk/text_atk")
  self.text_LastAttribute = self:GetControl("lab_atk/text_atknext")
end

function HolyRingInformationAttributeTemp:Refresh(data, ui)
  if data == nil then
    return
  end
  self.data = data
  self.parent = ui
  self:RefreshAttribute(data)
end

function HolyRingInformationAttributeTemp:RefreshAttribute(data)
  local totalAttributeValue, additionAttributeValue = 0, 0
  local holyRingHoleData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingHoleData()
  local ringAttributeMap = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingAttributeMap()
  local severValue = ringAttributeMap[data.attributeName] or 0
  if data.type == HolyRingAttributeType.BasicAttributes then
    for holeIndex, holeData in pairs(holyRingHoleData) do
      if holeData:GetHolyRingHoleItemData() then
        local addition = holeData:GetHolyRingAddition() / 100
        local holeItemAttribute = holeData:GetHolyRingHoleItemData():GetBasicsAttribute()
        for i, v in pairs(holeItemAttribute) do
          if v.attributeName == data.attributeName then
            if data.attributeName == "holyBeast" then
              totalAttributeValue = totalAttributeValue + v.attributeValue
            else
              totalAttributeValue = totalAttributeValue + v.attributeValue + v.attributeValue * addition
              additionAttributeValue = additionAttributeValue + v.attributeValue * addition
            end
          end
        end
      end
    end
    if data.attributeName == "holyBeast" then
      totalAttributeValue = string.format("%s%s", MathUtility.FormatNum(totalAttributeValue / 100 + severValue), "%")
    else
      totalAttributeValue = MathUtility.GetRounding(totalAttributeValue + severValue)
      additionAttributeValue = MathUtility.GetRounding(additionAttributeValue)
    end
  elseif data.type == HolyRingAttributeType.HoleAddition then
    totalAttributeValue = string.format("%s%s", MathUtility.FormatNum(severValue / 10), "%")
  end
  local nameStr = self:GetAttributeName()
  self.text_AttributeName:SetText(nameStr)
  self.text_TotalAttribute:SetText(totalAttributeValue)
  self.text_LastAttribute:SetText(additionAttributeValue == 0 and "" or string.format("(Buff Th\195\161nh Ho\195\160n %s)", additionAttributeValue))
end

function HolyRingInformationAttributeTemp:GetAttributeName()
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

return HolyRingInformationAttributeTemp
