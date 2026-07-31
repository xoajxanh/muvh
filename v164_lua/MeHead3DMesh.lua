MeHead3DMesh = class(PlayerHead3DMesh)

function MeHead3DMesh:RefreshMu2AvatarInfo(role)
  if role.id then
    local mu2Avatar = gameMgr:GetAvatarManager():GetMainPlayer()
    if mu2Avatar then
      self.mu2AvatarInfo = mu2Avatar:GetInfo()
    end
  else
    self.mu2AvatarInfo = nil
  end
end

function MeHead3DMesh:RefreshHPProgress(hp)
  local hpNum = QuickFind.LuaMainPlayerViewAttrData().hp
  local maxHpNum = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumHealth)
  if self.hp ~= nil and self.showBlood then
    self.bloodPos = Mathf.Clamp01(self:GetHPProgress(hpNum / maxHpNum))
    self.hp.fillAmount = self.bloodPos
  end
end
