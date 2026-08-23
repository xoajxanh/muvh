local Appear_Couture_AttributeTemplate = {}

function Appear_Couture_AttributeTemplate:Init()
  self:InitControls()
end

function Appear_Couture_AttributeTemplate:InitControls()
  self.nowControl = self:GetControl()
  self.lab_atk = self:GetControl("lab_atk")
  self.lab_atk_now = self:GetControl("lab_atk/text_atk")
  self.text_atknext = self:GetControl("lab_atk/text_atknext")
  self.text_atknext = self:GetControl("lab_atk/text_atknext")
  self.text_atkArrow = self:GetControl("lab_atk/text_atkArrow")
end

function Appear_Couture_AttributeTemplate:Refresh(data, ui)
  if data == nil then
    return
  end
  self.lab_atk:SetText(data.name)
  self.lab_atk_now:SetText(data.nowDes)
  local IsMax = data.nextDex == 0 or data.nextDex == "0" or data.nextDex == nil
  self.text_atknext:SetActive(not IsMax)
  self.text_atkArrow:SetActive(not IsMax)
  self.text_atknext:SetText(data.nextDex)
end

return Appear_Couture_AttributeTemplate
