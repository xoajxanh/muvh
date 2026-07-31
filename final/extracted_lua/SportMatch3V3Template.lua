local SportMatch3V3Template = {}

function SportMatch3V3Template:Init(data)
  self.root = data.root
  self.parent = data.parent
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
  self:BindEvent()
  self.starsList = {
    [1] = self.imgStar1,
    [2] = self.imgStar2,
    [3] = self.imgStar3,
    [4] = self.imgStar4,
    [5] = self.imgStar5
  }
end

function SportMatch3V3Template:InitControls()
  self.bg1 = self:GetControl("Bg/bg1")
  self.levelBg = self:GetControl("SegLevel/levelBg")
  self.imgLevelCount = self:GetControl("SegLevel/levelBg/imgLevelCount")
  self.stageEff = self:GetControl("SegLevel/stageEff")
  self.stars = self:GetControl("SegLevel/levelBg/stars")
  self.imgStar1 = self:GetControl("SegLevel/levelBg/stars/starBg1/imgStar1")
  self.imgStar2 = self:GetControl("SegLevel/levelBg/stars/starBg2/imgStar2")
  self.imgStar3 = self:GetControl("SegLevel/levelBg/stars/starBg3/imgStar3")
  self.imgStar4 = self:GetControl("SegLevel/levelBg/stars/starBg4/imgStar4")
  self.imgStar5 = self:GetControl("SegLevel/levelBg/stars/starBg5/imgStar5")
  self.progressCount = self:GetControl("SegLevel/progressBg/progressCount")
  self.ImgtitleName = self:GetControl("SegLevel/titleBg/ImgtitleName")
  self.imgSingle = self:GetControl("matchingPerson/singlePeople/singleBtn/imgSingle")
  self.singleBtn = self:GetControl("matchingPerson/singlePeople/singleBtn")
  self.matchTimeSolo = self:GetControl("matchingPerson/matchTimeSolo")
  self.imgSelect = self:GetControl("matchingPerson/singlePeople/singleBtn/imgSelect")
  self.matchTimeSolo = self:GetControl("matchingPerson/matchTimeSolo")
  self.lab_matchTimeSolo = self:GetControl("matchingPerson/matchTimeSolo/lab_matchTimeSolo")
  self.manyPeople = self:GetControl("matchingPerson/manyPeople")
  self.manyBtn = self:GetControl("matchingPerson/manyPeople/manyBtn")
  self.activityCount = self:GetControl("matchingPerson/activityCount")
  self.addCount = self:GetControl("matchingPerson/activityCount/addCount")
  self.times = self:GetControl("matchingPerson/activityTime/times")
  self.descBtn1 = self:GetControl("descBtn1")
  self.winPointDesc = self:GetControl("winPoint/winPointDescMask/winPointDesc")
  self.winDescCont = self:GetControl("winPoint/winPointDescMask/winPointDesc/winDesc/winDescCont")
  self.siteDescCont = self:GetControl("winPoint/winPointDescMask/winPointDesc/siteDesc/siteDescCont")
  self.pointDescCont = self:GetControl("winPoint/winPointDescMask/winPointDesc/pointDesc/pointDescCont")
  self.btn_winPoint = self:GetControl("winPoint/btn_winPoint")
  self.imgArrow = self:GetControl("winPoint/imgArrow")
  self.rewardRank = self:GetControl("rewardRank")
end

function SportMatch3V3Template:InitUI()
  self.rewardRankTemplate = luaTemplateManager.GetNewTemplate(self.rewardRank, LuaComponentTemplates.RewardRankTemplate, self.root)
end

function SportMatch3V3Template:BindUIEvent()
  self.singleBtn:SetOnClick(self, self.singleBtnOnClick)
  self.manyBtn:SetOnClick(self, self.manyBtnOnClick)
  self.descBtn1:SetOnClick(self, self.descBtn1OnClick)
  self.btn_winPoint:SetOnClick(self, self.btn_winPointOnClick)
end

function SportMatch3V3Template:BindEvent()
  self.eventContainer = EventContainer(EventManager)
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

