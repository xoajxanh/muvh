local SportTeam3V3Template = {}

function SportTeam3V3Template:Init(data)
  self.root = data.root
  self.parent = data.parent
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
  self:BindEvent()
end

function SportTeam3V3Template:InitControls()
  self.imgTitle = self:GetControl("teamInfo/imgTitle")
  self.player_1 = self:GetControl("teamInfo/teams/player_1")
  self.player_2 = self:GetControl("teamInfo/teams/player_2")
  self.player_3 = self:GetControl("teamInfo/teams/player_3")
  self.btn_start = self:GetControl("teamInfo/btns/btn_start")
  self.lab_Multi = self:GetControl("teamInfo/btns/btn_start/lab_Multi")
  self.btn_ready = self:GetControl("teamInfo/btns/btn_ready")
  self.lab_ready = self:GetControl("teamInfo/btns/btn_ready/lab_ready")
  self.btnTalk = self:GetControl("teamInfo/btns/btnTalk")
  self.btn_return = self:GetControl("teamInfo/btns/btn_return")
  self.matchTimeMulti = self:GetControl("teamInfo/matchTime/matchTimeMulti")
  self.lab_matchTimeMulti = self:GetControl("teamInfo/matchTime/matchTimeMulti/lab_matchTimeMulti")
  self.activityCount = self:GetControl("matchingPerson/activityCount")
  self.addCount2 = self:GetControl("matchingPerson/activityCount/addCount2")
  self.times2 = self:GetControl("matchingPerson/activityTime/times2")
  self.ContentMain = self:GetControl("teamInfo/person/ContentMain")
  self.firend = self:GetControl("teamInfo/person/ContentMain/firend")
  self.firendCount = self:GetControl("teamInfo/person/ContentMain/firend/firendCount")
  self.arrow_firend = self:GetControl("teamInfo/person/ContentMain/firend/arrow_firend")
  self.warAlliance = self:GetControl("teamInfo/person/ContentMain/warAlliance")
  self.warAllianceCount = self:GetControl("teamInfo/person/ContentMain/warAlliance/warAllianceCount")
  self.arrow_warAlliance = self:GetControl("teamInfo/person/ContentMain/warAlliance/arrow_warAlliance")
  self.near = self:GetControl("teamInfo/person/ContentMain/near")
  self.nearCount = self:GetControl("teamInfo/person/ContentMain/near/nearCount")
  self.arrow_near = self:GetControl("teamInfo/person/ContentMain/near/arrow_near")
  self.memberList = self:GetControl("teamInfo/person/ContentMain/memberList")
  self.memberListViewport = self:GetControl("teamInfo/person/ContentMain/memberList/Viewport")
  self.img_Accumulating = self:GetControl("teamInfo/person/ContentMain/memberList/Viewport/Content/img_Accumulating")
end

function SportTeam3V3Template:InitUI()
  self.roomPlayerTemplateList = {
    luaTemplateManager.GetNewTemplate(self.player_1, LuaComponentTemplates.RoomPlayerTemplate, self.root),
    luaTemplateManager.GetNewTemplate(self.player_2, LuaComponentTemplates.RoomPlayerTemplate, self.root),
    luaTemplateManager.GetNewTemplate(self.player_3, LuaComponentTemplates.RoomPlayerTemplate, self.root)
  }
  self.invitablePlayerContainer = UIUtility.BindUIContainerTemp(self.img_Accumulating, LuaComponentTemplates.InvitablePlayerTemplate, self.root)
end

function SportTeam3V3Template:BindUIEvent()
  self.btn_start:SetOnClick(self, self.btn_startOnClick)
  self.btn_ready:SetOnClick(self, self.btn_readyOnClick)
  self.btnTalk:SetOnClick(self, self.btnTalkOnClick)
  self.btn_return:SetOnClick(self, self.btn_returnOnClick)
  self.firend:SetOnClick(self, self.firendOnClick)
  self.warAlliance:SetOnClick(self, self.warAllianceOnClick)
  self.near:SetOnClick(self, self.nearOnClick)
