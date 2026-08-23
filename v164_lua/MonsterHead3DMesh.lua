MonsterHead3DMesh = class(RoleHead3DMesh)

function MonsterHead3DMesh:ctor(role)
  self.hideTime = nil
  self.base.ctor(self, role)
end

function MonsterHead3DMesh:RefreshData(role)
  self.monsterNameColor = self:GetNameColor()
  self.base.RefreshData(self, role)
  if not self.bloodActive then
    self:ShowOrHideHpHead(self.avatar.isSummon)
  end
  if self.title ~= nil then
    self.title.gameObject:SetActive(false)
  end
end

function MonsterHead3DMesh:Update()
  self.base.Update(self)
  if self.hideTime and self.hideTime < Time.GetServerTime() and self.bloodActive ~= false then
    self:ShowOrHideHpHead(false)
  end
end

function MonsterHead3DMesh:ShowOrHideHpHead(isShow)
  self.bloodActive = isShow
  self:SetTitleActive(isShow)
end

function MonsterHead3DMesh:GetHeight()
  if self.avatar.monsterTb and self.avatar.monsterTb.hudHeight then
    return tonumber(self.avatar.monsterTb.hudHeight)
  end
end

function MonsterHead3DMesh:ShowBloodActive()
  if self.avatar.isSummon then
    return
  end
  self.hideTime = Time.GetServerTime() + 5000
  self:ShowOrHideHpHead(true)
end

function MonsterHead3DMesh:SetTitleActive(isShow)
  if self.trans ~= nil then
    if self.avatar.monsterTb.type == 4001 then
      self.trans.gameObject:SetActive(self:JudgeShowHead(true))
    else
      self.trans.gameObject:SetActive(self:JudgeShowHead(isShow))
    end
  end
end

function MonsterHead3DMesh:IsFriend()
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

function MonsterHead3DMesh:InitHP()
  local color = HUDSetting.Sprites.Blood_Green
  local layer2 = HUDSetting.Sprites.Blood_Green_Layer2
  if self:IsFriend() then
  elseif RoleManager.me.PKMode == ERolePkMode.All then
    color = HUDSetting.Sprites.Blood_Red
    layer2 = HUDSetting.Sprites.Blood_Red_Layer2
  elseif self.avatar.isSummon then
    color = HUDSetting.Sprites.Blood_Green
    layer2 = HUDSetting.Sprites.Blood_Green_Layer2
  else
    color = HUDSetting.Sprites.Blood_Red
    layer2 = HUDSetting.Sprites.Blood_Red_Layer2
  end
  self.hp.gameObject:SetActive(true)
  if self.hp.SpriteName ~= color.res then
    self.hp.SpriteName = color.res
  end
  if self.hpLayer2.SpriteName ~= layer2.res then
    self.hpLayer2.SpriteName = layer2.res
  end
end

function MonsterHead3DMesh:GetNameColor()
  local monsterConfig = ClientTable.cfg_Monster_monsterManager:TryGetValue(self.avatar.configId)
  if monsterConfig.type == MonsterType.goldBoss then
    return HUDSetting.NameColor.GoldMonsterName
  end
  if self.avatar:IsBoss() then
    return HUDSetting.NameColor.MonsterName
  end
  return HUDSetting.NameColor.PlayerName
end

function MonsterHead3DMesh:SetActorName()
  local nameColor = Monster2ColorDic[self.avatar.data.nameColor]
  if nameColor then
    self.nameLabel.color = nameColor
    if self.avatar:IsBoss() then
      self.nameLabel.text = string.format("Lv.%s %s", self.avatar.level, self.avatar:GetName())
    else
      self.nameLabel.text = self.avatar:GetName()
    end
  else
    self.nameLabel.color = self.monsterNameColor
    if self.avatar:IsBoss() then
      self.nameLabel.text = string.format("Lv.%s %s", self.avatar.level, self.avatar:GetName())
    else
      self.nameLabel.text = self.avatar:GetName()
    end
  end
end
