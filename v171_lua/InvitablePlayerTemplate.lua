local InvitablePlayerTemplate = {}

function InvitablePlayerTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
end

function InvitablePlayerTemplate:InitControls()
  self.imgHead = self:GetControl("headBg/imgHead")
  self.playerLevel = self:GetControl("headBg/playerLevel")
  self.playerName = self:GetControl("headBg/playerName")
  self.playerOccupation = self:GetControl("headBg/playerOccupation")
  self.imgRank = self:GetControl("headBg/imgRank")
  self.imgLevel = self:GetControl("headBg/imgRank/imgLevel")
  self.playerCount = self:GetControl("headBg/playerCount")
  self.lab_count = self:GetControl("headBg/playerCount/lab_count")
  self.btn_invite = self:GetControl("headBg/btn_invite")
end

function InvitablePlayerTemplate:BindUIEvent()
  self.btn_invite:SetOnClick(self, self.btn_inviteOnClick)
end

function InvitablePlayerTemplate:btn_inviteOnClick()
  if not self.levelCondition then
    self.levelCondition = -1
    local condition = ClientTable.cfg_Function_functionManager:TryGetValue(3000501).condition[1]
    for i = 1, table.count(condition) do
      if condition[i][1] == 7001 then
        self.levelCondition = condition[i][2] * 400
      end
    end
  end
  if self.levelCondition and self.levelCondition > 0 and self.data.level <= self.levelCondition then
    local str = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Activity_3v3_Invite")
    FloatingTipUtility.QuickMsg(str)
    return
  end
  if QuickFind:GetThreeVsThreeDataMgr():GetMatchRoomPlayerNum() >= 3 then
    FloatingTipUtility.QuickMsg("Ph\195\178ng \196\145\195\163 \196\145\225\186\167y")
    return
  end
  if QuickFind:GetThreeVsThreeDataMgr():GetMatchState() == 1 then
    FloatingTipUtility.QuickMsg("\196\144ang gh\195\169p tr\225\186\173n kh\195\180ng th\225\187\131 th\225\187\177c hi\225\187\135n thao t\195\161c n\195\160y, h\195\163y h\225\187\167y Gh\195\169p Tr\225\186\173n tr\198\176\225\187\155c")
    return
  end
  local isTeam = false
  if self.inviteTime and self.inviteTime > Time.GetServerSecondTime() then
    isTeam = QuickFind:GetThreeVsThreeDataMgr():GetPlayerTeam(self.data)
    if not isTeam then
      local str = string.format("\196\144\195\163 m\225\187\157i ng\198\176\225\187\157i ch\198\161i, h\195\163y ch\225\187\157 %s gi\195\162y sau th\225\187\173 l\225\186\161i", self.inviteTime - Time.GetServerSecondTime())
      FloatingTipUtility.QuickMsg(str)
      return
    end
  end
  if self.data and self.data.id and self.data.serverId then
    networkRequest.ReqThreeVThreeInvitePlayer(self.data.id, self.data.serverId, 1)
    if not isTeam then
      self.inviteTime = tonumber(ClientTable.cfg_Activity_globalManager:TryGetValue(500068).effect) + Time.GetServerSecondTime()
    end
  end
end

function InvitablePlayerTemplate:Refresh(data, ui)
  if table.isNullOrEmpty(data) then
    self:UIControl():SetActive(false)
    return
  end
  self:UIControl():SetActive(true)
  self.data = data
  self.root = ui
  self:RefreshUIView()
end

function InvitablePlayerTemplate:RefreshUIView()
  self.root:SetSprite("Atlas_headPortrait", self.data.headIcon, self.imgHead)
  self.playerLevel:SetText(self.data.level)
  self.playerName:SetText(self.data.name)
  self.playerOccupation:SetText(RoleUtility.GteCareerNameByType(self.data.career))
  if self.data.cfgData and not string.isNullOrEmpty(self.data.cfgData.stageNameSmallBg) then
    self.root:SetSprite("Atlas_Main", self.data.cfgData.stageNameSmallBg, self.imgRank)
    self.imgRank:SetActive(true)
  else
    self.imgRank:SetActive(false)
  end
  if self.data.cfgData and not string.isNullOrEmpty(self.data.cfgData.stageLevelSmallName) then
    self.root:SetSprite("Atlas_Language", self.data.cfgData.stageLevelSmallName, self.imgLevel)
    self.imgLevel:SetActive(true)
  else
    self.imgLevel:SetActive(false)
  end
  local colorCount = string.GetColorText(self.data.pvpCount, self.data.pvpCount <= 0 and ItemQuality2ColorDic[EItemColorEnum.red] or ItemQuality2ColorDic[EItemColorEnum.green])
  self.playerCount:SetText(string.format("L\198\176\225\187\163t c\195\178n l\225\186\161i: %s l\225\186\167n", colorCount))
  self.lab_count:SetActive(false)
  local meIsCaptain = QuickFind:GetThreeVsThreeDataMgr():GetMeIsCaptain()
  self.btn_invite:SetActive(meIsCaptain)
end

function InvitablePlayerTemplate:OnHide()
end

return InvitablePlayerTemplate
