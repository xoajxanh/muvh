local AllocateTeam3V3Template = {}

function AllocateTeam3V3Template:Init(rootPanel)
  self.rootPanel = rootPanel
  self:InitControls()
  self:InitUI()
  self:BindUIEvents()
end

function AllocateTeam3V3Template:BindEvent()
  self.eventContainer = EventContainer(EventManager)
  self.eventContainer:Regist(Event.RefreshTeam3v3InvitablePlayInfo, self.RefreshInvitablePlayerView, self)
  self.eventContainer:Regist(Event.Team3v3CheckRecord, self.Team3v3CheckRecordView, self)
  self.eventContainer:Regist(Event.Team3v3MatchStatusChange, self.RefreshRace1State, self)
  self.eventContainer:Regist(Event.RefreshEnemyTeamInfoInfo, self.RefreshRace2State, self)
end

function AllocateTeam3V3Template:InitUI()
  self.invitablePlayerContainer = UIUtility.BindUIContainerTemp(self.img_Accumulating, LuaComponentTemplates.Team3v3InvitablePlayerTemplate, self.rootPanel)
  self.MemberList = {
    [1] = self.img_teamMember1,
    [2] = self.img_teamMember2,
    [3] = self.img_teamMember3,
    [4] = self.img_teamMember4
  }
  self.recordCtrList = {
    [1] = self.record1_txt,
    [2] = self.record2_txt,
    [3] = self.record3_txt,
    [4] = self.record4_txt
  }
end

function AllocateTeam3V3Template:InitControls()
  self.teamState = self:GetControl("teamState")
  self.teamName = self:GetControl("img_Bg/Text")
  self.ContentMain = self:GetControl("teamState/inviteState/person/ContentMain")
  self.firend = self:GetControl("teamState/inviteState/person/ContentMain/firend")
  self.firendCount = self:GetControl("teamState/inviteState/person/ContentMain/firend/firendCount")
  self.arrow_firend = self:GetControl("teamState/inviteState/person/ContentMain/firend/arrow_firend")
  self.warAlliance = self:GetControl("teamState/inviteState/person/ContentMain/warAlliance")
  self.warAllianceCount = self:GetControl("teamState/inviteState/person/ContentMain/warAlliance/warAllianceCount")
  self.arrow_warAlliance = self:GetControl("teamState/inviteState/person/ContentMain/warAlliance/arrow_warAlliance")
  self.memberList = self:GetControl("teamState/inviteState/person/ContentMain/memberList")
  self.near = self:GetControl("teamState/inviteState/person/ContentMain/near")
  self.nearCount = self:GetControl("teamState/inviteState/person/ContentMain/near/nearCount")
  self.arrow_near = self:GetControl("teamState/inviteState/person/ContentMain/near/arrow_near")
  self.memberListViewport = self:GetControl("teamState/inviteState/person/ContentMain/memberList/Viewport")
  self.img_Accumulating = self:GetControl("teamState/inviteState/person/ContentMain/memberList/Viewport/Content/img_Accumulating")
  self.btn_checkRank = self:GetControl("teamState/raceState1/btn_checkRank")
  self.tog_showCondition = self:GetControl("teamState/inviteState/tog_showCondition")
  self.btn_chatInvite = self:GetControl("teamState/inviteState/btn_chatInvite")
  self.captainButton = self:GetControl("captainButton")
  self.allocate_btn = self:GetControl("captainButton/allocate_btn")
  self.allocateState_txt = self:GetControl("captainButton/allocateState_txt")
  self.ConfirmAllocate_btn = self:GetControl("captainButton/ConfirmAllocate_btn")
  self.signUpState = self:GetControl("captainButton/signUpState")
  self.btn_disbind = self:GetControl("captainButton/signUpState/btn_disbind")
  self.btn_disbind_red = self:GetControl("captainButton/signUpState/btn_disbind/img_red")
  self.btn_disbind_gray = self:GetControl("captainButton/signUpState/btn_disbind/img_gray")
  self.btn_signUP = self:GetControl("captainButton/signUpState/btn_signUP")
  self.btn_signUP_2 = self:GetControl("captainButton/signUpState/btn_signUP_2")
  self.btn_manage = self:GetControl("captainButton/signUpState/btn_manage")
  self.btn_manage_img_redPoint = self:GetControl("captainButton/signUpState/btn_manage/img_redPoint")
  self.memberButton = self:GetControl("memberButton")
  self.img_teamMember1 = self:GetControl("sw_leaderList/Viewport/Content/img_teamMember1")
  self.img_teamMember2 = self:GetControl("sw_leaderList/Viewport/Content/img_teamMember2")
  self.img_teamMember3 = self:GetControl("sw_leaderList/Viewport/Content/img_teamMember3")
  self.img_teamMember4 = self:GetControl("sw_leaderList/Viewport/Content/img_teamMember4")
  self.img_headframe1 = self:GetControl("sw_leaderList/Viewport/Content/img_teamMember1/img_headframe1")
  self.img_headframe2 = self:GetControl("sw_leaderList/Viewport/Content/img_teamMember1/img_headframe2")
  self.img_headframe3 = self:GetControl("sw_leaderList/Viewport/Content/img_teamMember1/img_headframe3")
  self.img_headframe4 = self:GetControl("sw_leaderList/Viewport/Content/img_teamMember1/img_headframe4")
  self.inviteState = self:GetControl("teamState/inviteState")
  self.raceState1 = self:GetControl("teamState/raceState1")
  self.raceState1_lastTime_txt = self:GetControl("teamState/raceState1/lastTime_txt")
  self.raceState1_raceScore_txt = self:GetControl("teamState/raceState1/raceScore_txt")
  self.raceState1_rankTitle_txt = self:GetControl("teamState/raceState1/rankTitle_txt")
  self.raceState1_rankLimit_txt = self:GetControl("teamState/raceState1/rankLimit_txt")
  self.raceState1_winTimes_txt = self:GetControl("teamState/raceState1/winTimes_txt")
  self.raceState1_btn_match = self:GetControl("teamState/raceState1/match/btn_match")
  self.raceState1_btn_matching = self:GetControl("teamState/raceState1/match/btn_matching")
  self.btn_matching_time_txt = self:GetControl("teamState/raceState1/match/btn_matching/text_matching/time_txt")
  self.ready = self:GetControl("teamState/raceState1/ready")
  self.btn_ready = self:GetControl("teamState/raceState1/ready/btn_ready")
  self.btn_noready = self:GetControl("teamState/raceState1/ready/btn_noready")
  self.raceState2 = self:GetControl("teamState/raceState2")
  self.raceState_txt = self:GetControl("teamState/raceState2/raceState_txt")
  self.taotaisai_title_1 = self:GetControl("teamState/raceState2/raceState_txt/taotaisai_title_1")
  self.taotaisai_title_2 = self:GetControl("teamState/raceState2/raceState_txt/taotaisai_title_2")
  self.taotaisai_title_3 = self:GetControl("teamState/raceState2/raceState_txt/taotaisai_title_3")
  self.jijunsai_title = self:GetControl("teamState/raceState2/raceState_txt/jijunsai_title")
  self.guanjunsai_title = self:GetControl("teamState/raceState2/raceState_txt/guanjunsai_title")
  self.raceState2_enemyName_txt = self:GetControl("teamState/raceState2/enemyName/enemyName_txt")
  self.btn_checkEnemy = self:GetControl("teamState/raceState2/btn_checkEnemy")
  self.raceaState2_lastTime_txt = self:GetControl("teamState/raceState2/lastTime_txt")
  self.allocate_time_txt = self:GetControl("time_txt")
  self.raceState3 = self:GetControl("teamState/raceState3")
  self.raceState3_enemyName_txt = self:GetControl("teamState/raceState3/enemyName/enemyName_txt")
  self.btn_start = self:GetControl("teamState/raceState2/start/btn_start")
  self.btn_showRecord = self:GetControl("btn_showRecord")
  self.recordBg_img = self:GetControl("btn_showRecord/recordBg_img")
  self.record1_txt = self:GetControl("btn_showRecord/recordBg_img/sw_leaderList/Viewport/Content/record1_txt")
  self.record2_txt = self:GetControl("btn_showRecord/recordBg_img/sw_leaderList/Viewport/Content/record1_txt (1)")
  self.record3_txt = self:GetControl("btn_showRecord/recordBg_img/sw_leaderList/Viewport/Content/record1_txt (2)")
  self.record4_txt = self:GetControl("btn_showRecord/recordBg_img/sw_leaderList/Viewport/Content/record1_txt (3)")
  self.btn_description2 = self:GetControl("btn_description2")
