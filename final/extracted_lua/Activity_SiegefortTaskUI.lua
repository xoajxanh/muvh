Activity_SiegefortTaskUI = class(BaseUI)
Activity_SiegefortTaskUI.layer = UILayer.Panel
Activity_SiegefortTaskUI.orderInLayer = 1
Activity_SiegefortTaskUI.hideType = UIHideType.WaitDestroy
Activity_SiegefortTaskUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_SiegefortTaskUI.escClose = UIEscClose.DontClose

function Activity_SiegefortTaskUI:InitControls()
  self.btn_Exit = self:GetControl("btn_Exit")
  self.Time_Text = self:GetControl("btn_Exit/eventCountdown_lab/Time_Text")
  self.tog_Task = self:GetControl("TaskRankBar/tog_Task")
  self.tog_Ranking = self:GetControl("TaskRankBar/tog_Ranking")
  self.panel_Task = self:GetControl("panel_Task")
  self.img_bg_taskDes = self:GetControl("panel_Task/img_bg_taskDes")
  self.ico_bg_task = self:GetControl("panel_Task/img_bg_taskDes/ico_bg_task")
  self.lab_target = self:GetControl("panel_Task/targetPanel/lab_target")
  self.siegeTarget_lab = self:GetControl("panel_Task/targetPanel/lab_target/siegeTarget_lab")
  self.OccupyName_Text = self:GetControl("panel_Task/CurrentOccupying_lab/OccupyName_Text")
  self.ZMRank_Text = self:GetControl("panel_Task/ZMRank_lab/ZMRank_Text")
  self.MyRank_Text = self:GetControl("panel_Task/siegeAttackPanel/MyRank_lab/MyRank_Text")
  self.MyIntegral_Text = self:GetControl("panel_Task/siegeAttackPanel/MyIntegral_lab/MyIntegral_Text")
  self.btn_siegeShop = self:GetControl("panel_Task/btn_siegeShop")
  self.btn_desc = self:GetControl("panel_Task/btn_desc")
  self.Panel_Ranking = self:GetControl("Panel_Ranking")
  self.tog_siegeRanking = self:GetControl("Panel_Ranking/panel_tab/tog_siegeRanking")
  self.tog_personalRanking = self:GetControl("Panel_Ranking/panel_tab/tog_personalRanking")
  self.go_rankingOne = self:GetControl("Panel_Ranking/go_rankingOne")
  self.go_rankingTwo = self:GetControl("Panel_Ranking/go_rankingTwo")
  self.go_rankingThree = self:GetControl("Panel_Ranking/go_rankingThree")
  self.go_rankingMe = self:GetControl("Panel_Ranking/go_rankingMe")
  self.lab_noUnion = self:GetControl("Panel_Ranking/lab_noUnion")
  self.btn_reward = self:GetControl("Panel_Ranking/btn_reward")
  self.go_rankingOnePre = self:GetControl("Panel_Ranking/go_rankingOnePre")
  self.go_rankingTwoPre = self:GetControl("Panel_Ranking/go_rankingTwoPre")
  self.go_rankingThreePre = self:GetControl("Panel_Ranking/go_rankingThreePre")
  self.go_rankingMePre = self:GetControl("Panel_Ranking/go_rankingMePre")
end

function Activity_SiegefortTaskUI:OnPreLoad()
end

function Activity_SiegefortTaskUI:Init()
end

function Activity_SiegefortTaskUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_SiegefortTaskUI:InitUI()
  self.siegeInfo = "task"
  self.rankTypeToPanel = {
    siege = {
      self.go_rankingOne,
      self.go_rankingTwo,
      self.go_rankingThree
    },
    private = {
      self.go_rankingOnePre,
      self.go_rankingTwoPre,
      self.go_rankingThreePre
    }
  }
  self.rankType = "siege"
  self.unionData = nil
  self:InitContent()
end

local function TargetCreate(control)
  control.Target_Text = control:GetChild("Target_Text")
  control.MoveBtn = control:GetChild("MoveBtn")
  control.siegeTarget_lab = control:GetChild("siegeTarget_lab")
end

local function TargetRefresh(ctr, _, targetData, ui)
  ctr:SetText(targetData.desc)
  if targetData.fightType == "attack" then
    ctr.Target_Text:SetText("<color=#FF2323>0</color>/<color=#DCE1E5>1</color>")
  elseif targetData.targetId == 0 then
    ctr.Target_Text:SetText("")
  else
    local siegeTargetStr = ClientTable.cfg_Activity_globalManager:TryGetValue(targetData.targetId).effect
    local siegeTargetData = string.split(siegeTargetStr, "#")
    local monster = Activity_LuoLanSiegeData.GetMonsterByCell(tonumber(siegeTargetData[1]), tonumber(siegeTargetData[2]), tonumber(siegeTargetData[3]))
    ctr.Target_Text:SetText(string.format("(HP <color=#1BFF00>%s/%s</color>)", monster.hp, monster.maxHp))
  end
  ctr.siegeTarget_lab:SetText(string.format("Giai \196\145o\225\186\161n %s", targetData.warChapter))
  ctr.MoveBtn.transferId = targetData.transferId
  ctr.MoveBtn:SetOnClick(ui, ui.MoveToTarget)
