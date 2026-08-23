Team3V3UI = class(BaseUI)
Team3V3UI.layer = UILayer.Panel
Team3V3UI.orderInLayer = 0
Team3V3UI.hideType = UIHideType.WaitDestroy
Team3V3UI.hideFunc = UIHideFunc.MoveOutOfScreen
Team3V3UI.escClose = UIEscClose.DontClose

function Team3V3UI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("btn_close")
  self.tog_team = self:GetControl("sw_togList/Viewport/Content/tog_team")
  self.tog_raceSchedule = self:GetControl("sw_togList/Viewport/Content/tog_raceSchedule")
  self.tog_rewardShow = self:GetControl("sw_togList/Viewport/Content/tog_rewardShow")
  self.sw_team = self:GetControl("sw_team")
  self.sw_schedule = self:GetControl("sw_schedule")
  self.sw_rewardShow = self:GetControl("sw_rewardShow")
  self.tog_team_Label = self:GetControl("sw_togList/Viewport/Content/tog_team/Label")
  self.tog_raceSchedule_Label = self:GetControl("sw_togList/Viewport/Content/tog_raceSchedule/Label")
  self.tog_rewardShow_Label = self:GetControl("sw_togList/Viewport/Content/tog_rewardShow/Label")
  self.sw_team = self:GetControl("sw_team")
  self.createTeam = self:GetControl("sw_team/createTeam")
  self.allocateTeam = self:GetControl("sw_team/allocateTeam")
  self.btn_manage = self:GetControl("sw_team/allocateTeam/captainButton/signUpState/btn_manage")
end

function Team3V3UI:Init()
  self.curUIId = nil
end

function Team3V3UI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Team3V3UI:InitUI()
  self.togObj = {
    [Team3V3UIEnum.TEAM] = self.tog_team,
    [Team3V3UIEnum.SCHEDULE] = self.tog_raceSchedule,
    [Team3V3UIEnum.REWARD] = self.tog_rewardShow
  }
  self.togLabel = {
    [self.tog_team] = self.tog_team_Label,
    [self.tog_raceSchedule] = self.tog_raceSchedule_Label,
    [self.tog_rewardShow] = self.tog_rewardShow_Label
  }
  self.allocateTeamTemplate = luaTemplateManager.GetNewTemplate(self.allocateTeam, LuaComponentTemplates.AllocateTeam3V3Template, self)
  self.createTeamTemplate = luaTemplateManager.GetNewTemplate(self.createTeam, LuaComponentTemplates.CreateTeam3V3Template, self)
  self.scheduleTemplate = luaTemplateManager.GetNewTemplate(self.sw_schedule, LuaComponentTemplates.ScheduleTeam3V3Template, self)
  self.rewardShowTemplate = luaTemplateManager.GetNewTemplate(self.sw_rewardShow, LuaComponentTemplates.Team3v3RewardShowTemplate, self)
end

function Team3V3UI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.tog_team:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_raceSchedule:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_rewardShow:SetOnToggleChanged(self, self.OnToggleChanged)
end

function Team3V3UI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Team3V3UI)
end

function Team3V3UI:OnToggleChanged(control, isOn, isFromCode)
  if not self.curUIId then
    UIManager.Hide(UIID.Team3V3UI)
    return
  end
  if not isOn then
    return
  end
  if self.tog_team.toggle.isOn then
    self.curUIId = Team3V3UIEnum.TEAM
  elseif self.tog_raceSchedule.toggle.isOn then
    self.curUIId = Team3V3UIEnum.SCHEDULE
  elseif self.tog_rewardShow.toggle.isOn then
    self.curUIId = Team3V3UIEnum.REWARD
  end
  self.sw_team:SetActive(self.curUIId == Team3V3UIEnum.TEAM)
  self.sw_schedule:SetActive(self.curUIId == Team3V3UIEnum.SCHEDULE)
  self.sw_rewardShow:SetActive(self.curUIId == Team3V3UIEnum.REWARD)
  self.rewardShowTemplate:Exit()
  if self.curUIId == Team3V3UIEnum.TEAM then
    self:ShowTeam()
  elseif self.curUIId == Team3V3UIEnum.SCHEDULE then
    if not isFromCode then
      networkRequest.ReqTeamDuelTotal()
    end
  elseif self.curUIId == Team3V3UIEnum.REWARD then
    self.rewardShowTemplate:Refresh()
  end
  QuickFind:GetTeam3V3DataMgr():SetBattleMenberBtnShow(true)
  QuickFind:GetTeam3V3DataMgr():RestoreBattleInfo()
  for i, v in pairs(self.togObj) do
    local label = self.togLabel[v]
    if label then
      if v.toggle.isOn then
        label:SetColor("0xFAB93DFF")
      else
        label:SetColor("0x9F9D92FF")
      end
    end
  end
end

function Team3V3UI:OnShow()
  networkRequest.ReqCompetitionStage()
  self:RegistEvents()
  self:Refresh()
end