end

function AllocateTeam3V3Template:BindUIEvents()
  self.firend:SetOnClick(self, self.firendOnClick)
  self.warAlliance:SetOnClick(self, self.warAllianceOnClick)
  self.near:SetOnClick(self, self.nearOnClick)
  self.btn_chatInvite:SetOnClick(self, self.chatInviteOnClick)
  self.btn_disbind:SetOnClick(self, self.disbindOnClick)
  self.btn_signUP:SetOnClick(self, self.signUpOnClick)
  self.btn_signUP_2:SetOnClick(self, self.signUpOnClick)
  self.btn_manage:SetOnClick(self, self.manageOnClick)
  self.btn_checkRank:SetOnClick(self, self.checkRankOnClick)
  self.allocate_btn:SetOnClick(self, self.allocateOnClick)
  self.ConfirmAllocate_btn:SetOnClick(self, self.ConfirmAllocateOnClick)
  self.btn_showRecord:SetOnClick(self, self.btn_showRecordOnClick)
  self.raceState1_btn_match:SetOnClick(self, self.raceState1_btn_matchOnClick)
  self.raceState1_btn_matching:SetOnClick(self, self.raceState1_btn_matchingOnClick)
  self.btn_ready:SetOnClick(self, self.btn_readyOnClick)
  self.btn_noready:SetOnClick(self, self.btn_noreadyOnClick)
  self.btn_checkEnemy:SetOnClick(self, self.btn_checkEnemyOnClick)
  self.btn_start:SetOnClick(self, self.btn_startOnClick)
  self.tog_showCondition:SetOnToggleChanged(self, self.ShowConditionChanged)
  self.btn_description2:SetOnClick(self, self.btn_description2OnClick)
end

function AllocateTeam3V3Template:btn_description2OnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1157})
end

function AllocateTeam3V3Template:ShowConditionChanged(sender, isOn)
  self:RefreshInvitablePlayerView(true)
end

function AllocateTeam3V3Template:btn_startOnClick()
  if self.teamInfo.battleId == nil or self.teamInfo.battleId == 0 then
    FloatingTipUtility.QuickMsg("Tr\225\186\173n \196\145\225\186\165u hi\225\187\135n ch\198\176a b\225\186\175t \196\145\225\186\167u")
    return
  end
  networkRequest.ReqJoinCompetitionBattle(self.teamInfo.battleId)
end

function AllocateTeam3V3Template:btn_checkEnemyOnClick()
  local EnemyTeamInfo = QuickFind:GetTeam3V3DataMgr():GetEnemyTeamInfo()
  if not table.isNullOrEmpty(EnemyTeamInfo) and self.teamInfo.enemyTeamId ~= 0 then
    UIManager.Show(UIID.Team3V3CheckMemberUI, {teamMemberData = EnemyTeamInfo})
  else
    FloatingTipUtility.QuickMsg("T\225\186\161m th\225\187\157i ch\198\176a c\195\179 \196\145\225\187\153i phe \196\145\225\187\139ch")
  end
end

function AllocateTeam3V3Template:raceState1_btn_matchOnClick()
  local IsDecisionMaker = QuickFind:GetTeam3V3DataMgr():CheckIsDecisionMaker(RoleManager.me.id)
  if not IsDecisionMaker then
    FloatingTipUtility.QuickMsg("Ch\225\187\137 \196\144\225\187\153i Tr\198\176\225\187\159ng c\195\179 th\225\187\131 thao t\195\161c")
  end
  if self.btn_matchOnClickTime and Time.GetServerTime() - self.btn_matchOnClickTime < 3000 then
    FloatingTipUtility.QuickMsg("Nh\225\186\165n thao t\195\161c qu\195\161 nhanh")
    return
  end
  if not QuickFind:GetTeam3V3DataMgr():GetBattleMenberBtnShow() then
    FloatingTipUtility.QuickMsg("Vui l\195\178ng ho\195\160n t\225\186\165t c\195\160i \196\145\225\186\183t \196\145\225\187\153i vi\195\170n xu\225\186\165t chi\225\186\191n tr\198\176\225\187\155c khi b\225\186\175t \196\145\225\186\167u gh\195\169p tr\225\186\173n")
    return
  end
  local JoinMatchState = QuickFind:GetTeam3V3DataMgr():GetJoinMatch()
  if not self.btn_matchOnClickTime then
    self.btn_matchOnClickTime = Time.GetServerTime()
  end
  if self.teamInfo and self.teamInfo.teamId and IsDecisionMaker and not JoinMatchState.state then
    networkRequest.ReqMatchStairs(self.teamInfo.teamId)
  end
