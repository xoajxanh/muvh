PlayerHead3DMesh = class(RoleHead3DMesh)

function PlayerHead3DMesh:ctor(role)
  self.hideTime = nil
  self.showBlood = false
  self.killMonsterSecond = nil
  RoleHead3DMesh.ctor(self, role)
  self:ShowBlood(false)
end

function PlayerHead3DMesh:RefreshData(role)
  self.HudStyle = self:GetHudStyle()
  self:RefreshMu2AvatarInfo(role)
  RoleHead3DMesh.RefreshData(self, role)
  self:SetSiegeAttackState()
  self:SetSiegeDefenceState()
  self:SetKillMonsterCountDown()
  self:InitBoxComponent()
  self:InitBoxView()
  self:InitRankComponent()
  self:InitRankView()
end

function PlayerHead3DMesh:RefreshMu2AvatarInfo(role)
  if role.id then
    local mu2Avatar = gameMgr:GetAvatarManager():GetAvatar(AvatarEnum.Player, role.id)
    if mu2Avatar then
      self.mu2AvatarInfo = mu2Avatar:GetInfo()
    end
  else
    self.mu2AvatarInfo = nil
  end
end

function PlayerHead3DMesh:Update()
  RoleHead3DMesh.Update(self)
  if self.showBlood ~= false and self.hideTime and self.hideTime < Time.GetServerTime() then
    self:ShowBlood(false)
    self.hideTime = nil
  end
  self:UpdateKillMonsterCountDown()
  self:DelayUpdateBoxCountDown()
end

function PlayerHead3DMesh:ShowBlood(isShow)
  if self.hp ~= nil then
    self.showBlood = isShow
    self:RefreshData(self.avatar)
  end
end

function PlayerHead3DMesh:ShowBloodActive()
  self.hideTime = Time.GetServerTime() + 5000
  if not self.showBlood then
    self:ShowBlood(true)
  end
end

function PlayerHead3DMesh:SetTitleActive(isShow)
  if self.trans ~= nil then
    self.trans.gameObject:SetActive(self:JudgeShowHead(isShow))
  end
end

function PlayerHead3DMesh:SetTeamLeaderState(isShow)
end

function PlayerHead3DMesh:SetSiegeAttackState()
  if not Activity_LuoLanSiegeData.IsActivityOpen() then
    return
  end
  if self.avatar.unionId == 0 or self.avatar.unionId ~= Activity_LuoLanSiegeData.holdUnionId then
    if self.avatar.unionPosition == WarAllianceMemberType.Leader then
      self.icon1.SpriteName = HUDSetting.Sprites.siege_atkBig.res
    else
      self.icon1.SpriteName = HUDSetting.Sprites.siege_atk.res
    end
    self.icon1.gameObject:SetActive(true)
    self:ComputeTitlePos()
  end
end

function PlayerHead3DMesh:SetSiegeDefenceState()
  if not Activity_LuoLanSiegeData.IsActivityOpen() then
    return
  end
  if self.avatar.unionId ~= 0 and self.avatar.unionId == Activity_LuoLanSiegeData.holdUnionId then
    if self.avatar.unionPosition == WarAllianceMemberType.Leader then
      self.icon1.SpriteName = HUDSetting.Sprites.siege_defBig.res
    else
      self.icon1.SpriteName = HUDSetting.Sprites.siege_def.res
    end
    self.icon1.gameObject:SetActive(true)
    self:ComputeTitlePos()
  end
end

