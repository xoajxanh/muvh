local panel_ZhengBaTemplate = {}

function panel_ZhengBaTemplate:Init(root)
  self.root = root
  self.groupTeamObjList = {}
  self.groupTeamTempList = {}
  self.goodTeamTempList = {}
  self.rankPanelTemp = {}
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
end

function panel_ZhengBaTemplate:InitControls()
  self.firstGroup = self:GetControl("go_main/img_Bg/sw_joinUnion/Viewport_1/Content")
  self.secondGroup = self:GetControl("go_main/img_Bg/sw_joinUnion/Viewport_3/Content")
  self.thirdGroup = self:GetControl("go_main/img_Bg/sw_joinUnion/Viewport_2/Content")
  self.fourthGroup = self:GetControl("go_main/img_Bg/sw_joinUnion/Viewport_4/Content")
  self.img_line_left = self:GetControl("go_main/img_Bg/sw_joinUnion/line_left")
  self.img_line_right = self:GetControl("go_main/img_Bg/sw_joinUnion/line_right")
  self.theFirstTeam = self:GetControl("go_main/img_Bg/sw_leaderList/Viewport/Content/img_frist")
  self.theSecondTeam = self:GetControl("go_main/img_Bg/sw_leaderList/Viewport/Content/img_second")
  self.theThirdTeam = self:GetControl("go_main/img_Bg/sw_leaderList/Viewport/Content/img_third")
  self.btnSignUp = self:GetControl("go_main/img_Bg/btn_signUp")
  self.sw_leaderList = self:GetControl("go_main/img_Bg/sw_leaderList")
  self.sw_joinUnion = self:GetControl("go_main/img_Bg/sw_joinUnion")
  self.btnGoRank = self:GetControl("go_main/img_Bg/btn_goRank")
  self.panelTeamRank = self:GetControl("panel_union_rank")
  self.reward_detail = self:GetControl("reward_detail")
  self.rewardListItem = self:GetControl("reward_detail/sw_reward/Viewport/Content/panel_personageReward")
  self.btnCloseRankPanel = self:GetControl("panel_union_rank/img_bg/btn_close")
  self.btn_goReward = self:GetControl("go_main/img_Bg/btn_goReward")
  self.img_Bg = self:GetControl("go_main/img_Bg")
  self.btn_close_reward_detail = self:GetControl("reward_detail/btn_close")
  self.goodTeamSuccess = self:GetControl("go_main/img_Bg/lab_show_zhengba/lab_seniority/success")
  self.goodTeamFail = self:GetControl("go_main/img_Bg/lab_show_zhengba/lab_seniority/fail")
  self.bottomTxtObj = self:GetControl("go_main/img_Bg/lab_show_zhengba")
  self.txtNotPassServerIds = self:GetControl("go_main/img_Bg/sw_leaderList/lab_tips/lab_unserver/lab_unserver (1)")
  self.txtOpenTime = self:GetControl("go_main/img_Bg/lab_show_zhengba/lab_Time/lab_entryTime")
  self.btnDesc = self:GetControl("go_main/img_Bg/btn_detail")
  self.groups = {
    [1] = self.firstGroup,
    [2] = self.secondGroup,
    [3] = self.thirdGroup,
    [4] = self.fourthGroup
  }
  self.goodTeams = {
    [1] = self.theFirstTeam,
    [2] = self.theSecondTeam,
    [3] = self.theThirdTeam
  }
  self.panelType = {
    noThreeTeam = 1,
    threeTeam = 2,
    nominatedList = 3
  }
end

