local Avatar = {}
Avatar.Lid = 0

function Avatar:GetInfo()
  if self.avatarInfo == nil then
    self.avatarInfo = LuaClass.AvatarData:New()
  end
  return self.avatarInfo
end

function Avatar:Init()
end

function Avatar:RefreshData()
end

function Avatar:Destroy()
end

return Avatar
