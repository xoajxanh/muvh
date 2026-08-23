Instance_GoalUI = class(BaseUI)
Instance_GoalUI.layer = UILayer.Background
Instance_GoalUI.orderInLayer = 8
Instance_GoalUI.hideType = UIHideType.Hide
Instance_GoalUI.hideFunc = UIHideFunc.MoveOutOfScreen
Instance_GoalUI.escClose = UIEscClose.DontClose

function Instance_GoalUI:InitControls()
  self.RootPanel = self:GetControl("RootPanel")
  self.AllPanel = self:GetControl("RootPanel/AllPanel")
  self.subPanel = self:GetControl("RootPanel/AllPanel/panel/subPanel")
  self.GoalPanel = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel")
  self.lab_instance = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/lab_instance")
  self.personInstance = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/personInstance")
  self.lab_goal = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/personInstance/lab_goal")
  self.lab_goalmonster = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/personInstance/lab_goal/lab_goalmonster")
  self.lab_count = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/personInstance/lab_goal/lab_count")
  self.lab_boss = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/personInstance/lab_boss")
  self.lab_bossName = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/personInstance/lab_boss/lab_bossName")
  self.lab_bossState = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/personInstance/lab_boss/lab_bossState")
  self.lab_belongName = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/personInstance/lab_boss/lab_belongName")
  self.lab_rewards = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/personInstance/lab_rewards")
  self.Content = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/personInstance/lab_rewards/ScrollView/Viewport/Content")
  self.btn_ItemPri = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/personInstance/lab_rewards/ScrollView/Viewport/Content/btn_ItemPri")
  self.lab_newBoss = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/personInstance/lab_newBoss")
  self.btn_ItemGift = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/personInstance/lab_newBoss/lab_bossRank/excGift/btn_ItemGift")
  self.bloodCastleInstance = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance")
  self.wait = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/wait")
  self.lab_prepareTimeValue = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/wait/lab_prepare/lab_prepareTimeValue")
  self.btn_talk = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/wait/btn_talk")
  self.prepare = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/prepare")
  self.lab_prepare = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/prepare/lab_prepare")
  self.btn_rightnow = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/prepare/btn_rightnow")
  self.lab_preaPareTimeValue = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/prepare/preaPareTime/lab_preaPareTimeValue")
  self.btn_invite = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/prepare/btn_invite")
  self.lab_invite = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/prepare/btn_invite/lab_invite")
  self.underway = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/underway")
  self.fight = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/underway/fight")
  self.lab_goalBloodCastle = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/underway/fight/lab_goalBloodCastle")
  self.lab_goalMonsterBloodCastle = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/underway/fight/lab_goalBloodCastle/lab_goalMonsterBloodCastle")
  self.lab_countBloodCastle = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/underway/fight/lab_goalBloodCastle/lab_countBloodCastle")
  self.lab_rewardsBlood = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/underway/fight/lab_rewardsBlood")
  self.ContentBloodCastle = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/underway/fight/lab_rewardsBlood/ScrollView/Viewport/ContentBloodCastle")
  self.btn_ItemBloodCastle = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/underway/fight/lab_rewardsBlood/ScrollView/Viewport/ContentBloodCastle/btn_ItemBloodCastle")
  self.score = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/underway/fight/score")
  self.lab_score = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/underway/fight/score/lab_score")
  self.finish = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/underway/finish")
  self.lab_finish = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/underway/finish/lab_finish")
  self.lab_finish2 = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/underway/finish/lab_finish2")
  self.btn_combineFinish = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/underway/finish/btn_combine")
  self.lab_finishTimeValue = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/underway/finish/fightTime/lab_finishTimeValue")
  self.over = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/bloodCastleInstance/over")
  self.warAllianceBossInstance = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/warAllianceBossInstance")
  self.labboss_time = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/warAllianceBossInstance/tx_time/labboss_time")
  self.lab_layer = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/warAllianceBossInstance/layout/lab_layer")
  self.labtarget = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/warAllianceBossInstance/labtarget")
  self.lab_target = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/warAllianceBossInstance/labtarget/lab_target")
  self.btn_next = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/warAllianceBossInstance/btn_next")
  self.btn_auction = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/warAllianceBossInstance/btn_auction")
  self.secretInstance = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/secretInstance")
  self.sv_bossinfo = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/secretInstance/sv_bossinfo")
  self.bossInfoItem = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/secretInstance/sv_bossinfo/Viewport/Content/bossInfoItem")
  self.sv_damagelist = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/secretInstance/sv_damagelist")
  self.rankItem = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/secretInstance/sv_damagelist/Viewport/Content/rankItem")
  self.myRankItem = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/secretInstance/sv_damagelist/myRankItem")
  self.lab_myRank = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/secretInstance/sv_damagelist/myRankItem/lab_myRank")
  self.lab_myName = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/secretInstance/sv_damagelist/myRankItem/lab_myName")
  self.lab_myDamage = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/secretInstance/sv_damagelist/myRankItem/lab_myDamage")
  self.tips = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/secretInstance/sv_damagelist/tips")
  self.getReward = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/getReward")
  self.btn_receive = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/getReward/btn_receive")
  self.btn_towerNext = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/getReward/btn_towerNext")
  self.btn_ItemReward = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/getReward/lab_rewards/ScrollView/Viewport/Content/btn_ItemReward")
  self.lab_copyName = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/getReward/lab_finishGet/lab_copyName")
  self.lab_getRewardTime = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/getReward/lab_getRewardTime")
  self.lab_tips = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/getReward/lab_tips")
  self.btn_quit = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/btn_quit")
  self.btn_Action = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/btn_Action")
  self.lab_Action = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/btn_Action/lab_Action")
  self.descBtn = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/descBtn")
  self.bg_countdown = self:GetControl("RootPanel/bg_countdown")
  self.lab_countdown = self:GetControl("RootPanel/bg_countdown/lab_countdown")
  self.btn_Exit = self:GetControl("RootPanel/btn_Exit")
  self.fightTime = self:GetControl("RootPanel/btn_Exit/fightTime")
  self.lab_fightTimeValue = self:GetControl("RootPanel/btn_Exit/fightTime/lab_fightTimeValue")
  self.reinBossInstance = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/reinBossInstance")
  self.rankReinItem = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/reinBossInstance/sv_attacklist/Viewport/Content/rankItem")
  self.lab_myRankRein = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/reinBossInstance/sv_attacklist/myRankItem/lab_myRank")
  self.lab_myNameRein = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/reinBossInstance/sv_attacklist/myRankItem/lab_myName")
  self.lab_myDamageRein = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/reinBossInstance/sv_attacklist/myRankItem/lab_myDamage")
  self.defbtnRein = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/reinBossInstance/sv_attacklist/myRankItem/defbtn")
  self.descBtnRb = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/reinBossInstance/sv_attacklist/tips/descBtnRb")
  self.kalimaTempleInstance = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/kalimaTempleInstance")
  self.rankItemKalima = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/kalimaTempleInstance/sv_attacklist/Viewport/Content/rankItem")
  self.lab_myRankKalima = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/kalimaTempleInstance/sv_attacklist/myRankItem/lab_myRank")
  self.lab_myNameKalima = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/kalimaTempleInstance/sv_attacklist/myRankItem/lab_myName")
  self.lab_myDamageKalima = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/kalimaTempleInstance/sv_attacklist/myRankItem/lab_myDamage")
  self.defbtnKalima = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/kalimaTempleInstance/sv_attacklist/myRankItem/defbtn")
  self.descBtnKalima = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/kalimaTempleInstance/sv_attacklist/tips/descBtn")
  self.trailBossInstance = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/trailBossInstance")
  self.sv_trailbossinfo = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/trailBossInstance/sv_bossinfo")
  self.trailbossInfoItem = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/trailBossInstance/sv_bossinfo/Viewport/Content/bossInfoItem")
  self.sv_trailattacklist = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/trailBossInstance/sv_attacklist")
  self.rankTrailItem = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/trailBossInstance/sv_attacklist/Viewport/Content/rankItem")
  self.lab_myRankTrail = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/trailBossInstance/sv_attacklist/myRankItem/lab_myRank")
  self.lab_myNameTrail = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/trailBossInstance/sv_attacklist/myRankItem/lab_myName")
  self.lab_myDamageTrail = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/trailBossInstance/sv_attacklist/myRankItem/lab_myDamage")
  self.defbtnTrail = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/trailBossInstance/sv_attacklist/myRankItem/defbtn")
  self.descBtnRbTrail = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/trailBossInstance/sv_attacklist/tips/descBtnRb")
  self.KaLunTeInstance = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/KaLunTeInstance")
  self.NightFightInstance = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/NightFightInstance")
  self.YuanGuBOSSInstance = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/YuanGuBOSSInstance")
  self.zoomSecretRealmInstance = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/ZoomSecretRealmInstance")
end

local SecretBossTime = {}
local TrailBossTime = {}

function Instance_GoalUI:Init()
  self.PosData = {}
  self.taskType = 0
  self.pathPoint = {}
  self.pathPointNum = 1
  self.nextTime = 0
  self.EmoExpNum = nil
  self.objTbl = {}
  self.damageRankBossInfo = nil
end

function Instance_GoalUI:RootPanelState(state)
  self.RootPanel:SetActive(state)
end

function Instance_GoalUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Instance_GoalUI:InitUI()
  self.TaskStage = {
    [BloodCastleStage.INIT] = self.wait,
    [BloodCastleStage.WAITING] = self.prepare,
    [BloodCastleStage.RUNNING] = self.underway,
    [BloodCastleStage.CLOSING] = self.over
  }
  self:InitContent()
  self:InitPathPoint()
end