function panel_ZhengBaTemplate:InitUI()
  for groupIndex, groupObj in ipairs(self.groups) do
    self.groupTeamObjList[groupIndex] = {}
    local num = groupObj.transform.childCount
    for teamIndex = 1, num do
      local ctr = UIControl(groupObj.transform:GetChild(teamIndex - 1))
      self.groupTeamObjList[groupIndex][teamIndex] = ctr
    end
  end
  for groupIndex, groupTeamList in ipairs(self.groupTeamObjList) do
    self.groupTeamTempList[groupIndex] = {}
    for teamIndex, teamObj in ipairs(groupTeamList) do
      self.groupTeamTempList[groupIndex][teamIndex] = luaTemplateManager.GetNewTemplate(teamObj, LuaComponentTemplates.panel_ZhangBaTeamTemplate, self)
    end
  end
  for teamIndex, teamObj in ipairs(self.goodTeams) do
    self.goodTeamTempList[teamIndex] = luaTemplateManager.GetNewTemplate(teamObj, LuaComponentTemplates.panel_ZhangBaGoodTeamTemplate, self)
  end
  self.rankPanelTemp = luaTemplateManager.GetNewTemplate(self.panelTeamRank, LuaComponentTemplates.panel_ZhangBaRankTemplate, self.root)
  self.rewardListContainer = UIContainer(self.rewardListItem, self, self.rewardListCreate, self.rewardListRefresh)
  self.verticalLineHalfHeight = 134
  self.verticalLineItemHeight = 36
  self.verticalLineOffset = -10
  self.verticalLineOffset2 = 0
  self.verticalLineWidth = self.img_line_left:GetSizeDelta()
end

function panel_ZhengBaTemplate:SetVerticalLineHeight(count, imgControl)
  if count == 0 then
    imgControl:SetSizeDelta(self.verticalLineWidth, self.verticalLineHalfHeight + self.verticalLineOffset2)
  elseif 0 < count then
    imgControl:SetSizeDelta(self.verticalLineWidth, self.verticalLineHalfHeight + self.verticalLineOffset + self.verticalLineItemHeight * count)
  end
end

function panel_ZhengBaTemplate:BindUIEvent()
  self.btnSignUp:SetOnClick(self, self.btnSignUpOnClick)
  self.btnGoRank:SetOnClick(self, self.btnGoRankOnClick)
  self.btnCloseRankPanel:SetOnClick(self, self.btnCloseRankPanelOnClick)
  self.btn_goReward:SetOnClick(self, self.btn_goRewardOnClick)
  self.btn_close_reward_detail:SetOnClick(self, self.btn_close_rewardOnClick)
  self.btnDesc:SetOnClick(self, self.btnDescOnClick)
end

function panel_ZhengBaTemplate:btnSignUpOnClick()
  local isActivityOpen = QuickFind:GetDuoQiCrossDataManager():IsDuoQiZhengBaActivityOpen()
  if isActivityOpen ~= true then
    local tempCfg = ClientTable.cfg_Ui_wordManager:TryGetValue("Activity_DuoqiZhengBa_Tips2")
    if tempCfg ~= nil and string.isNullOrEmpty(tempCfg.content) == false then
      FloatingTipUtility.QuickMsg(tempCfg.content)
      return
    end
  end
  local isActivityOpenAndLevelOk = QuickFind:GetDuoQiCrossDataManager():IsZhengBaActivityOpenAndLevelOk()
  if isActivityOpenAndLevelOk ~= true then
    local tempCfg = ClientTable.cfg_Ui_wordManager:TryGetValue("Level2_prompt_1")
    if tempCfg ~= nil and string.isNullOrEmpty(tempCfg.content) == false then
      FloatingTipUtility.QuickMsg(tempCfg.content)
      return
    end
  end
  local myUnionRankOfZhengBa = QuickFind:GetDuoQiZhengBaManager():GetMyRuWeiInfoOfZhengBa()
  if myUnionRankOfZhengBa == nil then
    local tempCfg = ClientTable.cfg_Ui_wordManager:TryGetValue("Activity_DuoqiZhengBa_Tips1")
    if tempCfg ~= nil and string.isNullOrEmpty(tempCfg.content) == false then
      FloatingTipUtility.QuickMsg(tempCfg.content)
      return
    end
  end
  local mapData = {mapId = 1020701}
  SceneController.OnReqTransferTransmitMap(nil, mapData)
end

function panel_ZhengBaTemplate:btnGoRankOnClick()
  self.panelTeamRank:SetActive(true)
end

function panel_ZhengBaTemplate:btnCloseRankPanelOnClick()
  self.panelTeamRank:SetActive(false)
end

function panel_ZhengBaTemplate:btn_goRewardOnClick()
  self.reward_detail:SetActive(true)
  self.img_Bg:SetActive(false)
end

function panel_ZhengBaTemplate:btn_close_rewardOnClick()
  self.reward_detail:SetActive(false)
  self.img_Bg:SetActive(true)
end

function panel_ZhengBaTemplate:btnDescOnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1149})
end