function PlayerHead3DMesh:SetKillMonsterCountDown()
  if self.avatar.isMe then
    if KillMonsterCardData.IsOpenState() and self.labelCountDown ~= nil then
      local surplusTime = KillMonsterCardData.surplusTime
      local intervalTime = surplusTime - Time.GetServerTime()
      local intervalTimeSecond = Mathf.Floor(intervalTime / 1000)
      if intervalTimeSecond <= 0 then
        return
      end
      local countTime = TimeUtility.ShowTimeHour(intervalTimeSecond)
      self.labelCountDown.text = string.format("\196\144ang Th\225\187\167 H\225\187\153 %s", countTime)
      if not self.labelCountDown.gameObject.activeSelf then
        self.labelCountDown.gameObject:SetActive(true)
        self.labelCountDownBg.gameObject:SetActive(true)
        self.killMonsterSecond = nil
      end
      self:ComputeTitlePos()
    end
  else
    local countDownTime = self.avatar:GetProtectTIme()
    local intervalTime = 0
    if countDownTime ~= nil then
      intervalTime = countDownTime - Time.GetServerTime()
    else
      print("\233\148\153\232\175\175\239\188\129\239\188\129\239\188\129 countDownTime==nil")
    end
    if intervalTime <= 0 then
      return
    end
    local intervalTimeSecond = Mathf.Floor(intervalTime / 1000)
    local countTime = TimeUtility.ShowTimeHour(intervalTimeSecond)
    self.labelCountDown.text = string.format("\196\144ang Th\225\187\167 H\225\187\153 %s", countTime)
    if not self.labelCountDown.gameObject.activeSelf then
      self.labelCountDown.gameObject:SetActive(true)
      self.labelCountDownBg.gameObject:SetActive(true)
      self.killMonsterSecond = nil
    end
    self:ComputeTitlePos()
  end
end

function PlayerHead3DMesh:UpdateKillMonsterCountDown()
  if self.avatar.isMe then
    if not KillMonsterCardData.IsOpenState() then
      return
    end
  elseif not self.avatar:GetProtectTIme() or self.avatar:GetProtectTIme() <= 0 then
    return
  end
  local countDownTime = self.avatar.isMe and KillMonsterCardData.GetSurplusTimeInterval() or self.avatar:GetProtectTIme()
  if not countDownTime then
    return
  end
  local intervalTime = countDownTime - Time.GetServerTime()
  if intervalTime <= 0 then
    self.killMonsterSecond = nil
    if self.labelCountDown.gameObject.activeSelf then
      self.labelCountDown.gameObject:SetActive(false)
      self.labelCountDownBg.gameObject:SetActive(false)
      self:ComputeTitlePos()
    end
    return
  end
  local killMonsterSecond = Mathf.Floor(intervalTime / 1000)
  if not self.killMonsterSecond or self.killMonsterSecond - killMonsterSecond >= 1 then
    self.killMonsterSecond = killMonsterSecond
    local countTime = TimeUtility.ShowTimeHour(self.killMonsterSecond)
    self.labelCountDown.text = string.format("\196\144ang Th\225\187\167 H\225\187\153 %s", countTime)
  end
  if self.labelCountDownBg ~= nil then
    self.labelCountDownBg:SetLocalScale(self.labelCountDown.halfWidth / 62.5, 1, 1)
  end
  if not self.labelCountDown.gameObject.activeSelf then
    self.labelCountDown.gameObject:SetActive(true)
    self.labelCountDownBg.gameObject:SetActive(true)
    self:ComputeTitlePos()
  end
end

