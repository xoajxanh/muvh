require("GamePlay/Role/Head/HUDStyle")
RoleHead = class()

function RoleHead:ctor(role)
  self.avatar = role
  self.showName = true
  self.showBlood = true
  self:RefreshData(role)
end

function RoleHead:RefreshData(role)
  if role then
    self.avatar = role
  end
  self:ShowHead(self.showName, self.showBlood)
  self:RefreshHPProgress(self.avatar.hp)
  self:RefreshShieldProgress(self.avatar.shield)
  if not self.bloodBgPos then
    self:SetHPBkProgress(self.bloodPos)
  else
    self:SetHPBkProgress(self.bloodBgPos)
  end
  if not self.shieldBgPos then
    self:SetShieldBkProgress(self.shieldBgPos)
  else
    self:SetShieldBkProgress(self.shieldPos)
  end
  self.scaleRatio = self.avatar.id == ViewData.meData.id and 0.8 or 1
end

function RoleHead:ShowHead(showName, showHP)
  self:Destroy()
  if not self.mTitleIns then
    self.mTitleIns = CS.Framework.HUDTitleInfo.HUDTitleRender.Instance:RegisterTitle(self.avatar.transform, 1.8, self.avatar.isMe)
  end
  self.mTitle = CS.Framework.HUDTitleInfo.HUDTitleRender.Instance:GetTitle(self.mTitleIns)
  self.mTitle:Clear()
  if self.avatar.data.rideMount and (not self.avatar:IsCurSafeZone() or self.avatar.data.rideMount.cityride == 1) then
    self.mTitle:SetOffsetY(0.5)
  else
    self.mTitle:SetOffsetY(0)
  end
  self.mTitle:ShowTitle(self:JudgeShowHead(true))
  if showHP then
    self:InitHP()
  end
  if showName then
    self:SetActorName()
  end
end

function RoleHead:JudgeShowHead(showHead)
  if RedFortData.InRedFortActivity then
    return false
  end
  return showHead
end

function RoleHead:Update()
  if self.bloodPos ~= self.bloodBgPos then
    if self.bloodPos < self.bloodBgPos then
      local initHpPercent = self.bloodBgPos
      initHpPercent = initHpPercent - 0.5 * Time.deltaTime
      self:SetHPBkProgress(initHpPercent)
    else
      self:SetHPBkProgress(self.bloodPos)
    end
  end
  local hpTbl = HPData.hpDic[self.avatar.id]
  if hpTbl == nil then
    return
  end
  if hpTbl.curIndex == hpTbl.totalCount then
    hpTbl.curIndex = 0
    hpTbl.totalCount = 0
    return
  end
  if self.c == nil then
    self.c = 0
    return
  end
  if self.c < 5 then
    self.c = self.c + 1
  else
    self.c = 0
    self.index = 0
    for i = hpTbl.curIndex + 1, hpTbl.totalCount do
      hpTbl.curIndex = i
      local hpStruct = hpTbl.hpInfos[hpTbl.curIndex]
      local isDead = 0 >= self.avatar.hp
      CS.Framework.HUDNumberRender.Instance:AddHudNumber(self.avatar.transform, hpStruct.hudType, hpStruct.deltaHp, true, false, false, Vector3(0, self.index * 0.35, 0), isDead, self.scaleRatio)
      self.index = self.index + 1
      hpTbl.hpInfos[hpTbl.curIndex] = nil
    end
  end
end

function RoleHead:GetHPProgress(rate)
  return rate
end

function RoleHead:RefreshHPProgress(hp)
  if self.mTitle ~= nil and self.showBlood then
    self.bloodPos = self:GetHPProgress(hp / self.avatar.maxHp)
    self.mTitle:SetBloodPos(self.bloodPos)
  end
end

function RoleHead:SetHPBkProgress(pos)
  if self.mTitle ~= nil and self.showBlood then
    self.bloodBgPos = pos
    self.mTitle:SetBloodTimeBkPos(self.bloodBgPos)
  end
end

function RoleHead:RefreshShieldProgress(shield)
  if self.mTitle ~= nil and self.showBlood and shield and self.avatar.data.hasShield then
    self.shieldPos = self:GetHPProgress(shield / self.avatar.maxShield)
    self.mTitle:SetBloodPos(self.shieldPos)
  end
end

function RoleHead:SetShieldBkProgress(pos)
  if self.mTitle ~= nil and self.showBlood then
    self.shieldBgPos = pos
    self.mTitle:SetBloodTimeBkPos(self.shieldBgPos)
  end
end

function RoleHead:InitComponent()
  self.mHpFillAmount = 0
  self.mHpTargetFillAmount = 0
  self.isNeedUpdataListener = true
  self.mSmoothHpTargetFillAmount = 0
  self.tweenDuringTime = 1.5
end

function RoleHead:GetHudStyle()
  return HUDTitleStyle.PlayerName
end

function RoleHead:SetActorName()
  self.mTitle:BeginTitle()
  self.HudStyle = self:GetHudStyle()
  self.mTitle:PushTitle(self.avatar:GetName(), self.HudStyle, self:GetHeight())
  self.mTitle:EndTitle()
end

function RoleHead:SetTopDialog(content, existTime)
end

function RoleHead:DelayHideTopDialog(existTime)
  Coroutine.Wait(existTime)
  if self.hideTopDialogCoroutine then
    StopCoroutine(self.hideTopDialogCoroutine)
  end
end

function RoleHead:UpdateHpPosInMap()
end

function RoleHead:UpdateHpValue()
end

function RoleHead:InitHP()
end

function RoleHead:GetHeight()
  return 0
end

function RoleHead:ShowOrHideHpHead(isShow)
  if self.mTitle then
    self.mTitle:ShowTitle(self:JudgeShowHead(isShow))
  end
end

function RoleHead:PlayText(str, textType)
end

function RoleHead:InitAttribute()
end

function RoleHead:GetHeadTopOffset()
  return 0
end

function RoleHead:Destroy()
  if self.mTitleIns ~= nil then
    CS.Framework.HUDTitleInfo.HUDTitleRender.Instance:ReleaseTitle(self.mTitleIns)
    self.mTitleIns = nil
  end
  self.mTitle = nil
end

function RoleHead:ShowBlood(isShow)
  if self.mTitle then
    self.mTitle:ShowBloodTitle(self:JudgeShowHead(isShow))
  end
end
