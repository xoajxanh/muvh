local AvatarData = {}
AvatarData.Lid = nil
AvatarData.serverData = nil

function AvatarData:Init()
end

function AvatarData:Refresh(data)
  self:ResetData()
  self.serverData = data
  if self.serverData ~= nil then
    self.Lid = self.serverData.id
  end
end

function AvatarData:ResetData()
  self.Lid = nil
end

function AvatarData:GetBuffs()
  return BuffData.GetBuffs(self.Lid)
end

function AvatarData:Destroy()
  self.serverData = nil
  self:ResetData()
end

return AvatarData
