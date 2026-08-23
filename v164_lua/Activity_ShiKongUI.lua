Activity_ShiKongUI = class(BaseUI)
Activity_ShiKongUI.layer = UILayer.Panel
Activity_ShiKongUI.orderInLayer = 0
Activity_ShiKongUI.hideType = UIHideType.WaitDestroy
Activity_ShiKongUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_ShiKongUI.escClose = UIEscClose.DontClose

function Activity_ShiKongUI:InitControls()
  self.lab_Title = self:GetControl("panel_Task/lab_Title")
  self.btn_Exit = self:GetControl("btn_Exit")
  self.lab_Countdown = self:GetControl("btn_Exit/lab_Countdown")
  self.btn_TaskDescribe = self:GetControl("panel_Task/btn_TaskDescribe")
  self.btn_desc = self:GetControl("btn_desc")
  self.taskRankBar = self:GetControl("taskRankBar")
  self.tog_Task = self:GetControl("taskRankBar/tog_Task")
  self.tog_Ranking = self:GetControl("taskRankBar/tog_Ranking")
  self.panel_Task = self:GetControl("panel_Task")
  self.panel_Message = self:GetControl("panel_Message")
  self.panel_BossMessage = self:GetControl("panel_BossMessage")
  self.Panel_PersonRanking = self:GetControl("Panel_PersonRanking")
  self.Panel_UnionRanking = self:GetControl("Panel_UnionRanking")
  self.lab_CostNumber = self:GetControl("panel_Task/lab_CostNumber")
  self.boxRewardItem = self:GetControl("panel_Task/grid/btn_3DItem")
  self.lab_BoxNumber = self:GetControl("panel_Message/lab_BoxNumber")
  self.lab_BossTime = self:GetControl("panel_Message/lab_BossTime")
  self.bossInfoItem = self:GetControl("panel_BossMessage/sw_bossInfo/Viewport/Content/bossInfoItem")
  self.personRankItem = self:GetControl("Panel_PersonRanking/sw_rankList/Viewport/Content/go_ranking1")
  self.unionRankItem = self:GetControl("Panel_UnionRanking/sw_rankList/Viewport/Content/go_ranking1")
  self.person_Lab_Rank_My = self:GetControl("Panel_PersonRanking/go_rankingMe/lab_rank")
  self.person_Lab_Name_My = self:GetControl("Panel_PersonRanking/go_rankingMe/lab_Name")
  self.person_Lab_value_My = self:GetControl("Panel_PersonRanking/go_rankingMe/lab_value")
  self.person_Img_noRank_My = self:GetControl("Panel_PersonRanking/go_rankingMe/img_noRank")
  self.union_Lab_Rank_My = self:GetControl("Panel_UnionRanking/go_rankingMe/lab_rank")
  self.union_Lab_Name_My = self:GetControl("Panel_UnionRanking/go_rankingMe/lab_Name")
  self.union_Lab_value_My = self:GetControl("Panel_UnionRanking/go_rankingMe/lab_value")
  self.union_Img_noRank_My = self:GetControl("Panel_UnionRanking/go_rankingMe/img_noRank")
  self.btn_OpenBox = self:GetControl("btn_OpenBox")
  self.openBoxProgress = self:GetControl("openBoxProgress")
  self.btn_personRank = self:GetControl("btn_personRank")
  self.btn_unionRank = self:GetControl("btn_unionRank")
end

function Activity_ShiKongUI:Init()
  self.taskRankBar_pos = Vector3.zero
  self.panel_Task_pos = Vector3.zero
  self.panel_BossMessage_pos = Vector3.zero
  self.panel_Message_pos = Vector3.zero
  self.Panel_PersonRanking_pos = Vector3.zero
  self.Panel_UnionRanking_pos = Vector3.zero
  self.btn_desc_pos = Vector3.zero_pos
  self.btn_Exit_pos = Vector3.zero_pos
  self.btn_personRank_pos = Vector3.zero_pos
  self.btn_unionRank_pos = Vector3.zero_pos
end

