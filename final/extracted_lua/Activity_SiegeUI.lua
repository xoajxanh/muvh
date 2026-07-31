Activity_SiegeUI = class(BaseUI)
Activity_SiegeUI.layer = UILayer.Panel
Activity_SiegeUI.orderInLayer = 9
Activity_SiegeUI.hideType = UIHideType.WaitDestroy
Activity_SiegeUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_SiegeUI.escClose = UIEscClose.DontClose

function Activity_SiegeUI:InitControls()
  self.btn_close = self:GetControl("img_Bg/btn_close")
  self.lab_occupyWarAllianceName = self:GetControl("img_Bg/lab_occupyWarAlliance/lab_occupyWarAllianceName")
  self.btn_siegeReward = self:GetControl("img_Bg/btn_siegeReward")
  self.btn_goScene = self:GetControl("img_Bg/btn_goScene")
  self.lab_siegeOpenTime = self:GetControl("img_Bg/lab_siegeTime/lab_siegeOpenTime")
  self.descBtn = self:GetControl("descBtn")
  self.img_mainLeader = self:GetControl("img_Bg/go_leaderModel/img_mainLeader")
  self.img_secondLeaderOne = self:GetControl("img_Bg/go_leaderModel/img_secondLeaderOne")
  self.img_secondLeaderTwo = self:GetControl("img_Bg/go_leaderModel/img_secondLeaderTwo")
end

function Activity_SiegeUI:OnPreLoad()
end

function Activity_SiegeUI:Init()
end

function Activity_SiegeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_SiegeUI:InitUI()
  self.img_mainLeader.job = WarAllianceMemberType.Leader
  self.img_secondLeaderOne.job = WarAllianceMemberType.viceLeader
  self.img_secondLeaderTwo.job = WarAllianceMemberType.viceLeader
  self.leaderList = {
    self.img_mainLeader,
    self.img_secondLeaderOne,
    self.img_secondLeaderTwo
  }
  self.modeViewerList = {}
end

function Activity_SiegeUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_SiegeUI:OnHide()
  for i, v in ipairs(self.modeViewerList) do
    v:Destroy()
  end
  self.modeViewerList = {}
end

function Activity_SiegeUI:OnDestroy()
end

function Activity_SiegeUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_siegeReward:SetOnClick(self, self.btn_siegeRewardOnClick)
  self.btn_goScene:SetOnClick(self, self.btn_goSceneOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Activity_SiegeUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Activity_SiegeUI)
  UIManager.Hide(UIID.Activity_SiegeRewardUI)
end

function Activity_SiegeUI:btn_siegeRewardOnClick(control)
  UIManager.Show(UIID.Activity_SiegeRewardUI)
end

function Activity_SiegeUI:btn_goSceneOnClick(control)
  WarAllianceData.TryEnterActivity(1003, self, self.enterActivity)
end

function Activity_SiegeUI:enterActivity()
  if SceneData.mapId ~= 1031001 then
    local mapData = {mapId = 103100101}
    EventManager.Dispatch(Event.Map_ChangeMap, mapData)
    UIManager.Hide(UIID.Activity_SiegeUI)
  end
end

function Activity_SiegeUI:descBtnOnClick(control)
  UIManager.Show(UIID.Activity_SiegeRewardUI)
end

function Activity_SiegeUI:RegistEvents()
end

function Activity_SiegeUI:Refresh()
  self:InitUnionName()
  self:InitOpenTime()
  self:RefreshLeader()
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.siege,
    state = true
  })
end

function Activity_SiegeUI:InitUnionName()
  local unionName = Activity_LuoLanSiegeData.unionWinData and Activity_LuoLanSiegeData.unionWinData.unionName
  unionName = unionName and unionName ~= "" and unionName or "Tr\225\187\145ng"
  self.lab_occupyWarAllianceName:SetText(unionName)
end

function Activity_SiegeUI:InitOpenTime()
  local openActivityCond = ClientTable.cfg_Activity_overviewManager:TryGetValue(1003, "activityId").condition
  local isOpen = ConditionManager.Check4D(openActivityCond)
  local openTime = Activity_LuoLanSiegeData.GetNextOpenActivityTimeNew()
  local timeDateTab = os.date("*t", openTime)
  local openTime = ""
  if timeDateTab then
    openTime = string.format("%s/%s/%s %02d:%02d", timeDateTab.year, timeDateTab.month, timeDateTab.day, 20, 0)
  end
  if isOpen then
    self.lab_siegeOpenTime:SetText(string.GetColorText(openTime, "#00FF1E"))
  else
    self.lab_siegeOpenTime:SetText(string.GetColorText(openTime, "#FF0000"))
  end
end

function Activity_SiegeUI:Tips(tip)
  UIManager.Show(UIID.PromptTipUI, {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = tip,
    okText = "X\195\161c nh\225\186\173n",
    ok = function()
      UIManager.Hide(UIID.PromptTipUI)
    end
  })
end

function Activity_SiegeUI:RefreshLeader()
  local winMember = Activity_LuoLanSiegeData.GetUnionWinMember()
  for i, v in ipairs(self.leaderList) do
    v:GetChild("img_jy"):SetActive(true)
  end
  if not winMember then
    return
  end
  local index = 1
  for i, v in ipairs(self.leaderList) do
    local name = v:GetChild("lab_leaderName")
    name:SetActive(false)
    if not winMember[index] then
      break
    end
    local winRole = winMember[index]
    if v.job == winRole.job then
      local modelViewer = self.modeViewerList[index]
      local model = v:GetChild("go_model")
      name:SetActive(true)
      name:SetText(winRole.roleSummaryInfo.name)
      v:GetChild("img_jy"):SetActive(false)
      local viewRoleData = {}
      local equipData = RoleEquipData(winRole.roleSummaryInfo.equips)
      viewRoleData.equipsData = equipData
      viewRoleData.career = winRole.roleSummaryInfo.career
      viewRoleData.modelType = EModelType.Charactor
      viewRoleData.model = 1003
      viewRoleData.id = winRole.roleSummaryInfo.id
      viewRoleData.parent = model.transform
      viewRoleData.serverCoord = Vector2Int()
      viewRoleData.roleType = ERoleType.Player
      viewRoleData.holyRingInfo = winRole.holyRingInfo
      viewRoleData.circleRotation = Vector3:CircleRotation_UI()
      if not modelViewer then
        modelViewer = ViewRole(viewRoleData)
        modelViewer:SetPosition(0, -170, -10)
        table.insert(self.modeViewerList, index, modelViewer)
      else
        modelViewer:RefreshModel(viewRoleData)
      end
      modelViewer:SetRotation(0, -180, 0)
      index = index + 1
    end
  end
end
