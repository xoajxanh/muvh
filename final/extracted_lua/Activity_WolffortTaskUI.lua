Activity_WolffortTaskUI = class(BaseUI)
Activity_WolffortTaskUI.layer = UILayer.Panel
Activity_WolffortTaskUI.orderInLayer = 0
Activity_WolffortTaskUI.hideType = UIHideType.WaitDestroy
Activity_WolffortTaskUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_WolffortTaskUI.escClose = UIEscClose.DontClose

function Activity_WolffortTaskUI:InitControls()
  self.subPanel = self:GetControl("panel/subPanel")
  self.tog_Task = self:GetControl("panel/subPanel/TaskTeamBar/tog_Task")
  self.tog_Team = self:GetControl("panel/subPanel/TaskTeamBar/tog_Team")
  self.TaskPanel = self:GetControl("panel/subPanel/TaskPanel")
  self.PreparatoryPanel = self:GetControl("panel/subPanel/TaskPanel/PreparatoryPanel")
  self.lab_defendNum = self:GetControl("panel/subPanel/TaskPanel/PreparatoryPanel/lab_defendNum")
  self.lab_countdown = self:GetControl("panel/subPanel/TaskPanel/PreparatoryPanel/lab_countdown")
  self.CombatPanel = self:GetControl("panel/subPanel/TaskPanel/CombatPanel")
  self.lab_RunDefendNum = self:GetControl("panel/subPanel/TaskPanel/CombatPanel/lab_RunDefendNum")
  self.lab_norRankScore = self:GetControl("panel/subPanel/TaskPanel/CombatPanel/lab_norRankScore")
  self.lab_norRankNumber = self:GetControl("panel/subPanel/TaskPanel/CombatPanel/lab_norRankNumber")
  self.lab_teamRewards = self:GetControl("panel/subPanel/TaskPanel/CombatPanel/lab_teamRewards")
  self.lab_monsterRefreshStep = self:GetControl("panel/subPanel/TaskPanel/CombatPanel/lab_monsterRefreshStep")
  self.lab_MonsterCountDown = self:GetControl("panel/subPanel/TaskPanel/CombatPanel/lab_countDown")
  self.btn_summon = self:GetControl("panel/subPanel/TaskPanel/PreparatoryPanel/btn_summon")
  self.TeamPanel = self:GetControl("panel/subPanel/TeamPanel")
  self.descBtn = self:GetControl("panel/subPanel/descBtn")
  self.go_playerPanelBg = self:GetControl("panel/subPanel/TeamPanel/go_playerPanelBg")
  self.quitRoot = self:GetControl("panel/quitRoot")
  self.btn_quit = self:GetControl("panel/quitRoot/btn_quit")
  self.tog_autoJoin = self:GetControl("panel/subPanel/TeamPanel/NoMemberPanel/tog_autoJoin")
  self.btn_invitation = self:GetControl("panel/subPanel/TeamPanel/MemberPanel/btn_invitation")
  self.NoMemberPanel = self:GetControl("panel/subPanel/TeamPanel/NoMemberPanel")
  self.MemberPanel = self:GetControl("panel/subPanel/TeamPanel/MemberPanel")
  self.btn_createTeam = self:GetControl("panel/subPanel/TeamPanel/NoMemberPanel/btn_createTeam")
  self.btn_joinTeam = self:GetControl("panel/subPanel/TeamPanel/NoMemberPanel/btn_joinTeam")
  self.Content_Members = self:GetControl("panel/subPanel/TeamPanel/MemberPanel/sc_member/Viewport/Content_Members")
  self.lab_memberNum = self:GetControl("panel/subPanel/TeamPanel/MemberPanel/btn_team/lab_memberNum")
  self.btnContent = self:GetControl("panel/subPanel/TeamPanel/go_playerPanelBg/sp_playerPanelBg/sv_btns/Viewport/btnContent")
  self.btn_close = self:GetControl("panel/subPanel/TeamPanel/go_playerPanelBg/btn_close")