function Activity_ShiKongUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnRewardItemCreate(_control)
  _control.itemCtr = ItemUtility.InitItemCell(UIControl(_control.transform))
  _control.modelData = ItemCellData()
end

local function OnRewardItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  _control:SetActive(true)
  local itemData = ItemUtility.GenerateItemData(_data.itemId)
  itemData.count = _data.count
  _control.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(_control.itemCtr, _control.modelData, _ui, true)
end

local function OnRankItemCreate(_control)
  _control.lab_rank = UIControl(_control.transform, "lab_rank")
  _control.img_rankIcon1 = UIControl(_control.transform, "img_rankIcon1")
  _control.img_rankIcon2 = UIControl(_control.transform, "img_rankIcon2")
  _control.img_rankIcon3 = UIControl(_control.transform, "img_rankIcon3")
  _control.lab_name = UIControl(_control.transform, "lab_Name")
  _control.lab_value = UIControl(_control.transform, "lab_value")
  _control.btn_buff = UIControl(_control.transform, "union_buff/Grid_Buff/btn_buff")
  _control.rankIconTab = {
    _control.img_rankIcon1,
    _control.img_rankIcon2,
    _control.img_rankIcon3
  }
end

local function OnPersonRankItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  _control:SetActive(true)
  if _data.rank <= SpaceCrackMapData.ShowIconMaxRank then
    _control.lab_rank:SetActive(false)
    for i, v in pairs(_control.rankIconTab) do
      v:SetActive(i == _data.rank)
    end
  else
    for i, v in pairs(_control.rankIconTab) do
      v:SetActive(false)
    end
    _control.lab_rank:SetActive(true)
    _control.lab_rank:SetText(_data.rank)
  end
  _control.lab_name:SetText(_data.name)
  _control.lab_value:SetText(_data.score)
end

local function OnUnionBuffItemCreate(_control)
  _control.lab_buff = UIControl(_control.transform, "lab_buff")
  _control.img_buff = UIControl(_control.transform, "img_buff")
  _control.img_mask = UIControl(_control.transform, "img_mask")
  _control.lab_buffNum = UIControl(_control.transform, "lab_buffNum")
  _control.lab_num = UIControl(_control.transform, "lab_num")
end

local function OnUnionBuffItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  _data.buffCId = _data.buffId
  local buff_struct = BuffData.GenerateBuffStruct(_data)
  if buff_struct == nil then
    return
  end
  _control.data = buff_struct
  local time = buff_struct.time
  _control:SetActive(true)
  _control.lab_buff:SetText(buff_struct.buffConfig.name)
  if _control.buffMaskTimer then
    Timer.Stop(_control.buffMaskTimer)
    _control.buffMaskTimer = nil
  end
  if buff_struct.totalTime > 0 then
    _control.img_mask:SetActive(true)
    _control.img_mask:SetFillAmount(1)
    _control.buffMaskTimer = Timer.StartLoopForever(Time.deltaTime, function()
      time = time - Time.deltaTime
      if time <= 0 then
        Timer.Stop(_control.buffMaskTimer)
        _control.buffMaskTimer = nil
        _control:SetActive(false)
        return
      end
      _control.img_mask:SetFillAmount(1 - time / buff_struct.totalTime)
    end)
  else
    _control.img_mask:SetActive(false)
  end
  if _control.img_buff.loader then
    Coroutine.Stop(_control.img_buff.loader)
  end
  local buffOverlayNum = ""
  if _control.lab_buffNum and type(buff_struct.overlayNum) == "number" and buff_struct.overlayNum > 1 then
    buffOverlayNum = buff_struct.overlayNum
  end
  _control.lab_buffNum:SetText(buffOverlayNum)
  local buffCount = ""
  if _control.lab_num and type(buff_struct.count) == "number" and 1 < buff_struct.count then
    buffCount = buff_struct.count
  end
  _control.lab_num:SetText(buffCount)
  _control.img_buff.loader = _ui:SetSprite("Atlas_Buff", buff_struct.buffConfig.icon, _control.img_buff)
end

