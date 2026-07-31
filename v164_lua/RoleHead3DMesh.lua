require("GamePlay/Role/Head/HUDStyle")
RoleHead3DMesh = class()

function RoleHead3DMesh:GetBuffAnchor()
  if self.mBuffAnchor == nil then
    self.mBuffAnchor = self.trans:Find("BuffAnchor")
    if self.mBuffAnchor == nil then
      self.mBuffAnchor = CS.UnityEngine.GameObject("BuffAnchor")
      self.mBuffAnchor.transform:SetParent(self.trans, false)
    end
  end
  return self.mBuffAnchor.transform
end

function RoleHead3DMesh:ctor(role)
  self.avatar = role
  self.showName = true
  self.showBlood = true
  self:RefreshData(role)
end

function RoleHead3DMesh:RefreshData(role)
  if role then
    self.avatar = role
    self.mu2Avatar = gameMgr:GetAvatarManager():GetAvatar(AvatarEnum.Player, role.data.id)
  end
  self:ShowHead(self.showName, self.showBlood)
  self:RefreshAngelShieldProgress()
  self:RefreshHPProgress(self.avatar.hp)
  self:RefreshShieldProgress(self.avatar.shield)
  if not self.bloodBgPos then
    self:SetHPBkProgress(self.bloodPos)
  else
    self:SetHPBkProgress(self.bloodBgPos)
  end
  self.scaleRatio = self.avatar.id == ViewData.meData.id and 0.8 or 1
  self:RefreshFourPartyRivalryCampFlagIcon()
end

function RoleHead3DMesh:ShowHead(showName, showHP)
  self:Destroy()
  if self.trans == nil then
    self.gameObj = CS.Framework.ResourceManager.Instantiate("HUD/toplogoPlayer.prefab", Vector3(0, HUDSetting.YOffset, 0), HUDSetting.Rotation, self.avatar.transform)
    self.trans = self.gameObj.transform
  end
  if self.nameLabel == nil then
    self.nameLabel = self.trans:Find("Label", typeof(CS.CSLabel))
    self.nameLabel.transform:SetLocalPosition(0, 0.13, 0)
  end
  if self.areaNameLabel == nil then
    self.areaNameLabel = self.trans:Find("LabelAreaName", typeof(CS.CSLabel))
    self.areaNameLabel.transform:SetLocalPosition(0, 0.13, 0)
  end
  self.areaNameLabel.gameObject:SetActive(false)
  if self.labelCountDown == nil then
    self.labelCountDownBg = self.trans:Find("LabelCountDownBg")
    self.labelCountDown = self.trans:Find("LabelCountDown", typeof(CS.CSLabel))
    self.countDownPositionY = HUDSetting.LabelCountDown + self:GetHeight()
  end
  self.labelCountDownBg.gameObject:SetActive(false)
  self.labelCountDown.gameObject:SetActive(false)
  if self.hp == nil then
    self.hp = self.trans:Find("SpriteMesh-hp", typeof(CS.CSSpriteMesh))
    self.hpLayer2 = self.hp.transform:Find("hpbg", typeof(CS.CSSpriteMesh))
  end
  if self.shield == nil then
    self.shield = self.trans:Find("SpriteMesh-shield", typeof(CS.CSSpriteMesh))
    self.shieldLayer2 = self.shield.transform:Find("shieldbg", typeof(CS.CSSpriteMesh))
  end
  if self.title == nil then
    self.title = self.trans:Find("Title", typeof(CS.CSSpriteMesh))
  end
  if self.icon1 == nil then
    self.icon1 = self.trans:Find("Icon1", typeof(CS.CSSpriteMesh))
    self.icon1.gameObject:SetActive(false)
    self.icon1PositionY = HUDSetting.IconInitY + self:GetHeight()
  end
  if self.campIcon == nil then
    self.campIcon = self.trans:Find("Camp", typeof(CS.CSSpriteMesh))
    self.campIcon.gameObject:SetActive(false)
  end
  if self.avatar.data.rideMount and (not self.avatar:IsCurSafeZone() or self.avatar.data.rideMount.cityride == 1) and self.avatar:IsNowMapNotHorse() then
    self.trans:SetLocalPosition(0, HUDSetting.YOffset + 0.5 + self:GetHeight(), 0)
  else
    self.trans:SetLocalPosition(0, HUDSetting.YOffset + self:GetHeight(), 0)
  end
  self.gameObj:SetActive(self:JudgeShowHead(true))
  if showHP then
    self:InitHP()
  else
    self.hp.gameObject:SetActive(false)
  end
  if self.shield ~= nil then
    self.shield.gameObject:SetActive(self:JudgeShowHead(showHP) and self.avatar.shield and self.avatar.data.hasShield)
  end
  if showName then
    self:SetActorName()
  end
