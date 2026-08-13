Activity_SiFangUI = class(BaseUI)
Activity_SiFangUI.layer = UILayer.Panel
Activity_SiFangUI.orderInLayer = 0
Activity_SiFangUI.hideType = UIHideType.WaitDestroy
Activity_SiFangUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_SiFangUI.escClose = UIEscClose.DontClose

function Activity_SiFangUI:InitControls()
  self.tog_TaskPanel = self:GetControl("TaskRankBar/tog_TaskPanel")
  self.tog_RankPanel = self:GetControl("TaskRankBar/tog_RankPanel")
  self.TaskPanel = self:GetControl("TaskPanel")
  self.lab_Countdown = self:GetControl("TaskPanel/lab_Countdown")
  self.lab_CampRank = self:GetControl("TaskPanel/lab_CampRank")
  self.lab_MyRank = self:GetControl("TaskPanel/lab_MyRank")
  self.lab_MyIntegralRank = self:GetControl("TaskPanel/lab_MyIntegralRank")
  self.btn_Desc = self:GetControl("TaskPanel/btn_Desc")
  self.RankPanel = self:GetControl("RankPanel")
  self.tog_PersonRank = self:GetControl("RankPanel/tog_PersonRank")
  self.tog_CampRank = self:GetControl("RankPanel/tog_CampRank")
  self.scrollViewPerson = self:GetControl("RankPanel/scrollViewPerson")
  self.item_PersonRank = self:GetControl("RankPanel/scrollViewPerson/viewport/content/item_PersonRank")
  self.lab_ItemPersonRank = self:GetControl("RankPanel/scrollViewPerson/viewport/content/item_PersonRank/lab_ItemPersonRank")
  self.lab_MyPersonRank = self:GetControl("RankPanel/scrollViewPerson/MePersonRank/lab_MyPersonRank")
  self.lab_MyPersonName = self:GetControl("RankPanel/scrollViewPerson/MePersonRank/lab_MyPersonName")
  self.lab_MyPersonIntegral = self:GetControl("RankPanel/scrollViewPerson/MePersonRank/lab_MyPersonIntegral")
  self.scrollViewCamp = self:GetControl("RankPanel/scrollViewCamp")
  self.item_CampRank = self:GetControl("RankPanel/scrollViewCamp/viewport/content/item_CampRank")
  self.lab_ItemCampRank = self:GetControl("RankPanel/scrollViewCamp/viewport/content/item_CampRank/lab_ItemCampRank")
  self.lab_MyCampRank = self:GetControl("RankPanel/scrollViewCamp/meCampRank/lab_MyCampRank")
  self.img_MyCampBadge = self:GetControl("RankPanel/scrollViewCamp/meCampRank/img_MyCampBadge")
  self.lab_MyCampName = self:GetControl("RankPanel/scrollViewCamp/meCampRank/lab_MyCampName")
  self.lab_MyCampIntegral = self:GetControl("RankPanel/scrollViewCamp/meCampRank/lab_MyCampIntegral")
  self.ProgressPanel = self:GetControl("ProgressPanel")
  self.progress_1 = self:GetControl("ProgressPanel/Progress_1")
  self.progress_2 = self:GetControl("ProgressPanel/Progress_2")
  self.progress_3 = self:GetControl("ProgressPanel/Progress_3")
  self.progress_4 = self:GetControl("ProgressPanel/Progress_4")
  self.btn_AllRank = self:GetControl("btn_AllRank")
  self.btn_Exit = self:GetControl("btn_Exit")
  self.lab_Time = self:GetControl("btn_Exit/lab_Time")
  self.taskDescription = self:GetControl("TaskPanel/taskDescription")
  self.siegeTarget_lab = self:GetControl("TaskPanel/taskDescription/taskStage/bg/siegeTarget_lab")
  self.lab_target = self:GetControl("TaskPanel/taskDescription/taskTarget/bg/lab_target")
  self.lab_Target = self:GetControl("TaskPanel/taskDescription/taskTarget/lab_Target")
  self.btn_GoTo = self:GetControl("TaskPanel/taskDescription/taskStage/btn_GoTo/button_Image")
  self.img_bg_taskDes = self:GetControl("TaskPanel/bg/img_bg_taskDes")
end

function Activity_SiFangUI:Init()
end

function Activity_SiFangUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function PersonRankItemCreate(_control)
  _control.lab_ItemPersonRank = UIControl(_control.transform, "lab_ItemPersonRank")
  _control.img_RankIcon = UIControl(_control.transform, "img_RankIcon")
  _control.lab_PersonName = UIControl(_control.transform, "lab_PersonName")
  _control.lab_Integral = UIControl(_control.transform, "lab_Integral")