function PlayerHead3DMesh:SetActorName()
  self.HudStyle = self:GetHudStyle()
  local UnionName = self.avatar:GetUnionName()
  local RoleInfo = self.avatar:GetRoleInfo()
  self.nameLabel.transform:SetLocalPosition(0, 0.13, 0)
  self.areaNameLabel.transform:SetLocalPosition(0, 0.13, 0)
  if self.avatar.isMe then
    local nameColor = ERoleNameColor[ERoleAttackType.Peace]
    if RoleInfo.PKMode == ERolePkMode.Team then
      if TeamData.IsTeammate(self.avatar.id) then
        nameColor = ERoleNameColor[ERoleAttackType.Teammate]
      end
    elseif RoleInfo.PKMode == ERolePkMode.Union or RoleInfo.PKMode == ERolePkMode.SiegeAttack or RoleInfo.PKMode == ERolePkMode.SiegeDefense or RoleInfo.PKMode == ERolePkMode.Camp then
      nameColor = ERoleNameColor[ERoleAttackType.League]
    elseif RoleInfo.PKMode == ERolePkMode.UnionKuaFu then
      nameColor = ERoleNameColor[ERoleAttackType.LeagueKuaFu]
    elseif RoleInfo.PKMode == ERolePkMode.Peace then
      if self.avatar.evilLevel ~= EvilRoleType.Level0 then
        nameColor = ERoleEvilNameColor[self.avatar.evilLevel]
      end
    elseif RoleInfo.PKMode == ERolePkMode.All and self.avatar.evilLevel ~= EvilRoleType.Level0 then
      nameColor = ERoleEvilNameColor[self.avatar.evilLevel]
    end
    if SceneData.IsCrossRealm() then
      if not string.isNullOrEmpty(UnionName) then
        self.areaNameLabel.gameObject:SetActive(true)
        local UnionNameStr = tostring("[ " .. UnionName .. " ] ")
        self.areaNameLabel.text = UnionNameStr
        self.areaNameLabel.color = Color.yellow
        local PlayerNameStr = self.avatar:GetName()
        self.nameLabel:SetTwoColTex(string.format("S%d.", self.avatar.serverId), PlayerNameStr, Color.white, nameColor)
        self.nameLabel:Fill()
        self.areaNameLabel:Fill()
        self.nameLabel.transform:SetLocalPosition(self.areaNameLabel.halfWidth * 0.01, 0.13, 0)
        self.areaNameLabel.transform:SetLocalPosition(-self.nameLabel.halfWidth * 0.01, 0.13, 0)
      else
        local PlayerNameStr = self.avatar:GetName()
        self.nameLabel:SetTwoColTex(string.format("S%d.", self.avatar.serverId), PlayerNameStr, Color.white, nameColor)
      end
    elseif string.isNullOrEmpty(UnionName) then
      self.nameLabel.text = self.avatar:GetName()
      self.nameLabel.color = nameColor
    else
      local PlayerNameStr = self.avatar:GetName()
      local UnionNameStr = tostring("[ " .. UnionName .. " ] ")
      self.nameLabel:SetTwoColTex(UnionNameStr, PlayerNameStr, Color.yellow, nameColor)
    end
  else
    local nameColor = ERoleHudColor[ERoleAttackType.Enemy]
    local isEnemyUnion = WarAllianceUtility.IsEnemyUnion(self.avatar)
    local unionColor = Color.yellow
    if RoleManager.me.PKMode == ERolePkMode.Peace then
      if self.avatar.evilLevel == EvilRoleType.Level0 then
        if isEnemyUnion then
          if SceneData.IsCrossRealm() and CampController.IsSameCamp(self.avatar.unionCamp) then
            nameColor = ERoleHudColor[ERoleAttackType.Peace]
          else
            nameColor = ERoleHudColor[ERoleAttackType.Enemy]
          end
        else
          nameColor = ERoleHudColor[ERoleAttackType.Peace]
        end
      else
        nameColor = ERoleHudColor[ERoleAttackType.Enemy]
      end
    elseif RoleManager.me.PKMode == ERolePkMode.Team then
      if TeamData.IsTeammate(self.avatar.id) then
        nameColor = ERoleHudColor[ERoleAttackType.Teammate]
      elseif self.avatar.evilLevel == EvilRoleType.Level0 then
        nameColor = isEnemyUnion and ERoleHudColor[ERoleAttackType.Enemy] or Color.orange
      elseif self.avatar.evilLevel ~= EvilRoleType.Level0 then
        nameColor = ERoleHudColor[ERoleAttackType.Enemy]
      end
    elseif RoleManager.me.PKMode == ERolePkMode.Union then
      if ViewData.meData.unionId == self.avatar.unionId then
        nameColor = ERoleHudColor[ERoleAttackType.League]
      elseif self.avatar.evilLevel == EvilRoleType.Level0 then
        nameColor = isEnemyUnion and ERoleHudColor[ERoleAttackType.Enemy] or Color.orange
      elseif self.avatar.evilLevel ~= EvilRoleType.Level0 then
        nameColor = ERoleHudColor[ERoleAttackType.Enemy]
      end
      if QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi() == true and ViewData.meData.unionId ~= self.avatar.unionId then
        nameColor = Color.red
      end
    elseif RoleManager.me.PKMode == ERolePkMode.UnionKuaFu then
      if ViewData.meData.unionCamp == self.avatar.unionCamp then
        nameColor = ERoleHudColor[ERoleAttackType.LeagueKuaFu]
      elseif self.avatar.evilLevel == EvilRoleType.Level0 then
        nameColor = isEnemyUnion and ERoleHudColor[ERoleAttackType.Enemy] or Color.orange
      elseif self.avatar.evilLevel ~= EvilRoleType.Level0 then
        nameColor = ERoleHudColor[ERoleAttackType.Enemy]
      end
    elseif RoleManager.me.PKMode == ERolePkMode.All then
      if self.avatar.evilLevel ~= EvilRoleType.Level0 then
        nameColor = ERoleHudColor[ERoleAttackType.Enemy]
      elseif self.avatar.evilLevel == EvilRoleType.Level0 then
        nameColor = ERoleHudColor[ERoleAttackType.Enemy]
      end
    elseif RoleManager.me.PKMode == ERolePkMode.SiegeAttack then
      local holdUnionId = Activity_LuoLanSiegeData.holdUnionId
      if self.avatar.unionId ~= 0 and self.avatar.unionId ~= holdUnionId then
        nameColor = ERoleHudColor[ERoleAttackType.League]
      end
    elseif RoleManager.me.PKMode == ERolePkMode.SiegeDefense then
      if ViewData.meData.unionId == self.avatar.unionId then
        nameColor = ERoleHudColor[ERoleAttackType.League]
      end
    elseif RoleManager.me.PKMode == ERolePkMode.Camp and (QuickFind:GetKunShouBattleDataMgr():IsSameCamp(RoleManager.me.id, self.avatar.id) or self.avatar:IsSameCamp()) then
      nameColor = ERoleHudColor[ERoleAttackType.League]
    end
    if SceneData.IsCrossRealm() then
      if not string.isNullOrEmpty(UnionName) then
        self.areaNameLabel.gameObject:SetActive(true)
        local UnionNameStr = tostring("[ " .. UnionName .. " ] ")
        self.areaNameLabel.text = UnionNameStr
        self.areaNameLabel.color = Color.yellow
        local PlayerNameStr = self.avatar:GetName()
        self.nameLabel:SetTwoColTex(string.format("S%d.", self.avatar.serverId), PlayerNameStr, Color.white, nameColor)
        self.nameLabel:Fill()
        self.areaNameLabel:Fill()
        self.nameLabel.transform:SetLocalPosition(self.areaNameLabel.halfWidth * 0.01, 0.13, 0)
        self.areaNameLabel.transform:SetLocalPosition(-self.nameLabel.halfWidth * 0.01, 0.13, 0)
      else
        local PlayerNameStr = self.avatar:GetName()
        self.nameLabel:SetTwoColTex(string.format("S%d.", self.avatar.serverId), PlayerNameStr, Color.white, nameColor)
      end
    elseif string.isNullOrEmpty(UnionName) then
      self.nameLabel.text = self.avatar:GetName()
      self.nameLabel.color = nameColor
    else
      local PlayerNameStr = self.avatar:GetName()
      local UnionNameStr = tostring("[ " .. UnionName .. " ] ")
      self.nameLabel:SetTwoColTex(UnionNameStr, PlayerNameStr, unionColor, nameColor)
    end
  end
  local campIcon
  if SceneData.IsCrossRealm() and 0 < self.avatar.unionCamp then
    local config = ClientTable.cfg_Camp_detailManager:TryGetValue(self.avatar.unionCamp)
    if config then
      campIcon = config.icon
    end
  end
  self:SetPlayerCampIconHead(campIcon)
  if self.avatar.data.titleData:GetHudResName() and not SceneData.isHideTitle then
    self:SetPlayerTitleIconHead(self.avatar.data.titleData:GetHudResName())
  else
    self.title.gameObject:SetActive(false)
    self.titleData = nil
    self:RemoveTitleEffect()
  end
  if QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi() == true and ViewData.meData.unionId ~= self.avatar.unionId then
    self.nameLabel.color = Color.red
    self.areaNameLabel.color = Color.red
  end