end

function RoleHead3DMesh:JudgeShowHead(showHead)
  if RedFortData.InRedFortActivity then
    return false
  end
  if self.avatar ~= nil and self.avatar.CloakingState ~= nil and RoleManager.me ~= nil and self.avatar.id ~= RoleManager.me.id and self.avatar.CloakingState == true then
    return false
  end
  return showHead
end

local offsetPos = Vector3.zero

function RoleHead3DMesh:Update()
  if self.bloodPos ~= self.bloodBgPos then
    if self.bloodPos < self.bloodBgPos then
      local initHpPercent = self.bloodBgPos
      initHpPercent = initHpPercent - 0.5 * Time.deltaTime
      self:SetHPBkProgress(initHpPercent)
    else
      self:SetHPBkProgress(self.bloodPos)
    end
  end
  if self.shieldPos and self.shieldBgPos and self.shieldPos ~= self.shieldBgPos then
    if self.shieldPos < self.shieldBgPos then
      local initShieldPercent = self.shieldBgPos
      initShieldPercent = initShieldPercent - 0.5 * Time.deltaTime
      self:SetShieldBkProgress(initShieldPercent)
    else
      self:SetShieldBkProgress(self.shieldPos)
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
      local go
      if isDead then
        go = CS.Framework.ResourceManager.Instantiate("HUD/SpriteMeshAtlasLabel.prefab", Vector3.unity_vector3.zero, HUDSetting.Rotation, RoleManager.damageRoot)
        local rolePos = self.avatar.transform.position
        offsetPos:Set(rolePos.x, rolePos.y + self.index * 0.35, rolePos.z)
      else
        go = CS.Framework.ResourceManager.Instantiate("HUD/SpriteMeshAtlasLabel.prefab", Vector3.unity_vector3.zero, HUDSetting.Rotation, self.avatar.transform)
        offsetPos:Set(0, self.index * 0.35, 0)
      end
      local damageAnim = go:GetComponent(typeof(CS.CSSpriteDamageLabel))
      local hpValue = hpStruct.deltaHp
      if hpStruct.hudType == HUDNumberRenderType.HUB_SHOW_DODGE then
        hpValue = "a"
      elseif hpStruct.hudType == HUDNumberRenderType.HUB_SHOW_DODGE_Role then
        hpValue = "b"
      elseif hpStruct.hudType == HUDNumberRenderType.HUD_SHOW_SkILLDODGE then
        hpValue = "e"
      elseif hpStruct.hudType == HUDNumberRenderType.HUD_SHOW_MENGJI then
        hpValue = "m"
      elseif hpStruct.combo then
        hpValue = string.format("d%s", hpValue)
      end
      damageAnim:StartPlay(hpStruct.hudType, hpValue .. "", offsetPos, self.scaleRatio)
      self.index = self.index + 1
      hpTbl.hpInfos[hpTbl.curIndex] = nil
    end
  end
end

function RoleHead3DMesh:ComputeTitlePos()
  if self.icon1 ~= nil and self.icon1.enabled then
    if self.titleData ~= nil then
      self.icon1PositionY = HUDSetting.IconInitY + self.titleData.height
    else
      self.icon1PositionY = HUDSetting.IconInitY
    end
    self.icon1.transform:SetLocalPosition(0, self.icon1PositionY, 0)
  end
  if self.labelCountDown and self.labelCountDown.enabled then
    local bgPosY = 0.4
    if self.titleData ~= nil then
      self.countDownPositionY = 1.05
      bgPosY = 1.12
    else
      self.countDownPositionY = 0.35
      bgPosY = 0.42
    end
    self.labelCountDownBg.transform:SetLocalPosition(0, bgPosY, 0.01)
    self.labelCountDown.transform:SetLocalPosition(0, self.countDownPositionY, 0)
  end
end

function RoleHead3DMesh:GetHPProgress(rate)
  return rate
end

function RoleHead3DMesh:RefreshHPProgress(hp)
  if self.hp ~= nil and self.showBlood then
    self.bloodPos = Mathf.Clamp01(self:GetHPProgress(hp / self.avatar.maxHp))
    self.hp.fillAmount = self.bloodPos
  end
