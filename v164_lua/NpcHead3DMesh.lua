NpcHead3DMesh = class(RoleHead3DMesh)

function NpcHead3DMesh:ctor(role)
  self.avatar = role
  self.showHead = true
  self.showName = true
  self.showBlood = false
  self:RefreshData(role)
end

function NpcHead3DMesh:RefreshData(role)
  self.base.RefreshData(self, role)
  if self.title ~= nil then
    self.title.gameObject:SetActive(false)
  end
end

function NpcHead3DMesh:GetHeight()
  if self.avatar.data.config_Npc and self.avatar.data.config_Npc.nameHeight then
    return self.avatar.data.config_Npc.nameHeight
  else
    return 0
  end
end

function NpcHead3DMesh:SetActorName()
  local type = 4
  if self.avatar.data.config_Npc and self.avatar.data.config_Npc.NPCcolor and ENpcNameColor[self.avatar.data.config_Npc.NPCcolor] then
    type = self.avatar.data.config_Npc.NPCcolor
  end
  self.nameLabel.color = ENpcNameColor[type]
  self.nameLabel.text = self.avatar:GetName()
end