end

function AllocateTeam3V3Template:raceState1_btn_matchingOnClick()
  local IsDecisionMaker = QuickFind:GetTeam3V3DataMgr():CheckIsDecisionMaker(RoleManager.me.id)
  local JoinMatchState = QuickFind:GetTeam3V3DataMgr():GetJoinMatch()
  if self.teamInfo and self.teamInfo.teamId and IsDecisionMaker and JoinMatchState.state then
    networkRequest.ReqCancelMatchThreeVThree(1)
  else
    FloatingTipUtility.QuickMsg("Ch\225\187\137 \196\144\225\187\153i Tr\198\176\225\187\159ng c\195\179 th\225\187\131 thao t\195\161c")
  end
end

function AllocateTeam3V3Template:btn_readyOnClick()
  local roleInfo = QuickFind:GetTeam3V3DataMgr():GetMenbersInfoByRid(RoleManager.me.id)
  local isBattleMenber = QuickFind:GetTeam3V3DataMgr():CheckIsBattleMenber(RoleManager.me.id)
  if not isBattleMenber then
    FloatingTipUtility.QuickMsg("Ch\225\187\137 \196\145\225\187\153i vi\195\170n xu\225\186\165t chi\225\186\191n m\225\187\155i c\195\179 th\225\187\131 chu\225\186\169n b\225\187\139")
    return
  end
  if roleInfo then
    networkRequest.ReqPrepareMatch(self.teamInfo.teamId, true)
  end
end

function AllocateTeam3V3Template:btn_noreadyOnClick()
  local roleInfo = QuickFind:GetTeam3V3DataMgr():GetMenbersInfoByRid(RoleManager.me.id)
  local isBattleMenber = QuickFind:GetTeam3V3DataMgr():CheckIsBattleMenber(RoleManager.me.id)
  if not isBattleMenber then
    FloatingTipUtility.QuickMsg("Ch\225\187\137 \196\145\225\187\153i vi\195\170n kh\195\180ng xu\225\186\165t chi\225\186\191n m\225\187\155i c\195\179 th\225\187\131 h\225\187\167y chu\225\186\169n b\225\187\139")
    return
  end
  if roleInfo then
    networkRequest.ReqPrepareMatch(self.teamInfo.teamId, false)
  end
end

function AllocateTeam3V3Template:btn_showRecordOnClick()
  local isOpen = self.recordBg_img:GetActive()
  if not isOpen then
    networkRequest.ReqTeamKillInfo()
  end
  self.recordBg_img:SetActive(not isOpen)
end

function AllocateTeam3V3Template:allocateOnClick()
  if QuickFind:GetTeam3V3DataMgr():GetJoinMatch().state then
    FloatingTipUtility.QuickMsg("Trong l\195\186c gh\195\169p tr\225\186\173n, kh\195\180ng th\225\187\131 thay \196\145\225\187\149i th\195\160nh vi\195\170n xu\225\186\165t chi\225\186\191n")
    return
  end
  local show = QuickFind:GetTeam3V3DataMgr():GetBattleMenberBtnShow()
  self.allocate_btn:SetActive(not show)
  self.ConfirmAllocate_btn:SetActive(show)
  QuickFind:GetTeam3V3DataMgr():SetBattleMenberBtnShow(not show)
  self:RefreshChuZhanBtn()
end

function AllocateTeam3V3Template:ConfirmAllocateOnClick()
  local show = QuickFind:GetTeam3V3DataMgr():GetBattleMenberBtnShow()
  self.allocate_btn:SetActive(not show)
  self.ConfirmAllocate_btn:SetActive(show)
  QuickFind:GetTeam3V3DataMgr():SetBattleMenberBtnShow(not show)
  local menberCount = table.count(QuickFind:GetTeam3V3DataMgr():GetBattleInfo())
  if 0 < menberCount then
    local battleInfo = {}
    for i, v in pairs(QuickFind:GetTeam3V3DataMgr():GetBattleInfo()) do
      table.insert(battleInfo, v)
    end
    if self.teamInfo and self.teamInfo.teamStage == TeamProcessStage.PromotionMatch then
      networkRequest.ReqSetTeamBattler(battleInfo)
    elseif self.teamInfo.teamStage ~= TeamProcessStage.PromotionMatch then
      networkRequest.ReqSetTeamBattler(battleInfo)
    end
  end
  QuickFind:GetTeam3V3DataMgr():RestoreBattleInfo()
  self:RefreshChuZhanBtn()
end

function AllocateTeam3V3Template:checkRankOnClick()
  networkRequest.ReqStairsRank()
end

function AllocateTeam3V3Template:disbindOnClick()
  if self.teamInfo and self.teamInfo.teamId and self.teamInfo.leaderId == RoleManager.me.id then
    Team3V3Controller:TipShow("101", nil)
  else
    FloatingTipUtility.QuickMsg("Ch\225\187\137 \196\144\225\187\153i Tr\198\176\225\187\159ng c\195\179 th\225\187\131 thao t\195\161c")
  end
end

function AllocateTeam3V3Template:signUpOnClick()
  if self.teamInfo and self.teamInfo.status == 0 and self.teamInfo.leaderId == RoleManager.me.id then
    networkRequest.ReqSignUpMatchTeam(self.teamInfo.teamId, true)
  elseif self.teamInfo and self.teamInfo.status == 1 and self.teamInfo.leaderId == RoleManager.me.id then
    networkRequest.ReqSignUpMatchTeam(self.teamInfo.teamId, false)
  else
    FloatingTipUtility.QuickMsg("Ch\225\187\137 \196\144\225\187\153i Tr\198\176\225\187\159ng c\195\179 th\225\187\131 thao t\195\161c")
  end