function Instance_GoalUI:OnShow()
  self.nextTime = 0
  if LeftTopPanelManager.GetCurrentPanelType() == PanelType.TransPanelType or LeftTopPanelManager.GetCurrentPanelType() == PanelType.KSBattlePaneType then
    self.AllPanel:SetActive(true)
    self.defbtnRein:SetActive(false)
    self.defbtnKalima:SetActive(false)
    self.defbtnTrail:SetActive(false)
  else
    self.AllPanel:SetActive(false)
  end
  self:RootPanelState(true)
  self:RegistEvents()
  self:Refresh()
  self.isSecret = TranScriptData.GetSecretBossIsTask()
  if UIManager.IsVisible(UIID.Team_TeamUpQuicklyUI) then
    UIManager.Hide(UIID.Team_TeamUpQuicklyUI)
  end
  EventManager.Dispatch(Event.Team_TeamUpQuicklyMinimize, false)
  TeamUpQuicklyData.TeamInfor = nil
  self.sv_trailbossinfo.scrollRect.normalizedPosition = Vector2(0, 1)
  self.sv_bossinfo.scrollRect.normalizedPosition = Vector2(0, 1)
  self:RefreshRoleCountDownTimeByServer(nil, TranScriptData.ServerRoleCountDownTimeData)
end

function Instance_GoalUI:OnHide()
  if UIManager.IsVisible(UIID.PromptTipUI) then
    UIManager.Hide(UIID.PromptTipUI)
  end
  self.damageRankBossInfo = nil
  QiJiHelperController.SetSkillMonsterRange(self.QiJiHelperRange)
  self.btn_receive.transform.localPosition = Vector3.right * -409.3 + Vector3.up * -69.1
  if self.args and self.args.type == TranScriptType.BloodCastle or self.args and self.args.type == TranScriptType.DemonPlaza then
    QiJiHelperData.SetPickUpType()
  end
  self:DesToryTime()
  self:DesToryObj()
  self:HideUI()
  TranScriptData.ClearData()
  self.kalunteRuinsGoalUITemp:OnHide()
  TranScriptData.ServerRoleCountDownTimeData = nil
end

function Instance_GoalUI:OnDestroy()
  self.kalunteRuinsGoalUITemp:OnDestroy()
end

function Instance_GoalUI:HideUI()
  self.bg_countdown:SetActive(false)
  self.getReward:SetActive(false)
  self.lab_fightTimeValue:SetActive(false)
end

function Instance_GoalUI:DesToryObj()
  if self.objTbl then
    self.btn_ItemPriTemp:DesToryTable()
    self.btn_ItemTemp:DesToryTable()
    self.btn_ItemRewardTemp:DesToryTable()
    for i = 1, #self.objTbl do
      self.objTbl[i]:Destroy()
    end
    self.objTbl = {}
  end
end

function Instance_GoalUI:DesToryTime()
  if self.CountDownTimer then
    Timer.Stop(self.CountDownTimer)
    self.CountDownTimer = nil
  end
  if self.InitTimer then
    Timer.Stop(self.InitTimer)
    self.InitTimer = nil
  end
  if self.autoTimer then
    Timer.Stop(self.autoTimer)
    self.autoTimer = nil
  end
  if self.wayTimer then
    Timer.Stop(self.wayTimer)
    self.wayTimer = nil
  end
  if self.RewardTime then
    Timer.Stop(self.RewardTime)
    self.RewardTime = nil
  end
  if self.GradTime then
    Timer.Stop(self.GradTime)
    self.GradTime = nil
  end
  if self.nextInitTimer then
    Timer.Stop(self.nextInitTimer)
    self.nextInitTimer = nil
  end
  self:DestroySecretTime()
  self:DestroyTrailTime()
end

function Instance_GoalUI:RegistUIEvents()
  self.btn_receive:SetOnClick(self, self.btn_receiveOnClick)
  self.btn_Exit:SetOnClick(self, self.btn_ExitOnClick)
  self.btn_rightnow:SetOnClick(self, self.btn_rightnowOnClick)
  self.btn_Action:SetOnClick(self, self.btn_ActionOnClick)
  self.btn_quit:SetOnClick(self, self.btn_quitOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_towerNext:SetOnClick(self, self.btn_towerNextOnClick)
  self.descBtnRb:SetOnClick(self, self.DescBtnRbOnClick)
  self.descBtnRbTrail:SetOnClick(self, self.DescBtnRbOnClick)
  self.defbtnRein:SetOnClick(self, self.BeatBackOnClick)
  self.defbtnKalima:SetOnClick(self, self.BeatBackOnClick)
  self.descBtnKalima:SetOnClick(self, self.descBtnOnClick)
end

function Instance_GoalUI:DescBtnRbOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Instance_GoalUI")
  if 0 < #lvCfg and TranScriptData.InTranscript and TranScriptData.InTranscriptType then
    if TranScriptData.InTranscriptType == TranScriptType.RegenerateBoss and lvCfg[2] then
      UIManager.Show(UIID.System_DescUI, {
        id = lvCfg[2].id
      })
    elseif TranScriptData.InTranscriptType == TranScriptType.TrialsBoss and lvCfg[3] then
      UIManager.Show(UIID.System_DescUI, {
        id = lvCfg[3].id
      })
    elseif TranScriptData.InTranscriptType == TranScriptType.LostMirageBoss and lvCfg[5] then
      UIManager.Show(UIID.System_DescUI, {
        id = lvCfg[5].id
      })
    elseif TranScriptData.InTranscriptType == TranScriptType.YanGuBoss and lvCfg[6] then
      UIManager.Show(UIID.System_DescUI, {
        id = lvCfg[6].id
      })
    else
      UIManager.Show(UIID.System_DescUI, {
        id = lvCfg[1].id
      })
    end
  end
end

function Instance_GoalUI:BeatBackOnClick()
  local count = table.count(self.attackRoleIdTab.attackRoleId)
  if count == 0 then
    return
  end
  NetManager.Send(FightMessage.ReqDamageList)
  
  local function setSelectTarget()
    Coroutine.Wait(0.1)
    RoleTargetManager.SelectPlayerTarget(self.attackRoleIdTab.attackRoleId[count])
    RoleManager.me:SetAutoFight(AutoFightStrKey.ReleaseSkill)
  end
  
  Coroutine.Start(setSelectTarget)
end

function Instance_GoalUI:btn_towerNextOnClick()
  local currentData = TowerData:GetRunningInstanceData()
  currentData = TowerData.GetInstanceInforByFloorIndex(currentData.floorIndex + 1)
  TowerData:SetRunningInstanceData(currentData)
  local mapData = {
    mapId = currentData.transferId
  }
  EventManager.Dispatch(Event.Map_ChangeMap, mapData)
  self.bg_countdown:SetActive(false)
  if self.CountDownTimer then
    Timer.Stop(self.CountDownTimer)
    self.CountDownTimer = nil
  end
end

function Instance_GoalUI:descBtnOnClick()
  local lvCfg
  if self.args.type == TranScriptType.BloodCastle then
    lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Instance_BloodCastleUI")
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  elseif self.args.type == TranScriptType.DemonPlaza then
    lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Instance_DemonPlazaUI")
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  elseif self.args.type == TranScriptType.Person_KaliMaTemple then
    lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Instance_KalimaCastleUI")
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  elseif self.args.type == TranScriptType.VacantSpace then
    UIManager.Show(UIID.System_DescUI, {id = 1110})
  elseif self.args.type == TranScriptType.ZoomSecretRealm then
    lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "ZoomSecretRealmInstance")
    if 0 < #lvCfg then
      UIManager.Show(UIID.System_DescUI, {
        id = lvCfg[1].id
      })
    else
    end
  end
end

function Instance_GoalUI:btn_receiveOnClick(control)
  if self.RewardTime then
    Timer.Stop(self.RewardTime)
    self.RewardTime = nil
  end
  TranScriptController.ReqInstanceReward()
  if self.args.type == TranScriptType.BloodCastle or self.args.type == TranScriptType.DemonPlaza then
    self.isAcceptReward = true
    self.getReward:SetActive(false)
    self.bloodCastleInstance:SetActive(true)
  end
end

function Instance_GoalUI:btn_ExitOnClick()
  local titleText = Localization.GetUIWord("tishi")
  local prompTipArgs = {
    title = titleText,
    textContent = "R\225\187\157i ph\195\179 b\225\186\163n s\225\186\189 m\225\186\165t ti\225\186\191n \196\145\225\187\153, tho\195\161t kh\195\180ng",
    ok = function()
      self:OnHide()
      TranScriptController.ReqExitInstance()
    end,
    canel = function()
      UIManager.Hide(this.name)
    end
  }
  UIManager.Show(UIID.PromptTipUI, prompTipArgs)
end

function Instance_GoalUI:btn_quitOnClick()
  TranScriptController.ReqExitInstance()
end

function Instance_GoalUI:btn_rightnowOnClick()
  EventManager.Dispatch(Event.Team_ReqTeamsInfo, nil)
  if TeamData.isInTeam and TeamData.isLeader == false then
    for k, v in pairs(TeamData.membersList) do
      if v.rid == TeamData.leaderId and v.online == false then
        FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("TeamUpQuickly_1"))
        return
      end
      if v.rid == TeamData.leaderId and v.mapId == SceneData.mapId then
        FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("TeamUpQuickly_1"))
        return
      end
    end
  end
  NetManager.Send(MapMessage.ReqSkipWait)
end

function Instance_GoalUI:btn_ActionOnClick()
  TranScriptData.IsVoluntarily = true
  TranScriptData.isOperate = false
  TranScriptData.SetVoluntarily()
end

