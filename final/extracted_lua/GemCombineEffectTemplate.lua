local GemCombineEffectTemplate = {}
GemCombineEffectTemplate.gemCombineEffectParam = nil

function GemCombineEffectTemplate:Init()
  self.lab_name_water = self:GetControl("lab_name_water")
  self.btn_Breach = self:GetControl("btn_Breach")
  self.lab_des_water = self:GetControl("lab_des_water")
end

function GemCombineEffectTemplate:Refresh(data, ui)
  self.gemCombineEffectParam = data
  local name = string.format("%s(Lv.%d)", self.gemCombineEffectParam.stoneCombineTbl.name, self.gemCombineEffectParam.stoneCombineTbl.level)
  self.lab_name_water:SetText(name)
  self.btn_Breach:SetActive(not self.gemCombineEffectParam.IsActive)
  self.lab_des_water:SetText(self.gemCombineEffectParam.stoneCombineTbl.word)
end

return GemCombineEffectTemplate