end

function Activity_WolffortTaskUI:OnPreLoad()
end

function Activity_WolffortTaskUI:Init()
  self.layer = 0
end

function Activity_WolffortTaskUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local teamMemberEffect, btnContentCom

function Activity_WolffortTaskUI:InitUI()
  btnContentCom = self.btnContent.transform:GetComponent("UIScrollContainer")
end

function Activity_WolffortTaskUI:OnShow()
  local tab = ClientTable.cfg_Monster_monsterManager:TryGetValue(103500016, "id")
  self.statusMaxHp = tab.hp
  self:RegistEvents()
  self:Refresh()
  EventManager.Dispatch(Event.Task_SetTaskPanelHide, true)
  Activity_LangHunYaoSaiData.inActivity = true
  UIManager.Hide(UIID.WarAlliance_Activity)
end

function Activity_WolffortTaskUI:OnHide()
  EventManager.Dispatch(Event.Task_SetTaskPanelHide, false)
  EventManager.Dispatch(Event.TalentBtnShow, false)
  EventManager.Dispatch(Event.LangHunHurtTip, false)
  UIManager.Hide(UIID.WolffortbuffUI)
  Activity_LangHunYaoSaiData.Count = -1
  Activity_LangHunYaoSaiData.inActivity = false
end

function Activity_WolffortTaskUI:OnDestroy()
end

local countDownNum = 0
local downNum = 0

function Activity_WolffortTaskUI:Update()
  if 0 < countDownNum then
    countDownNum = countDownNum - UnityEngineLua.Time.deltaTime
    if countDownNum < 0 then
      countDownNum = 0
    end
    self.lab_countdown:SetText(TimeUtility.ShowTime(math.floor(countDownNum)))
  end
  if 0 < downNum then
    downNum = downNum - UnityEngineLua.Time.deltaTime
    if downNum < 0 then
      downNum = 0
    end
    self.lab_MonsterCountDown:SetText(TimeUtility.ShowTime(math.floor(downNum)))
  end
end

function Activity_WolffortTaskUI:RegistUIEvents()
  self.btn_summon:SetOnClick(self, self.OnBtnSummonOnClick)
  self.tog_Team:SetOnToggleChanged(self, self.TaskToggleClick)
  self.tog_Task:SetOnToggleChanged(self, self.TaskToggleClick)
  self.btn_invitation:SetOnClick(self, self.TeamInvite)
  self.btn_quit:SetOnClick(self, self.OnBtnQuitOnClick)
  self.descBtn:SetOnClick(self, self.OnDescBtnClick)
  self.teamContent = self.Content_Members.transform:GetComponent("UIScrollContainer")
  self.btn_joinTeam:SetOnClick(self, function()
    EventManager.Dispatch(Event.Team_OpenTeamsPanel, nil)
  end)
  self.btn_createTeam:SetOnClick(self, function()
    if TeamData.GetCreateTeamCondition() then
      EventManager.Dispatch(Event.Team_CreateTeam, nil)
    else
      local titleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamError_1")
      local createLevel = tonumber(GlobalConfig.GetGlobalConfig(2450010))
      local text = string.format(titleStr, createLevel)
      UIManager.Show(UIID.PromptTipUI, {
        title = "Nh\225\186\175c nh\225\187\159",
        textContent = text
      })
    end
  end)
  self.btn_close:SetOnClick(self, self.TeamHideUserPanel)
end

function Activity_WolffortTaskUI:OnDescBtnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Activity_WolffortTaskUI")
  if 0 < #lvCfg then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Activity_WolffortTaskUI:OnBtnQuitOnClick()
  NetManager.Send(MapMessage.ReqExitInstance)
end

function Activity_WolffortTaskUI:TaskToggleClick(control, isOn)
  local panel = control == self.tog_Task and self.TaskPanel or self.TeamPanel
  panel:SetActive(isOn)
end