end

function SportTeam3V3Template:BindEvent()
  self.eventContainer = EventContainer(EventManager)
  self.eventContainer:Regist(Event.RefreshThreeVThreeMatchTeamInfo, self.RefreshRelatedToTheCaptainView, self)
  self.eventContainer:Regist(Event.ThreeVThreeMatchTeamDissolve, self.ReturnSportMatch3V3View, self)
  self.eventContainer:Regist(Event.ThreeVThreeCancleMatchSuccess, self.CancleMatchSuccessCallBack, self)
  self.eventContainer:Regist(Event.ThreeVThreeMatching, self.MatchingCallBack, self)
end

local function okAction()
  local activityGlobal = ClientTable.cfg_Activity_globalManager:TryGetValue(500066)
  if activityGlobal ~= nil and not string.isNullOrEmpty(activityGlobal.effect) then
    local effectTab = string.split(activityGlobal.effect, "#")
    if BagInfoData.GetItemTotalCountByItemId(tonumber(effectTab[2])) < (2 >= QuickFind:GetThreeVsThreeDataMgr():GetPunishCount() and Mathf.Pow(10, QuickFind:GetThreeVsThreeDataMgr():GetPunishCount() + 1) or 10000) then
      FloatingTipUtility.QuickMsg("KC kh\195\180ng \196\145\225\187\167")
      return
    end
  end
  networkRequest.ReqClosePunish(1)
  UIManager.Hide(UIID.PromptTipUI)
end

function SportTeam3V3Template:btn_startOnClick()
  if QuickFind:GetThreeVsThreeDataMgr():GetMatchState() == 0 then
    networkRequest.ReqStartMatchThreeVThree(1)
    QuickFind:GetThreeVsThreeDataMgr():SetMatchPeopleType(2)
  elseif QuickFind:GetThreeVsThreeDataMgr():GetMeIsCaptain() and QuickFind:GetThreeVsThreeDataMgr():GetHangUpPunishState() then
    TipUtility.QuickShowPrompt({
      id = PromptWordType.HangUpPunish,
      cancelAction = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      okAction = okAction
    })
  else
    networkRequest.ReqCancelMatchThreeVThree(1)
    QuickFind:GetThreeVsThreeDataMgr():SetMatchPeopleType(0)
  end
end

function SportTeam3V3Template:btn_readyOnClick()
  if QuickFind:GetThreeVsThreeDataMgr():GetMeReadyState() == false then
    networkRequest.ReqPrepare(1, true)
  elseif QuickFind:GetThreeVsThreeDataMgr():GetMeReadyState() == true then
    if QuickFind:GetThreeVsThreeDataMgr():GetMatchState() == 1 then
      networkRequest.ReqCancelMatchThreeVThree(1)
      QuickFind:GetThreeVsThreeDataMgr():SetMatchPeopleType(0)
    else
      networkRequest.ReqPrepare(1, false)
    end
  end
end

function SportTeam3V3Template:btnTalkOnClick()
  UIManager.Show(UIID.ChatUI)
end

function SportTeam3V3Template:btn_returnOnClick()
  if QuickFind:GetThreeVsThreeDataMgr():GetMatchState() == 1 then
    networkRequest.ReqCancelMatchThreeVThree(1)
    QuickFind:GetThreeVsThreeDataMgr():SetMatchPeopleType(0)
    return
  end
  networkRequest.ReqExitThreeVThreeTeam(1)
end

function SportTeam3V3Template:firendOnClick()
  if self.arrow_firend:GetLocalEulerAnglesZ() == 270 then
    self.arrow_firend:SetLocalEulerAnglesZ(90)
    self.arrow_warAlliance:SetLocalEulerAnglesZ(270)
    self.arrow_near:SetLocalEulerAnglesZ(270)
    self.memberList:SetAsLastSibling()
    local allFriendDta = QuickFind:GetThreeVsThreeDataMgr():GetInvitablePlayerData(1, true)
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

