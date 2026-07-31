TeamTempUI = class(BaseUI)
TeamTempUI.layer = UILayer.Background
TeamTempUI.orderInLayer = 2
TeamTempUI.hideType = UIHideType.Hide
TeamTempUI.hideFunc = UIHideFunc.MoveOutOfScreen
TeamTempUI.escClose = UIEscClose.DontClose

function TeamTempUI:InitControls()
  self.RootPanel = self:GetControl("RootPanel")
  self.MemberPanel = self:GetControl("RootPanel/MemberPanel")
  self.Content_Members = self:GetControl("RootPanel/MemberPanel/sc_member/Viewport/Content_Members")
  self.btn_member = self:GetControl("RootPanel/MemberPanel/sc_member/Viewport/Content_Members/btn_member")
  self.btn_invitation = self:GetControl("RootPanel/MemberPanel/btn_invitation")
  self.btn_team = self:GetControl("RootPanel/MemberPanel/btn_team")
  self.lab_memberNum = self:GetControl("RootPanel/MemberPanel/btn_team/lab_memberNum")
  self.NoMemberPanel = self:GetControl("RootPanel/NoMemberPanel")
  self.tog_autoJoin = self:GetControl("RootPanel/NoMemberPanel/tog_autoJoin")
  self.btn_createTeam = self:GetControl("RootPanel/NoMemberPanel/btn_createTeam")
  self.btn_joinTeam = self:GetControl("RootPanel/NoMemberPanel/btn_joinTeam")
  self.go_playerPanelBg = self:GetControl("RootPanel/go_playerPanelBg")
  self.btn_close = self:GetControl("RootPanel/go_playerPanelBg/btn_close")
  self.imgJian = self:GetControl("RootPanel/go_playerPanelBg/imgJian")
  self.sp_playerPanelBg = self:GetControl("RootPanel/go_playerPanelBg/defaultPos/sp_playerPanelBg")
  self.ClickButtonTem = self:GetControl("RootPanel/go_playerPanelBg/defaultPos/sp_playerPanelBg/ClickButtonTem")
  self.topPos = self:GetControl("RootPanel/topPos")
end

function TeamTempUI:OnPreLoad()
end

function TeamTempUI:Init()
  self.frameIndex = 1
  self.clickRoleItemInfo = {}
end

function TeamTempUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function TeamTempUI:InitUI()
  self:InitTeamContent()
  self:RootPanelState(false)
end

function TeamTempUI:OnShow()
  self:RootPanelState(true)
  self:RegistEvents()
  self:UpdateTeamInfo()
end

function TeamTempUI:RootPanelState(state)
  self.RootPanel:SetActive(state)
end

function TeamTempUI:ShowAutoTeam()
  TeamData.SetAutoTeamFlag()
  self.tog_autoJoin.toggle.isOn = TeamData.isAutoInTeam
end

function TeamTempUI:UpdateTeamInfo(id)
  local isInTeam = TeamData.isInTeam
  self:UpdateMemberPanel(isInTeam)
  if isInTeam then
    self:UpdateMemberInfo()
  end
  self:SetLeaderUIItem()
  if self.go_playerPanelBg:GetActive() and self.clickRoleItemInfo and not TeamData.IsTeammate(self.clickRoleItemInfo.rid) then
    self.go_playerPanelBg:SetActive(false)
  end
  self:ShowAutoTeam()
end

function TeamTempUI:SetLeaderUIItem()
  self.btn_invitation:SetActive(TeamData.isLeader)
end

function TeamTempUI:UpdateMemberPanel(isInTeam)
  self.MemberPanel:SetActive(isInTeam)
  self.NoMemberPanel:SetActive(not isInTeam)
end

local function InitMemberInfo(ctr)
  ctr.effect = UIControl(ctr.transform, "img_selectionEffect")
  ctr.careerSp = UIControl(ctr.transform, "sp_careerIcon")
  ctr.lab_level = UIControl(ctr.transform, "lab_level")
  ctr.go_captain = UIControl(ctr.transform, "go_captain")
  ctr.go_noCaptain = UIControl(ctr.transform, "go_noCaptain")
  ctr.leadnameLabel = UIControl(ctr.transform, "go_captain/lab_name")
  ctr.nameLabel = UIControl(ctr.transform, "go_noCaptain/lab_name")
  ctr.sp_offline = UIControl(ctr.transform, "img_offLineBg")
  ctr.sp_far = UIControl(ctr.transform, "img_far")
  ctr.sl_hp = UIControl(ctr.transform, "sl_hp")
  ctr:SetOnClick(ctr, function()
    TeamTempUI:MemberClick(ctr)
    ctr.effect:SetActive(true)
    teamMemberEffect = ctr.effect
  end)
