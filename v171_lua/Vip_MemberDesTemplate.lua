local Vip_MemberDesTemplate = {}

function Vip_MemberDesTemplate:Init()
end

function Vip_MemberDesTemplate:Refresh(str, ui)
  self:UIControl():SetText(str)
end

return Vip_MemberDesTemplate
