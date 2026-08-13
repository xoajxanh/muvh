local ScheduleTeam3V3Template = {}

function ScheduleTeam3V3Template:Init(root)
  self.root = root
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
end

function ScheduleTeam3V3Template:InitControls()
  self.tog_race_JinJi = self:GetControl("sw_scheduleList/Viewport/Content/tog_race1")
  self.tog_race_TaoTai = self:GetControl("sw_scheduleList/Viewport/Content/tog_race1 (1)")
  self.tog_race_JiJun = self:GetControl("sw_scheduleList/Viewport/Content/tog_race1 (2)")
  self.tog_race_GuanJun = self:GetControl("sw_scheduleList/Viewport/Content/tog_race1 (3)")
  self.tog_race_JinJiLabel = self:GetControl("sw_scheduleList/Viewport/Content/tog_race1/Label")
  self.tog_race_TaoTaiLabel = self:GetControl("sw_scheduleList/Viewport/Content/tog_race1 (1)/Label")
  self.tog_race_JiJunLabel = self:GetControl("sw_scheduleList/Viewport/Content/tog_race1 (2)/Label")
  self.tog_race_GuanJunLabel = self:GetControl("sw_scheduleList/Viewport/Content/tog_race1 (3)/Label")
  self.panel_race_JinJi = self:GetControl("jinjisai")
  self.panel_race_TaoTai = self:GetControl("taotaisai")
  self.panel_race_JiJun = self:GetControl("jijunsai")
  self.panel_race_GuanJun = self:GetControl("guanjunsai")
  self.timeDesc_JinJi = self:GetControl("jinjisai/ScrollView/Viewport/Content/detail_txt")
  self.timeDesc_TaoTai = self:GetControl("taotaisai/ScrollView/Viewport/Content/detail1_txt")
  self.timeDesc_JiJun = self:GetControl("jijunsai/decisiveBattleTime_Bg/decisiveBattleTime_txt")
  self.timeDesc_GuanJun = self:GetControl("guanjunsai/decisiveBattleTime_Bg/decisiveBattleTime_txt")
end

function ScheduleTeam3V3Template:InitUI()
  self.togObj = {
    [ScheduleTeam3V3UIEnum.JINJI] = self.tog_race_JinJi,
    [ScheduleTeam3V3UIEnum.TAOTAI] = self.tog_race_TaoTai,
    [ScheduleTeam3V3UIEnum.JIJUN] = self.tog_race_JiJun,
    [ScheduleTeam3V3UIEnum.GUANJUN] = self.tog_race_GuanJun
  }
  self.panelObj = {
    [ScheduleTeam3V3UIEnum.JINJI] = self.panel_race_JinJi,
    [ScheduleTeam3V3UIEnum.TAOTAI] = self.panel_race_TaoTai,
    [ScheduleTeam3V3UIEnum.JIJUN] = self.panel_race_JiJun,
    [ScheduleTeam3V3UIEnum.GUANJUN] = self.panel_race_GuanJun
  }
  self.togLabel = {
    [self.tog_race_JinJi] = self.tog_race_JinJiLabel,
    [self.tog_race_TaoTai] = self.tog_race_TaoTaiLabel,
    [self.tog_race_JiJun] = self.tog_race_JiJunLabel,
    [self.tog_race_GuanJun] = self.tog_race_GuanJunLabel
  }
  self.taoTaiTemplate = luaTemplateManager.GetNewTemplate(self.panel_race_TaoTai, LuaComponentTemplates.ScheduleOfTaoTaiRaceTemplate, self)
  self.jiJunTemplate = luaTemplateManager.GetNewTemplate(self.panel_race_JiJun, LuaComponentTemplates.ScheduleOfJiJunOrGuanJunRaceTemplate, self)
  self.guanJunTemplate = luaTemplateManager.GetNewTemplate(self.panel_race_GuanJun, LuaComponentTemplates.ScheduleOfJiJunOrGuanJunRaceTemplate, self)
end

function ScheduleTeam3V3Template:BindUIEvent()
  self.tog_race_JinJi:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_race_TaoTai:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_race_JiJun:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_race_GuanJun:SetOnToggleChanged(self, self.OnToggleChanged)
end

function ScheduleTeam3V3Template:OnToggleChanged(control, isOn)
  if not self.curUIId then
    self:ResetPanel()
    return
  end
  if not isOn then
    return
  end
  if self.tog_race_JinJi.toggle.isOn then
    self.curUIId = ScheduleTeam3V3UIEnum.JINJI
  elseif self.tog_race_TaoTai.toggle.isOn then
    self.curUIId = ScheduleTeam3V3UIEnum.TAOTAI
  elseif self.tog_race_JiJun.toggle.isOn then
    self.curUIId = ScheduleTeam3V3UIEnum.JIJUN
  elseif self.tog_race_GuanJun.toggle.isOn then
    self.curUIId = ScheduleTeam3V3UIEnum.GUANJUN
  end
  self.panel_race_JinJi:SetActive(self.curUIId == ScheduleTeam3V3UIEnum.JINJI)
  self.panel_race_TaoTai:SetActive(self.curUIId == ScheduleTeam3V3UIEnum.TAOTAI)
  self.panel_race_JiJun:SetActive(self.curUIId == ScheduleTeam3V3UIEnum.JIJUN)
  self.panel_race_GuanJun:SetActive(self.curUIId == ScheduleTeam3V3UIEnum.GUANJUN)
  if self.curUIId == ScheduleTeam3V3UIEnum.TAOTAI then
    local allRankData = QuickFind:GetTeam3V3DataMgr():GetAllRaceRankInfo()
    self.taoTaiTemplate:Refresh(allRankData)
  elseif self.curUIId == ScheduleTeam3V3UIEnum.JIJUN then
    local thirdPlaceRankData = QuickFind:GetTeam3V3DataMgr():GetThirdPlaceRank()
    if table.isNullOrEmpty(thirdPlaceRankData) or thirdPlaceRankData[1] == nil then
      self.jiJunTemplate:Refresh()
    else
      networkRequest.ReqTeamDuelDetailById(thirdPlaceRankData[1].duelId)
    end
  elseif self.curUIId == ScheduleTeam3V3UIEnum.GUANJUN then
    local championRankData = QuickFind:GetTeam3V3DataMgr():GetChampionRank()
    if table.isNullOrEmpty(championRankData) or championRankData[1] == nil then
      self.guanJunTemplate:Refresh()
    else
      networkRequest.ReqTeamDuelDetailById(championRankData[1].duelId)
    end
  end
  for i, v in pairs(self.togObj) do
    local label = self.togLabel[v]
    if label then
      if v.toggle.isOn then
        label:SetColor("0xD49D32FF")
      else
        label:SetColor("0x9F9D92FF")
      end
    end
  end
  self:SetTimeDesc()