end

function Activity_SiegefortTaskUI:InitContent()
  self.targetTemp = UIContainer(self.lab_target, self, TargetCreate, TargetRefresh)
end

function Activity_SiegefortTaskUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_SiegefortTaskUI:OnHide()
  if self.countdownTime then
    Timer.Stop(self.countdownTime)
    self.countdownTime = nil
  end
  self.ZMRank_Text:SetText()
  self.MyRank_Text:SetText()
  self.MyIntegral_Text:SetText()
  self.rankType = "siege"
  self.siegeInfo = "task"
end

function Activity_SiegefortTaskUI:OnDestroy()
end

function Activity_SiegefortTaskUI:RegistUIEvents()
  self.btn_reward:SetOnClick(self, self.btn_siegeRewardOnClick)
  self.btn_Exit:SetOnClick(self, self.btn_ExitOnClick)
  self.btn_desc:SetOnClick(self, self.descBtnOnClick)
  self.tog_Task:SetOnToggleChanged(self, self.ShowTaskPanel)
  self.tog_Ranking:SetOnToggleChanged(self, self.ShowRankPanel)
  self.tog_siegeRanking:SetOnToggleChanged(self, self.ShowSiegeRank)
  self.tog_personalRanking:SetOnToggleChanged(self, self.ShowPrivateRank)
end

function Activity_SiegefortTaskUI:btn_ExitOnClick(control)
  local mapData = {mapId = 100101}
  EventManager.Dispatch(Event.Map_ChangeMap, mapData)
end

function Activity_SiegefortTaskUI:MoveToTarget(control)
  local transferConfig = ConfigManager.FindConfigs("cfg_Map_transfer", "id", control.transferId)
  local mapPos = string.split(transferConfig[1].position, "_")
  PathFinderManager.MoveToPosHangUpAutoFight(SceneData.groupId, Vector2(tonumber(mapPos[1]), tonumber(mapPos[2])))
end

function Activity_SiegefortTaskUI:shopBtnOnClick(control)
  UIManager.Show(UIID.Activity_SiegeShopUI, self.unionData)
end

function Activity_SiegefortTaskUI:descBtnOnClick(control)
  UIManager.Show(UIID.Activity_SiegeRewardUI)
end

function Activity_SiegefortTaskUI:btn_siegeRewardOnClick(control)
  UIManager.Show(UIID.Activity_SiegeRewardUI)
end

function Activity_SiegefortTaskUI:ShowTaskPanel(control)
  self.panel_Task:SetActive(control:GetIsOn())
  if not control:GetIsOn() then
    return
  end
  self.siegeInfo = "task"
  if self.rankType == "siege" then
    self.tog_siegeRanking:SetIsOn(true)
  else
    self.tog_personalRanking:SetIsOn(true)
  end
end

function Activity_SiegefortTaskUI:ShowRankPanel(control)
  self.Panel_Ranking:SetActive(control:GetIsOn())
  if not control:GetIsOn() then
    return
  end
  self.siegeInfo = "rank"
  if self.rankType == "siege" then
    self.tog_siegeRanking:SetIsOn(true)
  else
    self.tog_personalRanking:SetIsOn(true)
  end
end

function Activity_SiegefortTaskUI:ShowSiegeRank(control)
  if not control:GetIsOn() then
    return
  end
  self.rankType = "siege"
  self:UpdateRank()
end

function Activity_SiegefortTaskUI:ShowPrivateRank(control)
  if not control:GetIsOn() then
    return
  end
  self.rankType = "private"
  self:UpdateRank()
end

function Activity_SiegefortTaskUI:RegistEvents()
  self:RegistEvent(Event.EnterSiege, self.UpdateRank, self)
  self:RegistEvent(Event.RefreshSiegeTask, self.UpdateBasicTask, self)
  self:RegistEvent(Event.RefreshSiegeRank, self.UpdateRank, self)
  self:RegistEvent(Event.Main_UpdateMainUICall, self.UpdateTaskUI, self)
end

function Activity_SiegefortTaskUI:UpdateTaskUI()
  if self.siegeInfo == "task" then
    self.tog_Task:SetIsOn(true)
  else
    self.tog_Ranking:SetIsOn(true)
  end
end