local function OnUnionRankItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  _control:SetActive(true)
  if _data.rank <= SpaceCrackMapData.ShowIconMaxRank then
    _control.lab_rank:SetActive(false)
    for i, v in pairs(_control.rankIconTab) do
      v:SetActive(i == _data.rank)
    end
  else
    for i, v in pairs(_control.rankIconTab) do
      v:SetActive(false)
    end
    _control.lab_rank:SetActive(true)
    _control.lab_rank:SetText(_data.rank)
  end
  _control.lab_name:SetText(string.format("S%s.%s", _data.serverId, _data.unionName))
  _control.lab_value:SetText(_data.score)
  if _control.buffContainer == nil then
    _control.buffContainer = UIContainer(_control.btn_buff, _ui, OnUnionBuffItemCreate, OnUnionBuffItemRefresh)
  end
  _control.buffContainer:SetActiveTable()
  local resServerCrackUnionBuffInfoData = QuickFind:GetSpaceCrackDataManager().m_ResServerCrackUnionBuffInfoData
  if resServerCrackUnionBuffInfoData == nil then
    return
  end
  for i, v in pairs(resServerCrackUnionBuffInfoData) do
    if v.unionId == _data.unionId then
      _control.buffContainer:SetData(v.buffs)
      break
    end
  end
end

local function OnBossInfoItemCreate(_control)
  _control.lab_boss = UIControl(_control.transform, "lab_boss")
  _control.lab_position = UIControl(_control.transform, "lab_position")
  _control.lab_bossState = UIControl(_control.transform, "lab_bossState")
end

local function OnBossInfoItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  local monsterConfig = ClientTable.cfg_Monster_monsterManager:TryGetValue(_data.bossId)
  if monsterConfig == nil then
    return
  end
  _control:SetActive(true)
  _control.lab_boss:SetText(monsterConfig.name)
  _control.lab_position:SetText(string.format("T\225\187\141a \196\145\225\187\153  %d,%d", _data.x, _data.y))
  local bossStateText, color = "", ItemQuality2ColorDic[5]
  if _data.state == 1 then
    bossStateText = "\237\131\128\234\178\169 \234\176\128\235\138\165"
    color = ItemQuality2ColorDic[5]
  else
    bossStateText = "\236\157\180\235\175\184 \236\130\172\235\167\157"
    color = ItemQuality2ColorDic[10]
  end
  _control.lab_bossState:SetText(string.GetColorText(bossStateText, color))
  _control:SetOnClick(_ui, function()
    local pos = {
      x = _data.x,
      y = _data.y
    }
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
    RoleManager.me:MoveTo(pos, 0, function()
      local mePos = Vector2(RoleManager.me.cellPos.x, RoleManager.me.cellPos.y)
      local isArrive = PathFinderManager.pathFinding.IsDetectionRangePoint(pos, mePos, 5)
      if isArrive then
        RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
      end
    end)
  end)
end

function Activity_ShiKongUI:InitUI()
  self.boxRewardContainer = UIContainer(self.boxRewardItem, self, OnRewardItemCreate, OnRewardItemRefresh)
  self.bossInfoContainer = UIContainer(self.bossInfoItem, self, OnBossInfoItemCreate, OnBossInfoItemRefresh)
  self.personRankContainer = UIContainer(self.personRankItem, self, OnRankItemCreate, OnPersonRankItemRefresh)
  self.unionRankContainer = UIContainer(self.unionRankItem, self, OnRankItemCreate, OnUnionRankItemRefresh)
  self:GoPosInit()
end

function Activity_ShiKongUI:RegistUIEvents()
  self.btn_Exit:SetOnClick(self, self.btn_ExitOnClick)
  self.btn_TaskDescribe:SetOnClick(self, self.btn_TaskDescribeOnClick)
  self.tog_Task:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_Ranking:SetOnToggleChanged(self, self.OnToggleChanged)
  self.btn_OpenBox:SetOnClick(self, self.btn_OpenBoxOnClick)
  self.btn_desc:SetOnClick(self, self.btn_descOnClick)
  self.btn_personRank:SetOnClick(self, self.btn_personRankOnClick)
  self.btn_unionRank:SetOnClick(self, self.btn_unionRankOnClick)
end