end

function ScheduleTeam3V3Template:SetTimeDesc()
  local str1 = ClientTable.cfg_Ui_wordManager:TryGetValue("Team3v3_Tips_2").content
  local str2 = ClientTable.cfg_Ui_wordManager:TryGetValue("Team3v3_Tips_3").content
  local str3 = ClientTable.cfg_Ui_wordManager:TryGetValue("Team3v3_Tips_4").content
  local str4 = ClientTable.cfg_Ui_wordManager:TryGetValue("Team3v3_Tips_5").content
  local timeInfo = QuickFind:GetTeam3V3DataMgr():GetSelectionOpenTimeOfJinJi()
  if table.isNullOrEmpty(timeInfo) then
    self.timeDesc_JinJi:SetText(str1)
  else
    local raceCount = table.count(timeInfo)
    local strList = ""
    for i, v in ipairs(timeInfo) do
      local time = QuickFind:GetTeam3V3DataMgr():FormatTimeRange(v.promoteStartTime, v.promoteEndTime)
      local promoteStr = QuickFind:GetTeam3V3DataMgr():ConvertSpecialIdToStr(v.promoteCount)
      local str = string.format(str3, v.round, time, promoteStr)
      strList = strList .. str
    end
    self.timeDesc_JinJi:SetText(string.format(str2, raceCount) .. strList .. str4)
  end
  local str5 = ClientTable.cfg_Ui_wordManager:TryGetValue("Team3v3_Tips_6").content
  local str6 = ClientTable.cfg_Ui_wordManager:TryGetValue("Team3v3_Tips_7").content
  self.timeDesc_TaoTai:SetText(str5)
  self.timeDesc_JiJun:SetText("Th\225\187\157i gian thi \196\145\225\186\165u: Ch\198\176a x\195\161c \196\145\225\187\139nh")
  self.timeDesc_GuanJun:SetText("Th\225\187\157i gian thi \196\145\225\186\165u: Ch\198\176a x\195\161c \196\145\225\187\139nh")
  local timeInfoList = QuickFind:GetTeam3V3DataMgr():GetSelectionOpenTimeOfTaoTai()
  if table.isNullOrEmpty(timeInfoList) then
    return
  end
  local timeStr
  for i, v in ipairs(timeInfoList) do
    timeStr = QuickFind:GetTeam3V3DataMgr():FormatTimeRange(v.openTime, v.endTime)
    if v.stage == TeamProcessStage.KnockoutRound then
      self.timeDesc_TaoTai:SetText(string.format(str6, timeStr))
    elseif v.stage == TeamProcessStage.ThirdplaceMatch then
      self.timeDesc_JiJun:SetText("Th\225\187\157i gian thi \196\145\225\186\165u: " .. timeStr)
    elseif v.stage == TeamProcessStage.Championship then
      self.timeDesc_GuanJun:SetText("Th\225\187\157i gian thi \196\145\225\186\165u: " .. timeStr)
    end
  end
end

function ScheduleTeam3V3Template:ResetPanel()
  for i, v in pairs(self.panelObj) do
    v:SetActive(false)
  end
  self.curUIId = nil
end

function ScheduleTeam3V3Template:Refresh(panelType)
  self:ResetPanel()
  if panelType then
    self.curUIId = panelType
  end
  if not self.curUIId then
    self.curUIId = ScheduleTeam3V3UIEnum.JINJI
  end
  if self.togObj[self.curUIId].toggle.isOn then
    self:OnToggleChanged(nil, true)
  else
    self.togObj[self.curUIId].toggle.isOn = true
  end
end

function ScheduleTeam3V3Template:RefreshRaceInfo(type)
  if type == ScheduleTeam3V3UIEnum.JINJI then
  elseif type == ScheduleTeam3V3UIEnum.TAOTAI then
  elseif type == ScheduleTeam3V3UIEnum.JIJUN then
    local thirdPlaceTeamInfo = QuickFind:GetTeam3V3DataMgr():GetThirdPlaceTeamInfo()
    self.jiJunTemplate:Refresh(thirdPlaceTeamInfo)
  elseif type == ScheduleTeam3V3UIEnum.GUANJUN then
    local championTeamInfo = QuickFind:GetTeam3V3DataMgr():GetChampionTeamInfo()
    self.guanJunTemplate:Refresh(championTeamInfo)
  end
end

function ScheduleTeam3V3Template:Exit()
  self:ResetPanel()
end

return ScheduleTeam3V3Template