end

function AllocateTeam3V3Template:manageOnClick()
  if RoleManager.me.id == self.teamInfo.leaderId then
    UIManager.Show(UIID.Team3V3AuditApplicationUI)
    local FirstClick = string.format("%s_Team3V3btn_manageRedPoint", ViewData.meData.id)
    local lastRecordTime = PlayerPrefs.GetInt(FirstClick, 0)
    if lastRecordTime == 0 then
      PlayerPrefs.SetInt(FirstClick, 1)
      PlayerPrefs.Save()
      self.btn_manage_img_redPoint:SetActive(QuickFind:GetTeam3V3DataMgr():CheckRedPoint(2))
    end
  else
    FloatingTipUtility.QuickMsg("Ch\225\187\137 \196\144\225\187\153i Tr\198\176\225\187\159ng c\195\179 th\225\187\131 thao t\195\161c")
  end
end

function AllocateTeam3V3Template:chatInviteOnClick()
  if Time.GetServerTime() - QuickFind:GetTeam3V3DataMgr():GetChatCd() > 10000 then
    local Lv = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(80000001)
    local txt = string.format("Tham gia \196\145\225\187\153i c\225\187\167a ch\195\186ng t\195\180i %s<a href=[Team3v3]><color=#FFF200>[Nh\225\186\165n \196\145\225\187\131 \196\145\196\131ng k\195\189 tham gia]</color></a>", self.teamInfo.teamName)
    local data = {
      inputData = {
        ["[Team3v3]"] = {
          type = ChatInfoEnum.Team3v3_Join,
          teamId = self.teamInfo.teamId,
          GreaterLv = tonumber(Lv),
          teamLimitLv = self.teamInfo.levelLimit
        }
      },
      message = txt
    }
    local msg = {
      chatType = ChatChannelEnum.WORLD,
      textData = data
    }
    EventManager.Dispatch(Event.Chat_ReqChat, msg)
    FloatingTipUtility.QuickMsg("\196\144\195\163 g\225\187\173i \196\145\225\186\191n K\195\170nh Th\225\186\191 Gi\225\187\155i")
    QuickFind:GetTeam3V3DataMgr():SetChatCd(Time.GetServerTime())
  else
    FloatingTipUtility.QuickMsg("K\195\170u g\225\187\141i \196\145ang CD...")
  end
end

function AllocateTeam3V3Template:firendOnClick()
  if self.arrow_firend:GetLocalEulerAnglesZ() == 270 then
    self.arrow_firend:SetLocalEulerAnglesZ(90)
    self.arrow_warAlliance:SetLocalEulerAnglesZ(270)
    self.arrow_near:SetLocalEulerAnglesZ(270)
    self.memberList:SetAsLastSibling()
    local togState = self.tog_showCondition.toggle.isOn
    local GreaterLv = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(80000001)
    local allFriendDta = QuickFind:GetThreeVsThreeDataMgr():GetInvitablePlayerAndLvData(1, true, tonumber(GreaterLv), togState)
    self.invitablePlayerContainer:SetData(allFriendDta)
    self.memberList:SetActive(true)
    self.memberList:SetNormalizedPosition(0, 1)
    local siblingIndex = self.firend.transform:GetSiblingIndex() + 1
    self.memberList:SetSiblingIndex(siblingIndex)
  else
    self.arrow_firend:SetLocalEulerAnglesZ(270)
    self.memberList:SetActive(false)
  end
end

function AllocateTeam3V3Template:warAllianceOnClick()
  if self.arrow_warAlliance:GetLocalEulerAnglesZ() == 270 then
    self.arrow_warAlliance:SetLocalEulerAnglesZ(90)
    self.arrow_firend:SetLocalEulerAnglesZ(270)
    self.arrow_near:SetLocalEulerAnglesZ(270)
    self.memberList:SetAsLastSibling()
    local togState = self.tog_showCondition.toggle.isOn
    local GreaterLv = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(80000001)
    local allWarAllianceMemberData = QuickFind:GetThreeVsThreeDataMgr():GetInvitablePlayerAndLvData(2, true, tonumber(GreaterLv), togState)
    self.invitablePlayerContainer:SetData(allWarAllianceMemberData)
    self.memberList:SetActive(true)
    self.memberList:SetNormalizedPosition(0, 1)
    local siblingIndex = self.warAlliance.transform:GetSiblingIndex() + 1
    self.memberList:SetSiblingIndex(siblingIndex)
  else
    self.arrow_warAlliance:SetLocalEulerAnglesZ(270)
    self.memberList:SetActive(false)
  end
end

function AllocateTeam3V3Template:nearOnClick()
  if self.arrow_near:GetLocalEulerAnglesZ() == 270 then
    self.arrow_near:SetLocalEulerAnglesZ(90)
    self.arrow_firend:SetLocalEulerAnglesZ(270)
    self.arrow_warAlliance:SetLocalEulerAnglesZ(270)
    self.memberList:SetAsLastSibling()
    local togState = self.tog_showCondition.toggle.isOn
    local GreaterLv = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(80000001)
    local allNearMemberData = QuickFind:GetThreeVsThreeDataMgr():GetInvitablePlayerAndLvData(3, true, tonumber(GreaterLv), togState)
    self.invitablePlayerContainer:SetData(allNearMemberData)
    self.memberList:SetActive(true)
    self.memberList:SetNormalizedPosition(0, 1)
    local siblingIndex = self.near.transform:GetSiblingIndex() + 1
    self.memberList:SetSiblingIndex(siblingIndex)
  else
    self.arrow_near:SetLocalEulerAnglesZ(270)
    self.memberList:SetActive(false)
  end
end

function AllocateTeam3V3Template:Team3v3CheckRecordView()
  local memberList = QuickFind:GetTeam3V3DataMgr():GetMenbersInfo()
  local recordList = QuickFind:GetTeam3V3DataMgr().RecordInfo
  for i, v in pairs(self.recordCtrList) do
    v:SetText("")
  end
  local recordFormat = ClientTable.cfg_Ui_wordManager:TryGetValue("Team3v3_Tips_1").content
  for index, info in pairs(memberList) do
    local recordInfo = recordList[info.rid]
    if recordInfo then
      local recordStr = string.format(recordFormat, recordInfo.battleCount, recordInfo.winCount, recordInfo.winRate, recordInfo.killCount, recordInfo.dieCount)
      self.recordCtrList[index]:SetText(recordStr)
    end
  end