function Team3V3UI:RegistEvents()
  self:RegistEvent(Event.RefreshTeam3V3Info, self.Team3V3InfoChange, self)
  self:RegistEvent(Event.Team3v3MainToggleChange, self.Team3v3MainToggleChange, self)
  self:RegistEvent(Event.Team3v3RaceScheduleToggleChange, self.Team3v3RaceScheduleToggleChange, self)
  self:RegistEvent(Event.Team3v3RefreshRaceInfo, self.Team3v3RefreshRaceInfo, self)
end

function Team3V3UI:Team3v3RefreshRaceInfo(_, type)
  if not type then
    return
  end
  self.scheduleTemplate:RefreshRaceInfo(type)
end

function Team3V3UI:Team3v3RaceScheduleToggleChange(_, type)
  if not type then
    return
  end
  self.scheduleTemplate:Refresh(type)
end

function Team3V3UI:Team3v3MainToggleChange(_, type)
  if not type then
    return
  end
  self.curUIId = type
  if self.togObj[self.curUIId].toggle.isOn then
    self:OnToggleChanged(nil, true, self.curUIId == Team3V3UIEnum.SCHEDULE)
  else
    self.togObj[self.curUIId].toggle.isOn = true
  end
end

function Team3V3UI:Team3V3InfoChange()
  if self.curUIId and self.curUIId == Team3V3UIEnum.TEAM then
    self:ShowTeam()
  end
end

function Team3V3UI:Refresh()
  if not self.curUIId then
    if self.args and self.args.uiID then
      self.curUIId = self.args.uiID
    elseif self:HideTeamTog() then
      self.tog_team:SetActive(false)
      self.curUIId = Team3V3UIEnum.SCHEDULE
      self.tog_team.toggle.isOn = false
    else
      self.tog_team:SetActive(true)
      self.curUIId = Team3V3UIEnum.TEAM
      self.tog_team.toggle.isOn = true
    end
  end
  if self.togObj[self.curUIId].toggle.isOn then
    self:OnToggleChanged(nil, true)
  else
    self.togObj[self.curUIId].toggle.isOn = true
  end
end

function Team3V3UI:CheckToDraw()
  local teamInfo = QuickFind:GetTeam3V3DataMgr():GetMatchTeamInfo()
  if teamInfo and teamInfo.isDraw and teamInfo.leaderId == RoleManager.me.id then
    local function func()
      networkRequest.ReqMatchGroup(teamInfo.teamId)
    end
    
    Team3V3Controller:TipShow(KnockoutDrawTipType.ReqKnockoutDraw, nil, func)
  end
end

function Team3V3UI:HideTeamTog()
  local teamInfo = QuickFind:GetTeam3V3DataMgr():GetMatchTeamInfo()
  local inTime = math.floor(Time.GetServerTime() * 0.001) > QuickFind:GetTeam3V3DataMgr():GetBaoMinTime().endStamp
  if (not teamInfo.teamId or teamInfo.teamId == 0) and inTime then
    return true
  end
  return false
end

function Team3V3UI:ShowTeam()
  local info = QuickFind:GetTeam3V3DataMgr():GetMatchTeamInfo()
  if info.teamId and info.teamId ~= 0 then
    self.createTeamTemplate:Exit()
    self.createTeam:SetActive(false)
    self.allocateTeam:SetActive(true)
    self.allocateTeamTemplate:Refresh()
    self.allocateTeamTemplate:RefreshChuZhanBtn()
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      type = ERedPointType.Team3V3UI
    })
  else
    self.allocateTeamTemplate:Exit()
    self.createTeam:SetActive(true)
    self.allocateTeam:SetActive(false)
    self.createTeamTemplate:Refresh()
  end
  self.tog_team_Label:SetText(info.teamId and info.teamId ~= 0 and "Th\195\180ng tin Chi\225\186\191n \196\144\225\187\153i" or "Chi\225\186\191n \196\144\225\187\153i b\195\161o danh")
  self:CheckToDraw()
end

function Team3V3UI:OnHide()
  self.curUIId = nil
  self.allocateTeamTemplate:Exit()
  self.createTeamTemplate:Exit()
  self.scheduleTemplate:Exit()
  self.rewardShowTemplate:Exit()
  QuickFind:GetTeam3V3DataMgr():ResetStairsRank()
  local teamInfo = QuickFind:GetTeam3V3DataMgr():GetMatchTeamInfo()
  local isMatchSuccessFul = QuickFind:GetTeam3V3DataMgr():GetMatchSuccessFul()
  if teamInfo.teamStage == TeamProcessStage.PromotionMatch and not isMatchSuccessFul and teamInfo and teamInfo.teamId and teamInfo.teamId ~= 0 then
    networkRequest.ReqPrepareMatch(teamInfo.teamId, false)
    networkRequest.ReqCancelMatchThreeVThree(1)
  end
  QuickFind:GetTeam3V3DataMgr():SetMatchSuccessFul(false)
end

function Team3V3UI:OnDestroy()
end
