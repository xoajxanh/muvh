PlayerHead = class(RoleHead)

function PlayerHead:ctor(role)
  self.hideTime = nil
  self.showBlood = false
  self.base.ctor(self, role)
  self:ShowBlood(false)
end

function PlayerHead:RefreshData(role)
  self.HudStyle = self:GetHudStyle()
  self.base.RefreshData(self, role)
  self:SetSiegeAttackState()
  self:SetSiegeDefenceState()
end

function PlayerHead:Update()
  self.base.Update(self)
  if self.hideTime and self.hideTime < Time.GetServerTime() and self.showBlood ~= false then
    self:ShowBlood(false)
    self.hideTime = nil
  end
end

function PlayerHead:ShowBlood(isShow)
  if self.mTitle then
    self.showBlood = isShow
    self:RefreshData(self.avatar)
  end
end

function PlayerHead:ShowBloodActive()
  self.hideTime = Time.GetServerTime() + 5000
  self:ShowBlood(true)
end

function PlayerHead:SetTitleActive(isShow)
  if self.mTitle ~= nil then
    self.mTitle:ShowTitle(self:JudgeShowHead(isShow))
  end
end

function PlayerHead:SetTeamLeaderState(isShow)
  self.mTitle:BeginTitle()
  self.mTitle:PushIcon(HUDTitleStyle.TeamIcon, CS.Framework.HudSetting.Instance.m_nTeamFlagPic)
  self.mTitle:EndTitle()
end

function PlayerHead:SetSiegeAttackState()
  if not Activity_LuoLanSiegeData.IsActivityOpen() then
    return
  end
  if self.avatar.unionId == 0 or self.avatar.unionId ~= Activity_LuoLanSiegeData.holdUnionId then
    self.mTitle:BeginTitle()
    if self.avatar.unionPosition == WarAllianceMemberType.Leader then
      self.mTitle:PushIcon(HUDTitleStyle.TeamIcon, CS.Framework.HudSetting.Instance.m_nSiege_atkBig)
    else
      self.mTitle:PushIcon(HUDTitleStyle.TeamIcon, CS.Framework.HudSetting.Instance.m_nSiege_atk)
    end
    self.mTitle:EndTitle()
  end
end

function PlayerHead:SetSiegeDefenceState()
  if not Activity_LuoLanSiegeData.IsActivityOpen() then
    return
  end
  if self.avatar.unionId ~= 0 and self.avatar.unionId == Activity_LuoLanSiegeData.holdUnionId then
    self.mTitle:BeginTitle()
    if self.avatar.unionPosition == WarAllianceMemberType.Leader then
      self.mTitle:PushIcon(HUDTitleStyle.TeamIcon, CS.Framework.HudSetting.Instance.m_nSiege_defBig)
    else
      self.mTitle:PushIcon(HUDTitleStyle.TeamIcon, CS.Framework.HudSetting.Instance.m_nSiege_def)
    end
    self.mTitle:EndTitle()
  end
end