function Instance_GoalUI:RegistEvents()
  self:RegistEvent(Event.Scene_ShowLoading, self.Scene_ShootSceneFunc, self)
  self:RegistEvent(Event.UpdateCopyDataInfo, self.UpdateCopyInfoFunc, self)
  self:RegistEvent(Event.InstanceCountDownTimer, self.InstanceCountDownFunc, self)
  self:RegistEvent(Event.Role_OnRoleEnterView, self.Role_OnRoleEnterView, self)
  self:RegistEvent(Event.UpdateRolePos, self.JudgeDemonPlazaState, self)
  self:RegistEvent(Event.WarAlliance_BossUIUpdate, self.RefreshWarAllianceBoss, self)
  self:RegistEvent(Event.SelectMonster, self.SelectMonster, self)
  self:RegistEvent(Event.CancelSelectMonster, self.CancelSelectMonster, self)
  self:RegistEvent(Event.Team_RefreshTeamInfo, self.OnTeamInfo, self)
  self:RegistEvent(Event.RefreshReinBeatBack, self.RefreshReinBeatBack, self)
  self:RegistEvent(Event.GameObject_OnGameObjectLeaveView, self.OnRoleLeaveView, self)
  self:RegistEvent(Event.GetServerRoleCountDownTime, self.RefreshRoleCountDownTimeByServer, self)
  self:RegistEvent(Event.RefreshTrappedRank, self.RefreshTrappedRankCallBack, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
  self:RegistEvent(Event.MonsterRankingNews, self.MonsterDamageRanKingInformation, self)
  self:RegistEvent(Event.MonsterEnterView, self.OnMonsterEnterView, self)
end

function Instance_GoalUI:RefreshReinBeatBack(_, data)
  if data ~= nil and table.count(data.attackRoleId) > 0 then
    self.defbtnRein:SetActive(true)
    self.defbtnKalima:SetActive(true)
    self.defbtnTrail:SetActive(true)
  else
    self.defbtnRein:SetActive(false)
    self.defbtnKalima:SetActive(false)
    self.defbtnTrail:SetActive(false)
  end
  self.attackRoleIdTab = data
end

function Instance_GoalUI:SelectMonster(_, role)
  if TranScriptData.InTranscript then
    if role == nil then
      return
    end
    if role.data.data.ownerName == "" then
      self.lab_belongName:SetText(ViewData.meData.name)
    else
      self.lab_belongName:SetText(role.data.data.ownerName)
    end
    self.CurrentSelectId = role.data.id
    if self.args and self.args.type then
      self:SetDamageRank()
      if self.args.type == TranScriptType.SecretBoss then
        self:SetSecretUI(false)
      elseif self.args.type == TranScriptType.TrialsBoss then
        self:SetTrailUI(false)
      end
    end
  end
end

function Instance_GoalUI:CancelSelectMonster()
  if TranScriptData.InTranscript and self.args and self.args.type then
    if self.args.type == TranScriptType.SecretBoss then
      self:SetSecretUI(true)
    elseif self.args.type == TranScriptType.TrialsBoss then
      self:SetTrailUI(true)
    end
  end
end

function Instance_GoalUI:JudgeDemonPlazaState(id, msg)
  if TranScriptData.InTranscript then
    if self.args and self.args.type ~= TranScriptType.DemonPlaza or msg.roleType ~= ERoleType.Monster or QiJiHelperData.isAutoFight then
      return
    end
    local meCell = RoleManager.me.cellPos
    local distance = Mathf.Max(Mathf.Abs(msg.posX - meCell.x), Mathf.Abs(msg.posY - meCell.y))
    if distance <= 16 then
      self:StopMove()
    end
  end
end

function Instance_GoalUI:Scene_ShootSceneFunc()
  if TranScriptData.InTranscript then
    self:OnHide()
    LeftTopPanelManager.SetCurrentPanelType(PanelType.TaskPanelType)
    EventManager.Dispatch(Event.Task_ChangePanelState)
  end
end

function Instance_GoalUI:UpdateCopyInfoFunc()
  self.args = TranScriptData.InTranscriptData
  self.TranScriptType = self.args.id
  if self.args.type == TranScriptType.PersonBoss_Tower then
    self:SetBaseUIInfo()
  else
    self:SetUpdateUIInfo()
  end
end

function Instance_GoalUI:MonsterDamageRanKingInformation()
  local data = TranScriptData.BurialRankingData
  if data and not table.isNullOrEmpty(data.bossInfo) then
    self.args.bossInfo = data.bossInfo
    if self.args.type == TranScriptType.PersonBoss_Tower then
      self:SetBaseUIInfo()
    else
      self:SetUpdateUIInfo()
    end
  end
end

function Instance_GoalUI:InstanceCountDownFunc(id, msg)
  local timeText = Localization.GetUIWord("jieshudaojishi")
  self.lab_fightTimeValue:SetActive(false)
  self.bg_countdown:SetActive(true)
  self.lab_countdown:SetText(string.format(timeText, math.floor(msg.countdownTime / 1000)))
  self.CountDownTimer = self:ShowTimer(msg.countdownTime / 1000, self.lab_countdown, true)
end

function Instance_GoalUI:Refresh()
  self.QiJiHelperRange = QiJiHelperData.SettingData.KillMonsterScope
  self.meData = ViewData.meData
  self.IsPlayBgm = false
  if TranScriptData.InTranscriptData == nil then
    return
  end
  self.args = TranScriptData.InTranscriptData
  TranScriptData.RefreshOpenTime(SceneData.groupId)
  self:SetBaseUIInfo()
  self:isAuto()
  self:InitTeamInfo()
  self.isAcceptReward = false
end

function Instance_GoalUI:Role_OnRoleEnterView()
  if TranScriptData.InTranscript then
    self:StopMove()
  end
end

function Instance_GoalUI:InitPathPoint()
  local pathPoint = ClientTable.cfg_Activity_globalManager:TryGetValue(100706, "id").effect
  local mapIdPath = string.split(pathPoint, "&")
  for i = 1, #mapIdPath do
    local path = string.split(mapIdPath[i], "#")
    self.pathPoint[path[1]] = {}
    for j = 1, #path - 1 do
      table.insert(self.pathPoint[path[1]], path[j + 1])
    end
  end
end

function Instance_GoalUI:isAuto()
  local basic
  if self.args.type == TranScriptType.PersonBoss or self.args.type == TranScriptType.PersonResource or self.args.type == TranScriptType.PersonBoss_Tower then
    basic = self.args.basic
  else
    basic = self.args.basic.basic
  end
  TranScriptData.isOperate = false
  
  local function autoCombat()
    if not TranScriptData.isOperate and not QiJiHelperData.isAutoFight and not TranScriptData.isWay and self.args and basic.state == BloodCastleStage.RUNNING or basic.state == BloodCastleStage.WAITING then
      RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
    end
  end
  
  local function autoCombat2()
    RoleManager.me:SetAutoFight(AutoFightStrKey.AutoFight)
  end
  
  if self.args.type == TranScriptType.PersonBoss then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
    self.autoTimer = Timer.StartLoopForever(60, autoCombat)
  else
    if self.args.type == TranScriptType.PersonBoss_Tower then
      RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
      self.autoTimer = Timer.StartLoopForever(3, autoCombat2)
    else
    end
  end
end

local function OnBossInfoItemCreate(control)
  control.lab_boss = UIControl(control.transform, "lab_boss")
  control.lab_position = UIControl(control.transform, "lab_position")
  control.lab_bossState = UIControl(control.transform, "lab_bossState")
end

local function OnRankItemCreate(control)
  control.bg_img = UIControl(control.transform, "bg_img")
  control.lab_rank = UIControl(control.transform, "lab_rank")
  control.lab_belongName = UIControl(control.transform, "lab_belongName")
  control.lab_damageinfo = UIControl(control.transform, "lab_damageinfo")
end

local function BossInfoItemRefresh(ctr, _, bossData, ui)
  local monster = ClientTable.cfg_Monster_monsterManager:TryGetValue(bossData.bossId)
  ctr.lab_boss:SetText(monster.name)
  ctr.lab_position:SetText(string.format("T\225\187\141a \196\145\225\187\153  %d,%d", bossData.x, bossData.y))
  local totalTime = math.floor(bossData.reliveTime / 1000 - Time.GetServerTime() / 1000) or 0
  if 1 <= totalTime then
    if ui.args.type == TranScriptType.SecretBoss then
      SecretBossTime[bossData.number] = ui:ShowTimer(totalTime, ctr.lab_bossState)
    elseif ui.args.type == TranScriptType.TrialsBoss then
      TrailBossTime[bossData.number] = ui:ShowTimer(totalTime, ctr.lab_bossState)
    end
  elseif bossData.hurts and 0 < table.count(bossData.hurts) then
    ctr.lab_bossState:SetText(string.format("H\225\186\161ng 1 s\195\161t th\198\176\198\161ng:  %s", string.GetColorText(string.format("%s", bossData.hurts[1].name), ItemQuality2ColorDic[5])))
  else
    ctr.lab_bossState:SetText("Ch\225\187\157 ti\195\170u di\225\187\135t")
  end
  ctr:SetOnClick(ui, function()
    ui:BossInfoClick(bossData.x, bossData.y)
  end)
end

local function SetRankColor(ctr, rankData, colorNum)
  local damageNum = Mathf.NumberShowFormat(rankData.damage, 2)
  ctr.lab_rank:SetText(string.GetColorText(rankData.ranking, ItemQuality2ColorDic[colorNum]))
  ctr.lab_belongName:SetText(string.GetColorText(rankData.name, ItemQuality2ColorDic[colorNum]))
  ctr.lab_damageinfo:SetText(string.GetColorText(damageNum, ItemQuality2ColorDic[colorNum]))
end

local function rankItemRefresh(ctr, _, rankData, ui)
  if rankData.ranking <= 3 then
    ui:SetSprite("Atlas_Main", "ico_" .. rankData.ranking, ctr.bg_img, false)
  else
    ctr.bg_img:SetActive(false)
  end
  if rankData.ranking == 1 then
    SetRankColor(ctr, rankData, 5)
  elseif rankData.ranking == 2 then
    SetRankColor(ctr, rankData, 1)
  elseif rankData.ranking == 3 then
    SetRankColor(ctr, rankData, 2)
  else
    SetRankColor(ctr, rankData, 0)
  end
end

local function OnRankItemReinCreate(control)
  control.sl_progress = UIControl(control.transform, "sl_progress")
  control.lab_rank = UIControl(control.transform, "lab_rank")
  control.bg_img = UIControl(control.transform, "bg_img")
  control.lab_belongName = UIControl(control.transform, "lab_belongName")
  control.lab_damageinfo = UIControl(control.transform, "lab_damageinfo")
  control.atkbtn = UIControl(control.transform, "atkbtn")
end

local function rankItemReinRefresh(ctr, _, rankData, ui)
  if rankData.ranking <= 3 then
    ui:SetSprite("Atlas_Main", "ico_" .. rankData.ranking, ctr.bg_img, false)
    ctr.atkbtn:SetActive(rankData.id ~= ViewData.meData.id)
  else
    ctr.bg_img:SetActive(false)
    ctr.atkbtn:SetActive(false)
  end
  local damageNum = Mathf.NumberShowFormat(rankData.damage, 2)
  ctr.lab_rank:SetText(rankData.ranking)
  ctr.lab_belongName:SetText(rankData.name)
  ctr.lab_damageinfo:SetText(damageNum)
  ctr.sl_progress:SetValue((10 - rankData.ranking + 1) / 10)
  ctr.atkbtn.rankData = rankData
  ctr.atkbtn:SetOnClick(ui, ui.SelectAttackTarget)
end

function Instance_GoalUI:SelectAttackTarget(control)
  if control.rankData ~= nil then
    NetManager.Send(FightMessage.ReqDamageList, {
      attackToRoleId = control.rankData.id
    })
    
    local function setSelectTarget()
      Coroutine.Wait(0.1)
      RoleTargetManager.SelectPlayerTarget(control.rankData.id)
      RoleManager.me:SetAutoFight(AutoFightStrKey.ReleaseSkill)
    end
    
    Coroutine.Start(setSelectTarget)
  end
end

function Instance_GoalUI:InitContent()
  self.btn_ItemPriTemp = UIContainer(self.btn_ItemPri)
  self.btn_ItemTemp = UIContainer(self.btn_ItemBloodCastle)
  self.btn_ItemRewardTemp = UIContainer(self.btn_ItemReward)
  self.rankItemTemp = UIContainer(self.rankItem, self, OnRankItemCreate, rankItemRefresh)
  self.bossInfoItemTemp = UIContainer(self.bossInfoItem, self, OnBossInfoItemCreate, BossInfoItemRefresh)
  self.rankItemTempRein = UIContainer(self.rankReinItem, self, OnRankItemReinCreate, rankItemReinRefresh)
  self.rankItemTempKalima = UIContainer(self.rankItemKalima, self, OnRankItemReinCreate, rankItemReinRefresh)
  self.trailBossInfoItemTemp = UIContainer(self.trailbossInfoItem, self, OnBossInfoItemCreate, BossInfoItemRefresh)
  self.rankItemTempTrail = UIContainer(self.rankTrailItem, self, OnRankItemReinCreate, rankItemReinRefresh)
  self.kalunteRuinsGoalUITemp = luaTemplateManager.GetNewTemplate(self.KaLunTeInstance, LuaComponentTemplates.GoalUI_KalunteRuinsTemp)
  self.ancientBossGoalUITemp = luaTemplateManager.GetNewTemplate(self.YuanGuBOSSInstance, LuaComponentTemplates.GoalUI_AncientBossTemp, self)
  self.kunShouBattleGoalUITemp = luaTemplateManager.GetNewTemplate(self.NightFightInstance, LuaComponentTemplates.GoalUI_KSBattleTemp, {baseUI = self})
  self.zoomSecretRealmInstanceTemplate = luaTemplateManager.GetNewTemplate(self.zoomSecretRealmInstance, LuaComponentTemplates.ZoomSecretRealmInstanceTemplate, self)
end

function Instance_GoalUI:SetBaseUIInfo()
  local mapId, state
  if self.args.basic.basic == nil then
    mapId = self.args.basic.mapId
    state = self.args.basic.state
  else
    mapId = self.args.basic.basic.mapId
    state = self.args.basic.basic.state
  end
  self.mapId = mapId
  local map_instance = ClientTable.cfg_Map_instanceManager:TryGetValue(mapId, "mapId")
  self.map_instance = map_instance
  self.lab_instance:SetText(map_instance.name)
  TranScriptData.InTranscriptType = self.args.type
  TranScriptData.InTranscriptStage = state
  self.lab_rewards:SetActive(true)
  self.descBtn:SetActive(true)
  self.btn_towerNext:SetActive(false)
  self.btn_Exit:SetActive(true)
  self.lab_instance:SetActive(self.args.type ~= TranScriptType.SecretBoss and self.args.type ~= TranScriptType.Person_KaliMaTemple and self.args.type ~= TranScriptType.TrialsBoss and self.args.type ~= TranScriptType.KSBattle and self.args.type ~= TranScriptType.AncientBoss)
  self.descBtn:SetActive(self.args.type ~= TranScriptType.SecretBoss and self.args.type ~= TranScriptType.Person_KaliMaTemple and self.args.type ~= TranScriptType.PersonKaLiMa and self.args.type ~= TranScriptType.TrialsBoss and self.args.type ~= TranScriptType.RegenerateBoss and self.args.type ~= TranScriptType.RefineTower and self.args.type ~= TranScriptType.KSBattle and self.args.type ~= TranScriptType.AncientBoss and self.args.type ~= TranScriptType.LostMirageBoss)
  self.lab_tips:SetActive(self.args.type == TranScriptType.BloodCastle)
  self:SetTranUIActiveType()
  self.btn_Exit:SetAnchoredPosition(1234, 118)
  if self.args.type == TranScriptType.BloodCastle then
    self.lab_rewardsBlood.transform.localPosition = Vector3(-360, 37, 104)
    self:SetBloodCastleStage(state)
  elseif self.args.type == TranScriptType.DemonPlaza then
    QiJiHelperController.SetSkillMonsterRange(8)
    local integral = ClientTable.cfg_Activity_globalManager:TryGetValue(100705, "id").effect
    local str = string.split(integral, "&")
    for k, v in pairs(str) do
      if tonumber(string.split(v, "#")[1]) == self.args.basic.basic.mapId then
        self.EmoIntegral = tonumber(string.split(v, "#")[2])
        break
      end
    end
    self:SetBloodCastleStage(state)
  elseif self.args.type == TranScriptType.SecretBoss then
    local instanceType = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(10520102).effect)
    if self.args.instanceType ~= nil and TranScriptData.InTranscriptData.instanceType == instanceType then
      self:SetDamageRank()
      self.btn_Exit:SetAnchoredPosition(1246, 54)
    else
      local levelRestrict = ClientTable.cfg_Map_mapManager:TryGetValue(self.mapId, "id").enterCondition
      self.countKey = levelRestrict[1][2][2][1]
      self:DestroySecretTime()
      self:SetSecretUIInfo()
    end
  elseif self.args.type == TranScriptType.WarAllianceBoss then
    self.getReward:SetActive(false)
    self.descBtn:SetActive(false)
    self:RefreshWarAllianceBoss()
  elseif self.args.type == TranScriptType.Person_KaliMaTemple then
    self:SetDamageRank()
    local timeLeft = self.args.surplusTime / 1000
    if self.InitTimer == nil then
      self.InitTimer = self:ShowTimer(timeLeft, self.lab_fightTimeValue)
    end
  elseif self.args.type == TranScriptType.PersonKaLiMa then
    local timeLeft = self.args.countDownTime / 1000
    local timeStr = TimeUtility.ShowTimeWithColon(timeLeft)
    self.lab_fightTimeValue:SetText(timeStr)
    if self.InitTimer ~= nil then
      Timer.Stop(self.InitTimer)
    end
    self.InitTimer = self:ShowTimer(timeLeft, self.lab_fightTimeValue)
  elseif self.args.type == TranScriptType.TrialsBoss then
    self:DestroyTrailTime()
    self:SetBossInfoUI()
    self:SetDamageRank()
    self.btn_Exit:SetAnchoredPosition(1246, 54)
  elseif self.args.type == TranScriptType.RefineTower then
    self.lab_rewardsBlood.transform.localPosition = Vector3(-360, 37, 104)
    self:SetRefineTowerStage(state)
  elseif self.args.type == TranScriptType.KalunteRuins then
    self.kalunteRuinsGoalUITemp:SetRoot(self)
    self.kalunteRuinsGoalUITemp:SetStage(state)
  elseif self.args.type == TranScriptType.RegenerateBoss then
    self:SetDamageRank()
    self.btn_Exit:SetAnchoredPosition(1246, 54)
  elseif self.args.type == TranScriptType.VacantSpace then
    self.btn_Exit:SetAnchoredPosition(1246, 54)
    local totalTime = (self.args.endTime * 1000 - Time.GetServerTime()) / 1000
    if self.InitTimer ~= nil then
      Timer.Stop(self.InitTimer)
    end
    self.InitTimer = self:ShowRoleCountDownTimer(totalTime, self.lab_fightTimeValue, true)
  elseif self.args.type == TranScriptType.AncientBoss then
    self.ancientBossGoalUITemp:Refresh(self.mapId)
  elseif self.args.type == TranScriptType.YanGuBoss then
    self:SetDamageRank()
  elseif self.args.type == TranScriptType.KSBattle then
    self:RefershkSBattleRankView()
    local timeLeft = self.args.countDownTime / 1000
    local timeStr = TimeUtility.ShowTimeWithColon(timeLeft)
    self.lab_fightTimeValue:SetText(timeStr)
    if self.InitTimer ~= nil then
      Timer.Stop(self.InitTimer)
    end
    self.InitTimer = self:ShowTimer(timeLeft, self.lab_fightTimeValue)
  elseif self.args.type == TranScriptType.PersonBoss_Tower then
    local map_instanceMission = ClientTable.cfg_Map_instance_missionManager:TryGetValue(tonumber(map_instance.finishCondition), "id")
    local totalTime = (self.args.endTime - Time.GetServerTime()) / 1000
    self.monsterTbl = map_instanceMission
    local monsterId = tonumber(self.monsterTbl.id)
    local len = 0
    if self.args.level then
      monsterId, len = ClientTable.cfg_Activity_climbTowerManager:GetMostterd(self.args.level)
    end
    local monster_instance = ClientTable.cfg_Monster_monsterManager:TryGetValue(monsterId)
    local mapName = ClientTable.cfg_Map_mapManager:TryGetValue(mapId).name .. self.args.level
    self.lab_instance:SetText(mapName)
    self.lab_goalmonster:SetText(monster_instance.name .. "Ti\195\170u di\225\187\135t")
    if self.args.type == TranScriptType.PersonBoss_Tower then
      self.lab_rewards:SetText("Th\198\176\225\187\159ng ph\195\179 b\225\186\163n")
      local rewards = ClientTable.cfg_Activity_climbTowerManager:GetMostterReward(self.args.level)
      if rewards then
        self:SetTowerCopyReward(rewards)
      end
      self.descBtn:SetActive(false)
    end
    self:SetUpdateUIInfo()
    if self.InitTimer == nil then
      self.InitTimer = self:ShowRoleCountDownTimer(totalTime, self.lab_fightTimeValue, true)
    end
  elseif self.args.type == TranScriptType.LostMirageBoss then
    self:SetDamageRank()
    self.btn_Exit:SetAnchoredPosition(1246, 54)
  elseif self.args.type == TranScriptType.ZoomSecretRealm then
    self.zoomSecretRealmInstanceTemplate:Refresh()
  else
    local map_instanceMission = ClientTable.cfg_Map_instance_missionManager:TryGetValue(tonumber(map_instance.finishCondition), "id")
    self.countdownTime = map_instance.countdownTime / 1000
    local totalTime = map_instance.totalTime / 1000
    self.monsterTbl = map_instanceMission
    local monsterId = tonumber(self.monsterTbl.param)
    local monster_instance = ClientTable.cfg_Monster_monsterManager:TryGetValue(monsterId)
    self.lab_instance:SetText(map_instance.name)
    self.lab_goalmonster:SetText(monster_instance.name .. "Ti\195\170u di\225\187\135t")
    if self.args.type == TranScriptType.PersonBoss_Tower then
      self.lab_rewards:SetText("Th\198\176\225\187\159ng ph\195\179 b\225\186\163n")
      local currentData = TowerData:GetRunningInstanceData()
      if currentData then
        self:SetTowerCopyReward(currentData.rewards)
      end
      self.descBtn:SetActive(false)
    end
    self:SetUpdateUIInfo()
    if self.InitTimer == nil then
      self.InitTimer = self:ShowTimer(totalTime, self.lab_fightTimeValue)
    end
  end