end

local function PersonRankItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  _control:SetActive(true)
  local isShowRankIcon = _data.rank <= 3
  _control.lab_ItemPersonRank:SetText(_data.rank)
  _control.lab_ItemPersonRank:SetActive(not isShowRankIcon)
  _control.img_RankIcon:SetActive(isShowRankIcon)
  if isShowRankIcon then
    _ui:SetSprite("Atlas_Main", "ico_" .. _data.rank, _control.img_RankIcon, true)
  end
  _control.lab_PersonName:SetText(_data.name)
  _control.lab_Integral:SetText(string.format(_ui.rankText, _data.score))
end

local function CampRankItemCreate(_control)
  _control.lab_ItemCampRank = UIControl(_control.transform, "lab_ItemCampRank")
  _control.img_RankIcon = UIControl(_control.transform, "img_RankIcon")
  _control.img_Badge = UIControl(_control.transform, "img_Badge")
  _control.lab_CampName = UIControl(_control.transform, "lab_CampName")
  _control.lab_Integral = UIControl(_control.transform, "lab_Integral")
end

local function CampRankItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  _control:SetActive(true)
  local isShowRankIcon = _data.rank <= 3
  _control.lab_ItemCampRank:SetText(_data.rank)
  _control.lab_ItemCampRank:SetActive(not isShowRankIcon)
  _control.img_RankIcon:SetActive(isShowRankIcon)
  if isShowRankIcon then
    _ui:SetSprite("Atlas_Main", "ico_" .. _data.rank, _control.img_RankIcon, true)
  end
  if _data.campId > 0 then
    local campData = ClientTable.cfg_Activity_sifangCampManager:TryGetValue(_data.campId)
    _ui:SetSprite("Atlas_Common", campData.campImage, _control.img_Badge, true)
    _control.lab_CampName:SetText(campData.unionName)
  end
  _control.lab_Integral:SetText(string.format(_ui.rankText, _data.score))
end

function Activity_SiFangUI:InitUI()
  self.personRankContainer = UIContainer(self.item_PersonRank, self, PersonRankItemCreate, PersonRankItemRefresh)
  self.campRankContainer = UIContainer(self.item_CampRank, self, CampRankItemCreate, CampRankItemRefresh)
  self.progressTab = {
    [1] = self.progress_1,
    [2] = self.progress_2,
    [3] = self.progress_3,
    [4] = self.progress_4
  }
  self.rankText = ClientTable.cfg_Activity_globalManager:TryGetValue(500566).effect or ""
end

function Activity_SiFangUI:RegistUIEvents()
  self.tog_TaskPanel:SetOnToggleChanged(self, self.tog_TaskRankPanelOnToggleChanged)
  self.tog_RankPanel:SetOnToggleChanged(self, self.tog_TaskRankPanelOnToggleChanged)
  self.tog_PersonRank:SetOnToggleChanged(self, self.tog_PersonCampRankOnToggleChanged)
  self.tog_CampRank:SetOnToggleChanged(self, self.tog_PersonCampRankOnToggleChanged)
  self.btn_Desc:SetOnClick(self, self.btn_DescOnClick)
  self.btn_Exit:SetOnClick(self, self.btn_ExitOnClick)
  self.btn_AllRank:SetOnClick(self, self.btn_AllRankOnClick)
  self.btn_GoTo:SetOnClick(self, self.btn_GoToOnClick)
end

function Activity_SiFangUI:btn_GoToOnClick()
  if FourPartyRivalryManager.m_FourPartyRivalryActivityInfo == nil or FourPartyRivalryManager.m_FourPartyRivalryActivityInfo.stage == nil then
    return
  end
  local stage = FourPartyRivalryManager.m_FourPartyRivalryActivityInfo.stage
  local taskStage = FourPartyRivalryManager:GetTaskTargetData()
  if taskStage == nil then
    return
  end
  local mainPos = {
    x = RoleManager.me.cellPos.x,
    y = RoleManager.me.cellPos.y
  }
  local distance, curDistance = 0, 0
  local targetPos
  for i, v in pairs(taskStage[stage].targetList) do
    local transferConfig = ConfigManager.FindConfigs("cfg_Map_transfer", "id", v.transferId)
    local mapPos = string.split(transferConfig[1].position, "_")
    if 1 < table.count(mapPos) then
      distance = PathFinding.GetDistance(mainPos, {
        x = tonumber(mapPos[1]),
        y = tonumber(mapPos[2])
      })
    end
    if curDistance > distance or curDistance == 0 then
      curDistance = distance
      targetPos = mapPos
    end
  end
  PathFinderManager.MoveToPosHangUpAutoFight(SceneData.groupId, Vector2(tonumber(targetPos[1]), tonumber(targetPos[2])))