function Activity_WolffortTaskUI:UpdateTeamInfo(id)
  local isInTeam = TeamData.isInTeam
  self:UpdateMemberPanel(isInTeam)
  if isInTeam then
    self:UpdateMemberInfo()
  end
  self:SetLeaderUIItem()
  if self.go_playerPanelBg:GetActive() and self.clickRoleItemInfo and not TeamData.IsTeammate(self.clickRoleItemInfo.rid) then
    self.go_playerPanelBg:SetActive(false)
  end
  self:ShowAutoTeam()
end

function Activity_WolffortTaskUI:UpdateMemberPanel(isInTeam)
  self.MemberPanel.transform.gameObject:SetActive(isInTeam)
  self.NoMemberPanel.transform.gameObject:SetActive(not isInTeam)
end

function Activity_WolffortTaskUI:UpdateMemberInfo()
  local count = table.count(TeamData.membersList)
  self.lab_memberNum:SetText(string.format("%d/5", count))
  if self.teamContent then
    if count < 1 then
      return
    end
    self.teamContent.MaxCount = table.count(TeamData.membersList)
    local index = 0
    for i, v in pairs(TeamData.membersList) do
      local go = self.teamContent:GetScrollGoByIndex(index)
      local objControl = UIControl(go.transform)
      local effect = UIControl(go.transform, "img_selectionEffect")
      objControl:SetOnClick(self, function()
        self:MemberClick(v)
        effect.gameObject:SetActive(true)
        teamMemberEffect = effect
      end)
      self:RefreshMemberItem(v, objControl)
      index = index + 1
    end
  end
end

local teamOwnData = {
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamPosition"),
    callbackFunc = RoleInteractFuncEnum.SendPos
  },
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamLeave"),
    callbackFunc = RoleInteractFuncEnum.LeaveTeam
  }
}
local teamCapCheckOtherUnionData = {
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamSee"),
    callbackFunc = RoleInteractFuncEnum.CheckPlayer
  },
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamAddFriend"),
    callbackFunc = RoleInteractFuncEnum.AddFriend
  },
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamAddAlliance"),
    callbackFunc = RoleInteractFuncEnum.InviteInUnion
  },
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamPrivateChat"),
    callbackFunc = RoleInteractFuncEnum.PrivateTalk
  },
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamKickTeam"),
    callbackFunc = RoleInteractFuncEnum.KickTeam
  },
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamCaptain"),
    callbackFunc = RoleInteractFuncEnum.UpgradeCaptain
  }
}
local teamCapCheckOtherData = {
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamSee"),
    callbackFunc = RoleInteractFuncEnum.CheckPlayer
  },
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamAddFriend"),
    callbackFunc = RoleInteractFuncEnum.AddFriend
  },
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamPrivateChat"),
    callbackFunc = RoleInteractFuncEnum.PrivateTalk
  },
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamKickTeam"),
    callbackFunc = RoleInteractFuncEnum.KickTeam
  },
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamCaptain"),
    callbackFunc = RoleInteractFuncEnum.UpgradeCaptain
  }
}
local checkPlayerUnionData = {
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamSee"),
    callbackFunc = RoleInteractFuncEnum.CheckPlayer
  },
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamAddFriend"),
    callbackFunc = RoleInteractFuncEnum.AddFriend
  },
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamAddAlliance"),
    callbackFunc = RoleInteractFuncEnum.InviteInUnion
  },
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamPrivateChat"),
    callbackFunc = RoleInteractFuncEnum.PrivateTalk
  }
}
local checkPlayerData = {
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamSee"),
    callbackFunc = RoleInteractFuncEnum.CheckPlayer
  },
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamAddFriend"),
    callbackFunc = RoleInteractFuncEnum.AddFriend
  },
  {
    name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamPrivateChat"),
    callbackFunc = RoleInteractFuncEnum.PrivateTalk
  }
}
Activity_WolffortTaskUI.clickRoleItemInfo = {}