function Activity_ShiKongUI:btn_personRankOnClick()
  UIManager.Show(UIID.Activity_ShiKongPersonRankUI)
end

function Activity_ShiKongUI:btn_unionRankOnClick()
  UIManager.Show(UIID.Activity_ShiKongUnionRankUI)
end

function Activity_ShiKongUI:btn_ExitOnClick()
  local titleText = Localization.GetUIWord("tishi")
  local promptTipArgs = {
    title = titleText,
    textContent = "R\225\187\157i ph\195\179 b\225\186\163n s\225\186\189 m\225\186\165t ti\225\186\191n \196\145\225\187\153, tho\195\161t kh\195\180ng",
    ok = function()
      self:OnHide()
      TranScriptController.ReqExitInstance()
    end,
    canel = function()
      UIManager.Hide(this.name)
    end
  }
  UIManager.Show(UIID.PromptTipUI, promptTipArgs)
end

function Activity_ShiKongUI:btn_TaskDescribeOnClick()
  local groupId = SceneData.groupId
  PathFinderManager.JumpMapToMoveToPos(groupId, PathFinderManager.GetCalcPosData("131#95"), nil, nil, nil, nil, nil)
end

function Activity_ShiKongUI:OnToggleChanged(_control, _isOn)
  if not _isOn then
    return
  end
  if self.tog_Task:GetIsOn() then
    self:RefreshTaskOrMessageOrPersonRank()
  elseif self.tog_Ranking:GetIsOn() then
    self:RefreshUnionRank()
  end
end

function Activity_ShiKongUI:btn_OpenBoxOnClick(_control)
  if _control == nil or _control.openBoxNpcId == nil then
    return
  end
  if self.openBoxLoop ~= nil then
    Timer.Stop(self.openBoxLoop)
    self.openBoxLoop = nil
  end
  local resSpaceCrackOpenBoxState = QuickFind:GetSpaceCrackDataManager().m_ResSpaceCrackOpenBoxState
  if resSpaceCrackOpenBoxState and resSpaceCrackOpenBoxState == 1 then
    FloatingTipUtility.QuickMsg("\236\136\152\235\160\185 \236\131\129\237\149\156\236\151\144 \235\143\132\235\139\172\237\149\152\236\152\128\236\138\181\235\139\136\235\139\164")
    return
  end
  _control.gameObject:GetComponent("Button").enabled = false
  local setProcessTime = 0.05
  local littleProcess = setProcessTime * 1000 / 5000
  SpaceCrackController.ReqFlagActivityCollectBox(_control.openBoxNpcId, 1)
  local process = 0
  _control:GetChild("btn_OpenBoxFill"):SetFillAmount(process)
  self.openBoxLoop = Timer.StartLoopForever(setProcessTime, function()
    process = process + littleProcess
    _control:GetChild("btn_OpenBoxFill"):SetFillAmount(process)
    if 1 <= process then
      Timer.Stop(self.openBoxLoop)
      self.openBoxLoop = nil
      _control:SetActive(false)
      _control:GetChild("btn_OpenBoxFill"):SetFillAmount(0)
      SpaceCrackController.ReqFlagActivityCollectBox(_control.openBoxNpcId, 2)
    end
  end)
end

function Activity_ShiKongUI:btn_descOnClick()
  local config = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Activity_ShiKongUI")
  if 0 < #config then
    UIManager.Show(UIID.System_DescUI, {
      id = config[1].id
    })
  end
end