end

function Activity_SiFangUI:btn_DescOnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1152})
end

function Activity_SiFangUI:btn_ExitOnClick()
  TranScriptController.ReqExitInstance()
  EventManager.Dispatch(Event.QuitFourPartyRivalryScene)
end

function Activity_SiFangUI:btn_AllRankOnClick()
  if FourPartyRivalryManager.m_FourPartyRivalryRankData == nil then
    return
  end
  UIManager.Show(UIID.Activity_SiFangRankUI)
end

function Activity_SiFangUI:tog_TaskRankPanelOnToggleChanged(_control, _isOn)
  self.TaskPanel:SetActive(false)
  self.RankPanel:SetActive(false)
  if self.tog_TaskPanel:GetIsOn() then
    self.TaskPanel:SetActive(true)
  elseif self.tog_RankPanel:GetIsOn() then
    self.RankPanel:SetActive(true)
  end
end

function Activity_SiFangUI:tog_PersonCampRankOnToggleChanged(_control, _isOn)
  self.scrollViewPerson:SetActive(false)
  self.scrollViewCamp:SetActive(false)
  if self.tog_PersonRank:GetIsOn() then
    self.scrollViewPerson:SetActive(true)
  elseif self.tog_CampRank:GetIsOn() then
    self.scrollViewCamp:SetActive(true)
  end
end

function Activity_SiFangUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self.lastStage = -1
  self.sceneEffect = nil
end

function Activity_SiFangUI:RegistEvents()
  self:RegistEvent(Event.ResKuaFuGongChengScoreRank, self.RefreshLeftTopPanel, self)
  self:RegistEvent(Event.ProcessCollectionAndRob, self.ResFourPartyRivalryActivityInfo, self)
  self:RegistEvent(Event.ResFourPartyRivalryActivityInfo, self.ResFourPartyRivalryActivityInfo, self)
end

function Activity_SiFangUI:Refresh()
  self:RefreshDefaultTaskRankPanelToggle()
  self:RefreshDefaultPersonCampRankToggle()
  self:RefreshLeftTopPanel()
  self:ResFourPartyRivalryActivityInfo()
  self:SetReadyCountDown()
end

function Activity_SiFangUI:RefreshLeftTopPanel()
  self:RefreshTaskPanelView()
  self:ResKuaFuGongChengScoreRank()
  self:SetCountDown()
end

function Activity_SiFangUI:RefreshDefaultTaskRankPanelToggle()
  self.tog_TaskPanel:SetIsOn(true)
  self:tog_TaskRankPanelOnToggleChanged()
end

function Activity_SiFangUI:RefreshDefaultPersonCampRankToggle()
  self.tog_PersonRank:SetIsOn(true)
  self:tog_PersonCampRankOnToggleChanged()
end

function Activity_SiFangUI:SetReadyCountDown()
  local cfgTimeData = QuickFind:GetSiFangZhengBaDataManager():AnalysisTimeStamp()
  local timeData = QuickFind:GetSiFangZhengBaDataManager():GetSiFangActivityTimeData()
  if cfgTimeData == nil or timeData == nil then
    return
  end
  local readyEndTime = cfgTimeData[1] + timeData.prepareTime
  if readyEndTime > Time.GetServerTime() then
    self.img_bg_taskDes:SetActive(false)
    self.taskDescription:SetActive(false)
    self.lab_CampRank:SetActive(false)
    self.lab_MyRank:SetActive(false)
    self.lab_MyIntegralRank:SetActive(false)
    self.lab_Time:SetActive(false)
    self.lab_Countdown:SetActive(true)
    local totalTime = (readyEndTime - Time.GetServerTime()) / 1000
    self.InitReadyTimer = self:ShowRoleCountDownTimer(totalTime, self.lab_Countdown, false)
  end
end

