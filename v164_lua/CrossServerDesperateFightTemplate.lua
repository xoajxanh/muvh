local CrossServerDesperateFightTemplate = {}
CrossServerDesperateFightTemplate.leaderList = {}
CrossServerDesperateFightTemplate.modeViewerList = {}
CrossServerDesperateFightTemplate.rewardGoMainData = {}
CrossServerDesperateFightTemplate.rewardData = {}

function CrossServerDesperateFightTemplate:Init(rootPanel)
  self.rootPanel = rootPanel
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
end

function CrossServerDesperateFightTemplate:InitUI()
  self:InitContent()
  self.CrossServerDesReward = UIUtility.BindUIContainerTemp(self.rankGear, LuaComponentTemplates.CrossServerDesRewardTemplate, self, {
    rootPanel = self.rootPanel
  })
  self.main_panel:SetActive(true)
  self.detail_panel:SetActive(false)
end

function CrossServerDesperateFightTemplate:InitControls()
  self.btn_close = self:GetControl("go_detail/btn_close")
  self.btn_detail = self:GetControl("go_main/img_Bg/btn_detail")
  self.btn_goChange = self:GetControl("go_main/img_Bg/btn_goChange")
  self.detail_panel = self:GetControl("go_detail")
  self.main_panel = self:GetControl("go_main")
  self.img_first = self:GetControl("go_main/img_Bg/sw_leaderList/Viewport/Content/img_frist")
  self.img_second = self:GetControl("go_main/img_Bg/sw_leaderList/Viewport/Content/img_second")
  self.img_third = self:GetControl("go_main/img_Bg/sw_leaderList/Viewport/Content/img_third")
  self.btn_goScene = self:GetControl("go_main/img_Bg/btn_goScene")
  self.btn_Item = self:GetControl("go_main/img_Bg/img_ActivityDes/sw_reward/Viewport/Content/btn_Item")
  self.btn_dropFailBoy = self:GetControl("go_detail/panel_dropReward/Viewport/Content/Reward_Drop/dropReward/sw_failedMemberReward/Viewport/Content/btn_failBoy")
  self.btn_oneRewardFailBoy = self:GetControl("go_detail/panel_dropReward/Viewport/Content/Reward_RankReward/OneReward/sw_failedMemberReward/Viewport/Content/btn_failBoy")
  self.btn_twoRewardFailBoy = self:GetControl("go_detail/panel_dropReward/Viewport/Content/Reward_RankReward/TwoReward/sw_failedMemberReward/Viewport/Content/btn_failBoy")
  self.btn_paoDianFailBoy = self:GetControl("go_detail/panel_dropReward/Viewport/Content/Reward_PaoDian/paoDianReward/sw_failedMemberReward/Viewport/Content/btn_failBoy")
  self.rankGear = self:GetControl("go_detail/panel_integralReward/tx_integralReward/sw_integralReward/Viewport/Content/rankGear")
  self.lab_des = self:GetControl("go_main/img_Bg/img_ActivityDes/des/lab_des")
  self.lab_time = self:GetControl("go_main/img_Bg/img_ActivityDes/time/lab_time")
  self.lab_level = self:GetControl("go_main/img_Bg/img_ActivityDes/level/lab_level")
  self.des_one = self:GetControl("go_detail/panel_rule/Viewport/content/rule_one/ico/txt")
  self.des_two = self:GetControl("go_detail/panel_rule/Viewport/content/rule_two/ico/txt")
  self.des_three = self:GetControl("go_detail/panel_rule/Viewport/content/rule_three/ico/txt")
  self.des_four = self:GetControl("go_detail/panel_rule/Viewport/content/rule_four/ico/txt")
end

function CrossServerDesperateFightTemplate:BindUIEvent()
  self.btn_detail:SetOnClick(self, self.BtnDetailOnClick)
  self.btn_close:SetOnClick(self, self.BtnCloseOnClick)
  self.btn_goScene:SetOnClick(self, self.btnJumpActiveOnClick)
  self.btn_goChange:SetOnClick(self, self.btnJumpShopOnClick)
end

function CrossServerDesperateFightTemplate:btnJumpShopOnClick()
  UIManager.Show(UIID.Shop, {type = 21, subtype = 2})
end

function CrossServerDesperateFightTemplate:BtnDetailOnClick()
  self.detail_panel:SetActive(true)
  self.main_panel:SetActive(false)
end

function CrossServerDesperateFightTemplate:BtnCloseOnClick()
  self.detail_panel:SetActive(false)
  self.main_panel:SetActive(true)
end

function CrossServerDesperateFightTemplate:RefreshLevel()
  self.lab_level:SetText(QuickFind:GetKunShouBattleDataMgr():GetWordLevel())
end

function CrossServerDesperateFightTemplate:RefreshTime()
  self.lab_time:SetText(QuickFind:GetKunShouBattleDataMgr():GetWordTime())
end

function CrossServerDesperateFightTemplate:RefreshDes()
  self.lab_des:SetText(QuickFind:GetKunShouBattleDataMgr():GetWordDes())
