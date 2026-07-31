local ScheduleOfTaoTaiRaceTemplate = {}

function ScheduleOfTaoTaiRaceTemplate:Init(root)
  self.root = root
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
end

function ScheduleOfTaoTaiRaceTemplate:InitControls()
  self.Content = self:GetControl("ScrollView/Viewport/Content")
  self.teamCellTbl = {}
  local allCount = self:GetTeamCellAllCount()
  for i = 1, allCount do
    self:GetTeamCellControl(i, allCount)
  end
end

function ScheduleOfTaoTaiRaceTemplate:GetTeamCellAllCount()
  local allCount = 0
  for i, v in pairs(TeamCellSession) do
    allCount = allCount + v / 2
  end
  return allCount
end

function ScheduleOfTaoTaiRaceTemplate:GetTeamCellControl(group, allCount)
  if not self.teamCellTbl[group] then
    self.teamCellTbl[group] = {}
  end
  for i = 1, 2 do
    local teamCell = self:GetControl("ScrollView/Viewport/Content/detail2_txt/Group_" .. group .. "/teamName_bg_" .. i)
    local teamCellName = teamCell:GetChild("name_txt")
    local teamCellLine = group ~= allCount and teamCell:GetChild("jinji_img") or nil
    self.teamCellTbl[group][i] = {}
    self.teamCellTbl[group][i].teamCell = teamCell
    self.teamCellTbl[group][i].teamCellName = teamCellName
    self.teamCellTbl[group][i].teamCellLine = teamCellLine
    self.teamCellTbl[group][i].teamData = {group = group, index = i}
  end
end

function ScheduleOfTaoTaiRaceTemplate:InitUI()
end

function ScheduleOfTaoTaiRaceTemplate:BindUIEvent()
  for i, v in pairs(self.teamCellTbl) do
    for index, control in pairs(v) do
      control.teamCell:SetOnClickParam(self, self.OnTeamCellClick, control.teamData)
    end
  end
end

function ScheduleOfTaoTaiRaceTemplate:OnTeamCellClick(control)
  if not control.param or not control.param.teamId then
    return
  end
  networkRequest.ReqGetMatchTeamInfo(control.param.teamId, ReqTeamInfoType.Tips)
end

function ScheduleOfTaoTaiRaceTemplate:Refresh(data)
  self:ResetPanel()
  if not data then
    return
  end
  local myTeamInfo = QuickFind:GetTeam3V3DataMgr():GetMatchTeamInfo()
  local myTeamId = not table.isNullOrEmpty(myTeamInfo) and myTeamInfo.teamId or nil
  local myTeamPosition, isRedTeam
  for i, v in pairs(data) do
    if v.position and v.position > 15 then
      v.position = 15
    end
    if v.position and self.teamCellTbl[v.position] then
      local cell = self.teamCellTbl[v.position]
      if v.redTeamId and cell[1] then
        cell[1].teamData.teamId = v.redTeamId
      end
      if v.blueTeamId and cell[2] then
        cell[2].teamData.teamId = v.blueTeamId
      end
      local redResult = self:RefreshTaoTaiTeamCell(cell[1], v.redTeamId, v.redTeamName, myTeamId)
      if redResult.isMyTeam then
        myTeamPosition = v.position
        isRedTeam = true
      end
      local blueResult = self:RefreshTaoTaiTeamCell(cell[2], v.blueTeamId, v.blueTeamName, myTeamId)
      if blueResult.isMyTeam then
        myTeamPosition = v.position
        isRedTeam = false
      end
      if v.winTeamId and v.winTeamId > 0 then
        local isRedWin = v.redTeamId == v.winTeamId
        if cell[1] and cell[1].teamCellLine then
          cell[1].teamCellLine:SetActive(isRedWin)
        end
        if cell[2] and cell[2].teamCellLine then
          cell[2].teamCellLine:SetActive(not isRedWin)
        end
      end
    end
  end
  self:ScrollToMyTeam(myTeamPosition, isRedTeam)
end

function ScheduleOfTaoTaiRaceTemplate:RefreshTaoTaiTeamCell(cellControl, teamId, teamName, myTeamId)
  if not cellControl or not cellControl.teamCellName then
    return {isMyTeam = false}
  end
  local showStr = "Tr\225\187\145ng"
  if QuickFind:GetTeam3V3DataMgr():IsTimePassed() then
    showStr = "<color=#787878>Mi\225\187\133n chi\225\186\191n</color>"
  end
  local isMyTeam = false
  local displayName = not string.isNullOrEmpty(teamName) and teamName or showStr
  if myTeamId and teamId and teamId == myTeamId then
    displayName = "<color=#e18921>" .. displayName .. "</color>"
    isMyTeam = true
  end
  cellControl.teamCellName:SetText(displayName)
  return {isMyTeam = isMyTeam}
end

function ScheduleOfTaoTaiRaceTemplate:ScrollToMyTeam(myTeamPosition, isRedTeam)
  local contentPositionY = 157.7
  if not myTeamPosition or isRedTeam == nil then
    self.Content.transform.localPosition = Vector3(-494.7, contentPositionY, 0)
    return
  end
  if myTeamPosition == 1 or myTeamPosition == 2 or myTeamPosition == 9 or myTeamPosition == 13 and isRedTeam then
    contentPositionY = 150
  elseif myTeamPosition == 15 and isRedTeam then
    contentPositionY = 260
  elseif myTeamPosition == 3 or myTeamPosition == 4 or myTeamPosition == 10 or myTeamPosition == 13 and not isRedTeam then
    contentPositionY = 370
  elseif myTeamPosition == 5 or myTeamPosition == 6 or myTeamPosition == 11 or myTeamPosition == 14 and isRedTeam then
    contentPositionY = 590
  elseif myTeamPosition == 15 and not isRedTeam then
    contentPositionY = 700
  elseif myTeamPosition == 7 or myTeamPosition == 8 or myTeamPosition == 12 or myTeamPosition == 14 and not isRedTeam then
    contentPositionY = 790
  end
  self.Content.transform.localPosition = Vector3(-494.7, contentPositionY + 157.7, 0)
end

function ScheduleOfTaoTaiRaceTemplate:ResetPanel()
  for i, v in pairs(self.teamCellTbl) do
    for index, control in pairs(v) do
      control.teamCellName:SetText("Tr\225\187\145ng")
      if control.teamCellLine then
        control.teamCellLine:SetActive(false)
      end
    end
  end
end

function ScheduleOfTaoTaiRaceTemplate:Exit()
end

return ScheduleOfTaoTaiRaceTemplate