end

local function RefushMemberInfo(ctr, _, member, ui)
  ctr.member = member
  ctr.spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(member.startCareer, "id").headPortrait
  ui:SetSprite("Atlas_headPortrait", ctr.spriteName, ctr.careerSp)
  ctr.lab_level:SetText(string.format("lv.%d", member.startLevel))
  ctr.isCap = member.rid == TeamData.leaderId
  ctr.go_captain:SetActive(ctr.isCap)
  ctr.go_noCaptain:SetActive(not ctr.isCap)
  ctr.leadnameLabel:SetActive(ctr.isCap)
  ctr.leadnameLabel:SetText(member.startName)
  ctr.nameLabel:SetActive(not ctr.isCap)
  ctr.nameLabel:SetText(member.startName)
  if not member.online then
    ctr.sp_offline:SetActive(true)
    ctr.sp_far:SetActive(false)
    ctr.sl_hp:SetActive(false)
    return
  end
  ctr.sp_offline:SetActive(false)
  ctr.role = RoleManager.GetRoleById(member.rid)
  if not ctr.role then
    ctr.sp_far:SetActive(true)
  else
    ctr.sp_far:SetActive(false)
    local roleData = ctr.role.data
    ctr.sl_hp:SetActive(true)
    ctr.sl_hp:SetValue(roleData.hp / ctr.role.maxHp)
  end
end

local function InitBtnInfo(ctr)
  ctr.name = UIControl(ctr.transform, "btnName")
  ctr:SetOnClick(ctr, function()
    ShowBtnItemUtility.OperateType(ctr.btncon.callbackFunc)
    TeamTempUI.go_playerPanelBg:SetActive(false)
    if teamMemberEffect then
      teamMemberEffect:SetActive(false)
    end
  end)
end

local function RefushBtnInfo(ctr, _, btncon, ui)
  ctr.name:SetText(btncon.name)
  ctr.btncon = btncon
end

function TeamTempUI:InitTeamContent()
  self.memberTemp = UIContainer(self.btn_member, self, InitMemberInfo, RefushMemberInfo)
  self.btnTemp = UIContainer(self.ClickButtonTem, self, InitBtnInfo, RefushBtnInfo)
end

function TeamTempUI:UpdateMemberInfo()
  local count = table.count(TeamData.membersList)
  self.lab_memberNum:SetText(string.format("%d/5", count))
  if count < 1 then
    return
  end
  self.memberTemp:SetData(TeamData.membersList)
end

function TeamTempUI:Update()
  if TeamData.isInTeam and self.frameIndex > 50 then
    self:UpdateMemberInfo()
    self.frameIndex = 0
  end
  self.frameIndex = self.frameIndex + 1
end

function TeamTempUI:OnHide()
end

function TeamTempUI:OnDestroy()
end

function TeamTempUI:RegistUIEvents()
  self.btn_invitation:SetOnClick(self, self.TeamInvite)
  self.tog_autoJoin:SetOnToggleChanged(self, self.AutoJoinToggleClick)
  self.btn_close:SetOnClick(self, self.TeamHideUserPanel)
  self.btn_joinTeam:SetOnClick(self, self.JoinTeam)
  self.btn_createTeam:SetOnClick(self, self.CreateTeam)
  self.btn_team:SetOnClick(self, self.TeamInfoClick)
end

function TeamTempUI:CreateTeam()
  if TeamData.GetCreateTeamCondition() then
    EventManager.Dispatch(Event.Team_CreateTeam, nil)
  else
    local titleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamError_1")
    local createLevel = tonumber(GlobalConfig.GetGlobalConfig(2450010))
    local text = string.format(titleStr, createLevel)
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = text
    })
  end
end

function TeamTempUI:JoinTeam()
  EventManager.Dispatch(Event.Team_OpenTeamsPanel, nil)
end