end

function AllocateTeam3V3Template:RefreshInvitablePlayerView(eventKey)
  local togState = self.tog_showCondition.toggle.isOn
  local GreaterLv = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(80000001)
  local allFriendDta = QuickFind:GetThreeVsThreeDataMgr():GetInvitablePlayerAndLvData(1, true, tonumber(GreaterLv), togState)
  local allWarAllianceMemberData = QuickFind:GetThreeVsThreeDataMgr():GetInvitablePlayerAndLvData(2, true, tonumber(GreaterLv), togState)
  local allNearMemberData = QuickFind:GetThreeVsThreeDataMgr():GetInvitablePlayerAndLvData(3, true, tonumber(GreaterLv), togState)
  self.firendCount:SetText(string.format("B\225\186\161n b\195\168 [%d]", table.count(allFriendDta)))
  self.warAllianceCount:SetText(string.format("Guild [%d]", table.count(allWarAllianceMemberData)))
  self.nearCount:SetText(string.format("G\225\186\167n [%d]", table.count(allNearMemberData)))
  if eventKey == nil then
    self.arrow_firend:SetLocalEulerAnglesZ(table.count(allFriendDta) == 0 and 270 or 90)
    self.arrow_warAlliance:SetLocalEulerAnglesZ(270)
    self.arrow_near:SetLocalEulerAnglesZ(270)
    self.invitablePlayerContainer:SetData(allFriendDta)
    self.memberList:SetNormalizedPosition(0, 1)
    local siblingIndex = self.firend.transform:GetSiblingIndex() + 1
    self.memberList:SetSiblingIndex(siblingIndex)
    self.memberList:SetActive(table.count(allFriendDta) > 0)
  else
    local refreshData
    if self.arrow_firend:GetLocalEulerAnglesZ() == 90 then
      refreshData = allFriendDta
    elseif self.arrow_warAlliance:GetLocalEulerAnglesZ() == 90 then
      refreshData = allWarAllianceMemberData
    elseif self.arrow_near:GetLocalEulerAnglesZ() == 90 then
      refreshData = allNearMemberData
    end
    if refreshData then
      self.invitablePlayerContainer:SetData(refreshData)
    end
  end
end

function AllocateTeam3V3Template:RequestInvitePlayer()
  local allFriendDta = QuickFind:GetThreeVsThreeDataMgr():GetInvitablePlayerAndLvData(1, true)
  local allWarAllianceMemberData = QuickFind:GetThreeVsThreeDataMgr():GetInvitablePlayerAndLvData(2, true)
  local allNearMemberData = QuickFind:GetThreeVsThreeDataMgr():GetInvitablePlayerAndLvData(3, true)
  local roleId = {}
  for k, v in pairs(allFriendDta) do
    table.insert(roleId, v.id)
  end
  for k, v in pairs(allWarAllianceMemberData) do
    table.insert(roleId, v.id)
  end
  for k, v in pairs(allNearMemberData) do
    table.insert(roleId, v.id)
  end
  if table.count(roleId) > 0 then
    networkRequest.ReqQueryHasTeam(roleId)
  else
    self:RefreshInvitablePlayerView(true)
  end
end

function AllocateTeam3V3Template:Refresh()
  self:BindEvent()
  self.teamInfo = QuickFind:GetTeam3V3DataMgr():GetMatchTeamInfo()
  if table.isNullOrEmpty(self.teamInfo) or not self.teamInfo.teamId then
    self.teamState:SetActive(false)
    return
  end
  self.teamName:SetText(self.teamInfo.teamName)
  local teamStage = self.teamInfo.teamStage and self.teamInfo.teamStage or TeamProcessStage.SignUp
  if teamStage > TeamProcessStage.SignUp and self.requestInviteTimer then
    Timer.Stop(self.requestInviteTimer)
    self.requestInviteTimer = nil
  end
  if not self.requestInviteTimer and (teamStage == TeamProcessStage.Prepare or teamStage == TeamProcessStage.SignUp) then
    self:RequestInvitePlayer()
    self.requestInviteTimer = Timer.StartLoopForever(5, self.RequestInvitePlayer, self)
  end
  self.inviteState:SetActive(teamStage == TeamProcessStage.Prepare or teamStage == TeamProcessStage.SignUp)
  self.raceState1:SetActive(teamStage == TeamProcessStage.PromotionMatch and not self.teamInfo.isOut)
  self.raceState2:SetActive(teamStage >= TeamProcessStage.KnockoutRound and not self.teamInfo.isOut)
  self.raceState3:SetActive(self.teamInfo.isOut)
  self.btn_chatInvite:SetActive(RoleManager.me.id == self.teamInfo.leaderId)
  self.allocate_time_txt:SetActive(not self.teamInfo.isOut)
  if self.BaoMinEndTimer then
    Timer.Stop(self.BaoMinEndTimer)
    self.BaoMinEndTimer = nil
  end
  if teamStage == TeamProcessStage.SignUp then
    local Daojishi = QuickFind:GetTeam3V3DataMgr():GetBaoMinTime()
    self.BaoMinEndTimer = Timer.StartLoopForever(1, function()
      local NowTime = Time.GetServerSecondTime()
      if NowTime <= Daojishi.endStamp then
        self.allocate_time_txt:SetActive(true)
        self.allocate_time_txt:SetText("Th\225\187\157i gian b\195\161o danh c\195\178n l\225\186\161i: " .. TimeUtility.ShowDayTime(Daojishi.endStamp - Time.GetServerSecondTime()))
      else
        self.allocate_time_txt:SetText("")
      end
    end, self)
  elseif teamStage >= TeamProcessStage.PromotionMatch and not self.teamInfo.isOut and self.teamInfo.matchStartTime and self.teamInfo.matchEndTime then
    self.allocate_time_txt:SetActive(true)
    self.allocate_time_txt:SetText("Th\225\187\157i gian thi \196\145\225\186\165u: " .. QuickFind:GetTeam3V3DataMgr():FormatTimeRange(self.teamInfo.matchStartTime, self.teamInfo.matchEndTime))
  else
    self.allocate_time_txt:SetActive(false)
  end
  self:RefreshMenberList()
  if self.teamInfo.isOut then
    if teamStage == TeamProcessStage.PromotionMatch then
      self.raceState3_enemyName_txt:SetText(QuickFind:GetTeam3V3DataMgr():ConvertSpecialIdToStr(self.teamInfo.promoteOutRank))
    elseif teamStage >= TeamProcessStage.KnockoutRound then
      self.raceState3_enemyName_txt:SetText(TeamOutResult[self.teamInfo.knockoutRound])
    end
  elseif teamStage == TeamProcessStage.PromotionMatch then
    self:RefreshRace1State()
  elseif teamStage >= TeamProcessStage.KnockoutRound then
    self:RefreshRace2State()
  end
  self:RefreshBtnsGroupShow()
