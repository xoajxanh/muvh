local ScheduleOfJiJunOrGuanJunRaceTemplate = {}

function ScheduleOfJiJunOrGuanJunRaceTemplate:Init(root)
  self.root = root
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
end

function ScheduleOfJiJunOrGuanJunRaceTemplate:InitControls()
  self.teamCell_left = self:GetControl("teamName_bg_1")
  self.teamName_left = self:GetControl("teamName_bg_1/name_txt")
  self.checkMember_left = self:GetControl("teamName_bg_1/btn_info")
  self.score_left = self:GetControl("teamName_bg_1/Score")
  self.win_left = self:GetControl("teamName_bg_1/jiaobiao_img")
  self.teamCell_right = self:GetControl("teamName_bg_2")
  self.teamName_right = self:GetControl("teamName_bg_2/name_txt")
  self.checkMember_right = self:GetControl("teamName_bg_2/btn_info")
  self.score_right = self:GetControl("teamName_bg_2/Score")
  self.win_right = self:GetControl("teamName_bg_2/jiaobiao_img")
  self.time_txt = self:GetControl("decisiveBattleTime_Bg/decisiveBattleTime_txt")
end

function ScheduleOfJiJunOrGuanJunRaceTemplate:InitUI()
  self.redMembers = nil
  self.blueMembers = nil
  self.specialStrList = {
    [0] = "Tr\225\187\145ng",
    [1] = "<color=#787878>Mi\225\187\133n chi\225\186\191n</color>"
  }
end

function ScheduleOfJiJunOrGuanJunRaceTemplate:BindUIEvent()
  self.checkMember_left:SetOnClick(self, self.OnLeftTeamCellClick)
  self.checkMember_right:SetOnClick(self, self.OnRightTeamCellClick)
end

function ScheduleOfJiJunOrGuanJunRaceTemplate:OnLeftTeamCellClick(control)
  if table.isNullOrEmpty(self.redMembers) then
    return
  end
  UIManager.Show(UIID.Team3V3CheckMemberUI, {
    teamMemberData = {
      infos = self.redMembers
    }
  })
end

function ScheduleOfJiJunOrGuanJunRaceTemplate:OnRightTeamCellClick(control)
  if table.isNullOrEmpty(self.blueMembers) then
    return
  end
  UIManager.Show(UIID.Team3V3CheckMemberUI, {
    teamMemberData = {
      infos = self.blueMembers
    }
  })
end

function ScheduleOfJiJunOrGuanJunRaceTemplate:Refresh(data)
  self:ResetPanel()
  if not data or table.count(data) < 1 then
    return
  end
  local info = data
  if table.isNullOrEmpty(info) then
    return
  end
  local myTeamInfo = QuickFind:GetTeam3V3DataMgr():GetMatchTeamInfo()
  local myTeamId = not table.isNullOrEmpty(myTeamInfo) and myTeamInfo.teamId or nil
  local dataCount = (info.redTeamId > 0 and 1 or 0) + (0 < info.blueTeamId and 1 or 0)
  self.redMembers = info.redMembers
  self:RefreshTeamCell(info.redTeamId, info.redTeamName, info.redWinCount, myTeamId, dataCount, self.teamName_left, self.score_left)
  self.blueMembers = info.blueMembers
  self:RefreshTeamCell(info.blueTeamId, info.blueTeamName, info.blueWinCount, myTeamId, dataCount, self.teamName_right, self.score_right)
  if info.winTeamId and 0 < info.winTeamId then
    local isRedWin = info.winTeamId == info.redTeamId
    self.win_left:SetActive(isRedWin)
    self.win_right:SetActive(not isRedWin)
  end
end

function ScheduleOfJiJunOrGuanJunRaceTemplate:RefreshTeamCell(teamId, teamName, winCount, myTeamId, dataCount, nameCtrl, scoreCtrl)
  if teamId and 0 < teamId then
    local displayName = teamName
    if myTeamId and teamId == myTeamId then
      displayName = "<color=#e18921>" .. teamName .. "</color>"
    end
    nameCtrl:SetText(displayName)
  else
    nameCtrl:SetText(self.specialStrList[dataCount])
  end
  scoreCtrl:SetText(winCount or 0)
end

function ScheduleOfJiJunOrGuanJunRaceTemplate:ResetPanel()
  self.teamName_left:SetText("Tr\225\187\145ng")
  self.win_left:SetActive(false)
  self.score_left:SetText("0")
  self.teamName_right:SetText("Tr\225\187\145ng")
  self.win_right:SetActive(false)
  self.score_right:SetText("0")
end

function ScheduleOfJiJunOrGuanJunRaceTemplate:Exit()
  self.redMembers = nil
  self.blueMembers = nil
end

return ScheduleOfJiJunOrGuanJunRaceTemplate