end

function Instance_GoalUI:SetUpdateUIInfo()
  if self.args.type == TranScriptType.BloodCastle or self.args.type == TranScriptType.RefineTower or self.args.type == TranScriptType.DemonPlaza or self.args.type == TranScriptType.SecretBoss or self.args.type == TranScriptType.Person_KaliMaTemple or self.args.type == TranScriptType.PersonKaLiMa or self.args.type == TranScriptType.TrialsBoss or self.args.type == TranScriptType.RegenerateBoss or self.args.type == TranScriptType.KalunteRuins or self.args.type == TranScriptType.KSBattle or self.args.type == TranScriptType.VacantSpace or self.args.type == TranScriptType.AncientBoss or self.args.type == TranScriptType.YanGuBoss or self.args.type == TranScriptType.LostMirageBoss or self.args.type == TranScriptType.ZoomSecretRealm then
    self:SetBaseUIInfo()
    self.bg_countdown:SetActive(false)
  elseif self.args.type == TranScriptType.WarAllianceBoss then
    self:SetBaseUIInfo()
    self.bg_countdown:SetActive(false)
  else
    local success = self.args.success
    TranScriptData.IsTranscriptSuccess = success
    local monsterTbl = self.monsterTbl
    local count = tonumber(monsterTbl.count)
    self.lab_tips:SetActive(true)
    self.btn_Exit:SetActive(not success)
    if self.args.type == TranScriptType.PersonBoss_Tower then
      if success then
        self.btn_quit:SetActive(false)
        local currentData = TowerData:GetRunningInstanceData()
        self:GetTowerReward(currentData.rewards)
        if TowerData.GetResidueChallengeCount() > 1 then
          self.btn_towerNext:SetActive(true)
          self.btn_receive.transform.localPosition = Vector3.right * -457 + Vector3.up * -69.1
          self.btn_towerNext.transform.localPosition = Vector3.right * -356.8 + Vector3.up * -69.1
        end
        self.lab_tips:SetActive(false)
      end
      self.getReward:SetActive(success)
      if self.args.basic.mapId then
        local idMap = tonumber(self.args.basic.mapId)
        local floorNum = idMap % 100
        idMap = math.floor(idMap * 0.01) + 1
        idMap = idMap * 10000 + 100
        if floorNum == 0 then
          floorNum = 100
        end
        idMap = idMap + floorNum
        local countTab = ClientTable.cfg_Map_instance_missionManager:TryGetValue(idMap, "id")
        if countTab then
          count = countTab.count
        end
      end
    end
  end