end

function PlayerHead3DMesh:SetPlayerCampIconHead(param)
  if self.campIcon == nil then
    return
  end
  if self.areaNameLabel == nil then
    return
  end
  if param then
    self.campIcon.gameObject:SetActive(true)
    self.campIcon.SpriteName = param
    local halfWidth = (self.nameLabel.halfWidth + self.areaNameLabel.halfWidth) * 0.01
    local space = 0.2
    local offset = halfWidth + space
    local pos = self.campIcon.transform.localPosition
    self.campIcon.transform:SetLocalPosition(-offset, pos.y, pos.z)
  else
    self.campIcon.gameObject:SetActive(false)
  end
end

function PlayerHead3DMesh:GetTitleEffectProcessor()
  return gameMgr:GetEffectManager():GetEffectActionUtility():GetEffectProcessor(EffectProcessorType.Title)
end

function PlayerHead3DMesh:SetPlayerTitleIconHead(param)
  self.title.gameObject:SetActive(true)
  local isShowTitleEffect, itemId, titleEquipTbl = self:CheckShowTitleEffect(param)
  if not isShowTitleEffect then
    local nowSprites = {}
    if titleEquipTbl ~= nil then
      nowSprites.res = titleEquipTbl.imageIcon
      nowSprites.height = titleEquipTbl.height
    else
      nowSprites = HUDSetting.Sprites[param]
    end
    self.titleData = nowSprites
    self.title.SpriteName = self.titleData.res
  else
    self.title.SpriteName = "None"
  end
  self:TryShowTitleEffect(itemId)
  self:ComputeTitlePos()