function Activity_ShiKongUI:RefreshTaskOrMessageOrPersonRank()
  local resSpaceCrackTaskInfoData = QuickFind:GetSpaceCrackDataManager().m_ResSpaceCrackTaskInfoData
  local resSpaceCrackPvpInfoData = QuickFind:GetSpaceCrackDataManager().m_ResSpaceCrackPvpInfoData
  self.panel_Task:SetActive(false)
  self.panel_Message:SetActive(false)
  self.panel_BossMessage:SetActive(false)
  self.Panel_PersonRanking:SetActive(false)
  self.Panel_UnionRanking:SetActive(false)
  if resSpaceCrackTaskInfoData and resSpaceCrackPvpInfoData == nil then
    self.panel_Task:SetActive(true)
  elseif resSpaceCrackTaskInfoData == nil and resSpaceCrackPvpInfoData then
    if resSpaceCrackPvpInfoData.bossTime > Time.GetServerTime() then
      self.panel_Message:SetActive(true)
    else
      local resServerCrackBossInfoData = QuickFind:GetSpaceCrackDataManager().m_ResServerCrackBossInfoData
      if RoleManager.me ~= nil and RoleManager.me.TargetAvatar ~= nil and RoleManager.me.TargetAvatar.RoleType == ERoleType.Monster or resServerCrackBossInfoData and resServerCrackBossInfoData.state == 2 then
        self.Panel_PersonRanking:SetActive(true)
      else
        self.panel_BossMessage:SetActive(true)
      end
    end
  end
end

function Activity_ShiKongUI:RefreshUnionRank()
  self.panel_Task:SetActive(false)
  self.panel_Message:SetActive(false)
  self.panel_BossMessage:SetActive(false)
  self.Panel_PersonRanking:SetActive(false)
  self.Panel_UnionRanking:SetActive(true)
end

function Activity_ShiKongUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:OnActiveMainUI(Event.Logic_ActiveMainUI, true)
end

function Activity_ShiKongUI:RegistEvents()
  self:RegistEvent(Event.ResSpaceCrackTranscript, self.Refresh, self)
  self:RegistEvent(Event.RefreshSpaceCrackTranscriptOpenBoxButton, self.RefreshSpaceCrackTranscriptOpenBoxButton, self)
  self:RegistEvent(Event.Role_OnMePosChanged, self.Role_OnMePosChanged, self)
  self:RegistEvent(Event.ResSpaceCrackSettle, self.ResSpaceCrackSettle, self)
  self:RegistEvent(Event.SelectMonster, self.SelectMonster, self)
  self:RegistEvent(Event.CancelSelectMonster, self.CancelSelectMonster, self)
  self:RegistEvent(Event.RefreshSpaceCrackTranscriptRankButton, self.RefreshSpaceCrackTranscriptRankButton, self)
  self:RegistEvent(Event.Logic_ActiveMainUI, self.OnActiveMainUI, self)
end

function Activity_ShiKongUI:GoPosInit()
  self.taskRankBar_pos = self.taskRankBar.transform.localPosition
  self.panel_Task_pos = self.panel_Task.transform.localPosition
  self.panel_BossMessage_pos = self.panel_BossMessage.transform.localPosition
  self.panel_Message_pos = self.panel_Message.transform.localPosition
  self.Panel_PersonRanking_pos = self.Panel_PersonRanking.transform.localPosition
  self.Panel_UnionRanking_pos = self.Panel_UnionRanking.transform.localPosition
  self.btn_desc_pos = self.btn_desc.transform.localPosition
  self.btn_Exit_pos = self.btn_Exit.transform.localPosition
  self.btn_personRank_pos = self.btn_personRank.transform.localPosition
  self.btn_unionRank_pos = self.btn_unionRank.transform.localPosition
end

