require("GameModel/Mu2_CrossServer/CrossServerData")
local CrossServerKalunteGomainTemplate = {}
local leaderList = {}
local modeViewerList = {}

function CrossServerKalunteGomainTemplate:Init(rootPanel)
  self.rootPanel = rootPanel
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
end

function CrossServerKalunteGomainTemplate:InitUI()
  self:InitContent()
  self:RefreshGomain()
  self.main_panel:SetActive(true)
  self.detail_panel:SetActive(false)
end

function CrossServerKalunteGomainTemplate:InitControls()
  self.btn_close = self:GetControl("go_detail/btn_close")
  self.btn_detail = self:GetControl("go_main/img_Bg/btn_detail")
  self.detail_panel = self:GetControl("go_detail")
  self.main_panel = self:GetControl("go_main")
  self.btn_winWarBoss = self:GetControl("go_detail/panel_dropReward/Reward_RankReward/OneReward/sw_failedMemberReward/Viewport/Content/btn_failBoy")
  self.btn_failBoy = self:GetControl("go_detail/panel_dropReward/Reward_Drop/dropReward/sw_failedMemberReward/Viewport/Content/btn_failBoy")
  self.btn_PaoDian = self:GetControl("go_detail/panel_dropReward/Reward_PaoDian/paoDianReward/sw_failedMemberReward/Viewport/Content/btn_failBoy")
  self.btn_first = self:GetControl("go_detail/panel_integralReward/tx_integralReward/sw_integralReward/Viewport/Content/firstGear/sw_victoriousLeaderReward/Viewport/Content/btn_first")
  self.btn_second = self:GetControl("go_detail/panel_integralReward/tx_integralReward/sw_integralReward/Viewport/Content/secondGear/sw_victoriousLeaderReward/Viewport/Content/btn_second")
  self.btn_third = self:GetControl("go_detail/panel_integralReward/tx_integralReward/sw_integralReward/Viewport/Content/thirdGear/sw_victoriousLeaderReward/Viewport/Content/btn_third")
  self.btn_fourth = self:GetControl("go_detail/panel_integralReward/tx_integralReward/sw_integralReward/Viewport/Content/fourthGear/sw_victoriousLeaderReward/Viewport/Content/btn_fourth")
  self.btn_fifth = self:GetControl("go_detail/panel_integralReward/tx_integralReward/sw_integralReward/Viewport/Content/fifthGear/sw_victoriousLeaderReward/Viewport/Content/btn_fifth")
  self.btnItem = self:GetControl("go_main/img_Bg/img_ActivityDes/sw_reward/Viewport/Content/btn_Item")
  self.lab_time = self:GetControl("go_main/img_Bg/img_ActivityDes/time/lab_time")
  self.lab_level = self:GetControl("go_main/img_Bg/img_ActivityDes/level/lab_level")
  self.lab_des = self:GetControl("go_main/img_Bg/img_ActivityDes/des/lab_des")
  self.img_frist = self:GetControl("go_main/img_Bg/sw_leaderList/Viewport/Content/img_frist")
  self.img_second = self:GetControl("go_main/img_Bg/sw_leaderList/Viewport/Content/img_second")
  self.img_third = self:GetControl("go_main/img_Bg/sw_leaderList/Viewport/Content/img_third")
  self.btn_goScene = self:GetControl("go_main/img_Bg/btn_goScene")
  self.des_one = self:GetControl("go_detail/panel_rule/Viewport/content/rule_one/ico/txt")
  self.des_two = self:GetControl("go_detail/panel_rule/Viewport/content/rule_two/ico/txt")
  self.des_three = self:GetControl("go_detail/panel_rule/Viewport/content/rule_three/ico/txt")
  self.des_four = self:GetControl("go_detail/panel_rule/Viewport/content/rule_four/ico/txt")
end

local function ItemCreate(control)
  if control.itemCellData then
    control.itemCellData:Reset()
  else
    local itemCellData = ItemCellData()
    control.itemCellData = itemCellData
  end
end

local function ItemRefresh(ctr, _, itemData, ui)
  if not ctr.itemCellData then
    ctr.itemCellData = ItemCellData()
  end
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
end

function CrossServerKalunteGomainTemplate:BindUIEvent()
  self.btn_detail:SetOnClick(self, self.btndetailOnClick)
  self.btn_close:SetOnClick(self, self.btncloseOnClick)
  self.btn_goScene:SetOnClick(self, self.btnJumpActiveOnClick)
  self:RefreshDetail()
end