end

function RoleHead3DMesh:SetHPBkProgress(pos)
  if self.hpLayer2 ~= nil and self.showBlood then
    self.bloodBgPos = pos
    self.hpLayer2.fillAmount = self.bloodBgPos
  end
end

function RoleHead3DMesh:RefreshShieldProgress(shield)
  if self.otherShieldState then
    return
  end
  if shield then
    if self.shield ~= nil and self.showBlood and self.avatar.data.hasShield then
      self.shieldPos = self:GetHPProgress(shield / self.avatar.maxShield)
      self.shield.fillAmount = self.shieldPos
      self.shield.gameObject:SetActive(true)
      if self.avatar.maxShield ~= self.shieldBgPos then
        self:SetShieldBkProgress(self.shieldPos)
      end
    else
      self.shield.gameObject:SetActive(false)
    end
  end
end

function RoleHead3DMesh:RefreshAngelShieldProgress()
  if self.shield ~= nil and self.showBlood and self.mu2Avatar then
    local shieldDataMgr = self.mu2Avatar:GetShieldDataMgr()
    if shieldDataMgr then
      local shieldInfo = shieldDataMgr:GetShieldData()
      if shieldInfo ~= nil then
        local curPos = self:GetHPProgress(shieldInfo.value / shieldInfo.maxValue)
        self.shieldPos = curPos
        self.shield.fillAmount = self.shieldPos
        self.shield.gameObject:SetActive(shieldInfo.value > 0)
        self.hp.gameObject:SetActive(shieldInfo.value <= 0)
        if shieldInfo.maxValue ~= self.shieldBgPos then
          self:SetShieldBkProgress(self.shieldPos)
        end
        self.otherShieldState = shieldInfo.value > 0
        if shieldInfo.value <= 0 then
          self:RefreshShieldProgress(self.avatar.shield)
        end
        return
      end
    end
  end
  self.otherShieldState = false
  self.shield.gameObject:SetActive(false)
  self.hp.gameObject:SetActive(self.showBlood)
end

function RoleHead3DMesh:SetShieldBkProgress(pos)
  if self.shieldLayer2 ~= nil and self.showBlood then
    self.shieldBgPos = pos
    self.shieldLayer2.fillAmount = self.shieldBgPos
  end
end

function RoleHead3DMesh:InitComponent()
  self.mHpFillAmount = 0
  self.mHpTargetFillAmount = 0
  self.isNeedUpdataListener = true
  self.mSmoothHpTargetFillAmount = 0
  self.tweenDuringTime = 1.5
end

function RoleHead3DMesh:GetHudStyle()
  return HUDTitleStyle.PlayerName
end

function RoleHead3DMesh:SetActorName()
  self.nameLabel.text = self.avatar:GetName()
end

function RoleHead3DMesh:SetTopDialog(content, existTime)
end

function RoleHead3DMesh:DelayHideTopDialog(existTime)
  Coroutine.Wait(existTime)
  if self.hideTopDialogCoroutine then
    StopCoroutine(self.hideTopDialogCoroutine)
  end
end

function RoleHead3DMesh:UpdateHpPosInMap()
end

function RoleHead3DMesh:UpdateHpValue()
end

function RoleHead3DMesh:InitHP()
end

function RoleHead3DMesh:GetHeight()
  return 0
end

function RoleHead3DMesh:ShowOrHideHpHead(isShow)
  if self.trans ~= nil then
    self.trans.gameObject:SetActive(self:JudgeShowHead(isShow))
  end
end

function RoleHead3DMesh:PlayText(str, textType)
end

function RoleHead3DMesh:InitAttribute()
end

function RoleHead3DMesh:GetHeadTopOffset()
  return 0
end

function RoleHead3DMesh:Destroy()
  if self.gameObj ~= nil then
    if self.nameLabel ~= nil then
      self.nameLabel.rightIndex = 0
    end
    CS.Framework.ResourceManager.Recycle(self.gameObj)
    self.gameObj = nil
    self.trans = nil
    self.hp = nil
    self.title = nil
    self.nameLabel = nil
    self.icon1 = nil
    self.campIcon = nil
    self.titles = nil
    self.hpLayer2 = nil
    self.mBuffAnchor = nil
  end
end