end

function Instance_GoalUI:SetTranUIActiveType()
  if self.args and self.args.type then
    local instanceType = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(10520102).effect)
    self.personInstance:SetActive(self.args.type == TranScriptType.PersonBoss_Tower)
    self.bloodCastleInstance:SetActive(self.args.type == TranScriptType.BloodCastle or self.args.type == TranScriptType.DemonPlaza or self.args.type == TranScriptType.RefineTower)
    self.secretInstance:SetActive(self.args.type == TranScriptType.SecretBoss and self.args.instanceType ~= nil and self.args.instanceType ~= instanceType)
    self.reinBossInstance:SetActive(self.args.type == TranScriptType.SecretBoss and self.args.instanceType ~= nil and self.args.instanceType == instanceType or self.args.type == TranScriptType.RegenerateBoss or self.args.type == TranScriptType.LostMirageBoss or self.args.type == TranScriptType.YanGuBoss)
    self.kalimaTempleInstance:SetActive(self.args.type == TranScriptType.Person_KaliMaTemple)
    self.warAllianceBossInstance:SetActive(self.args.type == TranScriptType.WarAllianceBoss)
    self.trailBossInstance:SetActive(self.args.type == TranScriptType.TrialsBoss)
    self.KaLunTeInstance:SetActive(self.args.type == TranScriptType.KalunteRuins)
    self.NightFightInstance:SetActive(self.args.type == TranScriptType.KSBattle)
    self.YuanGuBOSSInstance:SetActive(self.args.type == TranScriptType.AncientBoss)
    self.zoomSecretRealmInstance:SetActive(self.args.type == TranScriptType.ZoomSecretRealm)
  end
end

function Instance_GoalUI:SetCopyAward(cfg_Map_instance, mapId)
  local BelongRewardID = MonsterData.GetBelongReward(mapId)
  local award = string.split(cfg_Map_instance.dropItem, "&")
  local tabReward = {}
  for k, v in pairs(BelongRewardID) do
    table.insert(tabReward, v)
  end
  for k, v in pairs(award) do
    if string.find(v, "_") then
      if RoleUtility.CareerJudge(ViewData.meData.career, tonumber(string.split(v, "_")[1])) then
        award = string.split(string.split(v, "_")[2], "#")
        for kk, vv in pairs(award) do
          table.insert(tabReward, vv)
        end
      end
    else
      local awardInAll = string.split(v, "#")
      for kk, vv in pairs(awardInAll) do
        table.insert(tabReward, vv)
      end
    end
  end
  self.copyName = cfg_Map_instance.name
  for index = 1, #tabReward do
    if index <= 3 then
      local obj = self.btn_ItemPriTemp:GetOrCreateItem(index)
      obj:SetActive(true)
      obj = UIControl(obj.transform)
      local rewardtbl = string.split(tabReward[index], "#")
      local rewardid = tonumber(rewardtbl[1])
      local rewardCount = tonumber(rewardtbl[2])
      local itemData = ItemUtility.GenerateItemData(rewardid)
      itemData.count = rewardCount
      obj.itemCellData = ItemCellData()
      obj.itemCellData:RefreshData(itemData)
      table.insert(self.objTbl, obj)
      ItemUtility.ShowItemCell(obj, obj.itemCellData, self, true)
    end
  end
end

function Instance_GoalUI:SetTowerCopyReward(tabReward)
  local childCount = self.Content.transform.childCount
  local obj
  if childCount > #tabReward then
    for index = #tabReward, childCount - 1 do
      obj = self.Content.transform:GetChild(index).gameObject
      obj:SetActive(false)
    end
  end
  for i = 1, #tabReward do
    local item = self.btn_ItemPriTemp:GetOrCreateItem(i)
    local AwardData = ItemUtility.GenerateItemData(tonumber(tabReward[i].itemId))
    AwardData.count = tonumber(tabReward[i].count)
    item.itemCellData = item.itemCellData or ItemCellData()
    item.itemCellData:RefreshData(AwardData)
    ItemUtility.ShowItemCell(item, item.itemCellData, self, true)
    item:SetActive(true)
  end
end

function Instance_GoalUI:SetMonsterInfo(monsters, monsterId)
  local monsterdeadCount = 0
  for k, monster in pairs(monsters) do
    local configid = monster.cid
    local hp = monster.hp
    if hp <= 0 and monsterId == configid then
      monsterdeadCount = monsterdeadCount + 1
    end
  end
  return monsterdeadCount
end

function Instance_GoalUI:InitTeamInfo()
  if TeamData.isInTeam == true then
    self:OnTeamInfo()
  end
end

function Instance_GoalUI:OnTeamInfo()
  self.isInTeam = TeamData.isInTeam
  if TranScriptData.InTranscript and (self.args and self.args.type == TranScriptType.BloodCastle or self.args and self.args.type == TranScriptType.DemonPlaza) then
    self:SetPickUpRule()
  end
end

function Instance_GoalUI:SetPickUpRule()
  local whiteType = string.format("%s#%s", EItemType.Equipe, "101")
  local greyType = string.format("%s#%s", EItemType.Equipe, "102")
  if self.isInTeam == true then
    QiJiHelperData.SetCantFakePickUpType(EResourcesType.gold, self.isInTeam)
    QiJiHelperData.SetCantFakePickUpType(whiteType, self.isInTeam)
    QiJiHelperData.SetCantFakePickUpType(greyType, self.isInTeam)
  else
    QiJiHelperData.SetPickUpType()
  end