function SportTeam3V3Template:warAllianceOnClick()
  if self.arrow_warAlliance:GetLocalEulerAnglesZ() == 270 then
    self.arrow_warAlliance:SetLocalEulerAnglesZ(90)
    self.arrow_firend:SetLocalEulerAnglesZ(270)
    self.arrow_near:SetLocalEulerAnglesZ(270)
    self.memberList:SetAsLastSibling()
    local allWarAllianceMemberData = QuickFind:GetThreeVsThreeDataMgr():GetInvitablePlayerData(2, true)
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

function SportTeam3V3Template:nearOnClick()
  if self.arrow_near:GetLocalEulerAnglesZ() == 270 then
    self.arrow_near:SetLocalEulerAnglesZ(90)
    self.arrow_firend:SetLocalEulerAnglesZ(270)
    self.arrow_warAlliance:SetLocalEulerAnglesZ(270)
    self.memberList:SetAsLastSibling()
    local allNearMemberData = QuickFind:GetThreeVsThreeDataMgr():GetInvitablePlayerData(3, true)
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

function SportTeam3V3Template:Refresh()
  if QuickFind:GetThreeVsThreeDataMgr():GetIsHaveTeam() == false then
    networkRequest.ReqCreateMatchTeam(1)
  else
    self:RefreshRelatedToTheCaptainView()
  end
  self:RefreshSurplusPvpCountView()
  self:RefreshActivityTimeView()
end

function SportTeam3V3Template:RefreshSurplusPvpCountView()
  local surplusPvpCount = QuickFind:GetThreeVsThreeDataMgr():GetPvpCount()
  local colorCount = string.GetColorText(surplusPvpCount, surplusPvpCount <= 0 and ItemQuality2ColorDic[EItemColorEnum.red] or ItemQuality2ColorDic[EItemColorEnum.green])
  self.activityCount:SetText(string.format("L\198\176\225\187\163t x\225\186\191p h\225\186\161ng c\195\178n l\225\186\161i: %s l\225\186\167n", colorCount))
end

function SportTeam3V3Template:RefreshActivityTimeView()
  local cfg = ClientTable.cfg_Activity_overviewManager:TryGetValue(5001, "activityId")
  local showTime = cfg and cfg.showTime or ""
  self.times2:SetText(showTime)
end

function SportTeam3V3Template:RefreshRoomPlayerView()
  local allPlayerData = QuickFind:GetThreeVsThreeDataMgr():GetMatchTeamData()
  for i, roomPlayerTemplate in pairs(self.roomPlayerTemplateList) do
    roomPlayerTemplate:Refresh(allPlayerData[i], self.root)
  end
end

function SportTeam3V3Template:RefreshInvitablePlayerView(eventKey)
  local allFriendDta = QuickFind:GetThreeVsThreeDataMgr():GetInvitablePlayerData(1, true)
  local allWarAllianceMemberData = QuickFind:GetThreeVsThreeDataMgr():GetInvitablePlayerData(2, true)
  local allNearMemberData = QuickFind:GetThreeVsThreeDataMgr():GetInvitablePlayerData(3, true)
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
    self.invitablePlayerContainer:SetData(refreshData)
    self.memberList:SetNormalizedPosition(0, 1)
  end
end

function SportTeam3V3Template:RefreshBtnStartStateView(state)
  if state == 0 then
    self.lab_Multi:SetText("B\225\186\175t \196\145\225\186\167u gh\195\169p c\225\186\183p")
    self.matchTimeMulti:SetActive(false)
    self:RefreshMatchTime(false)
  elseif state == 1 then
    self.lab_Multi:SetText("\196\144ang gh\195\169p tr\225\186\173n")
    self.matchTimeMulti:SetActive(true)
    self:RefreshMatchTime(true)
  end
end