function TeamTempUI:MemberClick(ctr)
  local role = ctr.member
  self.clickRoleItemInfo = role
  self.go_playerPanelBg:SetActive(true)
  if role and role.info then
    RoleInteractData.roleId = role.rid
    RoleInteractData.serverId = role.info.serverId
    RoleInteractData.roleName = role.info.name
    RoleInteractData.unionId = 0
    RoleInteractData.career = role.info.career
    RoleInteractData.unionName = nil
    RoleInteractData.unionPosition = 0
    RoleInteractData.fight = role.info.fight
    RoleInteractData.level = role.info.level
    RoleInteractData.interactType = RoleOpenType.TeamOpen
    RoleInteractData:TeamTempSetData({ctr = ctr})
    networkRequest.ReqOtherRoleInfo(0, 0, role.rid, role.info and role.info.serverId or 0)
    networkRequest.ReqTeamEquipsInfo(role.rid, role.info and role.info.hostId or 0, OtherRoleOpenSource.TeamOpen)
  end
end

function TeamTempUI:RefreshBtns(data)
  self.btnTemp:SetData(data)
end

function TeamTempUI:RefreshBtns(data)
  self.btnTemp:SetData(data)
end

function TeamTempUI:TeamInfoClick()
  EventManager.Dispatch(Event.Team_ReqTeamsInfo, nil)
  local openType = {
    openType = ShowTeamType.MyMemberType
  }
  UIManager.Show(UIID.Team_TeamInfoUI, {type = openType})
end

function TeamTempUI:TeamHideUserPanel()
  self.go_playerPanelBg:SetActive(false)
  if teamMemberEffect then
    teamMemberEffect:SetActive(false)
  end
end

function TeamTempUI:TeamInvite()
  local openType = {
    openType = ShowTeamType.nearGuideType
  }
  UIManager.Show(UIID.Team_TeamInfoUI, {type = openType})
end

function TeamTempUI:AutoJoinToggleClick()
  local autoJoin = false
  EventManager.Dispatch(Event.Team_AutoJoinTeamSet, autoJoin)
end

function TeamTempUI:RegistEvents()
  self:RegistEvent(Event.Team_RefreshTeamInfo, self.UpdateTeamInfo, self)
  self:RegistEvent(Event.Team_RefreshLimitInfo, self.UpdateTeamInfo, self)
end

function TeamTempUI:RetBtnsUI(ctr, count)
  local GridLayoutGroup = self.sp_playerPanelBg.transform:GetComponent("GridLayoutGroup")
  local ContentSizeFitted = self.sp_playerPanelBg.transform:GetComponent("ContentSizeFitter")
  local cell = GridLayoutGroup.cellSize
  local space = GridLayoutGroup.spacing
  local width, height = self.sp_playerPanelBg:GetSizeDelta()
  local curHeight = count * cell.y + count * space.y + GridLayoutGroup.padding.top + GridLayoutGroup.padding.bottom
  local jianTouPos = self.imgJian.transform.position
  jianTouPos.y = ctr.transform.position.y
  self.imgJian.transform.position = jianTouPos
  self.top_Pos = UIManager.uiCamera:WorldToScreenPoint(self.topPos.transform.position)
  if math.abs(self.top_Pos.y - UIManager.uiCamera:WorldToScreenPoint(ctr.transform.position).y) > curHeight / 2 then
    GridLayoutGroup.childAlignment = TextAnchor.MiddleCenter
    self.sp_playerPanelBg.contentSizeFitter.enabled = true
    if ContentSizeFitted ~= nil then
      ContentSizeFitted.verticalFit = FitModeEnum.PreferredSize
    end
    local pos = self.sp_playerPanelBg.transform.position
    pos.y = ctr.transform.position.y
    self.sp_playerPanelBg.transform.position = pos
  else
    GridLayoutGroup.childAlignment = TextAnchor.UpperCenter
    self.sp_playerPanelBg.contentSizeFitter.enabled = false
    self.sp_playerPanelBg:SetSizeDelta(width, curHeight)
    local pos = self.sp_playerPanelBg.transform.localPosition
    pos.y = 0 - ((count - 1) * space.y * 0.5 + (count - 1) * cell.y * 0.5)
    self.sp_playerPanelBg.transform.localPosition = pos
  end
end
