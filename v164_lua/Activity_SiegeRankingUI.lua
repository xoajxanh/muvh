Activity_SiegeRankingUI = class(BaseUI)
Activity_SiegeRankingUI.layer = UILayer.Panel
Activity_SiegeRankingUI.orderInLayer = 0
Activity_SiegeRankingUI.hideType = UIHideType.Hide
Activity_SiegeRankingUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_SiegeRankingUI.escClose = UIEscClose.DontClose

function Activity_SiegeRankingUI:InitControls()
  self.go_rankingOne = self:GetControl("Panel_Ranking/go_rankingOne")
  self.go_rankingTwo = self:GetControl("Panel_Ranking/go_rankingTwo")
  self.go_rankingThree = self:GetControl("Panel_Ranking/go_rankingThree")
  self.go_rankingMe = self:GetControl("Panel_Ranking/go_rankingMe")
  self.lab_noUnion = self:GetControl("Panel_Ranking/lab_noUnion")
  self.lab_time = self:GetControl("Panel_Ranking/lab_time")
end

function Activity_SiegeRankingUI:OnPreLoad()
end

function Activity_SiegeRankingUI:Init()
end

function Activity_SiegeRankingUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_SiegeRankingUI:InitUI()
  self.rankPanelList = {
    self.go_rankingOne,
    self.go_rankingTwo,
    self.go_rankingThree
  }
end

function Activity_SiegeRankingUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_SiegeRankingUI:OnHide()
  Timer.Stop(self.countdownTime)
  self.countdownTime = nil
end

function Activity_SiegeRankingUI:OnDestroy()
end

function Activity_SiegeRankingUI:RegistUIEvents()
end

function Activity_SiegeRankingUI:RegistEvents()
  self:RegistEvent(Event.EnterSiege, self.UpdateRank, self)
  self:RegistEvent(Event.Scene_SceneDataChange, self.HandleRankUIDisplay, self)
end

function Activity_SiegeRankingUI:HandleRankUIDisplay()
  if Activity_LuoLanSiegeData.IsActivityOpen() then
  else
    EventManager.Dispatch(Event.QuitSiege)
  end
end

function Activity_SiegeRankingUI:Refresh()
  Activity_LuoLanSiegeData.RefreshOpenTime()
  self:StartCountdownTime()
  self:UpdateRank()
end

function Activity_SiegeRankingUI:StartCountdownTime()
  local function CountdownTime()
    local intervalTime = Activity_LuoLanSiegeData.endLimitTimeUnix - Time.GetServerSecondTime()
    
    self.lab_time:SetText(string.format("%s sau k\225\186\191t th\195\186c", TimeUtility.ShowTime(intervalTime)))
    if intervalTime == 0 then
      Timer.Stop(self.countdownTime)
    end
  end
  
  if self.countdownTime then
    Timer.Stop(self.countdownTime)
    self.countdownTime = nil
  end
  self.countdownTime = Timer.StartLoopForever(1, CountdownTime)
  local intervalTime = Activity_LuoLanSiegeData.endLimitTimeUnix - Time.GetServerSecondTime()
  self.lab_time:SetText(string.format("%s sau k\225\186\191t th\195\186c", TimeUtility.ShowTime(intervalTime)))
end

function Activity_SiegeRankingUI:UpdateRank()
  for i, v in ipairs(self.rankPanelList) do
    self:UpdateMaxScoreRankPanel(v, Activity_LuoLanSiegeData.unionScoreRank[i])
  end
  if Activity_LuoLanSiegeData.myUnionScoreRank then
    self.go_rankingMe:SetActive(true)
    self.lab_noUnion:SetActive(false)
    self:UpdateMyRank(self.go_rankingMe, Activity_LuoLanSiegeData.myUnionScoreRank)
  else
    self.go_rankingMe:SetActive(false)
    self.lab_noUnion:SetActive(true)
  end
end

function Activity_SiegeRankingUI:UpdateMaxScoreRankPanel(control, rankData)
  local img_rank = control:GetChild("img_rank")
  local img_badge = control:GetChild("img_badge")
  local lab_WarAllianceName = control:GetChild("lab_WarAllianceName")
  local lab_integral = control:GetChild("lab_integral")
  if rankData then
    lab_WarAllianceName:SetText(rankData.unionName)
    lab_integral:SetText(string.format("\196\144i\225\187\131m: %s", rankData.score))
    self:InitUnionLogo(rankData.logo, img_badge)
    img_rank:SetActive(true)
    img_badge:SetActive(true)
    lab_WarAllianceName:SetActive(true)
    lab_integral:SetActive(true)
  else
    img_rank:SetActive(false)
    img_badge:SetActive(false)
    lab_WarAllianceName:SetActive(false)
    lab_integral:SetActive(false)
  end
end

function Activity_SiegeRankingUI:UpdateMyRank(control, rankData)
  local img_badge = control:GetChild("img_badge")
  local lab_WarAllianceName = control:GetChild("lab_WarAllianceName")
  local lab_integral = control:GetChild("lab_integral")
  local lab_rank = control:GetChild("lab_rank")
  lab_rank:SetText(rankData.rank)
  lab_integral:SetText(string.format("\196\144i\225\187\131m: %s", rankData.score))
  lab_WarAllianceName:SetText(rankData.unionName)
  self:InitUnionLogo(rankData.logo, img_badge)
end

function Activity_SiegeRankingUI:InitUnionLogo(logo, img_badge)
  local armbandColorData = {}
  local num = WarAllianceData.ArmbandsDesignGridNum
  for i = 1, num do
    table.insert(armbandColorData, logo[i])
  end
  local texture = Texture2D(8, 8)
  local index = 0
  for i = 1, 8 do
    for j = 1, 8 do
      index = index + 1
      local logoNum = ColorUtility.ColorToColor32(armbandColorData[index])
      texture:SetPixel(i - 1, j - 1, logoNum)
    end
  end
  texture:Apply()
  texture.filterMode = FilterMode.Point
  img_badge:SetTexture(texture)
end
