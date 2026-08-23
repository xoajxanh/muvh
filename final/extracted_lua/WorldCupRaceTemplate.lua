local WorldCupRaceTemplate = {}

function WorldCupRaceTemplate:Init(rootUI)
  self:InitControls(rootUI)
  self:InitData()
  self:BindUIEvent()
  self:InitContainer()
end

function WorldCupRaceTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.img_bg_start = self:GetControl("img_time/img_bg_start")
  self.img_bg_over = self:GetControl("img_time/img_bg_over")
  self.leftTeam = self:GetControl("img_info/leftTeam")
  self.leftScore = self:GetControl("img_info/leftScore")
  self.rightTeam = self:GetControl("img_info/rightTeam")
  self.rightScore = self:GetControl("img_info/rightScore")
  self.lb_results = self:GetControl("img_info/lb_results")
  self.btn_ItemTask = self:GetControl("img_info/btn_ItemTask")
  self.UnQuiz = self:GetControl("img_info/go_state/UnQuiz")
  self.lab_myQuiz = self:GetControl("img_info/go_state/lab_myQuiz")
  self.btn_goQuiz = self:GetControl("img_info/go_state/btn_goQuiz")
  self.btn_get = self:GetControl("img_info/go_state/btn_get")
  self.Eff_UI_annuikuang03 = self:GetControl("img_info/go_state/btn_get/Eff_UI_annuikuang03")
  self.Item_alreadyGet = self:GetControl("img_info/go_state/Item_alreadyGet")
end

function WorldCupRaceTemplate:InitContainer()
end

function WorldCupRaceTemplate:InitData()
  local scoreCtrList = {}
  table.insert(scoreCtrList, self.leftScore)
  table.insert(scoreCtrList, self.rightScore)
  self.scoreGroupList = {}
  for i, ctr in ipairs(scoreCtrList) do
    local scoreGroup = {}
    for resultType, index in pairs(WorldCupGuessResultType) do
      if index ~= 0 then
        local scoreCtr = ctr:GetChild(resultType)
        scoreGroup[index] = scoreCtr
      end
    end
    table.insert(self.scoreGroupList, scoreGroup)
  end
  local teamCtrList = {}
  table.insert(teamCtrList, self.leftTeam)
  table.insert(teamCtrList, self.rightTeam)
  self.teamGroupList = {}
  for i, ctr in ipairs(teamCtrList) do
    local teamGroup = {}
    teamGroup.flag = ctr:GetChild("img_flag")
    teamGroup.name = ctr:GetChild("img_name/lab_name")
    table.insert(self.teamGroupList, teamGroup)
  end
  self.ctrList = {}
  table.insert(self.ctrList, self.UnQuiz)
  table.insert(self.ctrList, self.lab_myQuiz)
  table.insert(self.ctrList, self.btn_goQuiz)
  table.insert(self.ctrList, self.btn_get)
  table.insert(self.ctrList, self.Item_alreadyGet)
  self.resultStrList = {
    [WorldCupGuessResultType.None] = "",
    [WorldCupGuessResultType.Win] = string.GetColorText("Phe \196\144\225\187\143 th\225\186\175ng", ItemQuality2ColorDic[7]),
    [WorldCupGuessResultType.Lose] = string.GetColorText("Phe Xanh th\225\186\175ng", ItemQuality2ColorDic[1]),
    [WorldCupGuessResultType.Draw] = string.GetColorText("H\195\178a", ItemQuality2ColorDic[5])
  }
end

function WorldCupRaceTemplate:BindUIEvent()
  self.btn_goQuiz:SetOnClick(self, self.btn_goQuizOnClick)
  self.btn_get:SetOnClick(self, self.btn_getOnClick)
end

function WorldCupRaceTemplate:btn_goQuizOnClick()
  QuickFind:GetWorldCupGuessData():SetCurId(self.data.id)
  EventManager.Dispatch(Event.WorldCupGuessPanelOpen, self.data.teamsInfo)
end

function WorldCupRaceTemplate:btn_getOnClick()
  if not self.data.giftInfo.isClick then
    QuickFind:GetWorldCupGuessData():SetIsClickById(self.data.id)
  end
  local isGuessSuccess = QuickFind:GetWorldCupGuessData():IsGuessSuccess(self.data)
  if isGuessSuccess then
    NetManager.Send(CommerceMessage.ReqWorldCupGuessingReceiveReward, {
      id = self.data.id
    })
  else
    UIManager.Show(UIID.Tip_WorldCupBuyGiftTipUI, {
      singleRaceInfo = self.data
    })
  end
