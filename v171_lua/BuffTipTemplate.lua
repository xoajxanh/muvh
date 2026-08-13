local BuffTipTemplate = {}
BuffTipTemplate.TargetPosition = nil
BuffTipTemplate.BuffStruct = nil
BuffTipTemplate.HaveBuffData = false
BuffTipTemplate.HeightOffset = nil

function BuffTipTemplate:Init()
  self:InitComponent()
  self:InitEvent()
  self:InitParams()
end

function BuffTipTemplate:InitComponent()
  self.go_buffTipBG = self:GetControl("go_buffTipBG")
  self.lab_buffName = self:GetControl("Panel/lab_buffName")
  self.lab_buffTime = self:GetControl("Panel/lab_buffTime")
  self.lab_buffEffect = self:GetControl("Panel/lab_buffEffect")
end

function BuffTipTemplate:InitEvent()
  self.go_buffTipBG:SetOnClick(self, self.BuffTipBgOnClick)
end

function BuffTipTemplate:InitParams()
  self.width, self.height = self:UIControl():GetSizeDelta()
end

function BuffTipTemplate:BuffTipBgOnClick()
  self:SetBuffTipState(false)
end

function BuffTipTemplate:SetBuffTipState(state)
  self:UIControl():SetActive(state)
  if state == false then
    self:StopTimeLoop()
  end
end

function BuffTipTemplate:Refresh(buffIconUIControl)
  if self:AnalysisParams(buffIconUIControl) == false then
    return
  end
  self:RefreshName()
  self:RefreshTime()
  self:RefreshEffect()
  self:AdjustPosition()
  self:SetBuffTipState(true)
end

function BuffTipTemplate:AnalysisParams(buffIconUIControl)
  if buffIconUIControl == nil or buffIconUIControl.buffData == nil or buffIconUIControl.transform == nil then
    return false
  end
  self.BuffStruct = buffIconUIControl.buffData
  self.HaveBuffData = self.BuffStruct ~= nil and self.BuffStruct.buffConfig
  local buffIconWidth, buffIconHeight = buffIconUIControl:GetSizeDelta()
  self.HeightOffset = self.height + buffIconHeight * 0.5
  self.TargetPosition = buffIconUIControl.transform.position
  return true
end

function BuffTipTemplate:RefreshName()
  self.lab_buffName:SetActive(self.HaveBuffData)
  if self.HaveBuffData then
    self.lab_buffName:SetText(self.BuffStruct.buffConfig.name)
  end
end

function BuffTipTemplate:RefreshTime()
  local haveBuffTime = self.BuffStruct.totalTime > 0
  self.lab_buffTime:SetActive(haveBuffTime)
  if haveBuffTime then
    self:StopTimeLoop()
    self:RefreshCurTime(self.BuffStruct.time)
    self.timeLoop = Timer.StartLoopForever(1, self.ReduceTime, self)
  end
end

function BuffTipTemplate:StopTimeLoop()
  if self.timeLoop ~= nil then
    Timer.Stop(self.timeLoop)
    self.timeLoop = nil
  end
end

function BuffTipTemplate:ReduceTime()
  if self.buffDataTime == nil then
    return
  end
  self:RefreshCurTime(self.buffDataTime - 1)
end

function BuffTipTemplate:RefreshCurTime(time)
  self.buffDataTime = time
  self.lab_buffTime:SetText(TimeUtility.ShowTime(self.buffDataTime))
  if self.buffDataTime <= 0 then
    self:SetBuffTipState(false)
  end
end

function BuffTipTemplate:RefreshEffect()
  if self.HaveBuffData == false then
    return
  end
  local haveDes = string.isNullOrEmpty(self.BuffStruct.buffConfig.desc) == false
  self.lab_buffEffect:SetActive(haveDes)
  if haveDes == false then
    return
  end
  local desc
  local matchAttNames = string.gmatch(self.BuffStruct.buffConfig.desc, "%[(%w+)%]")
  local formatDesc = string.gsub(self.BuffStruct.buffConfig.desc, "%[(%w+)%]", "")
  local attrVals = {}
  local attrVal
  for attrName in matchAttNames, nil, nil do
    attrVal = 0
    if ClientServersDifferenceAttribute[attrName] then
      attrVal = buffData.showAttribute[EAttributeType[attrName]] or 0
    else
      attrVal = buffData.attribute[EAttributeType[attrName]] or 0
    end
    if AttributeConfig.IsRatioAttribute(attrName) then
      attrVal = attrVal * 0.01
    end
    attrVals[#attrVals + 1] = attrVal
  end
  if #attrVals < 1 then
    desc = self.BuffStruct.buffConfig.desc
  else
    desc = string.format(formatDesc, unpack(attrVals))
  end
  self.lab_buffEffect:SetText(desc)
end

function BuffTipTemplate:AdjustPosition()
  self:UIControl().transform.position = self.TargetPosition
  local anchorPosition = self:UIControl().rectTransform.anchoredPosition
  local newAnchoredPosition = Vector2(anchorPosition.x, anchorPosition.y - self.HeightOffset)
  self:UIControl():SetAnchoredPosition(newAnchoredPosition.x, newAnchoredPosition.y)
end

function BuffTipTemplate:OnDestroy()
  self:StopTimeLoop()
end

return BuffTipTemplate