function Activity_ShiKongUI:OnActiveMainUI(_, state)
  local animalTime = C_UISettings.MainMenuUITime
  local distance = C_UISettings.MainUIDistance
  self.state = state
  if state then
    self.taskRankBar.transform:DOLocalMove(self.taskRankBar_pos, animalTime):SetEase(Ease.OutQuad)
    self.panel_Task.transform:DOLocalMove(self.panel_Task_pos, animalTime):SetEase(Ease.OutQuad)
    self.panel_BossMessage.transform:DOLocalMove(self.panel_BossMessage_pos, animalTime):SetEase(Ease.OutQuad)
    self.panel_Message.transform:DOLocalMove(self.panel_Message_pos, animalTime):SetEase(Ease.OutQuad)
    self.Panel_PersonRanking.transform:DOLocalMove(self.Panel_PersonRanking_pos, animalTime):SetEase(Ease.OutQuad)
    self.Panel_UnionRanking.transform:DOLocalMove(self.Panel_UnionRanking_pos, animalTime):SetEase(Ease.OutQuad)
    self.btn_desc.transform:DOLocalMove(self.btn_desc_pos, animalTime):SetEase(Ease.OutQuad)
    self.btn_Exit.transform:DOLocalMove(self.btn_Exit_pos, animalTime):SetEase(Ease.OutQuad)
    self.btn_personRank.transform:DOLocalMove(self.btn_personRank_pos, animalTime):SetEase(Ease.OutQuad)
    self.btn_unionRank.transform:DOLocalMove(self.btn_unionRank_pos, animalTime):SetEase(Ease.OutQuad)
  else
    self.taskRankBar.transform:DOLocalMove(self.taskRankBar_pos + Vector3.New(-distance, 0, 0), animalTime):SetEase(Ease.OutQuad)
    self.panel_Task.transform:DOLocalMove(self.panel_Task_pos + Vector3.New(-distance, 0, 0), animalTime):SetEase(Ease.OutQuad)
    self.panel_BossMessage.transform:DOLocalMove(self.panel_BossMessage_pos + Vector3.New(-distance, 0, 0), animalTime):SetEase(Ease.OutQuad)
    self.panel_Message.transform:DOLocalMove(self.panel_Message_pos + Vector3.New(-distance, 0, 0), animalTime):SetEase(Ease.OutQuad)
    self.Panel_PersonRanking.transform:DOLocalMove(self.Panel_PersonRanking_pos + Vector3.New(-distance, 0, 0), animalTime):SetEase(Ease.OutQuad)
    self.Panel_UnionRanking.transform:DOLocalMove(self.Panel_UnionRanking_pos + Vector3.New(-distance, 0, 0), animalTime):SetEase(Ease.OutQuad)
    self.btn_desc.transform:DOLocalMove(self.btn_desc_pos + Vector3.New(-distance, 0, 0), animalTime):SetEase(Ease.OutQuad)
    self.btn_Exit.transform:DOLocalMove(self.btn_Exit_pos + Vector3.New(-distance - 100, 0, 0), animalTime):SetEase(Ease.OutQuad)
    self.btn_personRank.transform:DOLocalMove(self.btn_personRank_pos + Vector3.New(-distance - 100, 0, 0), animalTime):SetEase(Ease.OutQuad)
    self.btn_unionRank.transform:DOLocalMove(self.btn_unionRank_pos + Vector3.New(-distance - 100, 0, 0), animalTime):SetEase(Ease.OutQuad)
  end
end

function Activity_ShiKongUI:RefreshSpaceCrackTranscriptRankButton()
  if self.btn_personRank:GetActive() or self.btn_unionRank:GetActive() then
    return
  end
  self.btn_personRank:SetActive(true)
  self.btn_unionRank:SetActive(true)
end

function Activity_ShiKongUI:SelectMonster()
  self:OnToggleChanged(_, true)
end

function Activity_ShiKongUI:CancelSelectMonster()
  self:OnToggleChanged(_, true)
end

function Activity_ShiKongUI:Refresh()
  self:OnToggleChanged(_, true)
  self:RefreshTaskPanel()
  self:RefreshMessagePanel()
  self:RefreshBossMessagePanel()
  self:RefreshPersonRankPanel()
  self:RefreshUnionRankPanel()
  self:RefreshTranscriptTime()
end

function Activity_ShiKongUI:RefreshTaskPanel()
  self.boxRewardContainer:SetActiveTable()
  local missionPhaseNum = SpaceCrackMapData.MaxLayer
  self.lab_Title:SetText(missionPhaseNum)
  local resSpaceCrackTaskInfoData = QuickFind:GetSpaceCrackDataManager().m_ResSpaceCrackTaskInfoData
  if resSpaceCrackTaskInfoData == nil then
    return
  end
  local serverTask = resSpaceCrackTaskInfoData.task
  if serverTask == nil then
    return
  end
  local instance_missionConfig = ClientTable.cfg_Map_instance_missionManager:TryGetValue(serverTask.id, "id")
  if instance_missionConfig == nil then
    return
  end
  missionPhaseNum = instance_missionConfig.missionPhaseNum
  self.btn_TaskDescribe:GetChild("Text"):SetText(instance_missionConfig.description)
  self.lab_CostNumber:SetText(string.format("%s/%s", resSpaceCrackTaskInfoData.task.count, instance_missionConfig.count))
  local boxConfig = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(instance_missionConfig.rewards))
  local itemDataTab = {}
  for n, m in pairs(boxConfig) do
    if m.condition == nil or ConditionManager.Check4D(m.condition) then
      local itemInfo = {
        itemId = m.itemId,
        count = m.count
      }
      table.insert(itemDataTab, itemInfo)
    end
  end
  self.boxRewardContainer:SetData(itemDataTab)
  self.lab_Title:SetText(missionPhaseNum)