end

function PlayerHead3DMesh:SetPlayerTitleEffect(effectId)
  if self.title == nil then
    return
  end
  if self.titleEffectId == effectId then
    return
  end
end

function PlayerHead3DMesh:ShowTitleEffect(_titleName)
end

function PlayerHead3DMesh:CheckShowTitleEffect(titleName)
  local nowTable = ClientTable.cfg_Equip_TitleManager:TryGetValue(titleName, "typeName")
  if nowTable == nil then
    return false
  end
  local itemTbl = ClientTable.cfg_Item_itemManager:TryGetValue(nowTable.itemId)
  return itemTbl and not string.isNullOrEmpty(itemTbl.modelEffect), itemTbl.id, nowTable
end

function PlayerHead3DMesh:TryShowTitleEffect(_itemId)
  if self:GetTitleEffectProcessor() then
    self.titleEffectLid = self:GetTitleEffectProcessor():InstantiationEffect({
      lid = self.titleEffectLid,
      layer = ROLE_LAYER,
      itemId = _itemId
    }, self.title.transform)
  end
end

function PlayerHead3DMesh:RemoveTitleEffect()
  if self.titleEffectLid then
    self:GetTitleEffectProcessor():RemoveEffect(self.titleEffectLid)
  end
end

function PlayerHead3DMesh:InitHP()
  local color = HUDSetting.Sprites.Blood_Green
  local layer2 = HUDSetting.Sprites.Blood_Green_Layer2
  if self.avatar.isMe then
  elseif RoleManager.me.PKMode == ERolePkMode.All then
    color = HUDSetting.Sprites.Blood_Red
    layer2 = HUDSetting.Sprites.Blood_Red_Layer2
  elseif RoleManager.me.PKMode == ERolePkMode.Peace then
    if self.avatar.evilLevel ~= EvilRoleType.Level0 then
      color = HUDSetting.Sprites.Blood_Red
      layer2 = HUDSetting.Sprites.Blood_Red_Layer2
    end
  elseif RoleManager.me.PKMode == ERolePkMode.Team then
    if not TeamData.IsTeammate(self.avatar.id) then
      color = HUDSetting.Sprites.Blood_Green
      layer2 = HUDSetting.Sprites.Blood_Green_Layer2
    end
  elseif RoleManager.me.PKMode == ERolePkMode.Union then
    if ViewData.meData.unionId == self.avatar.unionId then
      color = HUDSetting.Sprites.Blood_Green
    elseif self.avatar.evilLevel ~= EvilRoleType.Level0 then
      color = HUDSetting.Sprites.Blood_Red
      layer2 = HUDSetting.Sprites.Blood_Red_Layer2
    end
    if QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi() == true and ViewData.meData.unionId ~= self.avatar.unionId then
      color = HUDSetting.Sprites.Blood_Red
    end
  elseif RoleManager.me.PKMode == ERolePkMode.SiegeAttack then
    local holdUnionId = Activity_LuoLanSiegeData.holdUnionId
    if self.avatar.unionId ~= 0 and self.avatar.unionId ~= holdUnionId then
      color = HUDSetting.Sprites.Blood_Green
      layer2 = HUDSetting.Sprites.Blood_Green_Layer2
    else
      color = HUDSetting.Sprites.Blood_Red
      layer2 = HUDSetting.Sprites.Blood_Red_Layer2
    end
  elseif RoleManager.me.PKMode == ERolePkMode.SiegeDefense then
    if ViewData.meData.unionId == self.avatar.unionId then
      color = HUDSetting.Sprites.Blood_Green
      layer2 = HUDSetting.Sprites.Blood_Green_Layer2
    else
      color = HUDSetting.Sprites.Blood_Red
      layer2 = HUDSetting.Sprites.Blood_Red_Layer2
    end
  elseif RoleManager.me.PKMode == ERolePkMode.Camp then
    if QuickFind:GetKunShouBattleDataMgr():IsSameCamp(RoleManager.me.id, self.avatar.id) then
      color = HUDSetting.Sprites.Blood_Green
      layer2 = HUDSetting.Sprites.Blood_Green_Layer2
    else
      color = HUDSetting.Sprites.Blood_Red
      layer2 = HUDSetting.Sprites.Blood_Red_Layer2
    end
  end
  self.hp.gameObject:SetActive(true)
  if self.hp.SpriteName ~= color.res then
    self.hp.SpriteName = color.res
  end
  if self.hpLayer2.SpriteName ~= layer2.res then
    self.hpLayer2.SpriteName = layer2.res
  end
  if self.shield ~= nil then
    self.shield.SpriteName = HUDSetting.Sprites.Blood_Yellow.res
  end
  if self.shieldLayer2 ~= nil then
    self.shieldLayer2.SpriteName = HUDSetting.Sprites.Blood_Yellow.res
  end