function Activity_SiFangUI:SetCountDown()
  if FourPartyRivalryManager.m_FourPartyRivalryActivityInfo == nil then
    return
  end
  local timeData = QuickFind:GetSiFangZhengBaDataManager():GetSiFangActivityTimeData()
  local endTime = FourPartyRivalryManager.m_FourPartyRivalryActivityInfo.endTime - timeData.prepareTime
  local totalTime = (endTime - Time.GetServerTime()) / 1000
  if self.InitTimer == nil then
    self.img_bg_taskDes:SetActive(true)
    self.taskDescription:SetActive(true)
    self.lab_CampRank:SetActive(true)
    self.lab_MyRank:SetActive(true)
    self.lab_MyIntegralRank:SetActive(true)
    self.lab_Time:SetActive(true)
    self.lab_Countdown:SetActive(false)
    self.InitTimer = self:ShowRoleCountDownTimer(totalTime, self.lab_Time, true)
  end
end

function Activity_SiFangUI:ShowRoleCountDownTimer(surplusTime, lab_countdown, isZeroExitTranScript)
  surplusTime = math.floor(surplusTime)
  lab_countdown:SetActive(true)
  
  local function UpdateTimer()
    surplusTime = surplusTime - 1
    local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
    lab_countdown:SetText(timeStr)
    if surplusTime <= 0 then
      lab_countdown:SetActive(false)
      if isZeroExitTranScript == true then
      end
    end
  end
  
  local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
  lab_countdown:SetText(timeStr)
  return Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function Activity_SiFangUI:RefreshTaskPanelView()
  if FourPartyRivalryManager.m_FourPartyRivalryRankData == nil then
    return
  end
  local meCampRankData = FourPartyRivalryManager:GetMyCampRankData()
  if meCampRankData and meCampRankData.rank > 0 then
    self.lab_CampRank:SetText(meCampRankData.rank)
  end
  local mePersonRankData = FourPartyRivalryManager:GetMyPersonRankData()
  if mePersonRankData and mePersonRankData.rank > 0 then
    self.lab_MyRank:SetText(mePersonRankData.rank)
    self.lab_MyIntegralRank:SetText(mePersonRankData.score)
  end
  local taskStage = FourPartyRivalryManager:GetNowTaskStageData()
  if taskStage == nil then
    return
  end
  local taskStageStr = LocalizationUtility.GetContentByKey("fourPartyRivalryTaskStage")
  self.siegeTarget_lab:SetText(string.format(taskStageStr, tostring(taskStage.warChapter)))
  self.lab_target:SetText(taskStage.desc)
  local targetStr = taskStage.tasknum
  if FourPartyRivalryManager.m_FourPartyRivalryActivityInfo and FourPartyRivalryManager.m_FourPartyRivalryActivityInfo.zhenyingKillCount then
    local campId = QuickFind:GetSiFangZhengBaDataManager():GetMyUnionId()
    targetStr = string.format(taskStage.tasknum, FourPartyRivalryManager.m_FourPartyRivalryActivityInfo.zhenyingKillCount[campId])
  end
  self.lab_Target:SetText(targetStr)
end

function Activity_SiFangUI:ResKuaFuGongChengScoreRank()
  self:RefreshPersonRankListView()
  self:RefreshCampRankListView()
  EventManager.Dispatch(Event.RefreshSiFangRankUI)
end

function Activity_SiFangUI:RefreshPersonRankListView()
  if FourPartyRivalryManager.m_FourPartyRivalryRankData == nil then
    return
  end
  self.personRankContainer:SetActiveTable()
  local personRankDataList = FourPartyRivalryManager:GetMyCampPlayerRank()
  table.sort(personRankDataList, function(a, b)
    return a.rank < b.rank
  end)
  if table.count(personRankDataList) > 0 then
    self.personRankContainer:SetData(personRankDataList)
  end
  self.lab_MyPersonRank:SetText("")
  self.lab_MyPersonName:SetText("")
  self.lab_MyPersonIntegral:SetText("")
  local mePersonRankData = FourPartyRivalryManager:GetMyPersonRankData()
  if mePersonRankData == nil then
    return
  end
  self.lab_MyPersonRank:SetText(mePersonRankData.rank)
  self.lab_MyPersonName:SetText(mePersonRankData.name)
  self.lab_MyPersonIntegral:SetText(mePersonRankData.score)
end

