Rank_ListInfoUI = class(BaseUI)
Rank_ListInfoUI.layer = UILayer.Panel
Rank_ListInfoUI.orderInLayer = 2
Rank_ListInfoUI.hideType = UIHideType.Hide
Rank_ListInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Rank_ListInfoUI.escClose = UIEscClose.DontClose

function Rank_ListInfoUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.tog_fightlist = self:GetControl("tog_group/tog_fightlist")
  self.tog_levellist = self:GetControl("tog_group/tog_levellist")
  self.tog_towerlist = self:GetControl("tog_group/tog_towerlist")
  self.tog_crossFight = self:GetControl("tog_group/tog_crossFight")
  self.tog_crossLevel = self:GetControl("tog_group/tog_crossLevel")
  self.tog_crossThree = self:GetControl("tog_group/tog_crossThree")
  self.tog_Attacklist = self:GetControl("tog_group/tog_Attacklist")
  self.panel_list = self:GetControl("tog_group_career/panel_list")
  self.tog_fighgt_career = self:GetControl("tog_group_career/panel_list/tog_fighgt_career")
  self.tog_fighgt_jianshi = self:GetControl("tog_group_career/panel_list/tog_fighgt_jianshi")
  self.tog_fighgt_fashi = self:GetControl("tog_group_career/panel_list/tog_fighgt_fashi")
  self.tog_fighgt_gongjian = self:GetControl("tog_group_career/panel_list/tog_fighgt_gongjian")
  self.tog_fighgt_mojianshi = self:GetControl("tog_group_career/panel_list/tog_fighgt_mojianshi")
  self.tog_fighgt_shengdao = self:GetControl("tog_group_career/panel_list/tog_fighgt_shengdao")
  self.tog_fighgt_zhaohuanshi = self:GetControl("tog_group_career/panel_list/tog_fighgt_zhaohuanshi")
  self.scroll_View = self:GetControl("scroll_View")
  self.fightCross_Level = self:GetControl("fightCross_Level")
  self.level = self:GetControl("fightCross_Level/SegLevel/level")
  self.imgLevelCount = self:GetControl("fightCross_Level/SegLevel/level/imgLevelCount")
  self.ImgtitleName = self:GetControl("fightCross_Level/SegLevel/titleBg/ImgtitleName")
  self.stars1 = self:GetControl("fightCross_Level/SegLevel/stars/starBg/imgStar1")
  self.stars2 = self:GetControl("fightCross_Level/SegLevel/stars/starBg/imgStar2")
  self.stars3 = self:GetControl("fightCross_Level/SegLevel/stars/starBg/imgStar3")
  self.stars4 = self:GetControl("fightCross_Level/SegLevel/stars/starBg/imgStar4")
  self.stars5 = self:GetControl("fightCross_Level/SegLevel/stars/starBg/imgStar5")
  self.bg_list = self:GetControl("bg_list")
  self.myRankInfo = self:GetControl("myRankInfo/myRank")
  self.img_bg = self:GetControl("bg_list/img_bg")
  self.go_model = self:GetControl("go_model")
  self.btn_check = self:GetControl("btn_check")
  self.btn_close = self:GetControl("btn_close")
  self.lab_myranking = self:GetControl("lab_myranking")
  self.img_no_data = self:GetControl("img_no_data")
  self.lab_no_data = self:GetControl("img_no_data/lab_no_data")
  self.txt_playerLv = self:GetControl("txt_playerLv")
end

function Rank_ListInfoUI:Init()
  self.topTogList = {}
  self.togCareerList = {}
end

function Rank_ListInfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Rank_ListInfoUI:InitUI()
  self:InitTopToggle()
  self:InitToggleCareer()
  self:InitDefaultOption()
end