function RoleHead3DMesh:ShowBlood(isShow)
  if self.hp ~= nil then
    self.showBlood = self:JudgeShowHead(isShow)
    self.hp.gameObject:SetActive(self.showBlood)
  end
  if self.shield ~= nil then
    self.shield.gameObject:SetActive(self:JudgeShowHead(isShow) and self.avatar.shield and self.avatar.data.hasShield)
  end
  self.trans = nil
  self.hp = nil
  self.nameLabel = nil
end

function RoleHead3DMesh:RefreshFourPartyRivalryCampFlagIcon()
  if self.fourPartyRivalryCampIcon == nil then
    self.fourPartyRivalryCampIcon = self.trans:Find("FourPartyRivalryCamp", typeof(CS.CSSpriteMesh))
  end
  if self.fourPartyRivalryFlagIcon == nil then
    self.fourPartyRivalryFlagIcon = self.trans:Find("FourPartyRivalryFlag", typeof(CS.CSSpriteMesh))
  end
  if self.fourPartyRivalryReviveIcon == nil then
    self.fourPartyRivalryReviveIcon = self.trans:Find("FourPartyRivalryRevive", typeof(CS.CSSpriteMesh))
  end
  self.fourPartyRivalryCampIcon.gameObject:SetActive(false)
  self.fourPartyRivalryFlagIcon.gameObject:SetActive(false)
  self.fourPartyRivalryReviveIcon.gameObject:SetActive(false)
  if not FourPartyRivalryManager:IsEnterFourPartyRivalryMap() then
    return
  end
  local campId = QuickFind:GetSiFangZhengBaDataManager():GetCampIdByAppointUnionId(self.avatar.unionId)
  if campId == nil or campId == 0 then
    return
  end
  local hasFlagBuff = BuffData.GetFirstBuffByType(self.avatar.data.id, FourPartyRivalryConstant.FlagBuffType) ~= nil
  local hasReviveBuff = BuffData.IsHasBuff(self.avatar.data.id, FourPartyRivalryManager.m_ReviveBuffId)
  self:RefreshFourPartyRivalryCampIcon(campId, hasFlagBuff, hasReviveBuff)
  self:RefreshFourPartyRivalryFlagIcon(hasFlagBuff, hasReviveBuff)
  self:RefreshFourPartyRivalryReviveIcon(hasFlagBuff, hasReviveBuff)
end

function RoleHead3DMesh:RefreshFourPartyRivalryCampIcon(_campId, _hasFlagBuff, _hasReviveBuff)
  if _campId == nil then
    return
  end
  local config = ClientTable.cfg_Activity_sifangCampManager:TryGetValue(_campId)
  if config == nil or string.isNullOrEmpty(config.topplayerImage) then
    return
  end
  self.fourPartyRivalryCampIcon.SpriteName = config.topplayerImage
  self.fourPartyRivalryCampIcon.gameObject:SetActive(true)
  if not _hasFlagBuff and not _hasReviveBuff then
    self.fourPartyRivalryCampIcon.transform:SetLocalPosition(0, 0.6, 0)
  elseif _hasFlagBuff and _hasReviveBuff then
    self.fourPartyRivalryCampIcon.transform:SetLocalPosition(-0.4, 0.6, 0)
  else
    self.fourPartyRivalryCampIcon.transform:SetLocalPosition(-0.2, 0.6, 0)
  end
end

function RoleHead3DMesh:RefreshFourPartyRivalryFlagIcon(_hasFlagBuff, _hasReviveBuff)
  if not _hasFlagBuff then
    return
  end
  self.fourPartyRivalryFlagIcon.gameObject:SetActive(true)
  if _hasReviveBuff then
    self.fourPartyRivalryFlagIcon.transform:SetLocalPosition(0, 0.6, 0)
  else
    self.fourPartyRivalryFlagIcon.transform:SetLocalPosition(0.2, 0.6, 0)
  end
end

function RoleHead3DMesh:RefreshFourPartyRivalryReviveIcon(_hasFlagBuff, _hasReviveBuff)
  if not _hasReviveBuff then
    return
  end
  self.fourPartyRivalryReviveIcon.gameObject:SetActive(true)
  if _hasFlagBuff then
    self.fourPartyRivalryReviveIcon.transform:SetLocalPosition(0.4, 0.6, 0)
  else
    self.fourPartyRivalryReviveIcon.transform:SetLocalPosition(0.2, 0.6, 0)
  end
end