end

function PlayerHead3DMesh:InitBoxComponent()
  if self.kaLunTeBoxSptite == nil then
    self.kaLunTeBoxSptite = self.trans:Find("KaLunTeBox", typeof(CS.CSSpriteMesh))
    self.kaLunTeBoxSptite.gameObject:SetActive(false)
  end
  if self.boxCountDownLabel == nil then
    self.boxCountDownLabel = self.trans:Find("KaLunTeBox/LabelCountDown", typeof(CS.CSLabel))
  end
end

function PlayerHead3DMesh:InitBoxView()
  if self.avatar == nil then
    return
  end
  local buffStruct = BuffData.GetFirstBuffByType(self.avatar.data.id, BuffTypeEnum.KaLunTeBoxBuff, BuffSubTypeEnum.RoleBoxBuff)
  if buffStruct then
    self:RefreshBoxView({
      type = EBuffOperationType.Add,
      time = buffStruct.time,
      buffSubType = buffStruct.buffConfig and buffStruct.buffConfig.subType or 0
    })
  end
end

function PlayerHead3DMesh:RefreshBoxView(data)
  if self.kaLunTeBoxSptite == nil or IsNil(self.kaLunTeBoxSptite.gameObject) then
    return
  end
  if data.type == EBuffOperationType.Remove then
    self.kaLunTeBoxSptite.gameObject:SetActive(false)
    self.targetBoxDuration = nil
    return
  end
  local spriteName = ClientTable.cfg_Global_globalManager:GetKaLunTeBoxSpriteName(data.buffSubType)
  if spriteName then
    self.kaLunTeBoxSptite.SpriteName = spriteName
  end
  if self.boxCountDownLabel ~= nil and not IsNil(self.boxCountDownLabel) then
    self.targetBoxDuration = data.time
    self.boxInterVarTime = 0
    self:RefreshBoxLabelView()
  end
  self.kaLunTeBoxSptite.gameObject:SetActive(true)