function Rank_ListInfoUI:InitTopToggle()
  self.tog_fightlist.rankType = RANKTYPE.fight
  self.tog_levellist.rankType = RANKTYPE.level
  self.tog_towerlist.rankType = RANKTYPE.tower
  self.tog_crossFight.rankType = RANKTYPE.crossFight
  self.tog_crossLevel.rankType = RANKTYPE.crossLevel
  self.tog_Attacklist.rankType = RANKTYPE.attack
  self.tog_crossThree.rankType = RANKTYPE.CrossThree
  self.topTogList[#self.topTogList + 1] = self.tog_fightlist
  self.topTogList[#self.topTogList + 1] = self.tog_levellist
  self.topTogList[#self.topTogList + 1] = self.tog_towerlist
  self.topTogList[#self.topTogList + 1] = self.tog_crossFight
  self.topTogList[#self.topTogList + 1] = self.tog_crossLevel
  self.topTogList[#self.topTogList + 1] = self.tog_Attacklist
  self.topTogList[#self.topTogList + 1] = self.tog_crossThree
end

function Rank_ListInfoUI:InitToggleCareer()
  table.insert(self.togCareerList, self.tog_fighgt_career)
  table.insert(self.togCareerList, self.tog_fighgt_jianshi)
  table.insert(self.togCareerList, self.tog_fighgt_fashi)
  table.insert(self.togCareerList, self.tog_fighgt_gongjian)
  table.insert(self.togCareerList, self.tog_fighgt_mojianshi)
  table.insert(self.togCareerList, self.tog_fighgt_shengdao)
  table.insert(self.togCareerList, self.tog_fighgt_zhaohuanshi)
  local careerTable = {
    [1] = ERoleCareer.All,
    [2] = ERoleCareer.SwordMan,
    [3] = ERoleCareer.Magic,
    [4] = ERoleCareer.Archer,
    [5] = ERoleCareer.SpellSword,
    [6] = ERoleCareer.HolyMaster,
    [7] = ERoleCareer.SummonMagician
  }
  for i, v in pairs(careerTable) do
    if tonumber(v) > 0 then
      self.togCareerList[i].career = tonumber(v) % 10
    else
      self.togCareerList[i].career = v
    end
  end
  self.starNum = {
    [1] = self.stars1,
    [2] = self.stars2,
    [3] = self.stars3,
    [4] = self.stars4,
    [5] = self.stars5
  }
  for i, v in ipairs(self.starNum) do
    v:SetActive(false)
  end
end

function Rank_ListInfoUI:InitDefaultOption()
  self.isRefreshSelectRole = false
  self.selectRankType = RANKTYPE.fight
  self:SetCareer(ERoleCareer.All)
end

function Rank_ListInfoUI:UpdateViewModel(_, viewRoleData)
  if viewRoleData == nil then
    self.isRefreshSelectRole = true
    return
  end
  local animationName = "showstand"
  if self.selectViewRoleIndex == 1 then
    if RoleUtility.GetBasicCareer(viewRoleData.career) == ERoleCareer.Archer then
      animationName = "allSit"
    else
      animationName = "sit"
    end
    self.go_model:SetOnDrag(self, self.DontDoNothing)
  else
    self.go_model:SetOnDrag(self, self.DragViewRole)
  end
  viewRoleData.parent = self.go_model.transform
  viewRoleData.animationName = animationName
  viewRoleData.circleRotation = Vector3:CircleRotation_UI()
  if self.selectRankType == RANKTYPE.CrossThree then
    self.fightCross_Level:SetActive(true)
    local rankData = self:GetPlayerRankData(self.selectViewRoleIndex)
    local cfgData = ClientTable.cfg_PVP_3v3_team_stageManager:GetTabDataByStageAndLevel(rankData.pvpStage, rankData.pvpStageLevel)
    self:SetSprite("Atlas_Language", cfgData.stageNameBg, self.level)
    self:SetSprite("Atlas_Language", cfgData.stageLevelName, self.imgLevelCount)
    self:SetSprite("Atlas_Language", cfgData.stageName, self.ImgtitleName)
    local starsNum = tonumber(cfgData.stageStarsNum)
    for i, v in ipairs(self.starNum) do
      if i <= starsNum then
        v:SetActive(true)
      else
        v:SetActive(false)
      end
    end
  else
    self.fightCross_Level:SetActive(false)
  end
  if self.ViewRole then
    if self.ViewRole.id == viewRoleData.id and self.isRefreshSelectRole == false then
      return
    end
    self.ViewRole:Destroy()
    if type(self.buffEffectLids) == "table" then
      gameMgr:GetEffectManager():GetBuffEffectProcessor():RemoveEffects(self.buffEffectLids)
    end
    self.ViewRole = ViewRole(viewRoleData)
    self.ViewRole.viewRoleData = viewRoleData
    self.ViewRole:SetPosition(-35, -110, -350)
    self.isRefreshSelectRole = false
  else
    self.ViewRole = ViewRole(viewRoleData)
    self.ViewRole:SetPosition(-35, -110, -350)
  end
  self.ViewRole:SetBuffAnchorDepth(-2)
  self.ViewRole.viewRoleData = viewRoleData
  if self.ViewRole.viewRoleData.buffs ~= nil then
    self.buffEffectLids = gameMgr:GetEffectManager():GetBuffEffectProcessor():AddEffects(viewRoleData.buffs, self.ViewRole.model.BuffAnchor)
  end
  self.btn_check.id = viewRoleData.id
  self.btn_check.roleName = viewRoleData.roleName
  self.btn_check.equipData = viewRoleData.equipsData
  self.btn_check.unionName = viewRoleData.unionName
  self.btn_check.unionPosition = viewRoleData.unionPosition
  self.btn_check.fightValue = viewRoleData.fightValue
  self.ViewRole:SetRotation(0, 180, 0)
  self:ShowLab()
end

function Rank_ListInfoUI:DragViewRole(control, eventData)
  if self.ViewRole then
    local rotY = self.ViewRole:GetRotation().y
    rotY = rotY - eventData.delta.x
    self.ViewRole:SetRotation(0, rotY, 0)
  end
end

function Rank_ListInfoUI:DontDoNothing(control, eventData)
end

function Rank_ListInfoUI:AddViewRoleDragClick()
end

function Rank_ListInfoUI:UpdateRoleModel(control)
  control:SetInteractable(false)
  control.img_select:SetActive(true)
  control.rankLevel:SetColor("0xFFFFFFFF")
  control.img_rank:SetColor("0xFFFFFFFF")
  local allLoadCell = self.rankListTableView:GetAllLoadCell()
  for i, v in pairs(allLoadCell) do
    local btn = v.loadedCell.btn
    if btn.index ~= control.index then
      btn:SetInteractable(true)
      btn.img_select:SetActive(false)
      btn.rankLevel:SetColor("0x9F9F9FFF")
      btn.img_rank:SetColor("0x9F9F9FFF")
    end
  end
  self.selectViewRoleIndex = control.index
  local selectTable = {
    rankType = self.selectRankType,
    selectCareer = self.selectCareer,
    index = self.selectViewRoleIndex
  }
  self:ShowLab()
  EventManager.Dispatch(Event.Rank_UpdateViewRoleData, selectTable)
end

function Rank_ListInfoUI:UpdateRankTableview()
  self.selectViewRoleIndex = 1
  if not self.rankListTableView then
    self:CreateTableView()
  else
    self.rankListTableView:ReloadData(1)
  end
  self:UpdateRankView()
  self:ShowLab()
end

function Rank_ListInfoUI:GetRankData()
  local rankTab = RankListData.RankListAll[self.selectRankType]
  local careerTab = rankTab and RankListData.RankListAll[self.selectRankType][self.selectCareer] or {}
  return careerTab
end

function Rank_ListInfoUI:GetPlayerRankData(index)
  local roleIndex = index or index and self.selectViewRoleIndex
  local rankTab = RankListData.RankListAll[self.selectRankType]
  local careerTab = rankTab and RankListData.RankListAll[self.selectRankType][self.selectCareer]
  local playerRankData = careerTab and RankListData.RankListAll[self.selectRankType][self.selectCareer][roleIndex] or {}
  return playerRankData
end

function Rank_ListInfoUI:CreateTableView()
  self.rankListTableView = UITableView()
  self.rankListTableView:SetLowerMargin(0)
  self.rankListTableView:SetScrollView(self.scroll_View)
  self.rankListTableView:SetScalarForCellInTableView(self, self.ScalarForCellInTableView)
  self.rankListTableView:SetUpperMargin(0)
  self.rankListTableView:SetResetCellCallback(self, self.ResetBgList)
  self.rankListTableView:SetTotalCellCount(self, self.NumberOfCellsInTableView)
  self.rankListTableView:SetCellAtIndexInTableView(self, self.CellAtIndexInTableView)
  self.rankListTableView:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInTableViewWillAppear)
  self.rankListTableView:ReloadData(1)
  self.rankListTableView:ScrollToCell(1, true)
end

function Rank_ListInfoUI:ScalarForCellInTableView()
  local _, sizeY = self.bg_list:GetSizeDelta()
  return sizeY
end

function Rank_ListInfoUI:ResetBgList(cell)
  for i = 1, 4 do
    local bottom = cell:GetChild(string.format("img_rankBottom%d", i))
    bottom:SetInteractable(true)
  end
end

function Rank_ListInfoUI:NumberOfCellsInTableView()
  local rankData = self:GetRankData()
  local count = rankData and table.count(rankData) or 0
  return count
end

function Rank_ListInfoUI:CellAtIndexInTableView(index)
  return self.rankListTableView:ReuseOrCreateCell(self.bg_list)
end

function Rank_ListInfoUI:UpdateRankBottom(cell, index)
  local bottom4 = cell:GetChild(string.format("img_rankBottom%d", 4))
  local resBottom
  for i = 1, 3 do
    local bottom = cell:GetChild(string.format("img_rankBottom%d", i))
    if i == index then
      bottom:SetActive(true)
      resBottom = bottom
      bottom4:SetActive(false)
    else
      bottom:SetActive(false)
    end
  end
  if resBottom then
    return resBottom
  else
    bottom4:SetActive(true)
    return bottom4
  end
end

function Rank_ListInfoUI:CellAtIndexInTableViewWillAppear(index)
  local rankData = self:GetRankData()
  local cell = self.rankListTableView:GetLoadedCell(index)
  local rankLevel = cell:GetChild("lab_ranking")
  local img_rank = cell:GetChild("img_rank")
  local labName = cell:GetChild("lab_name")
  local img_career = cell:GetChild("img_career")
  local lab_union = cell:GetChild("lab_union")
  local img_select = cell:GetChild("img_select")
  local btn_check = cell:GetChild("btn_check")
  if not rankData or not rankData[index] then
    return
  end
  local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(rankData[index].career, "id").headPortrait
  self:SetSprite("Atlas_headPortrait", spriteName, img_career)
  if 1 <= index and index <= 3 then
    local rankStr = string.format("ico_l%d", index)
    self:SetSprite("Atlas_Main", rankStr, img_rank)
    rankLevel:SetActive(false)
    img_rank:SetActive(true)
  elseif 3 < index then
    rankLevel:SetActive(true)
    img_rank:SetActive(false)
    rankLevel:SetText(index)
  end
  local btn = self:UpdateRankBottom(cell, index)
  cell.btn = btn
  if RoleManager.me.id == rankData[index].lid then
    if self.selectRankType == RANKTYPE.crossFight or self.selectRankType == RANKTYPE.crossLevel then
      labName:SetText(string.format("S%s.<color=#1ADD1F>%s</color>", rankData[index].sid, rankData[index].name))
    else
      labName:SetText(string.format("<color=#1ADD1F>%s</color>", rankData[index].name))
    end
  elseif self.selectRankType == RANKTYPE.crossFight or self.selectRankType == RANKTYPE.crossLevel then
    labName:SetText(string.format("S%s.%s", rankData[index].sid, rankData[index].name))
  else
    labName:SetText(rankData[index].name)
  end
  if self.selectRankType == RANKTYPE.level or self.selectRankType == RANKTYPE.crossLevel then
    if RoleManager.me.id == rankData[index].lid then
      local unionName = rankData[index].unionName == "" and "Tr\225\187\145ng" or string.format("<color=#1ADD1F>%s</color>", rankData[index].unionName)
      lab_union:SetText("Guild: " .. unionName)
    else
      local unionName = rankData[index].unionName == "" and "Tr\225\187\145ng" or rankData[index].unionName
      lab_union:SetText("Guild: " .. unionName)
    end
  elseif self.selectRankType == RANKTYPE.fight or self.selectRankType == RANKTYPE.crossFight then
    if RoleManager.me.id == rankData[index].lid then
      local unionName = rankData[index].unionName == "" and "Tr\225\187\145ng" or string.format("<color=#1ADD1F>%s</color>", rankData[index].unionName)
      lab_union:SetText("Guild: " .. unionName)
    else
      local unionName = rankData[index].unionName == "" and "Tr\225\187\145ng" or rankData[index].unionName
      lab_union:SetText("Guild: " .. unionName)
    end
  elseif self.selectRankType == RANKTYPE.attack then
    if RoleManager.me.id == rankData[index].lid then
      local unionName = rankData[index].unionName == "" and "Tr\225\187\145ng" or string.format("<color=#1ADD1F>%s</color>", rankData[index].unionName)
      lab_union:SetText("Guild: " .. unionName)
    else
      local unionName = rankData[index].unionName == "" and "Tr\225\187\145ng" or rankData[index].unionName
      lab_union:SetText("Guild: " .. unionName)
    end
  elseif self.selectRankType == RANKTYPE.tower then
    if RoleManager.me.id == rankData[index].lid then
      local floorNumber = rankData[index].layers == "" and "Tr\225\187\145ng" or string.format("<color=#1ADD1F>%s</color>", rankData[index].layers)
      lab_union:SetText("S\225\187\145 t\225\186\167ng: " .. floorNumber)
    else
      local floorNumber = rankData[index].layers == "" and "Tr\225\187\145ng" or rankData[index].layers
      lab_union:SetText("S\225\187\145 t\225\186\167ng: " .. floorNumber)
    end
  elseif self.selectRankType == RANKTYPE.CrossThree then
    local cfgData = ClientTable.cfg_PVP_3v3_team_stageManager:GetTabDataByStageAndLevel(rankData[index].pvpStage, rankData[index].pvpStageLevel)
    if RoleManager.me.id == rankData[index].lid then
      local floorNumber = cfgData.name == "" and "Tr\225\187\145ng" or string.format("<color=#1ADD1F>%s</color>", cfgData.name)
      lab_union:SetText("Th\225\187\169 h\225\186\161ng: " .. floorNumber)
    else
      local floorNumber = cfgData.name == "" and "Tr\225\187\145ng" or cfgData.name
      lab_union:SetText("Th\225\187\169 h\225\186\161ng: " .. floorNumber)
    end
  end
  btn.index = index
  btn.img_select = img_select
  btn.btn_check = btn_check
  btn.rankLevel = rankLevel
  btn.img_rank = img_rank
  if self.selectViewRoleIndex == index then
    btn:SetInteractable(false)
    img_select:SetActive(true)
    rankLevel:SetColor("0xFFFFFFFF")
    img_rank:SetColor("0xFFFFFFFF")
  else
    btn:SetInteractable(true)
    img_select:SetActive(false)
    rankLevel:SetColor("0x9F9F9FFF")
    img_rank:SetColor("0x9F9F9FFF")
  end
  btn:SetOnClick(self, self.UpdateRoleModel)
  img_career.id = rankData[index].lid
  img_career.index = index
  img_career.hostId = rankData[index].hostId
  img_career:SetOnClick(self, self.btn_checkOnClick)
end

function Rank_ListInfoUI:ShowLab()
  local labStr = ""
  local rankData = self:GetRankData()
  local targetRankData = rankData[self.selectViewRoleIndex]
  self.txt_playerLv:SetActive(targetRankData ~= nil)
  if not targetRankData then
    return
  end
  if self.selectRankType == RANKTYPE.fight or self.selectRankType == RANKTYPE.crossFight then
    local cfg = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("RankPage_1")
    local fight = targetRankData.fightValue
    labStr = string.format(cfg, fight)
  elseif self.selectRankType == RANKTYPE.level or self.selectRankType == RANKTYPE.crossLevel then
    local cfg = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("RankPage_2")
    local level = targetRankData.level
    labStr = string.format(cfg, level)
  elseif self.selectRankType == RANKTYPE.attack then
    local cfg = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("RankPage_3")
    local attack = targetRankData.maxAttack
    labStr = string.format(cfg, attack)
  end
  self.txt_playerLv:SetText(labStr)
end

function Rank_ListInfoUI:UpdateRankView()
  local rankData = self:GetRankData()
  local dataCount = table.count(rankData)
  self:SetObjectDisplay(dataCount)
  self:SetDefaultViewRole()
  self:SetRank(dataCount)
end

function Rank_ListInfoUI:SetRank(dataCount)
  if dataCount == 0 then
    self.txt_playerLv:SetActive(false)
    return
  else
    self.txt_playerLv:SetActive(true)
  end
  self:SetMyRank()
end

function Rank_ListInfoUI:SetObjectDisplay(dataCount)
  self.img_no_data:SetActive(dataCount == 0 or false)
  if self.ViewRole then
    self.ViewRole:SetActive(dataCount ~= 0 or false)
  end
end

function Rank_ListInfoUI:ReloadTableView(dataCount, rankData)
  self.rankListTableView:SetTotalCellCount(dataCount)
  self.rankListTableView:SetData(rankData)
  self.rankListTableView:ReloadTableView()
end

function Rank_ListInfoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Rank_ListInfoUI:OnHide()
  if self.ViewRole then
    self.ViewRole:Destroy()
    self.ViewRole = nil
  end
  self.selectCareer = ERoleCareer.All
  self.selectRankType = RANKTYPE.fight
  self:SetCareerSelectEffect()
  if self.refreshRank then
    Timer.Stop(self.refreshRank)
    self.refreshRank = nil
  end
  if type(self.buffEffectLids) == "table" then
    gameMgr:GetEffectManager():GetBuffEffectProcessor():RemoveEffects(self.buffEffectLids)
  end
  self.needOpenRankEquipUI = false
end

function Rank_ListInfoUI:OnDestroy()
  if self.ViewRole then
    self.ViewRole:Destroy()
    self.ViewRole = nil
  end
  self.topTogList = {}
  self.togCareerList = {}
  self.rankListTableView = nil
  if self.refreshRank then
    Timer.Stop(self.refreshRank)
    self.refreshRank = nil
  end
  if type(self.buffEffectLids) == "table" then
    gameMgr:GetEffectManager():GetBuffEffectProcessor():RemoveEffects(self.buffEffectLids)
  end
end

function Rank_ListInfoUI:Destroy()
end

function Rank_ListInfoUI:RegistUIEvents()
  self.btn_check:SetOnClick(self, self.ShowRoleEquip)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self:SetTopToggleClickEvent()
  self:SetCareerToggleClickEvent()
  self:AddViewRoleDragClick()
end

function Rank_ListInfoUI:ShowRoleEquip(control)
  local rankData = self:GetPlayerRankData(self.selectViewRoleIndex)
  self.needOpenRankEquipUI = true
  networkRequest.ReqOtherRoleInfo(0, 0, rankData.lid, rankData.sid)
end

function Rank_ListInfoUI:ChangeRankTypeClick(control)
  local selectEffect = control:GetChild("img_clickeffect1")
  control:SetInteractable(not control.toggle.isOn)
  control:GetChild("lab_list"):SetColor(control:GetIsOn() and "0xDCE1E5FF" or "0x999999FF")
  selectEffect:SetActive(control.toggle.isOn)
  if not control.toggle.isOn then
    return
  end
  self.selectRankType = control.rankType
  self:SetCareer(ERoleCareer.All)
  self.tog_fighgt_career:SetInteractable(false)
  self:SetCareerSelectEffect()
  EventManager.Dispatch(Event.Rank_QueryRanks, control.rankType, ERoleCareer.All)
end

function Rank_ListInfoUI:btn_checkOnClick(control)
  if not control.id then
    return
  end
  if control.id == RoleManager.me.id then
    FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 ch\225\187\141n ch\195\173nh m\195\172nh")
    return
  end
  local rankData = self:GetPlayerRankData(control.index)
  RoleInteractData.roleId = rankData.lid
  RoleInteractData.roleName = rankData.name
  RoleInteractData.unionId = rankData.unionId
  RoleInteractData.career = rankData.career
  RoleInteractData.unionName = rankData.unionName
  RoleInteractData.unionPosition = rankData.unionPosition
  RoleInteractData.fight = rankData.fightValue
  RoleInteractData.level = rankData.level
  RoleInteractData.serverId = rankData.sid
  RoleInteractData.interactType = RoleOpenType.RankOpen
  NetManager.Send(RoleMessage.ReqTeamEquipsInfo, {
    roleId = control.id,
    hostId = control.hostId
  })
end

function Rank_ListInfoUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Rank_ListInfoUI)
end

function Rank_ListInfoUI:SetTopToggleClickEvent()
  for i, v in ipairs(self.topTogList) do
    v:SetOnToggleChanged(self, self.ChangeRankTypeClick)
  end
end

function Rank_ListInfoUI:SetCareerToggleClickEvent()
  for i, v in ipairs(self.togCareerList) do
    v:SetOnClick(self, self.UpdateCareerTableView)
  end
end

function Rank_ListInfoUI:SetCareerSelectEffect()
  for i, v in ipairs(self.togCareerList) do
    local selectEffect = v:GetChild("img_clickeffect2")
    selectEffect:SetActive(self.selectCareer == v.career)
    v:GetChild("Label"):SetColor(self.selectCareer == v.career and "0xE5E5E5FF" or "0x999999FF")
    v:SetInteractable(self.selectCareer ~= v.career)
  end
end

function Rank_ListInfoUI:UpdateCareerTableView(control)
  self:SetCareer(control.career)
  self:SetCareerSelectEffect()
  EventManager.Dispatch(Event.Rank_QueryRanks, self.selectRankType, control.career)
end

function Rank_ListInfoUI:UpdatePrivateRank()
  local imgCareer = self.myRankInfo:GetChild("img_career")
  local lab_name = self.myRankInfo:GetChild("lab_name")
  local lab_union = self.myRankInfo:GetChild("lab_union")
  local rankLevel = self.myRankInfo:GetChild("lab_ranking")
  local img_rank = self.myRankInfo:GetChild("img_rank")
  local img_wu = self.myRankInfo:GetChild("img_wu")
  local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(RoleManager.me.career, "id").headPortrait
  self:SetSprite("Atlas_headPortrait", spriteName, imgCareer)
  lab_name:SetText(RoleManager.me.name)
  if spriteName then
  end
  if self.selectRankType == RANKTYPE.CrossThree then
    local cfgData
    local rankData = self:GetRankData()
    for i, v in ipairs(rankData) do
      if v.lid == RoleManager.me.data.id then
        cfgData = ClientTable.cfg_PVP_3v3_team_stageManager:GetTabDataByStageAndLevel(v.pvpStage, v.pvpStageLevel)
        break
      end
    end
    if cfgData then
      lab_union:SetText("Th\225\187\169 h\225\186\161ng: " .. cfgData.name)
    else
      lab_union:SetText("Rank: Kh\195\180ng")
    end
  else
    lab_union:SetText("Guild: " .. (RoleManager.me.data.unionName ~= "" and RoleManager.me.data.unionName or "Tr\225\187\145ng"))
  end
  if self.selectCareer ~= RoleUtility.GetRankBasicCareer(RoleManager.me.career) and self.selectCareer ~= ERoleCareer.All then
    img_rank:SetActive(false)
    rankLevel:SetActive(false)
    img_wu:SetActive(true)
  else
    local count = table.count(self:GetRankData())
    for index = 1, count do
      if RoleManager.me.id == RankListData.GetPlayerId(self.selectRankType, self.selectCareer, index) then
        img_wu:SetActive(false)
        if 1 <= index and index <= 3 then
          local rankStr = string.format("ico_l%d", index)
          self:SetSprite("Atlas_Main", rankStr, img_rank)
          rankLevel:SetActive(false)
          img_rank:SetActive(true)
        elseif 3 < index then
          rankLevel:SetActive(true)
          img_rank:SetActive(false)
          rankLevel:SetText(index)
        end
        return
      end
    end
    img_wu:SetActive(true)
    img_rank:SetActive(false)
    rankLevel:SetActive(false)
  end
end

function Rank_ListInfoUI:SetMyRank()
  self:UpdatePrivateRank()
end

function Rank_ListInfoUI:SetCareer(career)
  self.selectCareer = career
end

function Rank_ListInfoUI:SetDefaultViewRole()
  local selectTable = {
    rankType = self.selectRankType,
    selectCareer = self.selectCareer,
    index = self.selectViewRoleIndex
  }
  EventManager.Dispatch(Event.Rank_UpdateViewRoleData, selectTable)
end

function Rank_ListInfoUI:RefreshRankList()
  local function RefreshRank()
    EventManager.Dispatch(Event.Rank_QueryRanks, self.selectRankType, self.selectCareer)
    
    self.isRefreshSelectRole = true
  end
  
  if self.refreshRank then
    Timer.Stop(self.refreshRank)
    self.refreshRank = nil
  end
  self.refreshRank = Timer.StartLoopForever(300, RefreshRank)
end

function Rank_ListInfoUI:RegistEvents()
  self:RegistEvent(Event.Rank_UpdateTableView, self.UpdateRankTableview, self)
  self:RegistEvent(Event.Rank_UpdateViewModel, self.UpdateViewModel, self)
  self:RegistEvent(Event.Rank_EquipInfoUIOpen, self.OnRank_EquipInfoUIOpen, self)
end

function Rank_ListInfoUI:OnRank_EquipInfoUIOpen()
  if self.needOpenRankEquipUI and not UIManager.IsVisible(UIID.Rank_EquipInfoUI) then
    self.needOpenRankEquipUI = false
    local tab = {
      Data = gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetEquipData().Data,
      roleInfo = {
        career = gameMgr:GetAvatarManager():GetOtherPlayer():GetInfo():GetData().career
      },
      Role = nil
    }
    UIManager.Show(UIID.Rank_EquipInfoUI, tab)
  end
end

function Rank_ListInfoUI:Refresh()
  self.root.canvas.overrideSorting = false
  for i = 1, #self.topTogList do
    if self.topTogList[i].rankType == self.selectRankType then
      if self.topTogList[i]:GetIsOn() then
        EventManager.Dispatch(Event.Rank_QueryRanks, self.selectRankType, self.selectCareer)
        break
      end
      self.topTogList[i]:SetIsOn(true)
      break
    end
  end
  self:RefreshRankList()
  self.tog_crossFight:SetActive(CrossRealmData.IsCrossRealm())
  self.tog_crossLevel:SetActive(CrossRealmData.IsCrossRealm())
  self.tog_Attacklist:SetActive(CrossRealmData.IsOpenAtkList())
  self.tog_crossThree:SetActive(CrossRealmData.IsOpenThree())
end
