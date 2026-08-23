local WorldCupGuessTemplate = {}

function WorldCupGuessTemplate:Init(rootUI)
  self:InitControls(rootUI)
  self:InitData()
  self:BindUIEvent()
  self:InitContainer()
end

function WorldCupGuessTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.List_WorldCup = self:GetControl("WorldCupPanel/sw_WorldCup/Viewport/Content/List_WorldCup")
  self.QuizScorePanel = self:GetControl("QuizScorePanel")
  self.bg_blackbox = self:GetControl("QuizScorePanel/bg_blackbox")
  self.btn_close = self:GetControl("QuizScorePanel/img_bg/btn_close")
  self.leftTeam = self:GetControl("QuizScorePanel/ResultChoose/leftTeam")
  self.rightTeam = self:GetControl("QuizScorePanel/ResultChoose/rightTeam")
  self.centerTeam = self:GetControl("QuizScorePanel/ResultChoose/centerTeam")
  self.btn_ok = self:GetControl("QuizScorePanel/ResultChoose/btn_ok")
  self.txt_lastTimeGift = self:GetControl("txt_lastTimeGift")
  self.txt_lastTimeGift:SetActive(true)
end

function WorldCupGuessTemplate:InitContainer()
  self.List_WorldCupContainer = UIUtility.BindUIContainerTemp(self.List_WorldCup, LuaComponentTemplates.WorldCupRaceTemplate, self.rootUI)
end

function WorldCupGuessTemplate:InitData()
  self.teamCtrList = {
    [WorldCupGuessResultType.Win] = self.leftTeam,
    [WorldCupGuessResultType.Lose] = self.rightTeam,
    [WorldCupGuessResultType.Draw] = self.centerTeam
  }
  for type, ctr in pairs(self.teamCtrList) do
    ctr.resultType = type
    if type ~= WorldCupGuessResultType.Draw then
      ctr.flag = ctr:GetChild("img_flag")
      ctr.name = ctr:GetChild("lab_name")
    end
    ctr.choose = ctr:GetChild("img_choose")
  end
  self.curChoose = WorldCupGuessResultType.Win
end

function WorldCupGuessTemplate:BindUIEvent()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.bg_blackbox:SetOnClick(self, self.btn_closeOnClick)
  for i, ctr in pairs(self.teamCtrList) do
    ctr:SetOnClick(self, self.ChooseResultOnClick)
  end
  self.btn_ok:SetOnClick(self, self.btn_okOnClick)
end

function WorldCupGuessTemplate:btn_closeOnClick()
  self.curChoose = WorldCupGuessResultType.Win
  self.QuizScorePanel:SetActive(false)
end

function WorldCupGuessTemplate:ChooseResultOnClick(control)
  if self.curChoose == control.resultType then
    return
  end
  self.curChoose = control.resultType
  for type, ctr in pairs(self.teamCtrList) do
    ctr.choose:SetActive(self.curChoose == type)
  end
end

function WorldCupGuessTemplate:btn_okOnClick()
  local id = self:GetWorldCupGuessMgr():GetCurId()
  NetManager.Send(CommerceMessage.ReqWorldCupGuessing, {
    id = id,
    choice = self.curChoose
  })
  self:btn_closeOnClick()
end

function WorldCupGuessTemplate:Refresh()
  local singleRaceInfoList = self:GetWorldCupGuessMgr():GetSingleRaceInfoList()
  self.List_WorldCupContainer:SetData(singleRaceInfoList)
  self:RefreshTime()
end

function WorldCupGuessTemplate:OnWorldCupGuessPanelOpen(_, teamsInfo)
  self.QuizScorePanel:SetActive(true)
  for i, teamInfo in ipairs(teamsInfo) do
    self.rootUI:SetSprite("Atlas_Common", teamInfo.flagSpriteName, self.teamCtrList[i].flag)
    self.teamCtrList[i].name:SetText(teamInfo.countryName)
  end
  for type, ctr in pairs(self.teamCtrList) do
    ctr.choose:SetActive(self.curChoose == type)
  end
end

function WorldCupGuessTemplate:RefreshTime()
  if self.RemainTimeLoop ~= nil then
    Timer.Stop(self.RemainTimeLoop)
  end
  self.RemainTimeLoop = Timer.StartLoopForever(1, function()
    self.txt_lastTimeGift:SetText(QuickFind:GetWorldCupGuessData():GetRemainTimeDes())
  end)
end

function WorldCupGuessTemplate:Exit()
  self:btn_closeOnClick()
  self:DestroyTime()
  self:ReleaseModel()
  self.List_WorldCupContainer:SetData({})
end

function WorldCupGuessTemplate:DestroyTime()
  Timer.Stop(self.RemainTimeLoop)
  self.RemainTimeLoop = nil
end

function WorldCupGuessTemplate:ReleaseModel()
  local itemTemp
  for i, v in ipairs(self.List_WorldCupContainer.items) do
    itemTemp = v.itemTemp
    itemTemp:Exit()
  end
end

function WorldCupGuessTemplate:GetWorldCupGuessMgr()
  return QuickFind:GetWorldCupGuessData()
end

return WorldCupGuessTemplate