function SportMatch3V3Template:singleBtnOnClick()
  local activityOverviewConfig = ClientTable.cfg_Activity_overviewManager:TryGetValue(5001)
  if activityOverviewConfig ~= nil then
    local condition = activityOverviewConfig.condition
    if not ConditionManager.Check4D(condition) then
      FloatingTipUtility.QuickMsg("S\225\187\177 ki\225\187\135n ch\198\176a m\225\187\159")
      return
    end
  end
  if SceneData.IsCrossRealm() or TranScriptData.InTranscript then
    FloatingTipUtility.QuickMsg("C\225\186\165m tham gia khi \196\145ang \225\187\159 b\225\186\163n \196\145\225\187\147 ho\225\186\183c PB Li\195\170n SV")
    return
  end
  if QuickFind:GetThreeVsThreeDataMgr():GetMatchState() == 1 then
    networkRequest.ReqCancelMatchThreeVThree(1)
    QuickFind:GetThreeVsThreeDataMgr():SetMatchPeopleType(0)
  elseif QuickFind:GetThreeVsThreeDataMgr():GetHangUpPunishState() then
    TipUtility.QuickShowPrompt({
      id = PromptWordType.HangUpPunish,
      cancelAction = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      okAction = okAction,
      showTimeType = PromptWordTimeType.HangUpPunish
    })
  else
    networkRequest.ReqStartMatchThreeVThree(1)
    QuickFind:GetThreeVsThreeDataMgr():SetMatchPeopleType(1)
  end
end

function SportMatch3V3Template:manyBtnOnClick()
  local activityOverviewConfig = ClientTable.cfg_Activity_overviewManager:TryGetValue(5001)
  if activityOverviewConfig ~= nil then
    local condition = activityOverviewConfig.condition
    if not ConditionManager.Check4D(condition) then
      FloatingTipUtility.QuickMsg("S\225\187\177 ki\225\187\135n ch\198\176a m\225\187\159")
      return
    end
  end
  if SceneData.IsCrossRealm() or TranScriptData.InTranscript then
    FloatingTipUtility.QuickMsg("C\225\186\165m tham gia khi \196\145ang \225\187\159 b\225\186\163n \196\145\225\187\147 ho\225\186\183c PB Li\195\170n SV")
    return
  end
  if QuickFind:GetThreeVsThreeDataMgr():GetMatchState() == 1 then
    FloatingTipUtility.QuickMsg("\196\144ang gh\195\169p tr\225\186\173n kh\195\180ng th\225\187\131 th\225\187\177c hi\225\187\135n thao t\195\161c n\195\160y, h\195\163y h\225\187\167y Gh\195\169p Tr\225\186\173n tr\198\176\225\187\155c")
    return
  elseif QuickFind:GetThreeVsThreeDataMgr():GetHangUpPunishState() then
    TipUtility.QuickShowPrompt({
      id = PromptWordType.HangUpPunish,
      cancelAction = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      okAction = okAction,
      showTimeType = PromptWordTimeType.HangUpPunish
    })
    return
  end
  self:UIControl():SetActive(false)
  self.parent.SportTeam3V3:SetActive(true)
  self.parent.sportTeam3V3Template:Refresh()
end

function SportMatch3V3Template:descBtn1OnClick()
end

function SportMatch3V3Template:btn_winPointOnClick()
  if self.imgArrow:GetLocalEulerAnglesZ() == 0 then
    self.imgArrow:SetLocalEulerAnglesZ(180)
    self.winPointDesc:SetAnchoredPosition(140, 0)
  else
    self.imgArrow:SetLocalEulerAnglesZ(0)
    self.winPointDesc:SetAnchoredPosition(-143, 0)
  end
end

function SportMatch3V3Template:Refresh()
  self:RefreshStageLevelInfo()
  self:RefreshSurplusPvpCountAndTimeInfo()
  self:RefreshSeasonScoreInfo()
  if QuickFind:GetThreeVsThreeDataMgr():GetMatchState() == 1 then
    self:RefreshSingleBtnView(1)
  else
    self:RefreshSingleBtnView(0)
  end
  self.rewardRankTemplate:Refresh()
end