end

function Instance_GoalUI:SetRefineTowerStage(state)
  TranScriptData.IsTranscriptSuccess = self.args.basic.success
  local totalTime = math.floor(self.args.basic.nextStateTime - Time.GetServerTime() / 1000) or 0
  if state == BloodCastleStage.INIT then
    self:SetCountDown(totalTime, self.lab_prepareTimeValue)
  elseif state == BloodCastleStage.WAITING then
    self:SetCountDown(totalTime, self.lab_preaPareTimeValue)
  elseif state == BloodCastleStage.CLOSING then
  else
    if self.args.basic.success then
      local posStr = ClientTable.cfg_Npc_npcManager:TryGetValue(self.args.basic.basic.mapId)
      self.bloodCastleInstance:SetActive(true)
      self:SetCountDown(totalTime, self.lab_fightTimeValue, true)
      self.fight:SetActive(false)
      self.finish:SetActive(true)
      self.lab_finish:SetText(ClientTable.cfg_Ui_wordManager:TryGetValue("tilianzhita_finish", "id").content)
      self.lab_finish2:SetActive(false)
      self.btn_combineFinish:SetActive(true)
      self.btn_combineFinish:SetOnClick(self, function()
        PathFinderManager.MoveToNpc({
          npcId = posStr.npcId
        }, nil, Purpose.ClickNpc, nil, nil, nil, true)
      end)
    else
      self.fight:SetActive(true)
      self.finish:SetActive(false)
      local task = ClientTable.cfg_Map_instance_missionManager:TryGetValue(self.args.basic.task[1].id, "id")
      self.taskType = task.type
      if task.missionPhase == "Giai \196\145o\225\186\161n 2" then
        CS.Framework.DrawbridgeEvent.SetDrawbridgeRotate()
      end
      if task.type == 4 then
        TranScriptData.NpcData = task
      end
      self.lab_goalMonsterBloodCastle:SetText(task.description)
      local str
      if self.args.basic.task[1].count < task.count then
        str = string.GetColorText(tostring(self.args.basic.task[1].count or 0), ItemQuality2ColorDic[7])
      else
        str = self.args.basic.task[1].count or 0
      end
      self.lab_countBloodCastle:SetText(string.format("%s/%d", str, task.count))
      if self.args.type == TranScriptType.RefineTower then
        local audios = ClientTable.cfg_Audio_audioManager:TryGetValue(38, "id")
        if audios and self.IsPlayBgm == false then
          AudioManager.PlayBGM(audios.resourceName, audios.volume)
          self.IsPlayBgm = true
        end
        if not string.isNullOrEmpty(task.autoMission) then
          local pos
          if task.type == BloodCastleStage.acquire then
            pos = ClientTable.cfg_Activity_globalManager:TryGetValue(101008, "id").effect
          else
            local type = string.split(task.autoMission, "&")
            pos = string.split(type[1], "#")[2]
          end
          TranScriptData.PosData = string.split(pos, "#")
          TranScriptData.TaskType = task.type
          TranScriptData.IsVoluntarily = true
        end
        self.lab_goalBloodCastle:SetText(task.missionPhase)
        self.score:SetActive(false)
      end
      self.lab_fightTimeValue:SetActive(true)
      self:SetCountDown(totalTime, self.lab_fightTimeValue)
    end
    local ContentData = TranScriptData.GetContentData()
    local dropItem = ClientTable.cfg_Map_instanceManager:TryGetValue(self.args.basic.basic.mapId).dropItem
    local AwardTab = {}
    if not string.isNullOrEmpty(dropItem) then
      AwardTab = string.split(dropItem, "&")
    end
    self.copyReward = AwardTab
    self.copyName = ContentData.name
    for i = 1, table.count(AwardTab) do
      local Award = string.split(AwardTab[i], "#")
      local obj = self.btn_ItemTemp:GetOrCreateItem(i)
      local AwardData = ItemUtility.GenerateItemData(tonumber(Award[1]))
      if self.args.type == TranScriptType.DemonPlaza then
        if self.args.score and 1000 <= self.args.score then
          AwardData.count = self.EmoExpNum
        else
          AwardData.count = tonumber(Award[2]) + self.args.score * self.EmoIntegral
          self.EmoExpNum = AwardData.count
        end
      else
        AwardData.count = tonumber(Award[2])
      end
      obj.itemCellData = obj.itemCellData or ItemCellData()
      obj.itemCellData:RefreshData(AwardData)
      table.insert(self.objTbl, obj)
      ItemUtility.ShowItemCell(obj, obj.itemCellData, self, true)
    end
  end
  self:SetTaskStageUI(state)
end

function Instance_GoalUI:SetBloodCastleStage(state)
  TranScriptData.IsTranscriptSuccess = self.args.basic.success
  local totalTime = math.floor(self.args.basic.nextStateTime - Time.GetServerTime() / 1000) or 0
  if state == BloodCastleStage.INIT then
    if self.args.basic.initWaitTime == 0 then
      local intervalTime = TranScriptData.limitTimeUnix - Time.GetServerSecondTime()
      local time = math.floor(intervalTime / 1000)
      self:SetCountDown(time, self.lab_prepareTimeValue)
    else
      self:SetCountDown(totalTime, self.lab_prepareTimeValue)
    end
  elseif state == BloodCastleStage.WAITING then
    self:SetCountDown(totalTime, self.lab_preaPareTimeValue)
  elseif state == BloodCastleStage.CLOSING then
    if self.args.type ~= TranScriptType.BloodCastle and self.args.type ~= TranScriptType.DemonPlaza then
      self.btn_quit:SetActive(true)
    end
    if self.args.type == TranScriptType.DemonPlaza then
      self:GetReward(10)
    end
  else
    if self.args.basic.success then
      if self.args.type == TranScriptType.BloodCastle then
        self.bloodCastleInstance:SetActive(true)
        self:SetCountDown(totalTime, self.lab_fightTimeValue, true)
      end
      self.fight:SetActive(false)
      self.finish:SetActive(true)
      self.lab_finish:SetActive(true)
      self.lab_finish2:SetActive(true)
      self.btn_combineFinish:SetActive(false)
      self.lab_finish:SetText("Nhi\225\187\135m v\225\187\165 hoan th\195\160nh, h\195\163y chi\225\186\191n \196\145\225\186\165u \196\145\225\186\191n gi\195\162y ph\195\186t cu\225\187\145i c\195\185ng!")
      self.lab_finish2:SetText("(Tr\198\176\225\187\155c khi h\225\186\191t gi\225\187\157 v\225\186\171n c\195\179 th\225\187\131 ti\225\186\191p t\225\187\165c di\225\187\135t qu\195\161i nh\225\186\173n EXP)")
    else
      self.fight:SetActive(true)
      self.finish:SetActive(false)
      local task = ClientTable.cfg_Map_instance_missionManager:TryGetValue(self.args.basic.task[1].id, "id")
      self.taskType = task.type
      if task.missionPhase == "Giai \196\145o\225\186\161n 2" then
        CS.Framework.DrawbridgeEvent.SetDrawbridgeRotate()
      end
      if task.type == 4 then
        TranScriptData.NpcData = task
      end
      self.lab_goalMonsterBloodCastle:SetText(task.description)
      local str
      if self.args.basic.task[1].count < task.count then
        str = string.GetColorText(tostring(self.args.basic.task[1].count or 0), ItemQuality2ColorDic[7])
      else
        str = self.args.basic.task[1].count or 0
      end
      self.lab_countBloodCastle:SetText(string.format("%s/%d", str, task.count))
      if self.args.type == TranScriptType.BloodCastle then
        local audios = ClientTable.cfg_Audio_audioManager:TryGetValue(38, "id")
        if audios and self.IsPlayBgm == false then
          AudioManager.PlayBGM(audios.resourceName, audios.volume)
          self.IsPlayBgm = true
        end
        if not string.isNullOrEmpty(task.autoMission) then
          local pos
          if task.type == BloodCastleStage.acquire then
            pos = ClientTable.cfg_Activity_globalManager:TryGetValue(100409, "id").effect
          else
            local type = string.split(task.autoMission, "&")
            pos = string.split(type[1], "#")[2]
          end
          TranScriptData.PosData = string.split(pos, "_")
          TranScriptData.TaskType = task.type
          TranScriptData.IsVoluntarily = true
          TranScriptData.SetVoluntarily()
        end
        self.lab_goalBloodCastle:SetText(task.missionPhase)
        self.score:SetActive(false)
      elseif self.args.type == TranScriptType.DemonPlaza then
        local function autoWay()
          local monsterList = RoleManager.GetRoleListByType(ERoleType.Monster)
          
          local meCell = RoleManager.me.cellPos
          local isHaveMonster = false
          for k, v in pairs(monsterList.list) do
            local distance = Mathf.Max(Mathf.Abs(v.cellPos.x - meCell.x), Mathf.Abs(v.cellPos.y - meCell.y))
            if distance <= QiJiHelperData.SettingData.KillMonsterScope then
              isHaveMonster = true
              break
            end
          end
          if QiJiHelperData.isAutoFight and RoleManager.me:IsStillState() and RoleManager.me.usingSkillId == nil and not TranScriptData.isWay and not TranScriptData.isOperate and RoleManager.me:CanMove() and not isHaveMonster then
            TranScriptData.isWay = true
            RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
            local mapId = tostring(self.args.basic.basic.mapId)
            local pointStr = ""
            local x = 0
            local y = 0
            if self.pathPoint[mapId] ~= nil then
              pointStr = string.split(self.pathPoint[mapId][self.pathPointNum], "_")
              x = tonumber(pointStr[1])
              y = tonumber(pointStr[2])
            end
            local path = RoleManager.me:MoveTo({x = x, y = y}, 0, function()
              if self.pathPointNum == 5 then
                self.pathPointNum = 1
              else
                self.pathPointNum = self.pathPointNum + 1
              end
              self:StopMove()
            end)
          end
        end
        
        if self.wayTimer == nil then
          self.wayTimer = Timer.StartLoopForever(5, autoWay)
        end
        self.lab_goalBloodCastle:SetText(string.format("\196\144\225\187\163t %d", self.args.count))
        self.lab_score:SetText(self.args.score)
        TranScriptData.DemonPlazaIntegral = self.args.score
        self.score:SetActive(true)
      end
      self:SetCountDown(totalTime, self.lab_fightTimeValue)
    end
    local ContentData = TranScriptData.GetContentData()
    local boxData = {}
    if self.args.type == TranScriptType.BloodCastle then
      local rewardId = tonumber(ClientTable.cfg_Activity_globalManager:TryGetValue(100412, "id").effect)
      ContentData.rewards = rewardId
      boxData = ConfigManager.FindConfigs("cfg_Box_box", "boxId", rewardId)
    else
    end
    local AwardTab = {}
    for k, v in pairs(boxData) do
      if v.boxId == tonumber(ContentData.rewards) then
        table.insert(AwardTab, v.itemId .. "#" .. v.count)
      end
    end
    self.copyReward = AwardTab
    self.copyName = ContentData.name
    for i = 1, table.count(AwardTab) do
      local Award = string.split(AwardTab[i], "#")
      local obj = self.btn_ItemTemp:GetOrCreateItem(i)
      local AwardData = ItemUtility.GenerateItemData(tonumber(Award[1]))
      if self.args.type == TranScriptType.DemonPlaza then
        if self.args.score and 1000 <= self.args.score then
          AwardData.count = self.EmoExpNum
        else
          AwardData.count = tonumber(Award[2]) + self.args.score * self.EmoIntegral
          self.EmoExpNum = AwardData.count
        end
      else
        AwardData.count = tonumber(Award[2])
      end
      obj.itemCellData = obj.itemCellData or ItemCellData()
      obj.itemCellData:RefreshData(AwardData)
      table.insert(self.objTbl, obj)
      ItemUtility.ShowItemCell(obj, obj.itemCellData, self, true)
    end
  end
  self:SetTaskStageUI(state)