function panel_ZhengBaTemplate:SendUnionKuaFuSystemInstanceInfo()
  self:UIControl():SetActive(true)
  networkRequest.ReqUnionKuaFuSystemInstanceInfo()
  networkRequest.ReqUnionKuaFuRanks()
end

function panel_ZhengBaTemplate:Refresh()
  QuickFind:GetDuoQiCrossDataManager():RefreshPerAndUnionRewards()
  local nominatedGroupList = QuickFind:GetDuoQiZhengBaManager():GetNominatedGroupList()
  local teamRankList = QuickFind:GetDuoQiZhengBaManager():GetTeamRanks()
  local atLastCount = QuickFind:GetDuoQiZhengBaManager():GetAtLastServerCount()
  if teamRankList ~= nil and table.count(teamRankList) > 0 then
    self:ShowPanelByPanelType(self.panelType.threeTeam)
  elseif nominatedGroupList == nil or atLastCount > table.count(nominatedGroupList) then
    self:ShowPanelByPanelType(self.panelType.noThreeTeam)
  elseif atLastCount <= table.count(nominatedGroupList) then
    self:ShowPanelByPanelType(self.panelType.nominatedList)
  end
  local teamRankList = QuickFind:GetDuoQiZhengBaManager():GetTeamRanks()
  self.rankPanelTemp:Refresh(teamRankList)
  local myUnionRankOfZhengBa = QuickFind:GetDuoQiZhengBaManager():GetMyRuWeiInfoOfZhengBa()
  if myUnionRankOfZhengBa == nil then
    self.goodTeamFail:SetActive(true)
    self.goodTeamSuccess:SetActive(false)
    local tempCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500404)
    if tempCfg ~= nil and string.isNullOrEmpty(tempCfg.effect) == false then
      self.goodTeamFail:SetText(tempCfg.effect)
    end
  else
    self.goodTeamFail:SetActive(false)
    self.goodTeamSuccess:SetActive(true)
    local tempCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500403)
    if tempCfg ~= nil and string.isNullOrEmpty(tempCfg.effect) == false then
      self.goodTeamSuccess:SetText(tempCfg.effect)
    end
  end
  local isOpenZhangBa = QuickFind:GetDuoQiCrossDataManager():IsDuoQiZhengBaActivityOpen()
  if isOpenZhangBa == true then
    self.txtOpenTime:SetColor(EUIColor.Green)
  else
    self.txtOpenTime:SetColor(EUIColor.Red)
  end
  local rewardListIds = {}
  for i = 1, 3 do
    table.insert(rewardListIds, {
      id = 500220 + i
    })
  end
  self.rewardListContainer:SetData(rewardListIds)
end

function panel_ZhengBaTemplate:ShowPanelByPanelType(type)
  if type == self.panelType.noThreeTeam then
    self.sw_leaderList:SetActive(true)
    self.sw_joinUnion:SetActive(false)
    for i, teamTemplate in ipairs(self.goodTeamTempList) do
      teamTemplate:ShowNoRank()
    end
    self.btnSignUp:SetActive(false)
    self.bottomTxtObj:SetActive(false)
    self:SetNotPassServerIdsText()
  elseif type == self.panelType.threeTeam then
    self.sw_leaderList:SetActive(true)
    self.sw_joinUnion:SetActive(false)
    local teamRankList = QuickFind:GetDuoQiZhengBaManager():GetTeamRanks()
    for i, teamTemplate in ipairs(self.goodTeamTempList) do
      teamTemplate:ShowGoodTeamRank(teamRankList[i])
    end
    self:SetNotPassServerIdsText()
  elseif type == self.panelType.nominatedList then
    self.sw_leaderList:SetActive(false)
    self.sw_joinUnion:SetActive(true)
    local nominatedGroupList = QuickFind:GetDuoQiZhengBaManager():GetNominatedGroupList()
    self:ShowNominatedGroupList(nominatedGroupList)
    self.btnSignUp:SetActive(true)
    self.bottomTxtObj:SetActive(true)
  end
end

function panel_ZhengBaTemplate:SetNotPassServerIdsText()
  local txt = ""
  local serverIdTbl = QuickFind:GetDuoQiZhengBaManager():GetNotPassServerIds()
  for i, serverId in ipairs(serverIdTbl) do
    txt = txt .. "S." .. serverId .. "  "
  end
  self.txtNotPassServerIds:SetText(txt)
