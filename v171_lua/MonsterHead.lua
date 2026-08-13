MonsterHead = class(RoleHead)

function MonsterHead:ctor(role)
  self.hideTime = nil
  self.base.ctor(self, role)
end

function MonsterHead:RefreshData(role)
  self.HudStyle = self:GetHudStyle()
  self.base.RefreshData(self, role)
  if not self.bloodActive then
    self:ShowOrHideHpHead(self.avatar.isSummon)
  end
end

function MonsterHead:GetHudStyle()
  local monsterConfig = ClientTable.cfg_Monster_monsterManager:TryGetValue(self.avatar.configId)
  if monsterConfig.type == MonsterType.goldBoss then
    return HUDTitleStyle.GoldMonsterName
  end
  if self.avatar:IsBoss() then
    return HUDTitleStyle.MonsterName
  end
  return HUDTitleStyle.PlayerName
end

function MonsterHead:Update()
  self.base.Update(self)
  if self.hideTime and self.hideTime < Time.GetServerTime() and self.bloodActive ~= false then
    self:ShowOrHideHpHead(false)
  end
end

function MonsterHead:ShowOrHideHpHead(isShow)
  self.bloodActive = isShow
  self:SetTitleActive(isShow)
end

function MonsterHead:GetHeight()
  if self.avatar.monsterTb and self.avatar.monsterTb.hudHeight then
    return tonumber(self.avatar.monsterTb.hudHeight)
  end
end

function MonsterHead:ShowBloodActive()
  if self.avatar.isSummon then
    return
  end
  self.hideTime = Time.GetServerTime() + 5000
  self:ShowOrHideHpHead(true)
end

function MonsterHead:SetTitleActive(isShow)
  if self.mTitle ~= nil then
    if self.avatar.monsterTb.type == 4001 then
      self.mTitle:ShowTitle(self:JudgeShowHead(true))
    else
      self.mTitle:ShowTitle(self:JudgeShowHead(isShow))
    end
  end
end

function MonsterHead:IsFriend()
  if self.avatar.isSummon and self.avatar.data.master == RoleManager.me.id then
    return true
  end
  if self.avatar.roleType == ERoleType.LuoLanDefense then
    return true
  end
  if Activity_LangHunYaoSaiData.RoleIsLangHunYongBing(self.avatar.id) then
    return true
  end
end

function MonsterHead:InitHP()
  self.mTitle:BeginTitle()
  if self:IsFriend() then
    self.mTitle:PushBlood(HUDBloodType.Blood_Green, HUDTitleStyle.Blood, 1, self:GetHeight())
  elseif RoleManager.me.PKMode == ERolePkMode.All then
    self.mTitle:PushBlood(HUDBloodType.Blood_Red, HUDTitleStyle.Blood, 1, self:GetHeight())
  elseif self.avatar.isSummon then
    self.mTitle:PushBlood(HUDBloodType.Blood_Green, HUDTitleStyle.Blood, 1, self:GetHeight())
  else
    self.mTitle:PushBlood(HUDBloodType.Blood_Red, HUDTitleStyle.Blood, 1, self:GetHeight())
  end
  self.mTitle:EndTitle()
end

function MonsterHead:SetActorName()
  self.mTitle:BeginTitle()
  self.HudStyle = self:GetHudStyle()
  local nameColor = Monster2ColorDic[self.avatar.data.nameColor]
  if nameColor then
    nameColor = ColorUtility.ColorToColor32(nameColor)
    self.mTitle:PushCustomColorTitle(self.avatar:GetName(), self.HudStyle, nameColor, self:GetHeight())
  else
    self.mTitle:PushTitle(self.avatar:GetName(), self.HudStyle, self:GetHeight())
  end
  self.mTitle:EndTitle()
end
