local SurrenderChunkTemplate = {}

function SurrenderChunkTemplate:Refresh(data, ui)
  if type(data) ~= "number" then
    return
  end
  local spriteName = data == 1 and "3V3surrenderYes" or "3V3surrenderNo"
  ui:SetSprite("Atlas_Common", spriteName, self:UIControl())
end

return SurrenderChunkTemplate
