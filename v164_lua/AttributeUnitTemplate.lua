local AttributeUnitTemplate = {}

function AttributeUnitTemplate:Init()
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
end

function AttributeUnitTemplate:InitParams()
  self.parentTbl = nil
  self.isNext = false
  self.pos = {
    [true] = {x = 170, y = 0},
    [false] = {x = 90, y = 0}
  }
end

function AttributeUnitTemplate:InitControls()
  self.lab_atk = self:GetControl("lab_atk")
  self.text_atk = self:GetControl("lab_atk/text_atk")
  self.text_atknext = self:GetControl("lab_atk/text_atknext")
  self.text_atkArrow = self:GetControl("lab_atk/text_atkArrow")
end

function AttributeUnitTemplate:BindUIEvent()
end

function AttributeUnitTemplate:Refresh(data, ui)
  self.attributeInfo = data
  self.parentTbl = ui
  self:RefreshView()
end

function AttributeUnitTemplate:RefreshView()
  if self.attributeInfo == nil then
    return
  end
  self.lab_atk:SetText(self.attributeInfo.name or "")
  self.text_atk:SetText(self.attributeInfo.curValue or "")
  self.text_atknext:SetText(string.GetColorText(self.attributeInfo.nextValue, self.attributeInfo.isUp and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[0]) or "")
  self.text_atknext:SetActive(not self.attributeInfo.nextIsNil)
  self.text_atkArrow:SetActive(not self.attributeInfo.nextIsNil)
  if self.nextIsNil ~= self.attributeInfo.nextIsNil and not IsNil(self.text_atk.gameObject) then
    self.nextIsNil = self.attributeInfo.nextIsNil
    self.text_atk.transform.localPosition = self.pos[self.nextIsNil]
  end
end

return AttributeUnitTemplate