function Activity_WolffortTaskUI:MemberClick(role)
  self.clickRoleItemInfo = role
  self.go_playerPanelBg.gameObject:SetActive(true)
  local isMe = role.rid == ViewData.meData.id
  if isMe then
    self:RefreshBtns(teamOwnData)
    return
  end
  if TeamData.isLeader then
    self:RefreshBtns(teamCapCheckOtherUnionData)
    return
  end
  self:RefreshBtns(checkPlayerUnionData)
end

function Activity_WolffortTaskUI:TeamHideUserPanel()
  self.go_playerPanelBg.gameObject:SetActive(false)
  if teamMemberEffect then
    teamMemberEffect.gameObject:SetActive(false)
  end
end

function Activity_WolffortTaskUI:RefreshBtns(data)
  local index = 0
  btnContentCom.MaxCount = table.count(data)
  for i, v in pairs(data) do
    local go = btnContentCom:GetScrollGoByIndex(index)
    local objControl = UIControl(go.transform)
    local btnName = UIControl(objControl.transform, "Text")
    btnName:SetText(v.name)
    objControl:SetOnClick(self, function()
      local callback = self:GetFuncByType(v.callbackFunc)
      callback(self)
    end)
    index = index + 1
  end
end

function Activity_WolffortTaskUI:GetFuncByType(type)
  if type == RoleInteractFuncEnum.CheckPlayer then
    return self.btn_seeOnClick
  elseif type == RoleInteractFuncEnum.SendPos then
    return self.btn_positionOnClick
  elseif type == RoleInteractFuncEnum.AddFriend then
    return self.btn_addFriendsOnClick
  elseif type == RoleInteractFuncEnum.InviteInUnion then
    return self.btn_addGuildOnClick
  elseif type == RoleInteractFuncEnum.PrivateTalk then
    return self.btn_chatOnClick
  elseif type == RoleInteractFuncEnum.KickTeam then
    return self.btn_kickTeamOnClick
  elseif type == RoleInteractFuncEnum.UpgradeCaptain then
    return self.btn_upgradeCaptainOnClick
  elseif type == RoleInteractFuncEnum.InviteTeam then
    return self.btn_inviteTeamOnClick
  elseif type == RoleInteractFuncEnum.LeaveTeam then
    return self.btn_leaveTeamOnClick
  end
end

function Activity_WolffortTaskUI:btn_seeOnClick()
end

function Activity_WolffortTaskUI:btn_positionOnClick()
end

function Activity_WolffortTaskUI:btn_addFriendsOnClick()
end

function Activity_WolffortTaskUI:btn_addGuildOnClick()
end

function Activity_WolffortTaskUI:btn_chatOnClick()
end

function Activity_WolffortTaskUI:btn_kickTeamOnClick()
end

function Activity_WolffortTaskUI:btn_upgradeCaptainOnClick()
end

function Activity_WolffortTaskUI:btn_inviteTeamOnClick()
end

function Activity_WolffortTaskUI:btn_leaveTeamOnClick()
end

function Activity_WolffortTaskUI:RefreshMemberItem(memberData, memberItem)
  local careerSp = UIControl(memberItem.transform, "sp_careerIcon")
  local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(memberData.startCareer, "id").headPortrait
  self:SetSprite("Atlas_headPortrait", spriteName, careerSp)
  local lab_level = UIControl(memberItem.transform, "lab_level")
  lab_level:SetText(string.format("lv.%d", memberData.startLevel))
  local isCap = memberData.rid == TeamData.leaderId
  local go_captain = UIControl(memberItem.transform, "go_captain")
  go_captain.gameObject:SetActive(isCap)
  local go_noCaptain = UIControl(memberItem.transform, "go_noCaptain")
  go_noCaptain.gameObject:SetActive(not isCap)
  local nameLabel = UIControl(isCap and go_captain.transform or go_noCaptain.transform, "lab_name")
  nameLabel:SetText(memberData.startName)
  local sp_offline = UIControl(memberItem.transform, "img_offLineBg")
  local sp_far = UIControl(memberItem.transform, "img_far")
  local sl_hp = UIControl(memberItem.transform, "sl_hp")
  if not memberData.online then
    sp_offline.transform.gameObject:SetActive(true)
    sp_far.transform.gameObject:SetActive(false)
    sl_hp.gameObject:SetActive(false)
    return
  end
  sp_offline.transform.gameObject:SetActive(false)
  local role = RoleManager.GetRoleById(memberData.rid)
  if not role then
    sp_far.transform.gameObject:SetActive(true)
  else
    sp_far.transform.gameObject:SetActive(false)
    local roleData = role.data
    sl_hp.gameObject:SetActive(true)
    sl_hp:SetValue(roleData.hp / role.maxHp)
  end