end

function WorldCupRaceTemplate:Refresh(data, ui)
  self.data = data
  self:RefreshTime(data)
  self:RefreshTeam(data, ui)
  self:RefreshGift(data, ui)
  self:RefreshGuess(data)
end

function WorldCupRaceTemplate:RefreshTime(data)
  local text = ""
  text = "Th\225\187\157i gian cu\225\187\153c thi: %s"
  text = string.format(text, data.raceTime)
  self.img_bg_start:SetText(text)
  text = "H\225\186\161n ng\225\187\171ng D\225\187\177 \196\144o\195\161n: %s"
  text = string.format(text, data.guessEndTime)
  self.img_bg_over:SetText(text)
end

function WorldCupRaceTemplate:RefreshTeam(data, ui)
  for i, teamInfo in ipairs(data.teamsInfo) do
    local text = string.GetColorText("Phe \196\144\225\187\143: ", ItemQuality2ColorDic[7])
    if i == 2 then
      text = string.GetColorText("Phe Xanh: ", ItemQuality2ColorDic[1])
    end
    self.teamGroupList[i].name:SetText(text .. teamInfo.countryName)
    ui:SetSprite("Atlas_Common", teamInfo.flagSpriteName, self.teamGroupList[i].flag)
    for type, scoreCtr in ipairs(self.scoreGroupList[i]) do
      if type == teamInfo.result then
        scoreCtr:SetActive(true)
        scoreCtr:SetText(tostring(teamInfo.score))
      else
        scoreCtr:SetActive(false)
      end
    end
  end
  local text = self.resultStrList[data.raceResult]
  self.lb_results:SetText(text)
end

function WorldCupRaceTemplate:RefreshGift(data, ui)
  self.btn_ItemTask.itemCellData = self.btn_ItemTask.itemCellData or ItemCellData()
  local itemInfo = ItemUtility.GenerateItemData(data.giftInfo.rewardItemId)
  itemInfo.count = data.giftInfo.rewardCount
  self.btn_ItemTask.itemCellData:RefreshData(itemInfo)
  ItemUtility.ShowItemCell(self.btn_ItemTask, self.btn_ItemTask.itemCellData, ui, true)
end

function WorldCupRaceTemplate:RefreshGuess(data)
  for i, ctr in ipairs(self.ctrList) do
    ctr:SetActive(false)
  end
  if data.timeState == WorldCupGuessTimeState.Guess then
    if data.guessResult == WorldCupGuessResultType.None then
      self.btn_goQuiz:SetActive(true)
    else
      self.lab_myQuiz:SetActive(true)
      local text = string.format("D\225\187\177 \196\144o\195\161n c\225\187\167a t\195\180i: %s", self.resultStrList[data.guessResult])
      self.lab_myQuiz:SetText(text)
    end
  elseif data.timeState == WorldCupGuessTimeState.Wait then
    if data.guessResult == WorldCupGuessResultType.None then
      self.UnQuiz:SetActive(true)
    else
      self.lab_myQuiz:SetActive(true)
      local text = string.format("D\225\187\177 \196\144o\195\161n c\225\187\167a t\195\180i: %s", self.resultStrList[data.guessResult])
      self.lab_myQuiz:SetText(text)
    end
  elseif data.timeState == WorldCupGuessTimeState.Announce then
    if data.guessResult == WorldCupGuessResultType.None then
      self.UnQuiz:SetActive(true)
    elseif data.giftInfo.state == GuardRewardStateEnum.CanGet then
      self.lab_myQuiz:SetActive(true)
      local text = string.format("D\225\187\177 \196\144o\195\161n c\225\187\167a t\195\180i: %s", self.resultStrList[data.guessResult])
      self.lab_myQuiz:SetText(text)
      self.btn_get:SetActive(true)
      if data.giftInfo.isClick then
        self.Eff_UI_annuikuang03:SetActive(false)
      else
        self.Eff_UI_annuikuang03:SetActive(true)
      end
    elseif data.giftInfo.state == GuardRewardStateEnum.Got then
      self.Item_alreadyGet:SetActive(true)
    end
  end
end

function WorldCupRaceTemplate:Exit()
  self:ReleaseModel()
end

function WorldCupRaceTemplate:ReleaseModel()
  ItemUtility.ReleaseItemCell(self.btn_ItemTask, self.btn_ItemTask.itemCellData)
end

return WorldCupRaceTemplate