function SportMatch3V3Template:RefreshStageLevelInfo()
  local cfgData = QuickFind:GetThreeVsThreeDataMgr():GetCfgData()
  if cfgData and not string.isNullOrEmpty(cfgData.stageBg) then
    self.root:SetSprite("Atlas_Main", cfgData.stageBg, self.bg1)
  end
  if cfgData and not string.isNullOrEmpty(cfgData.stageNameBg) then
    self.root:SetSprite("Atlas_Main", cfgData.stageNameBg, self.levelBg)
    self.levelBg:SetActive(true)
  else
    self.levelBg:SetActive(false)
  end
  if cfgData and not string.isNullOrEmpty(cfgData.stageLevelName) then
    self.root:SetSprite("Atlas_Language", cfgData.stageLevelName, self.imgLevelCount)
    self.imgLevelCount:SetActive(true)
  else
    self.imgLevelCount:SetActive(false)
  end
  local starNum = cfgData and tonumber(cfgData.stageStarsNum) or 0
  for i, star in ipairs(self.starsList) do
    star:SetActive(i <= starNum)
  end
  self.progressCount:SetText(string.format("%d/%d", QuickFind:GetThreeVsThreeDataMgr():GetScore(), cfgData and cfgData.levelPoints or 10))
  if cfgData and not string.isNullOrEmpty(cfgData.stageName) then
    self.root:SetSprite("Atlas_Language", cfgData.stageName, self.ImgtitleName)
    self.ImgtitleName:SetActive(true)
  else
    self.ImgtitleName:SetActive(false)
  end
  if self.eff then
    self.eff:Destroy()
    self.eff = nil
  end
  self.stageEff:SetActive(false)
  if cfgData and not string.isNullOrEmpty(cfgData.stageEff) then
    self.eff = UIEffectUtility.SetUIEffect(cfgData.stageEff, self.stageEff, false)
    UIEffectUtility:EffectOrderLayerSet(self.root, self.stageEff)
    self.stageEff:SetActive(true)
  end
end

function SportMatch3V3Template:RefreshSurplusPvpCountAndTimeInfo()
  local surplusPvpCount = QuickFind:GetThreeVsThreeDataMgr():GetPvpCount()
  local colorCount = string.GetColorText(surplusPvpCount, surplusPvpCount <= 0 and ItemQuality2ColorDic[EItemColorEnum.red] or ItemQuality2ColorDic[EItemColorEnum.green])
  self.activityCount:SetText(string.format("L\198\176\225\187\163t x\225\186\191p h\225\186\161ng c\195\178n l\225\186\161i: %s l\225\186\167n", colorCount))
  local cfg = ClientTable.cfg_Activity_overviewManager:TryGetValue(5001, "activityId")
  local showTime = cfg and cfg.showTime or ""
  self.times:SetText(showTime)
end

function SportMatch3V3Template:RefreshSeasonScoreInfo()
  self.winDescCont:SetText(QuickFind:GetThreeVsThreeDataMgr():GetVictorySum())
  self.siteDescCont:SetText(QuickFind:GetThreeVsThreeDataMgr():GetJoinSum())
  self.pointDescCont:SetText(string.format("%d%%", QuickFind:GetThreeVsThreeDataMgr():GetVictoryRate()))
end

function SportMatch3V3Template:RefreshSingleBtnView(state)
  if state == 0 then
    self.imgSingle:SetActive(true)
    self.imgSelect:SetActive(false)
    self.matchTimeSolo:SetActive(false)
    self:RefreshMatchTime(false)
  elseif state == 1 then
    self.imgSingle:SetActive(false)
    self.imgSelect:SetActive(true)
    self.matchTimeSolo:SetActive(true)
    self:RefreshMatchTime(true)
  end
end

function SportMatch3V3Template:RefreshMatchTime(isMatchState)
  if self.mathchTimeLoop then
    Timer.Stop(self.mathchTimeLoop)
    self.mathchTimeLoop = nil
  end
  if isMatchState then
    local matchTime = Mathf.Floor((Time.GetServerTime() - QuickFind:GetThreeVsThreeDataMgr():GetJoinMatchTime()) * 0.001)
    self.lab_matchTimeSolo:SetText(string.format("%s gi\195\162y", matchTime))
    self.mathchTimeLoop = Timer.StartLoopForever(0.3, function()
      local matchTime = Mathf.Floor((Time.GetServerTime() - QuickFind:GetThreeVsThreeDataMgr():GetJoinMatchTime()) * 0.001)
      self.lab_matchTimeSolo:SetText(string.format("%s gi\195\162y", matchTime))
    end)
  else
    local matchTime = 0
    self.lab_matchTimeSolo:SetText(string.format("%s gi\195\162y", matchTime))
  end
end

function SportMatch3V3Template:MatchingCallBack()
  self:RefreshSingleBtnView(1)
end

function SportMatch3V3Template:CancleMatchSuccessCallBack()
  self:RefreshSingleBtnView(0)
end

function SportMatch3V3Template:OnDisable()
  self.imgArrow:SetLocalEulerAnglesZ(0)
  self.winPointDesc:SetAnchoredPosition(-143, 0)
  if self.mathchTimeLoop then
    Timer.Stop(self.mathchTimeLoop)
    self.mathchTimeLoop = nil
  end
  if self.eff then
    self.eff:Destroy()
    self.eff = nil
  end
end

function SportMatch3V3Template:OnHide()
end

return SportMatch3V3Template