end

function Activity_ShiKongUI:RefreshMessagePanel()
  self:StopBossTime()
  self.lab_BossTime:SetActive(false)
  local resSpaceCrackPvpInfoData = QuickFind:GetSpaceCrackDataManager().m_ResSpaceCrackPvpInfoData
  if resSpaceCrackPvpInfoData == nil then
    return
  end
  self.lab_BoxNumber:SetText(resSpaceCrackPvpInfoData.boxSum)
  self:StartBossCountdown(resSpaceCrackPvpInfoData.bossTime, self.lab_BossTime, "%s")
end

function Activity_ShiKongUI:RefreshBossMessagePanel()
  self.bossInfoContainer:SetActiveTable()
  local resServerCrackBossInfoData = QuickFind:GetSpaceCrackDataManager().m_ResServerCrackBossInfoData
  if resServerCrackBossInfoData == nil then
    return
  end
  self.bossInfoContainer:SetData({
    [1] = resServerCrackBossInfoData
  })
end

function Activity_ShiKongUI:RefreshPersonRankPanel()
  self.personRankContainer:SetActiveTable()
  self.person_Lab_Rank_My:SetText("")
  self.person_Lab_Name_My:SetText("")
  self.person_Lab_value_My:SetText("")
  self.person_Img_noRank_My:SetActive(true)
  local resSpaceCrackPvpInfoData = QuickFind:GetSpaceCrackDataManager().m_ResSpaceCrackPvpInfoData
  if resSpaceCrackPvpInfoData == nil then
    return
  end
  local personInfo = resSpaceCrackPvpInfoData.personInfo
  if personInfo == nil then
    return
  end
  self.personRankContainer:SetData(personInfo)
  local myRankInfo
  for i, v in pairs(personInfo) do
    if v.rid == RoleManager.me.id then
      myRankInfo = v
      break
    end
  end
  if myRankInfo == nil then
    return
  end
  self.person_Img_noRank_My:SetActive(false)
  self.person_Lab_Rank_My:SetText(myRankInfo.rank)
  self.person_Lab_Name_My:SetText(myRankInfo.name)
  self.person_Lab_value_My:SetText(myRankInfo.score)
end

function Activity_ShiKongUI:RefreshUnionRankPanel()
  self.unionRankContainer:SetActiveTable()
  self.union_Lab_Rank_My:SetText("")
  self.union_Lab_Name_My:SetText("")
  self.union_Lab_value_My:SetText("")
  self.union_Img_noRank_My:SetActive(true)
  local resSpaceCrackPvpInfoData = QuickFind:GetSpaceCrackDataManager().m_ResSpaceCrackPvpInfoData
  if resSpaceCrackPvpInfoData == nil then
    return
  end
  local unionInfo = resSpaceCrackPvpInfoData.unionInfo
  if unionInfo == nil then
    return
  end
  self.unionRankContainer:SetData(unionInfo)
  local myRankInfo
  for i, v in pairs(unionInfo) do
    if WarAllianceData.IsHaveUnion and WarAllianceData.MyWarAllianceData and WarAllianceData.MyWarAllianceData.id == v.unionId then
      myRankInfo = v
      break
    end
  end
  if myRankInfo == nil then
    return
  end
  self.union_Img_noRank_My:SetActive(false)
  self.union_Lab_Rank_My:SetText(myRankInfo.rank)
  self.union_Lab_Name_My:SetText(string.format("S%s.%s", myRankInfo.serverId, myRankInfo.unionName))
  self.union_Lab_value_My:SetText(myRankInfo.score)
