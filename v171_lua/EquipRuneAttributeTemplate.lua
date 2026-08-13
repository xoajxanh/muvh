local EquipRuneAttributeTemplate = {}

function EquipRuneAttributeTemplate:Init()
  self:InitControls()
end

function EquipRuneAttributeTemplate:InitControls()
  self.text_Attribute = self:GetControl("lab_atk/text_atk")
end

function EquipRuneAttributeTemplate:Refresh(data, ui)
  if data == nil then
    self:GetControl():SetActive(false)
    return
  end
  self.data = data
  self.parent = ui
  self:RefreshAttribute()
end

function EquipRuneAttributeTemplate:RefreshAttribute()
  self.text_Attribute:SetText(self.data.attributeDes)
end

return EquipRuneAttributeTemplate