end

function AllocateTeam3V3Template:RefreshRace1State()
  local IsDecisionMaker = QuickFind:GetTeam3V3DataMgr():CheckIsDecisionMaker(RoleManager.me.id)
  local JoinMatchState = QuickFind:GetTeam3V3DataMgr():GetJoinMatch()
  local score = self.teamInfo.promoteInfo and self.teamInfo.promoteInfo.score or 0
  local rank = self.teamInfo.promoteInfo and self.teamInfo.promoteInfo.rank or 0
  local promoteCount = self.teamInfo.promoteInfo and self.teamInfo.promoteInfo.promoteCount or 0
  local validBattleCount = self.teamInfo.promoteInfo and self.teamInfo.promoteInfo.validBattleCount or 0
  local winCount = self.teamInfo.promoteInfo and self.teamInfo.promoteInfo.winCount or 0
  self.raceState1_raceScore_txt:SetText("" .. score)
  self.raceState1_rankTitle_txt:SetText("X\225\186\191p h\225\186\161ng hi\225\187\135n t\225\186\161i: " .. rank)
  self.raceState1_rankLimit_txt:SetText("Th\196\131ng H\225\186\161ng: " .. QuickFind:GetTeam3V3DataMgr():ConvertSpecialIdToStr(promoteCount))
  self.raceState1_lastTime_txt:SetText(string.format("S\225\187\145 l\225\186\167n c\195\178n l\225\186\161i: <color=#00FF00>%s</color> l\225\186\167n", validBattleCount))
  self.raceState1_winTimes_txt:SetText(string.format("S\225\187\145 tr\225\186\173n th\225\186\175ng: %s", winCount))
  self.raceState1_btn_match:SetActive(not JoinMatchState.state)
  self.raceState1_btn_matching:SetActive(JoinMatchState.state)
  self.ready:SetActive(not IsDecisionMaker and not JoinMatchState.state)
  self.btn_ready:SetActive(not QuickFind:GetTeam3V3DataMgr():GetMenbersInfoByRid(RoleManager.me.id).prepare and not IsDecisionMaker)
  self.btn_noready:SetActive(QuickFind:GetTeam3V3DataMgr():GetMenbersInfoByRid(RoleManager.me.id).prepare and not IsDecisionMaker)
  if self.JoinMatchStateTimer then
    Timer.Stop(self.JoinMatchStateTimer)
    self.JoinMatchStateTimer = nil
  end
  if JoinMatchState.state and JoinMatchState.info and JoinMatchState.info.unit and JoinMatchState.info.unit.startMatchTime then
    local StartTime = math.floor(JoinMatchState.info.unit.startMatchTime * 0.001)
    self.JoinMatchStateTimer = Timer.StartLoopForever(1, function()
      local elapsed = math.floor(Time.GetServerTime() * 0.001) - StartTime
      self.btn_matching_time_txt:SetText(elapsed .. "-\231\167\146")
    end)
  else
    self.btn_matching_time_txt:SetText("")
  end
end

function AllocateTeam3V3Template:RefreshRace2State()
  local EnemyTeamInfo = QuickFind:GetTeam3V3DataMgr():GetEnemyTeamInfo()
  self.taotaisai_title_1:SetActive(self.teamInfo.knockoutRound == TeamSmallStage.SixteenToEight)
  self.taotaisai_title_2:SetActive(self.teamInfo.knockoutRound == TeamSmallStage.EightToFour)
  self.taotaisai_title_3:SetActive(self.teamInfo.knockoutRound == TeamSmallStage.FourToTwo)
  self.jijunsai_title:SetActive(self.teamInfo.teamStage == TeamProcessStage.ThirdplaceMatch)
  self.guanjunsai_title:SetActive(self.teamInfo.teamStage == TeamProcessStage.Championship)
  self.btn_start:SetActive(self.teamInfo.battleId ~= nil and self.teamInfo.battleId ~= 0)
  if self.teamInfo.bye then
    self.raceState2_enemyName_txt:SetText("Mi\225\187\133n chi\225\186\191n")
  else
    self.raceState2_enemyName_txt:SetText(not table.isNullOrEmpty(EnemyTeamInfo) and EnemyTeamInfo.enemyTeamName or "Tr\225\187\145ng")
  end
  if self.NextOpenTimer then
    Timer.Stop(self.NextOpenTimer)
    self.NextOpenTimer = nil
  end
  if self.teamInfo.knockoutStartTime then
    local StartTime = self.teamInfo.knockoutStartTime
    self.NextOpenTimer = Timer.StartLoopForever(1, function()
      if 0 < StartTime then
        local nextTime = StartTime - math.floor(Time.GetServerTime() * 0.001)
        if 0 < nextTime then
          self.raceaState2_lastTime_txt:SetText("\196\144\225\186\191m ng\198\176\225\187\163c tr\225\186\173n \196\145\225\186\165u:" .. TimeUtility.ShowDayTime(nextTime))
        else
          self.raceaState2_lastTime_txt:SetText("")
        end
      else
        self.raceaState2_lastTime_txt:SetText("")
      end
    end)
  end
end