function Activity_SiFangUI:RefreshCampRankListView()
  if FourPartyRivalryManager.m_FourPartyRivalryRankData == nil then
    return
  end
  self.campRankContainer:SetActiveTable()
  local campRankDataList = FourPartyRivalryManager.m_FourPartyRivalryRankData.campList
  table.sort(campRankDataList, function(a, b)
    return a.rank < b.rank
  end)
  if table.count(campRankDataList) > 0 then
    self.campRankContainer:SetData(campRankDataList)
  end
  self.lab_MyCampRank:SetText("")
  self.img_MyCampBadge:SetActive(false)
  self.lab_MyCampName:SetText("")
  self.lab_MyCampIntegral:SetText("")
  local meCampRankData = FourPartyRivalryManager:GetMyCampRankData()
  if meCampRankData == nil then
    return
  end
  self.lab_MyCampRank:SetText(meCampRankData.rank)
  local cfgTbl = ClientTable.cfg_Activity_sifangCampManager:TryGetValue(meCampRankData.campId)
  self:SetSprite("Atlas_Common", cfgTbl.campImage, self.img_MyCampBadge, true)
  self.lab_MyCampName:SetText(cfgTbl.unionName)
  self.lab_MyCampIntegral:SetText(string.format(self.rankText, meCampRankData.score))
end

function Activity_SiFangUI:ResFourPartyRivalryActivityInfo()
  self:RefreshSceneEffectColor()
  local fourPartyRivalryActivityInfo = FourPartyRivalryManager.m_FourPartyRivalryActivityInfo
  if fourPartyRivalryActivityInfo == nil or not FourPartyRivalryUtility:IsPointInTriangle(RoleManager.me.cellPos) then
    self.ProgressPanel:SetActive(false)
    return
  end
  self.ProgressPanel:SetActive(true)
  local activityGlobalEffect = ClientTable.cfg_Activity_globalManager:TryGetValue(500536)
  local siFangConfig = ClientTable.cfg_Activity_sifangCampManager:TryGetValue(fourPartyRivalryActivityInfo.campId)
  local campProgress
  for i, v in pairs(self.progressTab) do
    local campProgressIsShow = siFangConfig and siFangConfig.index == i or false
    if v and v.transform then
      v:SetActive(campProgressIsShow)
      if campProgressIsShow then
        campProgress = v
      end
    end
  end
  if campProgress == nil or campProgress.transform == nil or activityGlobalEffect == nil or string.isNullOrEmpty(activityGlobalEffect.effect) then
    return
  end
  campProgress:GetChild("showBelong/img_ProgressFill"):SetFillAmount(fourPartyRivalryActivityInfo.campScore / tonumber(activityGlobalEffect.effect))
  campProgress:GetChild("showBelong/lab_ProgressFill"):SetText(string.format("%d/%d", fourPartyRivalryActivityInfo.campScore, tonumber(activityGlobalEffect.effect)))
end

function Activity_SiFangUI:RefreshSceneEffectColor()
  local fourPartyRivalryActivityInfo = FourPartyRivalryManager.m_FourPartyRivalryActivityInfo
  if fourPartyRivalryActivityInfo == nil then
    return
  end
  if self.lastStage == fourPartyRivalryActivityInfo.stage then
    return
  end
  local activityConfig = ClientTable.cfg_Activity_globalManager:TryGetValue(500558)
  if activityConfig == nil or string.isNullOrEmpty(activityConfig.effect) then
    return false
  end
  local colorTab = TableParse:SplitStringToIntListList(activityConfig.effect, "&", "#")
  local color = fourPartyRivalryActivityInfo.stage == FourPartyRivalryConstant.ThronedStage and Color(colorTab[2][1], colorTab[2][2], colorTab[2][3], colorTab[2][4]) or Color(colorTab[1][1], colorTab[1][2], colorTab[1][3], colorTab[1][4])
  if self.sceneEffect == nil then
    if CS == nil or CS.UnityEngine == nil or CS.UnityEngine.GameObject == nil then
      return
    end
    self.sceneEffect = CS.UnityEngine.GameObject.Find("Dynamic/Effect/Eff_anquanqu2")
  end
  if self.sceneEffect == nil or self.sceneEffect.transform == nil or self.sceneEffect.gameObject == nil then
    return
  end
  local meshRendererList = self.sceneEffect.gameObject:GetComponentsInChildren(typeof(UnityEngineLua.MeshRenderer))
  local length = meshRendererList.Length
  for k = 0, length - 1 do
    local meshRenderer = meshRendererList[k]
    if meshRenderer and meshRenderer.material and meshRenderer.material:HasProperty("_TintColor") then
      meshRenderer.material:SetColor("_TintColor", color)
    end
  end
  self.lastStage = fourPartyRivalryActivityInfo.stage
end

function Activity_SiFangUI:OnHide()
  if self.InitTimer then
    Timer.Stop(self.InitTimer)
    self.InitTimer = nil
  end
  if self.InitReadyTimer then
    Timer.Stop(self.InitReadyTimer)
    self.InitReadyTimer = nil
  end
  self.lastStage = -1
  self.sceneEffect = nil
end

function Activity_SiFangUI:OnDestroy()
end