end

function PlayerHead3DMesh:DelayUpdateBoxCountDown()
  if self.targetBoxDuration == nil then
    return
  end
  self.boxInterVarTime = self.boxInterVarTime + Time.deltaTime
  self.targetBoxDuration = self.targetBoxDuration - Time.deltaTime
  if self.boxInterVarTime >= 1 or self.targetBoxDuration <= 0 then
    self.boxInterVarTime = 0
    self:RefreshBoxLabelView()
  end
end

function PlayerHead3DMesh:RefreshBoxLabelView()
  if self.targetBoxDuration <= 0 then
    self.targetBoxDuration = nil
    self.kaLunTeBoxSptite.gameObject:SetActive(false)
    return
  end
  local minutes = Mathf.Floor(self.targetBoxDuration / 60)
  local seconds = Mathf.Floor(self.targetBoxDuration % 60)
  local lab_time = string.format("%02d:%02d", minutes, seconds)
  self.boxCountDownLabel.text = lab_time
end

function PlayerHead3DMesh:DestroyBox()
  self.kaLunTeBoxSptite = nil
  self.boxCountDownLabel = nil
end

function PlayerHead3DMesh:InitRankComponent()
  if self.rankSprite == nil then
    self.rankSprite = self.trans:Find("KunShouRank", typeof(CS.CSSpriteMesh))
    self.rankSprite.gameObject:SetActive(false)
    self.rankPos = self.rankSprite.transform.localPosition
  end
  self.rankSpace = 20
end

function PlayerHead3DMesh:InitRankView()
  if self.avatar == nil then
    return
  end
  local buffStruct = BuffData.GetFirstBuffByType(self.avatar.data.id, BuffTypeEnum.RankBuff, BuffSubTypeEnum.KSRankBuff)
  if buffStruct then
    self:RefreshRankView({
      type = EBuffOperationType.Add,
      buffId = buffStruct.buffConfig and buffStruct.buffConfig.id or 0
    })
  end
end

function PlayerHead3DMesh:RefreshRankView(data)
  if self.rankSprite == nil or IsNil(self.rankSprite.gameObject) then
    return
  end
  if data.type == EBuffOperationType.Remove then
    self.rankSprite.gameObject:SetActive(false)
    return
  end
  local spriteName = ClientTable.cfg_Global_globalManager:GetRankBuffSpriteName(data.buffId)
  if not string.isNullOrEmpty(spriteName) then
    self.rankSprite.SpriteName = spriteName
  end
  self:SetRankPos()
  self.rankSprite.gameObject:SetActive(true)
end

function PlayerHead3DMesh:SetRankPos()
  if self.nameLabel == nil or IsNil(self.nameLabel.gameObject) then
    return
  end
  if self.nameLabelScale == nil then
    self.nameLabelScale = self.nameLabel.transform.localScale.x
  end
  local nameWidth = self.nameLabel.HalfWidth
  self.rankPos.x = 0 - (nameWidth + self.rankSpace) * self.nameLabelScale
  self.rankPos.y = self.nameLabel.transform.localPosition.y + self.nameLabel.transform.localPosition.y / 2
  self.rankSprite.transform.localPosition = self.rankPos
end

function PlayerHead3DMesh:Destroy()
  RoleHead3DMesh.Destroy(self)
  self:DestroyBox()
  self:RemoveTitleEffect()
end