function CrossServerKalunteGomainTemplate:InitContent()
  self.winBossItemTemp = UIContainer(self.btn_winWarBoss, self.rootPanel, ItemCreate, ItemRefresh)
  self.failBoyItemTemp = UIContainer(self.btn_failBoy, self.rootPanel, ItemCreate, ItemRefresh)
  self.PaoDianItemTemp = UIContainer(self.btn_PaoDian, self.rootPanel, ItemCreate, ItemRefresh)
  self.firstItemTemp = UIContainer(self.btn_first, self.rootPanel, ItemCreate, ItemRefresh)
  self.secondItemTemp = UIContainer(self.btn_second, self.rootPanel, ItemCreate, ItemRefresh)
  self.thirdItemTemp = UIContainer(self.btn_third, self.rootPanel, ItemCreate, ItemRefresh)
  self.fourthItemTemp = UIContainer(self.btn_fourth, self.rootPanel, ItemCreate, ItemRefresh)
  self.fifthItemTemp = UIContainer(self.btn_fifth, self.rootPanel, ItemCreate, ItemRefresh)
  self.rewardSeventhGomainData = UIContainer(self.btnItem, self.rootPanel, ItemCreate, ItemRefresh)
  leaderList = {
    {
      self.img_frist,
      CrossServerMemberType.first
    },
    {
      self.img_second,
      CrossServerMemberType.sccend
    },
    {
      self.img_third,
      CrossServerMemberType.three
    }
  }
end

function CrossServerKalunteGomainTemplate:btndetailOnClick()
  self.detail_panel:SetActive(true)
  self.main_panel:SetActive(false)
end

function CrossServerKalunteGomainTemplate:btncloseOnClick()
  self.detail_panel:SetActive(false)
  self.main_panel:SetActive(true)
end

function CrossServerKalunteGomainTemplate:btnJumpActiveOnClick()
  self:ShowGomainTime()
  self:ShowGomainLevel()
  if not self:CrossServermgr():GetCrossServerData().LevelBol then
    FloatingTipUtility.QuickMsg(string.format(LocalizationUtility.GetContentByKey("Activity_kalunte_9")))
    return
  elseif not self:CrossServermgr():GetCrossServerData().TimeBol then
    FloatingTipUtility.QuickMsg(string.format(LocalizationUtility.GetContentByKey("Activity_kalunte_10")))
    return
  end
  local mapData = {mapId = 107101}
  SceneController.OnReqTransferTransmitMap(nil, mapData)
  UIManager.Hide(UIID.CrossServer_IntoUI)
end

function CrossServerKalunteGomainTemplate:RefreshDetail(data, ui)
  self:ShowDetailItems()
end

function CrossServerKalunteGomainTemplate:ShowDetailItems()
  local winBossItemTemp, failBoyItemTemp, PaoDianItemTemp = self:CrossServermgr():GetCrossServerData():ReturnCrossServer()
  self.winBossItemTemp:SetData(winBossItemTemp)
  self.failBoyItemTemp:SetData(failBoyItemTemp)
  self.PaoDianItemTemp:SetData(PaoDianItemTemp)
  local firstItemTemp, secondItemTemp, thirdItemTemp, fourthItemTemp, fifthItemTemp = self:CrossServermgr():GetCrossServerData():ReturnCrossServerSort()
  self.firstItemTemp:SetData(firstItemTemp)
  self.secondItemTemp:SetData(secondItemTemp)
  self.thirdItemTemp:SetData(thirdItemTemp)
  self.fourthItemTemp:SetData(fourthItemTemp)
  self.fifthItemTemp:SetData(fifthItemTemp)
  self.des_one:SetText(self:ShowGoDaildes("Activity_kalunte_1"))
  self.des_two:SetText(self:ShowGoDaildes("Activity_kalunte_2"))
  self.des_three:SetText(self:ShowGoDaildes("Activity_kalunte_3"))
  self.des_four:SetText(self:ShowGoDaildes("Activity_kalunte_4"))
end

function CrossServerKalunteGomainTemplate:ShowGoDaildes(idname)
  local des = ClientTable.cfg_Ui_wordManager:TryGetValue(idname, "id").content
  return des
end

function CrossServerKalunteGomainTemplate:RefreshGomain(data, ui)
  self:ShowGomainItems()
  self:ShowGomaindes()
end

function CrossServerKalunteGomainTemplate:ShowGomainItems()
  local rewardSeventhGomainData = self:CrossServermgr():GetCrossServerData():ReturnCrossServerGomian()
  self.rewardSeventhGomainData:SetData(rewardSeventhGomainData)
end

function CrossServerKalunteGomainTemplate:ShowGomainTime()
  self.lab_time:SetText(self:CrossServermgr():GetCrossServerData():ReturnCrossServeritemtime())
end

function CrossServerKalunteGomainTemplate:ShowGomainLevel()
  self.lab_level:SetText(self:CrossServermgr():GetCrossServerData():ReturnCrossServerGomianItemLevel())
end