function PlayerHead:SetActorName()
  self.mTitle:BeginTitle()
  self.HudStyle = self:GetHudStyle()
  local UnionName = self.avatar:GetUnionName()
  local RoleInfo = self.avatar:GetRoleInfo()
  if self.avatar.isMe then
    local nameColor = ColorUtility.ColorToColor32(ERoleNameColor[ERoleAttackType.Peace])
    if RoleInfo.PKMode == ERolePkMode.Team then
      if TeamData.IsTeammate(self.avatar.id) then
        nameColor = ColorUtility.ColorToColor32(ERoleNameColor[ERoleAttackType.Teammate])
      end
    elseif RoleInfo.PKMode == ERolePkMode.Union and ViewData.meData.unionId == self.avatar.unionId then
      nameColor = ColorUtility.ColorToColor32(ERoleNameColor[ERoleAttackType.League])
    end
    if string.isNullOrEmpty(UnionName) then
      self.mTitle:PushCustomColorTitle(self.avatar:GetName(), self.HudStyle, nameColor, 0)
    else
      local PlayerNameStr = self.avatar:GetName()
      local UnionNameStr = tostring("[ " .. UnionName .. " ] ")
      self.mTitle:PushAloneColorTitle(UnionNameStr, PlayerNameStr, HUDTitleStyle.PlayerName, nameColor, Color.yellow)
    end
  else
    local nameColor = ColorUtility.ColorToColor32(ERoleNameColor[ERoleAttackType.Enemy])
    if RoleManager.me.PKMode == ERolePkMode.Peace then
      if self.avatar.evilLevel == EvilRoleType.Level0 then
        nameColor = ColorUtility.ColorToColor32(ERoleNameColor[ERoleAttackType.Peace])
      else
        nameColor = ColorUtility.ColorToColor32(ERoleNameColor[ERoleAttackType.Enemy])
      end
    elseif RoleManager.me.PKMode == ERolePkMode.Team then
      if TeamData.IsTeammate(self.avatar.id) then
        nameColor = ColorUtility.ColorToColor32(ERoleNameColor[ERoleAttackType.Teammate])
      end
    elseif RoleManager.me.PKMode == ERolePkMode.Union then
      if ViewData.meData.unionId == self.avatar.unionId then
        nameColor = ColorUtility.ColorToColor32(ERoleNameColor[ERoleAttackType.League])
      elseif self.avatar.evilLevel == EvilRoleType.Level0 then
        nameColor = ColorUtility.ColorToColor32(Color.orange)
      end
    elseif RoleManager.me.PKMode == ERolePkMode.All then
      if self.avatar.evilLevel ~= EvilRoleType.Level0 then
        nameColor = ColorUtility.ColorToColor32(ERoleEvilNameColor[self.avatar.evilLevel])
      end
    elseif RoleManager.me.PKMode == ERolePkMode.SiegeAttack then
      local holdUnionId = Activity_LuoLanSiegeData.holdUnionId
      if self.avatar.unionId ~= 0 and self.avatar.unionId ~= holdUnionId then
        nameColor = ColorUtility.ColorToColor32(ERoleNameColor[ERoleAttackType.League])
      end
    elseif RoleManager.me.PKMode == ERolePkMode.SiegeDefense then
      if ViewData.meData.unionId == self.avatar.unionId then
        nameColor = ColorUtility.ColorToColor32(ERoleNameColor[ERoleAttackType.League])
      end
    elseif RoleManager.me.PKMode == ERolePkMode.Camp and QuickFind:GetKunShouBattleDataMgr():IsSameCamp(RoleManager.me.id, self.avatar.id) then
      nameColor = ColorUtility.ColorToColor32(ERoleNameColor[ERoleAttackType.League])
    end
    if string.isNullOrEmpty(UnionName) then
      self.mTitle:PushCustomColorTitle(self.avatar:GetName(), self.HudStyle, nameColor, 0)
    else
      local UnionNameStr = tostring("[ " .. UnionName .. " ] ")
      local PlayerNameStr = self.avatar:GetName()
      self.mTitle:PushAloneColorTitle(UnionNameStr, PlayerNameStr, HUDTitleStyle.PlayerName, nameColor, Color.yellow)
    end
  end
  self.mTitle:EndTitle()
  if self.avatar.data.titleData:GetHudResName() then
    self:SetPlayerTitleIconHead(self.avatar.data.titleData:GetHudResName())
  end
end

function PlayerHead:SetPlayerTitleIconHead(param)
  self.mTitle:BeginTitle()
  self.mTitle:PushIcon(HUDTitleStyle.TeamIcon, param)
  self.mTitle:EndTitle()
end

function PlayerHead:InitHP()
  self.mTitle:BeginTitle()
  if self.avatar.isMe then
    self.mTitle:PushBlood(HUDBloodType.Blood_Green, HUDTitleStyle.Blood, 1, self:GetHeight())
  else
    local color = HUDBloodType.Blood_Green
    if RoleManager.me.PKMode == ERolePkMode.All then
      color = HUDBloodType.Blood_Red
    elseif RoleManager.me.PKMode == ERolePkMode.Team then
      if not TeamData.IsTeammate(self.avatar.id) then
        color = HUDBloodType.Blood_Green
      end
    elseif RoleManager.me.PKMode == ERolePkMode.Peace then
      if self.avatar.evilLevel ~= EvilRoleType.Level0 then
        color = HUDBloodType.Blood_Red
      end
    elseif RoleManager.me.PKMode == ERolePkMode.Union then
      if ViewData.meData.unionId == self.avatar.unionId then
        color = HUDBloodType.Blood_Green
      elseif self.avatar.evilLevel ~= EvilRoleType.Level0 then
        color = HUDBloodType.Blood_Red
      end
    elseif RoleManager.me.PKMode == ERolePkMode.SiegeAttack then
      local holdUnionId = Activity_LuoLanSiegeData.holdUnionId
      if self.avatar.unionId ~= 0 and self.avatar.unionId ~= holdUnionId then
        color = HUDBloodType.Blood_Green
      else
        color = HUDBloodType.Blood_Red
      end
    elseif RoleManager.me.PKMode == ERolePkMode.SiegeDefense then
      if ViewData.meData.unionId == self.avatar.unionId then
        color = HUDBloodType.Blood_Green
      else
        color = HUDBloodType.Blood_Red
      end
    elseif RoleManager.me.PKMode == ERolePkMode.Camp then
      if QuickFind:GetKunShouBattleDataMgr():IsSameCamp(RoleManager.me.id, self.avatar.id) then
        color = HUDBloodType.Blood_Green
      else
        color = HUDBloodType.Blood_Red
      end
    end
    self.mTitle:PushBlood(color, HUDTitleStyle.Blood, 1, self:GetHeight())
  end
  self.mTitle:EndTitle()
end