end

function Activity_WolffortTaskUI:TeamInvite()
end

function Activity_WolffortTaskUI:SetLeaderUIItem()
  self.btn_invitation.gameObject:SetActive(TeamData.isLeader)
end

function Activity_WolffortTaskUI:ShowAutoTeam()
  TeamData.SetAutoTeamFlag()
  self.tog_autoJoin.toggle.isOn = TeamData.isAutoInTeam
end

function Activity_WolffortTaskUI:OnBtnSummonOnClick()
  if 5 - Activity_LangHunYaoSaiData.yongBing < 1 then
    FloatingTipUtility.QuickMsg("\196\144\195\163 tri\225\187\135u h\225\187\147i \196\145\225\187\167 L\195\173nh Thu\195\170")
    return
  end
  local cellPos = RoleManager.me.cellPos
  if cellPos.x <= 126 and cellPos.x >= 115 and cellPos.y < 37 and cellPos.y > 26 then
    if not UIManager.IsVisible(UIID.WolffortPreUI) and Activity_LangHunYaoSaiData.State == ActivityStatusEnum.RUNNING then
      UIManager.Show(UIID.WolffortPreUI)
    end
    return
  end
  local path = RoleManager.me:MoveTo({x = 120, y = 31}, 0, function()
    Activity_LangHunYaoSaiController.SummonControl = false
  end)
  if not path and not UIManager.IsVisible(UIID.WolffortPreUI) and Activity_LangHunYaoSaiData.State == ActivityStatusEnum.RUNNING then
    UIManager.Show(UIID.WolffortPreUI)
    return
  end
  Activity_LangHunYaoSaiController.SummonControl = true
end

function Activity_WolffortTaskUI:RegistEvents()
  self:RegistEvent(Event.Team_RefreshLimitInfo, self.UpdateTeamInfo, self)
  self:RegistEvent(Event.Team_RefreshTeamInfo, self.UpdateTeamInfo, self)
  self:RegistEvent(Event.RefreshLangHunYaoSaiTaskInfor, self.TaskInforRefresh, self)
  self:RegistEvent(Event.RefreshLangHunYaoSaiRankInfor, self.RefreshRankInfor, self)
  self:RegistEvent(Event.LangHunYaoSaiStatusRefresh, self.RefreshStatusRefresh, self)
  self:RegistEvent(Event.Scene_SceneDataChange, self.HandleRankUIDisplay, self)
end

local instanceState = 0

function Activity_WolffortTaskUI:Refresh()
  if ViewData.meData.unionPosition >= WarAllianceMemberType.Captain then
    self.btn_summon:SetActive(false)
  else
    self.btn_summon:SetActive(true)
  end
  if Time.GetServerTime() - Activity_LangHunYaoSaiData.initTime - Activity_LangHunYaoSaiData.prepareTime < 0 then
    instanceState = 0
  end
  self:TaskInforRefresh()
  self:RefreshRankInfor()
  self:UpdateTeamInfo()
  self.lab_RunDefendNum:SetText("100%")
  self.lab_countdown:SetText(TimeUtility.ShowTime(math.floor(Activity_LangHunYaoSaiData.prepareTime * 0.001)))
end

local function StartPrepareCountDown()
  if instanceState == 0 then
    instanceState = 1
    countDownNum = (Activity_LangHunYaoSaiData.prepareTime + Activity_LangHunYaoSaiData.initTime - Time.GetServerTime()) * 0.001
  end