end

function panel_ZhengBaTemplate:ShowNominatedGroupList(NominatedGroupList)
  if NominatedGroupList == nil then
    return
  end
  for groupIndex, teamTempList in ipairs(self.groupTeamTempList) do
    local countOfTeam
    if NominatedGroupList[groupIndex] == nil or table.count(NominatedGroupList[groupIndex]) <= 0 then
      countOfTeam = 0
    else
      countOfTeam = table.count(NominatedGroupList[groupIndex])
    end
    for teamIndex, teamTemp in ipairs(teamTempList) do
      if teamIndex <= countOfTeam then
        teamTemp:ShowByData(NominatedGroupList[groupIndex][teamIndex])
      else
        teamTemp:SetObjActive(false)
      end
    end
    if groupIndex == 3 then
      local thirdGroupTeamCount = 0
      if teamTempList[groupIndex] ~= nil then
        thirdGroupTeamCount = table.count(NominatedGroupList[groupIndex])
      end
      self:SetVerticalLineHeight(thirdGroupTeamCount, self.img_line_left)
    elseif groupIndex == 4 then
      local fourthGroupTeamCount = 0
      if teamTempList[groupIndex] ~= nil then
        fourthGroupTeamCount = table.count(NominatedGroupList[groupIndex])
      end
      self:SetVerticalLineHeight(fourthGroupTeamCount, self.img_line_right)
    end
  end
end

function panel_ZhengBaTemplate.rewardListCreate(ctr1)
  ctr1.title = UIControl(ctr1.transform, "tx_integralReward")
  ctr1.title2 = UIControl(ctr1.transform, "tx_integralReward/img_title_bg/txt_title")
  ctr1.rankItem = UIControl(ctr1.transform, "tx_integralReward/sw_integralReward/Viewport/Content/rankGear")
end

local function rankListCreate(ctr2)
  ctr2.txt = UIControl(ctr2.transform, "")
  ctr2.btnRewards = UIControl(ctr2.transform, "sw_victoriousLeaderReward/Viewport/Content/btn_first")
end

local function rankRewardsCreate(ctr3)
  ctr3.itemCtr = ItemUtility.InitItemCell(UIControl(ctr3.transform))
  ctr3.modelData = ItemCellData()
end

local function rankRewardsRefresh(ctr3, index, data, ui)
  if data == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr3.modelData:RecycleRes()
  ctr3.modelData:RefreshData(itemData)
  ctr3.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr3.itemCtr, ctr3.modelData, ui, true)
end

local function rankListRefresh(ctr2, index, data, ui)
  if data == nil then
    return
  end
  ctr2.txt:SetText(data.title)
  local strings = string.split(data.showReward, "&")
  if next(strings) == nil then
    return
  end
  if ctr2.rankRewardListContainer == nil then
    ctr2.rankRewardListContainer = UIContainer(ctr2.btnRewards, ui.root, rankRewardsCreate, rankRewardsRefresh)
  end
  local rewardInfos = {}
  for i, v in ipairs(strings) do
    local rewardStrs = string.split(v, "#")
    if #rewardStrs ~= 2 then
      return
    end
    table.insert(rewardInfos, {
      itemId = tonumber(rewardStrs[1]),
      count = tonumber(rewardStrs[2])
    })
  end
  ctr2.rankRewardListContainer:SetData(rewardInfos)
end

function panel_ZhengBaTemplate.rewardListRefresh(ctr1, index, data, ui)
  local tempCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(data.id)
  if tempCfg == nil or tempCfg.effect == nil then
    return
  end
  local strings = string.split(tempCfg.effect, "&")
  if next(strings) == nil then
    return
  end
  ctr1.title:SetText(strings[1])
  ctr1.title2:SetText(strings[2])
  if ctr1.rankListContainer == nil then
    ctr1.rankListContainer = UIContainer(ctr1.rankItem, ui, rankListCreate, rankListRefresh)
  end
  local rankList = QuickFind:GetDuoQiCrossDataManager():GetZhangbaRankListByRewardType(index)
  ctr1.rankListContainer:SetData(rankList)
end

function panel_ZhengBaTemplate:OnDisable()
end

function panel_ZhengBaTemplate:Exit()
  self:UIControl():SetActive(false)
end

return panel_ZhengBaTemplate