function AllocateTeam3V3Template:RefreshBtnsGroupShow()
  local state = self.teamInfo.teamStage
  local isCaptain = QuickFind:GetTeam3V3DataMgr():CheckIsDecisionMaker(RoleManager.me.id)
  self.captainButton:SetActive(isCaptain and not self.teamInfo.isOut)
  self.allocateState_txt:SetActive(isCaptain and not self.teamInfo.isOut and state == TeamProcessStage.PromotionMatch)
  self.memberButton:SetActive(not isCaptain and not self.teamInfo.isOut)
  self.signUpState:SetActive(state == TeamProcessStage.SignUp and RoleManager.me.id == self.teamInfo.leaderId)
  self.allocate_btn:SetActive(state > TeamProcessStage.SignUp)
  self.ConfirmAllocate_btn:SetActive(state > TeamProcessStage.SignUp)
  if isCaptain and state == TeamProcessStage.SignUp then
    self.btn_disbind:SetActive(true)
    self.btn_disbind:SetInteractable(self.teamInfo.status == 0)
    self.btn_disbind_red:SetActive(self.teamInfo.status == 0)
    self.btn_disbind_gray:SetActive(self.teamInfo.status == 1)
    self.btn_signUP:SetActive(self.teamInfo.status == 0)
    self.btn_signUP_2:SetActive(self.teamInfo.status == 1)
  elseif isCaptain and state ~= TeamProcessStage.SignUp then
    self.allocate_btn:SetActive(QuickFind:GetTeam3V3DataMgr():GetBattleMenberBtnShow())
    self.ConfirmAllocate_btn:SetActive(not QuickFind:GetTeam3V3DataMgr():GetBattleMenberBtnShow())
  end
end

function AllocateTeam3V3Template:RefreshMenberList()
  local isLeader = RoleManager.me.id == self.teamInfo.leaderId
  local menberInfo = QuickFind:GetTeam3V3DataMgr():GetMenbersInfo()
  self.allocateState_txt:SetText(string.format("S\225\187\145 ng\198\176\225\187\157i xu\225\186\165t chi\225\186\191n hi\225\187\135n t\225\186\161i (%s/3)", table.count(QuickFind:GetTeam3V3DataMgr():GetBattleMenberInfo())))
  for i, v in ipairs(self.MemberList) do
    local menber = menberInfo[i]
    local obj = v
    local img_headframe = obj:GetChild("img_headframe")
    local img_touxiang = obj:GetChild("img_headframe/img_touxiang")
    local img_rank = obj:GetChild("img_headframe/img_rank")
    local img_rank_2 = obj:GetChild("img_headframe/img_rank_2")
    local bg_online = obj:GetChild("bg_online")
    local img_online = obj:GetChild("bg_online/img_online")
    local bg_offline = obj:GetChild("bg_online/img_offline")
    local img_levelBg = obj:GetChild("img_headframe/img_levelBg")
    local img_lock = obj:GetChild("img_headframe/img_lock")
    local level = obj:GetChild("img_headframe/img_levelBg/level")
    local img_select = obj:GetChild("img_headframe/img_select")
    local img_unSelect = obj:GetChild("img_headframe/img_unSelect")
    local lab_Name = obj:GetChild("lab_Name")
    local YiChuZhan_img = obj:GetChild("YiChuZhan_img")
    local btn_leave = obj:GetChild("btn_leave")
    local btn_leave_red = obj:GetChild("btn_leave/btn_img_red")
    local btn_leave_gray = obj:GetChild("btn_leave/btn_img_gray")
    local ready = obj:GetChild("ready")
    local playerInfo = obj:GetChild("playerInfo")
    local btn_closePlayerInfoBg = obj:GetChild("playerInfo/btn_closePlayerInfoBg")
    local btn_look = obj:GetChild("playerInfo/bg_playerinfo/btn_look")
    local btn_out = obj:GetChild("playerInfo/bg_playerinfo/btn_out")
    local btn_entrust = obj:GetChild("playerInfo/bg_playerinfo/btn_entrust")
    img_lock:SetActive(not menber and self.teamInfo.teamStage >= TeamProcessStage.PromotionMatch)
    img_touxiang:SetActive(menber)
    img_rank:SetActive(false)
    img_rank_2:SetActive(false)
    bg_online:SetActive(true)
    img_online:SetActive(true)
    img_select:SetActive(false)
    img_unSelect:SetActive(false)
    img_levelBg:SetActive(menber)
    ready:SetActive(false)
    level:SetText("")
    lab_Name:SetText("")
    playerInfo:SetActive(false)
    btn_leave:SetActive(false)
    btn_entrust:SetActive(RoleManager.me.id == self.teamInfo.leaderId)
    if menber then
      local IsDecisionMaker = QuickFind:GetTeam3V3DataMgr():CheckIsDecisionMaker(menber.rid)
      local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(menber.career, "id").headPortrait
      self.rootPanel:SetSprite("Atlas_headPortrait", spriteName, img_touxiang)
      img_levelBg:SetActive(true)
      level:SetText(tostring(menber.level))
      if self.teamInfo.teamStage == TeamProcessStage.PromotionMatch then
        ready:SetActive(menber.prepare)
        if IsDecisionMaker then
          ready:SetActive(false)
        end
      end
      btn_out:SetActive(RoleManager.me.id == self.teamInfo.leaderId and self.teamInfo.teamStage <= TeamProcessStage.SignUp)
      lab_Name:SetText(string.GetColorText(menber.name, menber.rid == RoleManager.me.id and "#e18921" or "#FFFFFF"))
      YiChuZhan_img:SetActive(QuickFind:GetTeam3V3DataMgr():CheckIsBattleMenber(menber.rid) and self.teamInfo.teamStage > TeamProcessStage.SignUp)
      img_rank:SetActive(menber.rid == self.teamInfo.leaderId)
      img_rank_2:SetActive(menber.rid == self.teamInfo.secondLeader)
      img_select:SetActive(menber.online)
      img_unSelect:SetActive(not menber.online)
      bg_offline:SetActive(not menber.online)
      if self.teamInfo.teamStage == TeamProcessStage.SignUp then
        btn_leave:SetActive(not isLeader and menber.rid == RoleManager.me.id and self.teamInfo.teamStage <= TeamProcessStage.PromotionMatch)
        btn_leave:SetInteractable(self.teamInfo.status == 0)
        btn_leave_red:SetActive(self.teamInfo.status == 0)
        btn_leave_gray:SetActive(self.teamInfo.status == 1)
      elseif self.teamInfo.teamStage > TeamProcessStage.SignUp then
        btn_leave:SetActive(false)
      end
    else
      playerInfo:SetActive(false)
      YiChuZhan_img:SetActive(false)
      bg_offline:SetActive(false)
    end
    img_headframe:SetOnClick(self, function()
      if not self.teamInfoPanel then
        self.teamInfoPanel = playerInfo
      elseif self.teamInfoPanel ~= playerInfo then
        self.teamInfoPanel:SetActive(false)
        self.teamInfoPanel = playerInfo
      end
      if menber and menber.rid ~= RoleManager.me.id then
        playerInfo:SetActive(true)
      end
    end)
    btn_closePlayerInfoBg:SetOnClick(self, function()
      playerInfo:SetActive(false)
    end)
    btn_look:SetOnClick(self, function()
      if menber and menber.rid then
        RoleInteractData.roleId = menber.rid
        RoleInteractData.roleName = menber.name
        RoleInteractData.unionId = nil
        RoleInteractData.career = menber.career
        RoleInteractData.unionName = ""
        RoleInteractData.unionPosition = nil
        RoleInteractData.fight = 0
        RoleInteractData.level = menber.level
        RoleInteractData.serverId = nil
        RoleInteractData.interactType = RoleOpenType.Team3v3
        networkRequest.ReqTeamEquipsInfo(menber.rid)
      end
    end)
    btn_out:SetOnClick(self, function()
      if RoleManager.me.id == self.teamInfo.leaderId then
        networkRequest.ReqKickMatchTeam(menber.rid, self.teamInfo.teamId)
        playerInfo:SetActive(false)
      else
        FloatingTipUtility.QuickMsg("Ch\225\187\137 \196\144\225\187\153i Tr\198\176\225\187\159ng c\195\179 th\225\187\131 thao t\195\161c")
      end
    end)
    btn_entrust:SetOnClick(self, function()
      if RoleManager.me.id == self.teamInfo.leaderId then
        if self.teamInfo.secondLeader ~= menber.rid then
          networkRequest.ReqSetSecondLeader(menber.rid)
        end
        playerInfo:SetActive(false)
      else
        FloatingTipUtility.QuickMsg("Ch\225\187\137 \196\144\225\187\153i Tr\198\176\225\187\159ng c\195\179 th\225\187\131 thao t\195\161c")
      end
    end)
    btn_leave:SetOnClick(self, function()
      Team3V3Controller:TipShow("102", nil)
    end)
  end