end

function Instance_GoalUI:SetCountDown(time, lab, isSucceed)
  if self.nextTime ~= self.args.basic.nextStateTime or isSucceed then
    if self.InitTimer then
      Timer.Stop(self.InitTimer)
      self.InitTimer = nil
    end
    self.InitTimer = self:ShowTimer(time, lab)
    self.nextTime = self.args.basic.nextStateTime or 0
  end
end

function Instance_GoalUI:SetTaskStageUI(state)
  for k, v in pairs(self.TaskStage) do
    if k == state then
      v:SetActive(true)
    else
      v:SetActive(false)
    end
  end
  self.personInstance:SetActive(false)
  self.warAllianceBossInstance:SetActive(false)
end

function Instance_GoalUI:ShowTimer(surplusTime, lab_countdown, isText, isZeroExitTranScript)
  surplusTime = math.floor(surplusTime)
  lab_countdown:SetActive(true)
  
  local function UpdateTimer(isInit)
    if not isInit then
      surplusTime = surplusTime - 1
    end
    local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
    local timeStrSecret = TimeUtility.ShowNewTime(surplusTime)
    local endTimeText = Localization.GetUIWord("jieshudaojishi")
    local endTime = string.format(endTimeText, math.modf(surplusTime))
    local refresh = string.format("L\195\160m m\225\187\155i sau %s", timeStrSecret)
    if self.args.type == TranScriptType.PersonBoss or self.args.type == TranScriptType.PersonBoss_Tower or self.args.type == TranScriptType.DemonPlaza or self.args.type == TranScriptType.Person_KaliMaTemple or self.args.type == TranScriptType.PersonKaLiMa then
      if isText then
        lab_countdown:SetText(endTime)
        if surplusTime <= 1 then
          self.lab_rewards:SetActive(false)
        end
      else
        if surplusTime <= 1 then
          lab_countdown:SetText("00:00")
        end
        lab_countdown:SetText(timeStr)
      end
    elseif self.args.type == TranScriptType.SecretBoss then
      if surplusTime <= 0 then
        lab_countdown:SetText("Ch\225\187\157 ti\195\170u di\225\187\135t")
      else
        self.count = RefreshData.GetInstanceCount(tonumber(self.countKey))
        if 0 < self.count and self.mapId ~= tonumber(TranScriptData.secretBossPreTask[3]) then
          if isText then
            lab_countdown:SetText(endTime)
          else
            lab_countdown:SetText(refresh)
          end
        elseif isText then
          lab_countdown:SetText(endTime)
        else
          lab_countdown:SetText(refresh)
        end
      end
    elseif self.args.type == TranScriptType.TrialsBoss then
      if surplusTime <= 0 then
        lab_countdown:SetText("Ch\225\187\157 ti\195\170u di\225\187\135t")
      elseif isText then
        lab_countdown:SetText(endTime)
      else
        lab_countdown:SetText(refresh)
      end
    else
      lab_countdown:SetText(timeStr)
    end
    if self.args.type == TranScriptType.SecretBoss or self.args.type == TranScriptType.TrialsBoss then
    elseif surplusTime <= 0 and self.args.type ~= TranScriptType.DemonPlaza and self.args.type ~= TranScriptType.BloodCastle then
      lab_countdown:SetActive(false)
      self.bg_countdown:SetActive(false)
    end
  end
  
  UpdateTimer(true)
  return Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function Instance_GoalUI:RefreshRoleCountDownTimeByServer(_, serverRoleCountDownTimeData)
  if table.isNullOrEmpty(serverRoleCountDownTimeData) == false and self.mapId and self.mapId == serverRoleCountDownTimeData.mapId and serverRoleCountDownTimeData.countDownTime >= 0 then
    if self.InitTimer ~= nil then
      Timer.Stop(self.InitTimer)
      self.InitTimer = nil
    end
    self.InitTimer = self:ShowRoleCountDownTimer(serverRoleCountDownTimeData.countDownTime / 1000, self.lab_fightTimeValue, false)
  end
end

function Instance_GoalUI:ShowRoleCountDownTimer(surplusTime, lab_countdown, isZeroExitTranScript)
  surplusTime = math.floor(surplusTime)
  lab_countdown:SetActive(true)
  
  local function UpdateTimer()
    surplusTime = surplusTime - 1
    local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
    lab_countdown:SetText(timeStr)
    if surplusTime <= 0 then
      lab_countdown:SetActive(false)
      self.bg_countdown:SetActive(false)
      TranScriptData.ServerRoleCountDownTimeData = nil
      if isZeroExitTranScript == true then
        TranScriptController.ReqExitInstance()
      end
    end
  end
  
  local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
  lab_countdown:SetText(timeStr)
  return Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function Instance_GoalUI:StopMove()
  if TranScriptData.InTranscript then
    TranScriptData.isWay = false
    if not TranScriptData.isOperate and self.args and self.args.type == TranScriptType.DemonPlaza and not QiJiHelperData.isAutoFight then
      RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
    end
  end
end

function Instance_GoalUI:UpdateTimer()
  if IsNil(self.lab_getRewardTime) == true then
    return
  end
  self.lab_getRewardTime:SetActive(true)
  self.lab_getRewardTime:SetText(string.format("(%dS)", self.getRewardTime))
  self.getRewardTime = self.getRewardTime - 1
  if self.getRewardTime == 0 and self.RewardTime then
    Timer.Stop(self.RewardTime)
    self.RewardTime = nil
    self.lab_getRewardTime:SetActive(false)
    self:btn_receiveOnClick()
  end
end

function Instance_GoalUI:GetReward(getRewardTime)
  if self.isAcceptReward then
    self.lab_instance:SetActive(true)
    return
  end
  self.lab_instance:SetActive(false)
  self.personInstance:SetActive(false)
  self.warAllianceBossInstance:SetActive(false)
  self.getReward:SetActive(true)
  self.btn_Action:SetActive(false)
  self.getRewardTime = getRewardTime
  self.lab_copyName:SetText(self.copyName)
  for i = 1, table.count(self.copyReward) do
    local Award = string.split(self.copyReward[i], "#")
    local obj = self.btn_ItemRewardTemp:GetOrCreateItem(i)
    local AwardData = ItemUtility.GenerateItemData(tonumber(Award[1]))
    AwardData.count = self.EmoExpNum or Award[2]
    obj.itemCellData = obj.itemCellData or ItemCellData()
    obj.itemCellData:RefreshData(AwardData)
    table.insert(self.objTbl, obj)
    ItemUtility.ShowItemCell(obj, obj.itemCellData, self, true)
  end
  if getRewardTime and (self.args.type == TranScriptType.BloodCastle or self.args.type == TranScriptType.DemonPlaza) then
    self.RewardTime = Timer.StartLoopForever(1, self.UpdateTimer, self)
  end
end

function Instance_GoalUI:GetTowerReward(currentData)
  if self.isAcceptReward then
    return
  end
  self.lab_instance:SetActive(false)
  self.personInstance:SetActive(false)
  self.warAllianceBossInstance:SetActive(false)
  self.getReward:SetActive(true)
  self.btn_Action:SetActive(false)
  self.lab_copyName:SetText(TowerData:GetRunningInstanceData().name)
  for i = 1, #currentData do
    local obj = self.btn_ItemRewardTemp:GetOrCreateItem(i)
    local AwardData = ItemUtility.GenerateItemData(currentData[i].itemId)
    AwardData.count = currentData[i].count
    obj.itemCellData = obj.itemCellData or ItemCellData()
    obj.itemCellData:RefreshData(AwardData)
    ItemUtility.ShowItemCell(obj, obj.itemCellData, self, true)
    table.insert(self.objTbl, obj)
    obj:SetActive(true)
  end
end