function SportTeam3V3Template:RefreshReadyBtnStateView(state)
  if state == 0 then
    self.lab_ready:SetText("Chu\225\186\169n b\225\187\139")
    self.matchTimeMulti:SetActive(false)
    self:RefreshMatchTime(false)
  elseif state == 1 then
    self.lab_ready:SetText("\196\144ang chu\225\186\169n b\225\187\139")
    self.matchTimeMulti:SetActive(false)
    self:RefreshMatchTime(false)
  elseif state == 2 then
    self.lab_ready:SetText("\196\144ang gh\195\169p tr\225\186\173n")
    self.matchTimeMulti:SetActive(true)
    self:RefreshMatchTime(true)
  end
end

function SportTeam3V3Template:RefreshMatchTime(isMatchState)
  if self.mathchTimeLoop then
    Timer.Stop(self.mathchTimeLoop)
    self.mathchTimeLoop = nil
  end
  if isMatchState then
    local matchTime = Mathf.Floor((Time.GetServerTime() - QuickFind:GetThreeVsThreeDataMgr():GetJoinMatchTime()) * 0.001)
    self.lab_matchTimeMulti:SetText(string.format("%s gi\195\162y", matchTime))
    self.mathchTimeLoop = Timer.StartLoopForever(0.3, function()
      local matchTime = Mathf.Floor((Time.GetServerTime() - QuickFind:GetThreeVsThreeDataMgr():GetJoinMatchTime()) * 0.001)
      self.lab_matchTimeMulti:SetText(string.format("%s gi\195\162y", matchTime))
    end)
  else
    local matchTime = 0
    self.lab_matchTimeMulti:SetText(string.format("%s gi\195\162y", matchTime))
  end
end

function SportTeam3V3Template:RefreshBtnStateView()
  local meIsCaptain = QuickFind:GetThreeVsThreeDataMgr():GetMeIsCaptain()
  self.btn_start:SetActive(meIsCaptain)
  self.btn_ready:SetActive(not meIsCaptain)
  if QuickFind:GetThreeVsThreeDataMgr():GetMatchState() == 1 then
    if meIsCaptain then
      self:RefreshBtnStartStateView(1)
    else
      self:RefreshReadyBtnStateView(2)
    end
  elseif meIsCaptain then
    self:RefreshBtnStartStateView(0)
  elseif QuickFind:GetThreeVsThreeDataMgr():GetMeReadyState() == false then
    self:RefreshReadyBtnStateView(0)
  else
    self:RefreshReadyBtnStateView(1)
  end
end

function SportTeam3V3Template:RefreshRelatedToTheCaptainView()
  self:RefreshRoomPlayerView()
  self:RefreshInvitablePlayerView()
  self:RefreshBtnStateView()
end

function SportTeam3V3Template:ReturnSportMatch3V3View()
  self.parent:RefreshSportMatch3V3Template()
end

function SportTeam3V3Template:MatchingCallBack()
  local meIsCaptain = QuickFind:GetThreeVsThreeDataMgr():GetMeIsCaptain()
  if meIsCaptain then
    self:RefreshBtnStartStateView(1)
  else
    self:RefreshReadyBtnStateView(2)
  end
end

function SportTeam3V3Template:CancleMatchSuccessCallBack()
  local meIsCaptain = QuickFind:GetThreeVsThreeDataMgr():GetMeIsCaptain()
  if meIsCaptain then
    self:RefreshBtnStartStateView(0)
  elseif QuickFind:GetThreeVsThreeDataMgr():GetMeReadyState() == false then
    self:RefreshReadyBtnStateView(0)
  else
    self:RefreshReadyBtnStateView(1)
  end
end

function SportTeam3V3Template:OnDisable()
  if self.mathchTimeLoop then
    Timer.Stop(self.mathchTimeLoop)
    self.mathchTimeLoop = nil
  end
end

function SportTeam3V3Template:OnHide()
end

return SportTeam3V3Template