end

function Activity_ShiKongUI:RefreshTranscriptTime()
  self:StopTime()
  self.lab_Countdown:SetActive(false)
  local resSpaceCrackEndTime = QuickFind:GetSpaceCrackDataManager().m_ResSpaceCrackEndTime
  if resSpaceCrackEndTime == nil then
    return
  end
  self:StartCountdown(resSpaceCrackEndTime, self.lab_Countdown, "%s")
end

function Activity_ShiKongUI:StopTime()
  if self.countdownTimer then
    Timer.Stop(self.countdownTimer)
    self.countdownTimer = nil
  end
end

function Activity_ShiKongUI:StopBossTime()
  if self.countdownBossTimer then
    Timer.Stop(self.countdownBossTimer)
    self.countdownBossTimer = nil
  end
end

function Activity_ShiKongUI:StartCountdown(_endTime, _uiControl, _formatText)
  if string.isNullOrEmpty(_endTime) or _uiControl == nil or string.isNullOrEmpty(_formatText) then
    return
  end
  local flagTime = math.floor((_endTime - Time.GetServerTime()) * 0.001)
  if flagTime <= 0 then
    return
  end
  _uiControl:SetActive(true)
  _uiControl:SetText(string.format(_formatText, TimeUtility.ShowTime(flagTime)))
  
  local function Countdown()
    flagTime = flagTime - 1
    if flagTime <= 0 then
      _uiControl:SetActive(false)
      self:StopTime()
      return
    end
    _uiControl:SetText(string.format(_formatText, TimeUtility.ShowTime(flagTime)))
  end
  
  self.countdownTimer = Timer.StartLoopForever(1, Countdown)
end

function Activity_ShiKongUI:StartBossCountdown(_endTime, _uiControl, _formatText)
  if string.isNullOrEmpty(_endTime) or _uiControl == nil or string.isNullOrEmpty(_formatText) then
    return
  end
  local flagTime = math.floor((_endTime - Time.GetServerTime()) * 0.001)
  if flagTime <= 0 then
    return
  end
  _uiControl:SetActive(true)
  _uiControl:SetText(string.format(_formatText, TimeUtility.ShowTime(flagTime)))
  
  local function Countdown()
    flagTime = flagTime - 1
    if flagTime <= 0 then
      _uiControl:SetActive(false)
      self:StopBossTime()
      return
    end
    _uiControl:SetText(string.format(_formatText, TimeUtility.ShowTime(flagTime)))
  end
  
  self.countdownBossTimer = Timer.StartLoopForever(1, Countdown)
end

function Activity_ShiKongUI:RefreshSpaceCrackTranscriptOpenBoxButton(_, _openBoxNpcId)
  if _openBoxNpcId ~= self.btn_OpenBox.openBoxNpcId then
    self:ResetBtn_OpenBox()
  end
  self.btn_OpenBox.openBoxNpcId = _openBoxNpcId
  self.btn_OpenBox:SetActive(_openBoxNpcId ~= nil)
end

function Activity_ShiKongUI:ResetBtn_OpenBox()
  if self.openBoxLoop ~= nil then
    Timer.Stop(self.openBoxLoop)
    self.openBoxLoop = nil
  end
  self.btn_OpenBox.gameObject:GetComponent("Button").enabled = true
  self.btn_OpenBox:GetChild("btn_OpenBoxFill"):SetFillAmount(0)
  self.btn_OpenBox:SetActive(false)
end

function Activity_ShiKongUI:Role_OnMePosChanged()
  if self.openBoxLoop then
    self:ResetBtn_OpenBox()
  end
end

function Activity_ShiKongUI:ResSpaceCrackSettle()
  UIManager.Show(UIID.Activity_ShiKongUnionRankUI)
end

function Activity_ShiKongUI:OnHide()
  self.btn_unionRank:SetActive(false)
  self.btn_personRank:SetActive(false)
end

function Activity_ShiKongUI:OnDestroy()
end
