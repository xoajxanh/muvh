local Equip_GuardAttributesTemplate = {}

function Equip_GuardAttributesTemplate:Init()
  self.lab_des = self:GetControl("lab_atk")
  self.lab_nowDes = self:GetControl("lab_atk/text_atk")
  self.lab_nextDes = self:GetControl("lab_atk/text_atknext")
end

function Equip_GuardAttributesTemplate:Refresh(params)
  if params == nil then
    return
  end
  local des, now, next = gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():GetAttributesShowInfo(params.GuardInfoItem, params.AttributesName)
  self.lab_des:SetText(des)
  self.lab_nowDes:SetText(now)
  self.lab_nextDes:SetText(next)
end

return Equip_GuardAttributesTemplate
