local RoleCircleEffectShowRule = {}

function RoleCircleEffectShowRule:GetEffectTypeByRule(role)
  if role == nil or role.data == nil then
    return ERoleCircleEffectType.None
  end
  if role.data.roleType == ERoleType.Player then
    return self:GetEffectTypeByPlayer(role)
  end
end

function RoleCircleEffectShowRule:GetEffectTypeByPlayer(role)
  if role == nil or role.CloakingState then
    return ERoleCircleEffectType.None
  end
  local type = self:GetAppearCircleEffectType(role.id)
  if type ~= ERoleCircleEffectType.None then
    return type
  elseif self:CheckHolyRingCircleEffect(role) and not role:CheckReturnLoadReinEffect() then
    return ERoleCircleEffectType.HolyRing
  elseif self:CheckViewRoleHolyRingCircleEffect(role) then
    return ERoleCircleEffectType.ViewRoleHolyRing
  elseif self:CheckReinCircleEffect(role) and not role:CheckReturnLoadReinEffect() then
    return ERoleCircleEffectType.Rein
  end
  return ERoleCircleEffectType.None
end

function RoleCircleEffectShowRule:GetAppearCircleEffectType(rid)
  local appearData = ForgeData.appearData[rid]
  if appearData and appearData.roleCircle then
    return tonumber(appearData.roleCircle)
  end
  return ERoleCircleEffectType.None
end

function RoleCircleEffectShowRule:CheckHolyRingCircleEffect(role)
  if role == nil then
    return false
  end
  local holyRingTbl
  if RoleManager.me and role.id == RoleManager.me.id then
    local avatar = gameMgr:GetAvatarManager():GetMainPlayer()
    if avatar == nil or avatar:GetHolyRingDataMgr() == nil then
      return false
    end
    local state
    state, holyRingTbl = avatar:GetHolyRingDataMgr():GetWearStateAndMap()
    return state
  elseif not role.isViewRole then
    local avatar = gameMgr:GetAvatarManager():GetAvatar(AvatarEnum.Player, role.id)
    if avatar == nil or avatar:GetHolyRingDataMgr() == nil then
      return false
    end
    holyRingTbl = avatar:GetHolyRingDataMgr():GetOtherWearHolyRingTab()
  end
  return holyRingTbl and table.count(holyRingTbl) > 0
end

function RoleCircleEffectShowRule:CheckViewRoleHolyRingCircleEffect(role)
  return role.holyRingTbl and table.count(role.holyRingTbl) > 0
end

function RoleCircleEffectShowRule:CheckReinCircleEffect(role)
  return role:GetRoleLevelRein() > 0
end

function RoleCircleEffectShowRule:GetEffectTypeByMonster(role)
end

return RoleCircleEffectShowRule