function Instance_GoalUI:RefreshWarAllianceBoss()
  if self.args and self.args.type == TranScriptType.WarAllianceBoss then
    local floor = GradData.JudgeArea(RoleManager.me.cellPos)
    if not floor then
      return
    end
    local str = string.format("<color=#FF2323>%d</color>/<color=#1ADD1F>%d</color>", floor, GradData.maxFloor)
    if floor >= GradData.maxFloor then
      str = string.format("<color=#1ADD1F>%d</color>/<color=#1ADD1F>%d</color>", floor, GradData.maxFloor)
    end
    self.lab_layer:SetText(str)
    local monster = GradData.GetBoss(floor) and GradData.GetBoss(floor) or {isKill = false}
    local number = monster.isKill and 1 or 0
    local killColor = monster.isKill and "#1ADD1F" or "#FF2323"
    local strmon = string.format("<color=%s>%d</color>/<color=#1ADD1F>%d</color>", killColor, number, 1)
    self.lab_target:SetText(strmon)
    if floor <= GradData.maxFloor then
      if monster.isKill then
        if floor == GradData.maxFloor then
          self.btn_next:SetActive(false)
          self.btn_auction:SetActive(GradData.GetShowAuction())
        else
          self.btn_next:SetActive(true)
          self.btn_auction:SetActive(false)
        end
      else
        self.btn_next:SetActive(false)
        self.btn_auction:SetActive(false)
      end
    else
      self.btn_next:SetActive(false)
      self.btn_auction:SetActive(false)
    end
    self.btn_next:SetOnClick(self, function()
      local position = GradData.GetTransPos(floor)
      if position then
        RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
        RoleManager.me:MoveTo(position, 0, function(moveRes)
        end)
      end
    end)
    self.btn_auction:SetOnClick(self, function()
      local tbl = GradData.GetNavi()
      if tbl and GradData.GoToNavi(tbl) then
        NavigationUtility.OpenPanel(tbl)
      end
    end)
    self:GradCoolDownTime()
  end
end

function Instance_GoalUI:GradCoolDownTime()
  local curTime = Time.GetServerSecondTime()
  local time = os.date("*t", curTime)
  local startTime, endTime = GradData.GetGradTime()
  local endTimes = 0
  if endTime ~= nil then
    local timeS = string.split(endTime, ":")
    endTimes = os.time({
      year = time.year,
      month = time.month,
      day = time.day,
      hour = tonumber(timeS[1]),
      min = tonumber(timeS[2])
    })
  end
  local coolTime = tonumber(endTimes) - curTime
  self:SetCountDown(coolTime, self.labboss_time)
end

function Instance_GoalUI:SetSecretPath()
  if TranScriptData.GetSecretBossIsTask() == true and QiJiHelperData.isAutoFight == false then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
  end
end

function Instance_GoalUI:SetSecretUIInfo()
  self:SetBossInfoUI()
  self:SetDamageRank()
end

function Instance_GoalUI:SetBossInfoUI()
  local bossDataList = {}
  for i = 1, table.count(self.args.monsters) do
    local bossData = {}
    bossData.number = i
    bossData.bossId = self.args.monsters[i].cid
    bossData.reliveTime = self.args.monsters[i].reliveTime
    bossData.x = self.args.monsters[i].x
    bossData.y = self.args.monsters[i].y
    bossData.hurts = nil
    for j = 1, #self.args.bossInfo do
      if self.args.bossInfo[j].mid == self.args.monsters[i].mid then
        bossData.hurts = self.args.bossInfo[j].hurts
      end
    end
    bossDataList[i] = bossData
  end
  
  local function GetMonsterDefendByBossID(BossID)
    local MonsterBossTable = ClientTable.cfg_Monster_bossManager:TryGetValue(BossID, "id")
    return MonsterBossTable and MonsterBossTable.defend or 0
  end
  
  table.sort(bossDataList, function(a, b)
    if a ~= nil and b ~= nil then
      if a.bossId and b.bossId then
        return GetMonsterDefendByBossID(a.bossId) < GetMonsterDefendByBossID(b.bossId)
      else
        return false
      end
    else
      return false
    end
  end)
  if self.args and self.args.type == TranScriptType.TrialsBoss then
    self.trailBossInfoItemTemp:SetData(bossDataList)
  else
    self.bossInfoItemTemp:SetData(bossDataList)
  end
end

function Instance_GoalUI:OnRoleLeaveView(_, roleData)
  if self.args.type ~= TranScriptType.Person_KaliMaTemple and self.args.type ~= TranScriptType.TrialsBoss and self.args.type ~= TranScriptType.RegenerateBoss and self.args.type ~= TranScriptType.LostMirageBoss and self.args.type ~= TranScriptType.YanGuBoss then
    return
  end
  if self.damageRankBossInfo and roleData and self.damageRankBossInfo.mid == roleData.id then
    local damageRankList = {}
    local myDamage = 0
    local myRank = ""
    self:RefreshDamageRank(damageRankList, myDamage, myRank)
    self.damageRankBossInfo = nil
  end
end

function Instance_GoalUI:OnMonsterEnterView(id, data)
  if data.hp == 0 and self.args.type == TranScriptType.YanGuBoss then
    self:SetUpdateUIInfo()
  end
end

function Instance_GoalUI:SetDamageRank()
  local damageRankList = {}
  local myDamage = 0
  local myRank = ""
  if self.args.type == TranScriptType.Person_KaliMaTemple or self.args.type == TranScriptType.TrialsBoss or self.args.type == TranScriptType.RegenerateBoss or self.args.type == TranScriptType.LostMirageBoss or self.args.type == TranScriptType.YanGuBoss then
    if not table.isNullOrEmpty(self.args.bossInfo) then
      if 0 < #self.args.bossInfo then
        self.damageRankBossInfo = self.args.bossInfo[1]
      end
    else
      self:OnRoleLeaveView()
    end
  else
    for i = 1, table.count(self.args.bossInfo) do
      if self.CurrentSelectId == self.args.bossInfo[i].mid then
        self.damageRankBossInfo = self.args.bossInfo[i]
      end
    end
  end
  local bossInfo = self.damageRankBossInfo
  if bossInfo then
    for i = 1, table.count(bossInfo.hurts) do
      local rankData = {}
      rankData.ranking = i
      rankData.id = bossInfo.hurts[i].id
      rankData.name = bossInfo.hurts[i].name
      rankData.damage = bossInfo.hurts[i].damage
      damageRankList[i] = rankData
      if rankData.id == ViewData.meData.id then
        myDamage = rankData.damage
        myRank = i
      end
    end
  end
  self:RefreshDamageRank(damageRankList, myDamage, myRank)
end

function Instance_GoalUI:RefreshDamageRank(damageRankList, myDamage, myRank)
  local rankItemTemp = self.rankItemTemp
  local lab_myRank = self.lab_myRank
  local lab_myName = self.lab_myName
  local lab_myDamage = self.lab_myDamage
  local instanceType = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(10520102).effect)
  if self.args.instanceType ~= nil and self.args.instanceType == instanceType then
    rankItemTemp = self.rankItemTempRein
    lab_myRank = self.lab_myRankRein
    lab_myName = self.lab_myNameRein
    lab_myDamage = self.lab_myDamageRein
  end
  if self.args.type == TranScriptType.Person_KaliMaTemple then
    rankItemTemp = self.rankItemTempKalima
    lab_myRank = self.lab_myRankKalima
    lab_myName = self.lab_myNameKalima
    lab_myDamage = self.lab_myDamageKalima
  end
  if self.args.type == TranScriptType.TrialsBoss then
    rankItemTemp = self.rankItemTempTrail
    lab_myRank = self.lab_myRankTrail
    lab_myName = self.lab_myNameTrail
    lab_myDamage = self.lab_myDamageTrail
  end
  if self.args.type == TranScriptType.RegenerateBoss or self.args.type == TranScriptType.YanGuBoss then
    rankItemTemp = self.rankItemTempRein
    lab_myRank = self.lab_myRankRein
    lab_myName = self.lab_myNameRein
    lab_myDamage = self.lab_myDamageRein
  end
  if self.args.type == TranScriptType.LostMirageBoss then
    rankItemTemp = self.rankItemTempRein
    lab_myRank = self.lab_myRankRein
    lab_myName = self.lab_myNameRein
    lab_myDamage = self.lab_myDamageRein
  end
  rankItemTemp:SetData(damageRankList)
  lab_myRank:SetText(myRank)
  lab_myName:SetText(ViewData.meData.name)
  lab_myDamage:SetText(Mathf.NumberShowFormat(myDamage, 2))
end

function Instance_GoalUI:BossInfoClick(posX, posY)
  local pos = {x = posX, y = posY}
  self:BeginFindPath(pos)
end

function Instance_GoalUI:SetSecretUI(state)
  self.sv_bossinfo:SetActive(state)
  self.sv_damagelist:SetActive(not state)
end

function Instance_GoalUI:SetTrailUI(state)
  self.sv_trailbossinfo:SetActive(state)
  self.sv_trailattacklist:SetActive(not state)
end

function Instance_GoalUI:DestroySecretTime()
  for k, v in pairs(SecretBossTime) do
    Timer.Stop(SecretBossTime[k])
    SecretBossTime[k] = nil
  end
end

function Instance_GoalUI:DestroyTrailTime()
  for k, v in pairs(TrailBossTime) do
    Timer.Stop(TrailBossTime[k])
    TrailBossTime[k] = nil
  end
end

function Instance_GoalUI:BeginFindPath(pos)
  RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
  RoleManager.me:MoveTo({
    x = pos.x,
    y = pos.y
  }, 0, function()
    local mePos = Vector2(RoleManager.me.cellPos.x, RoleManager.me.cellPos.y)
    local isArrive = PathFinderManager.pathFinding.IsDetectionRangePoint(pos, mePos, 5)
    if isArrive then
      RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
    end
  end)
end

function Instance_GoalUI:RefreshTrappedRankCallBack()
  self:RefershkSBattleRankView()
end

function Instance_GoalUI:RefershkSBattleRankView()
  if self.kunShouBattleGoalUITemp then
    self.kunShouBattleGoalUITemp:RefreshView()
  end
end

function Instance_GoalUI:OnBagChange()
  if self.args == nil or self.args.type == nil then
    return
  end
  if self.args.type == TranScriptType.ZoomSecretRealm then
    self.zoomSecretRealmInstanceTemplate:Refresh()
  end
end