end

function CrossServerDesperateFightTemplate:Refresh()
  self:BtnCloseOnClick()
  self:UIControl():SetActive(true)
  self:RefreshRewardShow()
  self:RefreshLevel()
  self:RefreshTime()
  self:RefreshDes()
end

function CrossServerDesperateFightTemplate:RefreshRewardShow()
  local rewardGoMainData = QuickFind:GetKunShouBattleDataMgr():ShowRankRewardData()
  if not self.rewardGoMainData then
    return
  end
  for i, v in ipairs(self.rewardGoMainData) do
    v:SetData(rewardGoMainData[i])
  end
  local rewardData = QuickFind:GetKunShouBattleDataMgr():GetSortedAllRankReward()
  self.CrossServerDesReward:SetData(rewardData)
  self.des_one:SetText(self:ShowGoDaildes("Activity_kunshou_1"))
  self.des_two:SetText(self:ShowGoDaildes("Activity_kunshou_2"))
  self.des_three:SetText(self:ShowGoDaildes("Activity_kunshou_3"))
  self.des_four:SetText(self:ShowGoDaildes("Activity_kunshou_4"))
end

function CrossServerDesperateFightTemplate:ShowGoDaildes(idname)
  local des = ClientTable.cfg_Ui_wordManager:TryGetValue(idname, "id").content
  return des
end

function CrossServerDesperateFightTemplate:InitContent()
  local des = ClientTable.cfg_Ui_wordManager:TryGetValue("Activity_kalunte_6", "id").content
  self.lab_des:SetText(des)
  self.itemDataShow = {
    self.btn_Item,
    self.btn_dropFailBoy,
    self.btn_oneRewardFailBoy,
    self.btn_twoRewardFailBoy,
    self.btn_paoDianFailBoy
  }
  self.leaderList = {
    {
      self.img_first,
      CrossServerKunShouType.first
    },
    {
      self.img_second,
      CrossServerKunShouType.second
    },
    {
      self.img_third,
      CrossServerKunShouType.three
    }
  }
  for i, v in ipairs(self.itemDataShow) do
    self.rewardGoMainData[i] = UIUtility.BindUIContainerTemp(v, LuaComponentTemplates.UIItemTemplate, self.rootPanel, {isShowTips = true})
  end
end

function CrossServerDesperateFightTemplate:btnJumpActiveOnClick()
  self:RefreshLevel()
  self:RefreshTime()
  if not QuickFind:GetKunShouBattleDataMgr().LevelBol then
    FloatingTipUtility.QuickMsg(string.format(LocalizationUtility.GetContentByKey("Activity_kunshou_9")))
    return
  elseif not QuickFind:GetKunShouBattleDataMgr().TimeBol then
    FloatingTipUtility.QuickMsg(string.format(LocalizationUtility.GetContentByKey("Activity_kunshou_10")))
    return
  end
  local mapData = {mapId = 107701}
  SceneController.OnReqTransferTransmitMap(nil, mapData)
  UIManager.Hide(UIID.CrossServer_IntoUI)
end

function CrossServerDesperateFightTemplate:RankDestory()
  for i, v in ipairs(self.leaderList) do
    local nameModel = v[1]:GetChild("lab_Name")
    nameModel:SetText("")
    nameModel:SetActive(false)
    local btn_check = v[1]:GetChild("btn_check")
    btn_check:SetActive(false)
    v[1]:GetChild("img_jy"):SetActive(true)
  end
  for i, v in pairs(self.modeViewerList) do
    v:Destroy()
  end
  self.modeViewerList = {}
  self:UIControl():SetActive(false)
end

function CrossServerDesperateFightTemplate:RefreshLeader()
  local winMember = QuickFind:GetKunShouBattleDataMgr():GetRankData()
  for i, v in ipairs(self.leaderList) do
    v[1]:GetChild("img_jy"):SetActive(true)
  end
  if not winMember then
    return
  end
  local index = 1
  for i, v in ipairs(self.leaderList) do
    local name = v[1]:GetChild("lab_Name")
    local btn_check = v[1]:GetChild("btn_check")
    name:SetActive(false)
    if not winMember[index] then
      break
    end
    local winRole = winMember[index]
    if v[2] == index then
      local modelViewer = self.modeViewerList[index]
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
          table.insert(self.modeViewerList, index, modelViewer)
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

function CrossServerDesperateFightTemplate:btn_checkOnClick(control)
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

function CrossServerDesperateFightTemplate:GetPlayerRankData(index)
  local rankTab = QuickFind:GetKunShouBattleDataMgr():GetRankData()[index]
  local playerRankData = rankTab and QuickFind:GetKunShouBattleDataMgr():GetRankData()[index] or {}
  return playerRankData
end

function CrossServerDesperateFightTemplate:CrossServerKunShouRank()
  networkRequest.ReqPlayerTarppedRanks()
end

return CrossServerDesperateFightTemplate