function Activity_SiegefortTaskUI:Refresh()
  Activity_LuoLanSiegeData.GetNextOpenActivityTime()
  self:UpdateTaskUI()
  self:StartCountdownTime()
  self:UpdateBasicTask()
  self:UpdateRank()
end

function Activity_SiegefortTaskUI:UpdateBasicTask()
  local holdUnionId = Activity_LuoLanSiegeData.holdUnionId
  if holdUnionId ~= 0 and RoleManager.me.unionId == holdUnionId then
    self:SetSprite("Atlas_Common", "img_siege_gong", self.img_bg_taskDes)
    self:SetSprite("Atlas_Common", "ico_siege_shou", self.ico_bg_task)
    self.targetTemp:SetData(Activity_LuoLanSiegeData.GetUnCompleteDefendTarget())
  else
    self:SetSprite("Atlas_Common", "img_siege_gong", self.img_bg_taskDes)
    self:SetSprite("Atlas_Common", "ico_siege_gong", self.ico_bg_task)
    self.targetTemp:SetData(Activity_LuoLanSiegeData.GetUnCompleteAttackTarget())
  end
  self.unionData = Activity_LuoLanSiegeData.GetUnionByUnionId(holdUnionId)
  if not self.unionData then
    self.OccupyName_Text:SetText("Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i")
    return
  end
  local unionName = self.unionData.name
  if self.unionData.unionId == RoleManager.me.unionId then
    unionName = string.format("<color=#1BFF00>%s</color>", unionName)
  else
    unionName = string.format("<color=#FF8100>%s</color>", unionName)
  end
  self.OccupyName_Text:SetText(unionName)
end

function Activity_SiegefortTaskUI:StartCountdownTime()
  local intervalTime = Activity_LuoLanSiegeData.endLimitTimeUnix - Time.GetServerSecondTime()
  local intervalTime1 = Activity_LuoLanSiegeData.endLimitTimeUnix * 1000 - Time.GetServerTime()
  local _, secondInterval = math.modf(intervalTime1 / 1000)
  self.Time_Text:SetText(TimeUtility.ShowTime(intervalTime))
  
  local function CountdownTime()
    intervalTime = intervalTime - 1
    self.Time_Text:SetText(TimeUtility.ShowTime(intervalTime))
    if intervalTime <= 0 then
      Timer.Stop(self.countdownTime)
    end
  end
  
  local function StartCountDown()
    CountdownTime()
    self.countdownTime = Timer.StartLoopForever(1, CountdownTime)
  end
  
  if self.countdownTime then
    Timer.Stop(self.countdownTime)
    self.countdownTime = nil
  end
  self.countdownTime = Timer.Start(secondInterval, StartCountDown)
end

function Activity_SiegefortTaskUI:UpdateTaskSiegeInfo()
  if Activity_LuoLanSiegeData.myUnionScoreRank then
    self.ZMRank_Text:SetText(Activity_LuoLanSiegeData.myUnionScoreRank.rank)
  else
    self.ZMRank_Text:SetText("Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i")
  end
  if Activity_LuoLanSiegeData.myPersonalScoreRank then
    self.MyRank_Text:SetText(Activity_LuoLanSiegeData.myPersonalScoreRank.rank)
    self.MyIntegral_Text:SetText(Activity_LuoLanSiegeData.myPersonalScoreRank.score)
  else
    self.MyRank_Text:SetText("Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i")
    self.MyIntegral_Text:SetText(0)
  end
end

function Activity_SiegefortTaskUI:UpdateRank()
  if self.rankType == "siege" then
    self:UpdateSiegeRank()
  else
    self:UpdatePrivateRank()
  end
  self:UpdateTaskSiegeInfo()
end

function Activity_SiegefortTaskUI:UpdatePrivateRank()
  for i, v in ipairs(self.rankTypeToPanel.private) do
    self:UpdatePrivateScoreRankPanel(v, Activity_LuoLanSiegeData.personalScoreRank[i])
  end
  for i, v in ipairs(self.rankTypeToPanel.siege) do
    v:SetActive(false)
  end
  self.go_rankingMe:SetActive(false)
  if Activity_LuoLanSiegeData.myPersonalScoreRank then
    self.go_rankingMePre:SetActive(true)
    self.lab_noUnion:SetActive(false)
    self:UpdateMyPersonalRank(self.go_rankingMePre, Activity_LuoLanSiegeData.myPersonalScoreRank)
  else
    self.go_rankingMePre:SetActive(false)
    self.lab_noUnion:SetActive(true)
  end
  self.go_rankingMe:GetChild("img_badge"):SetActive(false)
end