end

function AllocateTeam3V3Template:RefreshChuZhanBtn()
  if QuickFind:GetTeam3V3DataMgr():CheckIsDecisionMaker(RoleManager.me.id) then
    local menberInfo = self.teamInfo.members
    for i, v in ipairs(self.MemberList) do
      local menber = menberInfo[i]
      local obj = v
      local YiChuZhan_img = obj:GetChild("YiChuZhan_img")
      local SetChuZhan_btn = obj:GetChild("SetChuZhan_btn")
      local SetQuXiaoChuZhan_btn = obj:GetChild("SetQuXiaoChuZhan_btn")
      local MsgIsBattle = QuickFind:GetTeam3V3DataMgr():CheckIsBattleMenber(menber and menber.rid or nil)
      if menber and self.allocate_btn:GetActive() then
        YiChuZhan_img:SetActive(MsgIsBattle and self.teamInfo.teamStage > TeamProcessStage.SignUp)
        SetChuZhan_btn:SetActive(false)
        SetQuXiaoChuZhan_btn:SetActive(false)
      elseif menber and self.ConfirmAllocate_btn:GetActive() then
        SetChuZhan_btn:SetActive(not MsgIsBattle)
        SetQuXiaoChuZhan_btn:SetActive(MsgIsBattle)
        SetChuZhan_btn:SetOnClick(self, function()
          local BattleInfo = QuickFind:GetTeam3V3DataMgr():GetBattleInfo()
          if table.count(BattleInfo) >= 3 then
            FloatingTipUtility.QuickMsg("S\225\187\145 ng\198\176\225\187\157i xu\225\186\165t chi\225\186\191n hi\225\187\135n t\225\186\161i \196\145\195\163 \196\145\225\186\167y")
            return
          end
          local isInsert = QuickFind:GetTeam3V3DataMgr():InsertBattleInfo(menber.rid)
          if not isInsert then
            QuickFind:GetTeam3V3DataMgr():RemoveBattleInfo(menber.rid)
          end
          local isBattle = BattleInfo[menber.rid]
          SetChuZhan_btn:SetActive(not isBattle)
          SetQuXiaoChuZhan_btn:SetActive(isBattle)
        end)
        SetQuXiaoChuZhan_btn:SetOnClick(self, function()
          local BattleInfo = QuickFind:GetTeam3V3DataMgr():GetBattleInfo()
          local Remove = QuickFind:GetTeam3V3DataMgr():RemoveBattleInfo(menber.rid)
          if not Remove then
            QuickFind:GetTeam3V3DataMgr():InsertBattleInfo(menber.rid)
          end
          local isBattle = BattleInfo[menber.rid]
          SetChuZhan_btn:SetActive(not isBattle)
          SetQuXiaoChuZhan_btn:SetActive(isBattle)
        end)
      else
        YiChuZhan_img:SetActive(false)
        SetChuZhan_btn:SetActive(false)
        SetQuXiaoChuZhan_btn:SetActive(false)
      end
    end
  end
end

function AllocateTeam3V3Template:Exit()
  self.btn_matchOnClickTime = nil
  if self.requestInviteTimer then
    Timer.Stop(self.requestInviteTimer)
    self.requestInviteTimer = nil
  end
  if self.JoinMatchStateTimer then
    Timer.Stop(self.JoinMatchStateTimer)
    self.JoinMatchStateTimer = nil
  end
  if self.NextOpenTimer then
    Timer.Stop(self.NextOpenTimer)
    self.NextOpenTimer = nil
  end
  if self.BaoMinEndTimer then
    Timer.Stop(self.BaoMinEndTimer)
    self.BaoMinEndTimer = nil
  end
  if self.eventContainer then
    self.eventContainer:UnRegistAll()
  end
  QuickFind:GetTeam3V3DataMgr():SetBattleMenberBtnShow(true)
  self.recordBg_img:SetActive(false)
end

return AllocateTeam3V3Template