function CrossServerKalunteGomainTemplate:ShowGomaindes()
  self.lab_des:SetText(self:CrossServermgr():GetCrossServerData():ReturnCrossServerGomianitemdes())
end

function CrossServerKalunteGomainTemplate:CrossServermgr()
  if gameMgr:GetAvatarManager() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager()
  end
  return nil
end

function CrossServerKalunteGomainTemplate:Refresh()
  self:btncloseOnClick()
  self:UIControl():SetActive(true)
  self:ShowGomainTime()
  self:ShowGomainLevel()
  self:ShowDetailItems()
  self:ShowGomainItems()
end

function CrossServerKalunteGomainTemplate:SrossServerRankDestory()
  for i, v in ipairs(leaderList) do
    local nameModel = v[1]:GetChild("lab_Name")
    nameModel:SetText("")
    nameModel:SetActive(false)
    local btn_check = v[1]:GetChild("btn_check")
    btn_check:SetActive(false)
    v[1]:GetChild("img_jy"):SetActive(true)
  end
  for i, v in pairs(modeViewerList) do
    v:Destroy()
  end
  modeViewerList = {}
  self:UIControl():SetActive(false)
end

function CrossServerKalunteGomainTemplate:RefreshLeader()
  local winMember = self:CrossServermgr():GetCrossServerData():ReturnCrossServerGomianitem()
  for i, v in ipairs(leaderList) do
    v[1]:GetChild("img_jy"):SetActive(true)
  end
  if not winMember then
    return
  end
  local index = 1
  for i, v in ipairs(leaderList) do
    local name = v[1]:GetChild("lab_Name")
    local btn_check = v[1]:GetChild("btn_check")
    name:SetActive(false)
    if not winMember[index] then
      break
    end
    local winRole = winMember[index]
    if v[2] == index then
      local modelViewer = modeViewerList[index]
      local model = v[1]:GetChild("go_model")
      name:SetActive(true)
      name:SetText(winRole.name)
      v[1]:GetChild("img_jy"):SetActive(false)
      local viewRoleData = {}
      local equipData = RoleEquipData(winRole.equips)
      viewRoleData.equipsData = equipData
      viewRoleData.career = winRole.career
      viewRoleData.modelType = EModelType.Charactor
      viewRoleData.model = 1003
      viewRoleData.id = winRole.lid
      viewRoleData.parent = model.transform
      viewRoleData.serverCoord = Vector2Int()
      viewRoleData.roleType = ERoleType.Player
      if not modelViewer then
        modelViewer = ViewRole(viewRoleData)
        if modelViewer then
          modelViewer:SetPosition(0, -170, -10)
          table.insert(modeViewerList, index, modelViewer)
        end
      else
        modelViewer:RefreshModel(viewRoleData)
      end
      if modelViewer then
        modelViewer:SetRotation(0, -180, 0)
      end
      btn_check:SetActive(true)
      btn_check.id = winRole.lid
      btn_check.index = index
      btn_check.hostId = winRole.hostId
      btn_check:SetOnClick(self, self.btn_checkOnClick)
      index = index + 1
    end
  end
end

function CrossServerKalunteGomainTemplate:btn_checkOnClick(control)
  local rankData = self:GetPlayerRankData(control.index)
  local tab = {
    Data = RoleEquipData(rankData.equips).Data,
    roleInfo = {
      career = rankData.career
    },
    Role = nil
  }
  gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():RefreshAllData(rankData.equips)
  gameMgr:GetAvatarManager():GetOtherPlayer():GetInfo():RefrashData({
    career = rankData.career
  })
  gameMgr:GetAvatarManager():GetOtherPlayer():GetRuneDataMgr():ServerUpdateRuneData(rankData.reRuneInfoPackingInfo)
  gameMgr:GetAvatarManager():GetOtherPlayer():GetHolyRingDataMgr():RefreshOtherHoleData(nil)
  gameMgr:GetAvatarManager():GetOtherPlayer():GetSacredBoneDataMgr():RefreshSacredBoneEquipInfo(rankData)
  if not UIManager.IsVisible(UIID.Rank_EquipInfoUI) then
    UIManager.Show(UIID.Rank_EquipInfoUI, tab)
  else
    UIManager.Hide(UIID.Rank_EquipInfoUI)
  end
end

function CrossServerKalunteGomainTemplate:GetPlayerRankData(index)
  local rankTab = self:CrossServermgr():GetCrossServerData().RankListAll[index]
  local playerRankData = rankTab and self:CrossServermgr():GetCrossServerData().RankListAll[index] or {}
  return playerRankData
end

function CrossServerKalunteGomainTemplate:CrossServerRank()
  networkRequest.ReqQueryRanks(RANKTYPE.Crosskalunte, ERoleCareer.All)
end

return CrossServerKalunteGomainTemplate