end

function Activity_WolffortTaskUI:TaskInforRefresh()
  if Activity_LangHunYaoSaiData.runState == LangHunYaoSaiRunStateEnum.Ready then
    self.PreparatoryPanel:SetActive(true)
    self.CombatPanel:SetActive(false)
  else
    self.PreparatoryPanel:SetActive(false)
    self.CombatPanel:SetActive(true)
    UIManager.Hide(UIID.WolffortPreUI)
  end
  if Activity_LangHunYaoSaiData.yongBing == 5 and UIManager.IsVisible(UIID.WolffortPreUI) then
    UIManager.Hide(UIID.WolffortPreUI)
    FloatingTipUtility.QuickMsg("\196\144\195\163 tri\225\187\135u h\225\187\147i \196\145\225\187\167 L\195\173nh Thu\195\170")
  end
  self.lab_defendNum:SetText(string.format("(%s/5)", Activity_LangHunYaoSaiData.yongBing))
  if Activity_LangHunYaoSaiData.status then
    if self.currentHp and Activity_LangHunYaoSaiData.status.hp < self.currentHp then
      EventManager.Dispatch(Event.LangHunHurtTip, true)
    end
    self.currentHp = Activity_LangHunYaoSaiData.status.hp
    local percent = Activity_LangHunYaoSaiData.status.hp / self.statusMaxHp
    percent = math.floor(percent * 10000)
    percent = percent * 0.01
    self.lab_RunDefendNum:SetText(string.format("%s%%", percent))
    local statue = Activity_LangHunYaoSaiData.status.hp > 0 and 1 or 0
    if 0 < statue then
      self.lab_RunDefendNum:SetColor("0x00FF00FF")
    else
      self.lab_RunDefendNum:SetColor("0xFF0000FF")
    end
  end
  self.lab_monsterRefreshStep:SetText(Activity_LangHunYaoSaiData.monsterRefreshStep)
  local startTime = Activity_LangHunYaoSaiData.initTime + Activity_LangHunYaoSaiData.prepareTime
  if 0 <= Time.GetServerTime() - Activity_LangHunYaoSaiData.initTime or Activity_LangHunYaoSaiData.State == ActivityStatusEnum.RUNNING then
    if 0 > Time.GetServerTime() - startTime then
      StartPrepareCountDown()
    end
  else
    self.lab_countdown:SetText(TimeUtility.ShowTime(math.floor(Activity_LangHunYaoSaiData.prepareTime * 0.001)))
  end
  if self.monsterRefreshTime ~= Activity_LangHunYaoSaiData.nextMonsterAttackTime then
    self.monsterRefreshTime = Activity_LangHunYaoSaiData.nextMonsterAttackTime
    downNum = (self.monsterRefreshTime - Time.GetServerTime()) * 0.001
  end
  self.lab_teamRewards:SetText(Activity_LangHunYaoSaiData.rewardExp)
end

function Activity_WolffortTaskUI:RefreshRankInfor()
  self.lab_norRankScore:SetText(Activity_LangHunYaoSaiData.RankInfor.score)
  self.lab_norRankNumber:SetText(Activity_LangHunYaoSaiData.RankInfor.rank)
end

function Activity_WolffortTaskUI:RefreshStatusRefresh(_, msg)
  if self.currentHp and msg.current < self.currentHp then
    EventManager.Dispatch(Event.LangHunHurtTip, true)
  end
  local percent = msg.current / msg.max
  percent = math.floor(percent * 10000)
  percent = percent * 0.01
  self.lab_RunDefendNum:SetText(string.format("%s%%", percent))
end

function Activity_WolffortTaskUI:HandleRankUIDisplay(_, msg)
  if Activity_LangHunYaoSaiData.State == ActivityStatusEnum.RUNNING then
  else
    EventManager.Dispatch(Event.QuitWolffortSiege)
  end
end