function Activity_SiegefortTaskUI:UpdateMyPersonalRank(control, rankData)
  local lab_WarAllianceName = control:GetChild("lab_WarAllianceName")
  local lab_presonName = control:GetChild("lab_presonName")
  local lab_integral = control:GetChild("lab_integral")
  local lab_rank = control:GetChild("lab_rank")
  lab_rank:SetText(rankData.rank)
  lab_integral:SetText(string.format("\196\144i\225\187\131m: %s", rankData.score))
  lab_presonName:SetText(rankData.name)
  lab_WarAllianceName:SetText(rankData.unionName)
  self.MyRank_Text:SetText(rankData.rank)
  self.MyIntegral_Text:SetText(rankData.score)
end

function Activity_SiegefortTaskUI:UpdatePrivateScoreRankPanel(control, rankData)
  local lab_WarAllianceName = control:GetChild("lab_WarAllianceName")
  local lab_integral = control:GetChild("lab_integral")
  local lab_presonName = control:GetChild("lab_presonName")
  if rankData then
    control:SetActive(true)
    lab_presonName:SetText(rankData.name)
    lab_WarAllianceName:SetText(rankData.unionName)
    lab_integral:SetText(string.format("\196\144i\225\187\131m: %s", rankData.score))
  else
    control:SetActive(false)
  end
end

function Activity_SiegefortTaskUI:UpdateSiegeRank()
  for i, v in ipairs(self.rankTypeToPanel.siege) do
    self:UpdateMaxScoreRankPanel(v, Activity_LuoLanSiegeData.unionScoreRank[i])
  end
  for i, v in ipairs(self.rankTypeToPanel.private) do
    v:SetActive(false)
  end
  self.go_rankingMePre:SetActive(false)
  if Activity_LuoLanSiegeData.myUnionScoreRank then
    self.go_rankingMe:SetActive(true)
    self.lab_noUnion:SetActive(false)
    self:UpdateMyRank(self.go_rankingMe, Activity_LuoLanSiegeData.myUnionScoreRank)
  else
    self.go_rankingMe:SetActive(false)
    self.lab_noUnion:SetActive(true)
  end
end

function Activity_SiegefortTaskUI:UpdateMaxScoreRankPanel(control, rankData)
  local img_badge = control:GetChild("img_badge")
  local lab_WarAllianceName = control:GetChild("lab_WarAllianceName")
  local lab_integral = control:GetChild("lab_integral")
  local img_defense = control:GetChild("img_defense")
  local lab_defenseMe = control:GetChild("img_defense/lab_defenseMe")
  local lab_defenseNotMe = control:GetChild("img_defense/lab_defenseNotMe")
  if rankData then
    control:SetActive(true)
    lab_WarAllianceName:SetText(rankData.unionName)
    lab_integral:SetText(string.format("\196\144i\225\187\131m: %s", rankData.score))
    if rankData.unionId == Activity_LuoLanSiegeData.holdUnionId then
      local res = rankData.unionId == RoleManager.me.unionId
      lab_defenseMe:SetActive(res)
      lab_defenseNotMe:SetActive(not res)
    else
      img_defense:SetActive(false)
    end
    self:InitUnionLogo(rankData.unionId, img_badge)
  else
    control:SetActive(false)
  end
end

function Activity_SiegefortTaskUI:UpdateMyRank(control, rankData)
  local img_badge = control:GetChild("img_badge")
  local lab_WarAllianceName = control:GetChild("lab_WarAllianceName")
  local lab_integral = control:GetChild("lab_integral")
  local lab_rank = control:GetChild("lab_rank")
  local img_defense = control:GetChild("img_defense")
  local lab_defenseMe = control:GetChild("img_defense/lab_defenseMe")
  local lab_defenseNotMe = control:GetChild("img_defense/lab_defenseNotMe")
  lab_rank:SetText(rankData.rank)
  lab_integral:SetText(string.format("\196\144i\225\187\131m: %s", rankData.score))
  self.ZMRank_Text:SetText(rankData.rank)
  lab_WarAllianceName:SetText(rankData.unionName)
  if rankData.unionId == Activity_LuoLanSiegeData.holdUnionId then
    img_defense:SetActive(true)
    local res = rankData.unionId == RoleManager.me.unionId
    lab_defenseMe:SetActive(res)
    lab_defenseNotMe:SetActive(not res)
  else
    img_defense:SetActive(false)
  end
  self:InitUnionLogo(rankData.unionId, img_badge)
end

function Activity_SiegefortTaskUI:InitUnionLogo(unionId, img_badge)
  if not unionId or unionId == 0 then
    img_badge:SetActive(false)
    return
  else
    img_badge:SetActive(true)
  end
  local tex2D = WarAllianceUtility.GetUnionBadgeTex2D(unionId)
  if not tex2D then
    return
  end
  img_badge:SetTexture(tex2D)
end
