Team_TeamInfoUI = class(BaseUI)
Team_TeamInfoUI.layer = UILayer.Background
Team_TeamInfoUI.orderInLayer = 0
Team_TeamInfoUI.hideType = UIHideType.WaitDestroy
Team_TeamInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Team_TeamInfoUI.escClose = UIEscClose.DontClose

function Team_TeamInfoUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_teamBg/btn_close")
  self.TeamInfoPanel = self:GetControl("img_teamBg/TeamInfoPanel")
  self.go_memberCaptain = self:GetControl("img_teamBg/TeamInfoPanel/TeamMember/Viewport/Content/go_memberCaptain")
  self.go_memberOne = self:GetControl("img_teamBg/TeamInfoPanel/TeamMember/Viewport/Content/go_memberOne")
  self.go_memberTwo = self:GetControl("img_teamBg/TeamInfoPanel/TeamMember/Viewport/Content/go_memberTwo")
  self.go_memberThree = self:GetControl("img_teamBg/TeamInfoPanel/TeamMember/Viewport/Content/go_memberThree")
  self.go_memberFour = self:GetControl("img_teamBg/TeamInfoPanel/TeamMember/Viewport/Content/go_memberFour")
  self.btn_broadcast = self:GetControl("img_teamBg/TeamInfoPanel/btn_broadcast")
  self.btn_applyList = self:GetControl("img_teamBg/TeamInfoPanel/btn_applyList")
  self.btn_leaveTeam = self:GetControl("img_teamBg/TeamInfoPanel/btn_leaveTeam")
  self.btn_create = self:GetControl("img_teamBg/TeamInfoPanel/btn_create")
  self.lab_experienceBonus = self:GetControl("img_teamBg/TeamInfoPanel/lab_experienceBonus/lab_experienceBonus")
  self.btn_tips = self:GetControl("img_teamBg/TeamInfoPanel/lab_experienceBonus/btn_tips")
  self.dp_activity = self:GetControl("img_teamBg/TeamInfoPanel/go_teamSetting/dp_activity")
  self.activityArrow = self:GetControl("img_teamBg/TeamInfoPanel/go_teamSetting/dp_activity/activityArrow")
  self.ActivityTemplate = self:GetControl("img_teamBg/TeamInfoPanel/go_teamSetting/dp_activity/ActivityTemplate")
  self.activityItem1 = self:GetControl("img_teamBg/TeamInfoPanel/go_teamSetting/dp_activity/ActivityTemplate/Viewport/Content/activityItem1")
  self.dp_level = self:GetControl("img_teamBg/TeamInfoPanel/go_teamSetting/dp_level")
  self.levelArrow = self:GetControl("img_teamBg/TeamInfoPanel/go_teamSetting/dp_level/levelArrow")
  self.LevelTemplate = self:GetControl("img_teamBg/TeamInfoPanel/go_teamSetting/dp_level/LevelTemplate")
  self.LevelItem1 = self:GetControl("img_teamBg/TeamInfoPanel/go_teamSetting/dp_level/LevelTemplate/Viewport/Content/LevelItem1")
  self.dp_acceptCondition = self:GetControl("img_teamBg/TeamInfoPanel/go_teamSetting/dp_acceptCondition")
  self.Arrow = self:GetControl("img_teamBg/TeamInfoPanel/go_teamSetting/dp_acceptCondition/Arrow")
  self.Template = self:GetControl("img_teamBg/TeamInfoPanel/go_teamSetting/dp_acceptCondition/Template")
  self.Item1 = self:GetControl("img_teamBg/TeamInfoPanel/go_teamSetting/dp_acceptCondition/Template/Viewport/Content/Item1")
  self.autoApply = self:GetControl("img_teamBg/TeamInfoPanel/autoApply")
  self.TeamNearPanel = self:GetControl("img_teamBg/TeamNearPanel")
  self.NearContent = self:GetControl("img_teamBg/TeamNearPanel/img_list/sw_data/Viewport/NearContent")
  self.sp_teamInfo = self:GetControl("img_teamBg/TeamNearPanel/img_list/sw_data/Viewport/NearContent/sp_teamInfo")
  self.TeamInvitePanel = self:GetControl("img_teamBg/TeamInvitePanel")
  self.sv_memberList = self:GetControl("img_teamBg/TeamInvitePanel/img_show/sv_memberList")
  self.InviteContent = self:GetControl("img_teamBg/TeamInvitePanel/img_show/sv_memberList/Viewport/InviteContent")
  self.sp_dataBg = self:GetControl("img_teamBg/TeamInvitePanel/img_show/sv_memberList/Viewport/InviteContent/sp_dataBg")
  self.TeamApplyPanel = self:GetControl("img_teamBg/TeamApplyPanel")
  self.ApplyContent = self:GetControl("img_teamBg/TeamApplyPanel/img_Bg/img_list/sv_InfoList  /Viewport/ApplyContent")
  self.sp_applydataBg = self:GetControl("img_teamBg/TeamApplyPanel/img_Bg/img_list/sv_InfoList  /Viewport/ApplyContent/sp_applydataBg")
  self.btn_allRefuse = self:GetControl("img_teamBg/TeamApplyPanel/img_Bg/btn_allRefuse")
  self.btn_allAgree = self:GetControl("img_teamBg/TeamApplyPanel/img_Bg/btn_allAgree")
  self.descBtn = self:GetControl("descBtn")
  self.tg_group = self:GetControl("tg_group")
  self.btn_mymember = self:GetControl("tg_group/btn_mymember")
  self.btn_nearteam = self:GetControl("tg_group/btn_nearteam")
  self.btn_guild = self:GetControl("tg_group/btn_guild")
  self.btn_friends = self:GetControl("tg_group/btn_friends")
  self.btn_wars = self:GetControl("tg_group/btn_wars")
  self.btn_apply = self:GetControl("tg_group/btn_apply")
  self.plane_left = self:GetControl("plane_left")
  self.plane_right = self:GetControl("plane_right")
end

function Team_TeamInfoUI:Init()
  self.showInfoIndex = ShowTeamType.MyMemberType
  self.applyInvite = ApplyInviteType.Apply
  self:InitMyMember()
  self:InitNearRoles()
  self:InitApply()
end

function Team_TeamInfoUI:OnCreate()
  self:InitControls()
  self:RegistUIEvents()
  self:InitMyMemberUI()
  self:InitNearRolesUI()
  self:InitNearTeamUI()
  self:InitApplyUI()
  self.showPanel = {
    [1] = self.TeamInfoPanel,
    [2] = self.TeamNearPanel,
    [3] = self.TeamInvitePanel,
    [4] = self.TeamInvitePanel,
    [5] = self.TeamInvitePanel,
    [6] = self.TeamApplyPanel
  }
  self.showBtn = {
    [1] = UIControl(self.btn_mymember.transform, "img_Pressed"),
    [2] = UIControl(self.btn_nearteam.transform, "img_Pressed"),
    [3] = UIControl(self.btn_guild.transform, "img_Pressed"),
    [4] = UIControl(self.btn_friends.transform, "img_Pressed"),
    [5] = UIControl(self.btn_wars.transform, "img_Pressed"),
    [6] = UIControl(self.btn_apply.transform, "img_Pressed")
  }
end

function Team_TeamInfoUI:OnShow()
  self:RegistEvents()
  if self.args ~= nil and self.args.type.openType ~= nil then
    self.showInfoIndex = self.args.type.openType
  end
  self.refushMemberInfoFlag = false
  self:RefushModerLevel()
  self:Refresh()
  self:ShowAutoApplyTeam()
end

function Team_TeamInfoUI:ShowAutoApplyTeam()
  TeamData.SetAutoApplyTeamFlag()
  self.autoApply.toggle.isOn = TeamData.isApplyAutoTeam
end

function Team_TeamInfoUI:OnHide()
  self:SetOnHideMyMember()
end

function Team_TeamInfoUI:OnDestroy()
  self:SetOnDestroyMyMember()
end

function Team_TeamInfoUI:RegistUIEvents()
  self.btn_mymember:SetOnClick(self, self.BtnClickMember)
  self.btn_nearteam:SetOnClick(self, self.BtnClickNearTeam)
  self.btn_guild:SetOnClick(self, self.ClickNearGuid)
  self.btn_friends:SetOnClick(self, self.BtnClickFriends)
  self.btn_wars:SetOnClick(self, self.BtnClickWars)
  self.btn_apply:SetOnClick(self, self.ClickAskList)
  self.dp_activity:SetOnDropDownValueChanged(self, self.DropDownClickActivityModer)
  self.dp_level:SetOnDropDownValueChanged(self, self.SetActivityLevel)
  self.autoApply:SetOnDropDownValueChanged(self, self.AutoApplyToggleClick)
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_broadcast:SetOnClick(self, self.btn_broadcastOnClick)
  self.btn_leaveTeam:SetOnClick(self, self.btn_leaveTeamOnClick)
  self.btn_create:SetOnClick(self, self.CreateTeam)
  self.btn_tips:SetOnClick(self, self.btn_tipsOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_allAgree:SetOnClick(self, self.btn_allAgreeOnClick)
  self.btn_allRefuse:SetOnClick(self, self.btn_allRefuseOnClick)
end

function Team_TeamInfoUI:RegistEvents()
  self:RegistEvent(Event.Team_RefreshTeamInfo, self.Refresh, self)
  self:RegistEvent(Event.Team_RefreshLimitInfo, self.RefushModerLevel, self)
  self:RegistEvent(Event.Friend_ResFriendList, self.Refresh, self)
  self:RegistEvent(Event.WarAlliance_MemberList, self.Refresh, self)
  self:RegistEvent(Event.Team_InviteListUpdate, self.Refresh, self)
  self:RegistEvent(Event.Team_RefushTeamsPanel, self.Refresh, self)
  self:RegistEvent(Event.UI_Show, self.HideMask, self)
  self:RegistEvent(Event.UI_Hide, self.ShowMask, self)
end

function Team_TeamInfoUI:ShowMask(_, msg)
  if msg ~= nil and msg.name == UIID.Rank_EquipInfoUI then
    self.plane_right:SetActive(true)
  end
end

function Team_TeamInfoUI:HideMask(_, msg)
  if msg ~= nil and msg.name == UIID.Rank_EquipInfoUI then
    self.plane_right:SetActive(false)
  end
end

function Team_TeamInfoUI:Refresh()
  if self.showInfoIndex == ShowTeamType.MyMemberType then
    self:ClickMyMember()
  end
  if self.showInfoIndex == ShowTeamType.NearTeamType then
    self:ClickNearTeam()
  end
  if self.showInfoIndex == ShowTeamType.nearGuideType then
    self:ClickNearGuid()
  end
  if self.showInfoIndex == ShowTeamType.MyFriendsType then
    self:ClickFriends()
  end
  if self.showInfoIndex == ShowTeamType.MyWarType then
    self:ClickWars()
  end
  if self.showInfoIndex == ShowTeamType.MyApplyType then
    self:ClickAskList()
  end
end

function Team_TeamInfoUI:ClickAskList()
  if not TeamData.isInTeam then
    self.applyInvite = ApplyInviteType.Invite
    self:ClickInvites()
  else
    self.applyInvite = ApplyInviteType.Apply
    self:ClickApplys()
  end
end

function Team_TeamInfoUI:AutoApplyToggleClick()
  local autoApply = self.autoApply.toggle.isOn
  TeamData.SetApplyAutoInTeam(autoApply)
end

function Team_TeamInfoUI:BtnClickMember()
  if not TeamData.isInTeam then
    self:ClickMyMember()
    return
  end
  self.showInfoIndex = ShowTeamType.MyMemberType
  if not self.refushMemberInfoFlag then
    self.refushMemberInfoFlag = true
    EventManager.Dispatch(Event.Team_ReqTeamsInfo, nil)
  else
    self:Refresh()
  end
end

function Team_TeamInfoUI:ClickMyMember()
  self.showInfoIndex = ShowTeamType.MyMemberType
  for k, v in pairs(self.showPanel) do
    v:SetActive(false)
  end
  for k, v in pairs(self.showBtn) do
    v:SetActive(false)
  end
  self.showPanel[self.showInfoIndex]:SetActive(true)
  self.showBtn[self.showInfoIndex]:SetActive(true)
  self:SetMemberState()
  if not TeamData.isInTeam then
    self:RefushModerLevel()
    for i, v in pairs(self.membersList) do
      local hasMember = TeamData.HasMemberByIndex(i)
      local inviteBgSprite = UIControl(v.transform, "sp_inviteBg")
      inviteBgSprite:SetActive(not hasMember)
      local memberInfoSprite = UIControl(v.transform, "sp_member")
      memberInfoSprite:SetActive(hasMember)
      local inviteBtn = UIControl(inviteBgSprite.transform, "btn_invite")
      inviteBtn:SetActive(true)
      inviteBtn:SetOnClick(self, function()
        local uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_13")
        FloatingTipUtility.QuickMsg(uiWord)
      end)
    end
    return
  end
  self:InitMyMemberSetInfo()
  self:RefushMyMember()
end

function Team_TeamInfoUI:CreateTeam()
  if TeamData.GetCreateTeamCondition() then
    EventManager.Dispatch(Event.Team_CreateTeam, nil)
  else
    local titleStr = ""
    local tableTemp = ClientTable.cfg_Ui_wordManager:TryGetValue("TeamError_1")
    if tableTemp ~= nil then
      titleStr = tableTemp.content
    end
    local createLevel = tonumber(GlobalConfig.GetGlobalConfig(2450010))
    local text = string.format(titleStr, createLevel)
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = text
    })
  end
end

function Team_TeamInfoUI:InitMyMember()
  self.curOption = {}
  self.refushMemberInfoFlag = false
end

function Team_TeamInfoUI:InitMyMemberUI()
  self.membersList = {}
  self.modeViewerList = {}
  self.membersGoList = {
    self.go_memberCaptain,
    self.go_memberOne,
    self.go_memberTwo,
    self.go_memberThree,
    self.go_memberFour
  }
  for i = 1, 5 do
    table.insert(self.membersList, i, self.membersGoList[i])
  end
  self:InitMyMemberSetInfo()
end

function Team_TeamInfoUI:InitMyMemberSetInfo()
  if TeamData.isLeader or not TeamData.isInTeam then
    self.dp_activity:SetSelectValue(TeamData.activityOption)
    TeamData.SetDemonSquare()
    self.dp_level.dropdown:ClearOptions()
    self.curOption = {}
    for _, option in pairs(TeamData.GetOptionList()) do
      if option.optionFlag then
        table.insert(self.curOption, option)
        self.dp_level.dropdown:AddOption(option.optionName)
      end
    end
    self.dp_level:SetSelectValue(TeamData.activityLevelOption)
  end
end

function Team_TeamInfoUI:DropDownClickActivityModer()
  if TeamData.isLeader then
    if self.dp_activity:GetSelectValue() > 0 and SceneData.serverType == serverType.span then
      local uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_22")
      FloatingTipUtility.QuickMsg(uiWord)
      self.dp_activity:SetSelectValue(TeamData.activityOption)
      return
    end
    TeamData.SetActivityType(self.dp_activity:GetSelectValue())
    self.dp_level.dropdown:ClearOptions()
    self.curOption = {}
    for _, option in pairs(TeamData.GetOptionList()) do
      if option.optionFlag then
        table.insert(self.curOption, option)
        self.dp_level.dropdown:AddOption(option.optionName)
      end
    end
    TeamData.SetActivityLevel(0, self.curOption)
  else
    self.dp_activity:SetSelectValue(TeamData.activityOption)
  end
end

function Team_TeamInfoUI:SetActivityLevel()
  if TeamData.isLeader then
    TeamData.SetActivityLevel(tonumber(self.dp_level.dropdown.value), self.curOption)
  else
    self.dp_level.dropdown:ClearOptions()
    local option = TeamData.GetCurLevelTable()
    if option and option.optionName then
      self.dp_level.dropdown:AddOption(option.optionName)
      self.dp_level.dropdown.value = tonumber(0)
    end
  end
end

function Team_TeamInfoUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Team_TeamInfoUI)
end

function Team_TeamInfoUI:btn_broadcastOnClick(control)
  if not TeamData.isInTeam then
    local uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_13")
    FloatingTipUtility.QuickMsg(uiWord)
    return
  end
  local TeamDesc_4 = ""
  local tableTemp = ClientTable.cfg_Ui_wordManager:TryGetValue("TeamDesc_4")
  if tableTemp ~= nil then
    TeamDesc_4 = tableTemp.content
  end
  local txt = string.format("<a href=[JoinTeam:6]>" .. TeamDesc_4 .. "</a>", table.count(TeamData.membersList))
  if TeamData.activityOption ~= TeamActivityType.None and TeamData.activityLevelOption ~= nil and self.curOption ~= nil and self.curOption[TeamData.activityLevelOption + 1] then
    TeamData.SetCurRecruit(self.curOption[TeamData.activityLevelOption + 1])
    local str = ""
    if TeamData.activityOption == TeamActivityType.ColorCastle then
      str = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_11")
    end
    if TeamData.activityOption == TeamActivityType.DemonSquare then
      str = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_12")
    end
    local TeamDesc_19_Content = ""
    local TeamDesc_19 = ClientTable.cfg_Ui_wordManager:TryGetValue("TeamDesc_19")
    if TeamDesc_19 ~= nil then
      TeamDesc_19_Content = tableTemp.content
    end
    local desshow = string.format(TeamDesc_19_Content, self.curOption[TeamData.activityLevelOption + 1].number, self.curOption[TeamData.activityLevelOption + 1].lowLevel, self.curOption[TeamData.activityLevelOption + 1].hightLevel)
    local TeamDesc_10_Content = ""
    local TeamDesc_10 = ClientTable.cfg_Ui_wordManager:TryGetValue("TeamDesc_10")
    if TeamDesc_10 ~= nil then
      TeamDesc_10_Content = tableTemp.content
    end
    local option = TeamData.GetCurLevelTable()
    local levelDes = ""
    if option and (option.hightLevel ~= 0 or option.lowLevel ~= 0) then
      levelDes = option.optionName
    end
    txt = string.format("<a href=[JoinTeam:6]>" .. str .. levelDes .. TeamDesc_10_Content .. "</a>", table.count(TeamData.membersList))
  end
  local data = {
    inputData = {
      ["[JoinTeam:6]"] = {
        type = ChatInfoEnum.JOIN_TEAM,
        teamId = TeamData.teamId
      }
    },
    message = txt
  }
  local msg = {
    chatType = ChatChannelEnum.RECRUIT,
    textData = data
  }
  EventManager.Dispatch(Event.Chat_ReqChat, msg)
end

function Team_TeamInfoUI:btn_leaveTeamOnClick(control)
  EventManager.Dispatch(Event.Team_QuitTeam)
end

function Team_TeamInfoUI:OnRetTeamMemberList()
end

function Team_TeamInfoUI:btn_tipsOnClick(control)
end

function Team_TeamInfoUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Team_TeamInfoUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Team_TeamInfoUI:SetOnHideMyMember()
  for k, v in pairs(self.modeViewerList) do
    if v ~= nil then
      v:Destroy()
    end
  end
  self.modeViewerList = {}
end

function Team_TeamInfoUI:SetOnDestroyMyMember()
  if self.modeViewerList then
    for k, v in pairs(self.modeViewerList) do
      if v ~= nil then
        v:Destroy()
      end
    end
    self.modeViewerList = {}
  end
end

function Team_TeamInfoUI:SetMemberState()
  self.btn_broadcast:SetActive(TeamData.isInTeam and TeamData.isLeader)
  self.btn_create:SetActive(not TeamData.isInTeam)
  self.btn_leaveTeam:SetActive(TeamData.isInTeam)
end

function Team_TeamInfoUI:RefushModerLevel()
  if not TeamData.isLeader then
    self.dp_activity:SetSelectValue(TeamData.activityOption)
    self.dp_level.dropdown:ClearOptions()
    local option = TeamData.GetCurLevelTable()
    if option and option.optionName then
      self.dp_level.dropdown:AddOption(option.optionName)
      self.dp_level:SetSelectValue(0)
    end
  end
end

function Team_TeamInfoUI:RefushMyMember()
  for k, v in pairs(self.modeViewerList) do
    if v ~= nil then
      v:Destroy()
    end
  end
  self.modeViewerList = {}
  for i, v in pairs(self.membersList) do
    local hasMember = TeamData.HasMemberByIndex(i)
    local inviteBgSprite = UIControl(v.transform, "sp_inviteBg")
    inviteBgSprite:SetActive(not hasMember)
    local memberInfoSprite = UIControl(v.transform, "sp_member")
    memberInfoSprite:SetActive(hasMember)
    if hasMember then
      local memberInfo = TeamData.GetMemberByIndex(i)
      local lab_name = UIControl(memberInfoSprite.transform, "lab_name")
      lab_name:SetText(memberInfo.startName)
      local lab_level = UIControl(memberInfoSprite.transform, "lab_level")
      lab_level:SetText(string.format("lv.%d", memberInfo.startLevel))
      local lab_map = UIControl(memberInfoSprite.transform, "lab_map")
      if memberInfo.online then
        local configMap = ClientTable.cfg_Map_mapManager:TryGetValue(memberInfo.mapId)
        if configMap ~= nil then
          local line = memberInfo.line % 3
          if line == 0 then
            line = 3
          end
          local lineShow = string.format(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_20"), configMap.name, line)
          lab_map:SetText(lineShow)
        end
      else
        lab_map:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_21"))
      end
      local clickRole = UIControl(memberInfoSprite.transform, "ClickRole")
      clickRole:SetOnClick(self, function()
        self:ClickRolePanel(memberInfo)
      end)
      local swordMan = UIControl(memberInfoSprite.transform, "bg/SwordMan")
      local magic = UIControl(memberInfoSprite.transform, "bg/Magic")
      local archer = UIControl(memberInfoSprite.transform, "bg/Archer")
      local SpellSword = UIControl(memberInfoSprite.transform, "bg/SpellSword")
      local SummonMagician = UIControl(memberInfoSprite.transform, "bg/SummonMagician")
      if memberInfo.online then
        swordMan:SetActive(RoleUtility.GetBasicCareer(memberInfo.info.career) == ERoleCareer.SwordMan)
        magic:SetActive(RoleUtility.GetBasicCareer(memberInfo.info.career) == ERoleCareer.Magic)
        archer:SetActive(RoleUtility.GetBasicCareer(memberInfo.info.career) == ERoleCareer.Archer)
        SpellSword:SetActive(RoleUtility.GetBasicCareer(memberInfo.info.career) == ERoleCareer.SpellSword)
        SummonMagician:SetActive(RoleUtility.GetBasicCareer(memberInfo.info.career) == ERoleCareer.SummonMagician)
      else
        swordMan:SetActive(RoleUtility.GetBasicCareer(memberInfo.startCareer) == ERoleCareer.SwordMan)
        magic:SetActive(RoleUtility.GetBasicCareer(memberInfo.startCareer) == ERoleCareer.Magic)
        archer:SetActive(RoleUtility.GetBasicCareer(memberInfo.startCareer) == ERoleCareer.Archer)
        SpellSword:SetActive(RoleUtility.GetBasicCareer(memberInfo.startCareer) == ERoleCareer.SpellSword)
        SummonMagician:SetActive(RoleUtility.GetBasicCareer(memberInfo.info.career) == ERoleCareer.SummonMagician)
      end
      local model = UIControl(memberInfoSprite.transform, "go_model")
      local viewRoleData = {}
      local equipData = {}
      equipData = RoleEquipData(memberInfo.equips)
      viewRoleData.equipsData = equipData
      if memberInfo.online then
        viewRoleData.career = memberInfo.info.career
      else
        viewRoleData.career = memberInfo.startCareer
      end
      viewRoleData.modelType = EModelType.Charactor
      viewRoleData.model = 1003
      viewRoleData.modelScale = 0.55
      viewRoleData.id = memberInfo.rid
      viewRoleData.parent = model.transform
      viewRoleData.serverCoord = Vector2Int()
      viewRoleData.roleType = ERoleType.Player
      local modelViewer = ViewRole(viewRoleData)
      modelViewer:SetPosition(0, -140, -200)
      table.insert(self.modeViewerList, i, modelViewer)
      modelViewer:SetRotation(0, -180, 0)
    end
    local inviteBtn = UIControl(inviteBgSprite.transform, "btn_invite")
    if TeamData.isLeader then
      inviteBtn:SetOnClick(self, function()
        self.showInfoIndex = ShowTeamType.nearGuideType
        self:Refresh()
      end)
    end
    inviteBtn:SetActive(TeamData.isLeader)
  end
end

function Team_TeamInfoUI:ClickRolePanel(role)
  local curRole = ShowBtnItemUtility.GetRoelShowInfo(role.rid, RoleOpenType.TeamOpen)
  if not curRole then
    if role.online then
      curRole = {
        interactType = RoleOpenType.TeamOpen,
        online = role.online,
        roleId = role.rid,
        mapId = role.mapId,
        roleName = role.startName,
        unionName = role.info.unionName,
        unionPosition = role.info.unionPosition,
        teamId = TeamData.teamId,
        fightValue = role.info.fight,
        career = role.info.career,
        level = role.info.level,
        equipData = RoleEquipData(role.equips),
        maxHp = 0,
        hp = 0,
        maxMp = 0,
        mp = 0
      }
    else
      curRole = {
        interactType = RoleOpenType.TeamOpen,
        online = role.online,
        roleId = role.rid,
        mapId = role.mapId,
        roleName = role.startName,
        unionName = 0,
        unionPosition = 0,
        teamId = TeamData.teamId,
        fightValue = 0,
        career = role.startCareer,
        level = role.startLevel,
        equipData = RoleEquipData(role.equips),
        maxHp = 0,
        hp = 0,
        maxMp = 0,
        mp = 0
      }
    end
  end
  UIManager.Show(UIID.Team_RoleInteractUI, curRole)
end

function Team_TeamInfoUI:ClickNearGuid()
  self.showInfoIndex = ShowTeamType.nearGuideType
  for k, v in pairs(self.showPanel) do
    v:SetActive(false)
  end
  for k, v in pairs(self.showBtn) do
    v:SetActive(false)
  end
  self.showPanel[self.showInfoIndex]:SetActive(true)
  self.showBtn[self.showInfoIndex]:SetActive(true)
  self:UpdateNearbyPlayerItem()
end

function Team_TeamInfoUI:BtnClickFriends()
  self.showInfoIndex = ShowTeamType.MyFriendsType
  NetManager.Send(FriendMessage.ReqOpenFriendPanel, {
    type = FriendTypeEnum.FRIEND
  })
end

function Team_TeamInfoUI:ClickFriends()
  self.showInfoIndex = ShowTeamType.MyFriendsType
  for k, v in pairs(self.showPanel) do
    v:SetActive(false)
  end
  for k, v in pairs(self.showBtn) do
    v:SetActive(false)
  end
  self.showPanel[self.showInfoIndex]:SetActive(true)
  self.showBtn[self.showInfoIndex]:SetActive(true)
  self:UpdateFriendPlayerItem()
end

function Team_TeamInfoUI:BtnClickWars()
  if WarAllianceData.IsHaveUnion then
    self.showInfoIndex = ShowTeamType.MyWarType
    NetManager.Send(UnionMessage.ReqMemberList)
  else
    self:ClickWars()
  end
end

function Team_TeamInfoUI:ClickWars()
  self.showInfoIndex = ShowTeamType.MyWarType
  for k, v in pairs(self.showPanel) do
    v:SetActive(false)
  end
  for k, v in pairs(self.showBtn) do
    v:SetActive(false)
  end
  self.showPanel[self.showInfoIndex]:SetActive(true)
  self.showBtn[self.showInfoIndex]:SetActive(true)
  self:UpdateGuildPlayerItem()
end

function Team_TeamInfoUI:InitNearRoles()
  self.infoContainer = nil
  self.curInviteType = ""
end

local function OnCreate(ctr)
  ctr.name = UIControl(ctr.transform, "lab_name")
  ctr.level = UIControl(ctr.transform, "lab_level")
  ctr.career = UIControl(ctr.transform, "lab_career")
  ctr.guildName = UIControl(ctr.transform, "lab_guildName")
  ctr.inviteBtn = UIControl(ctr.transform, "btn_invite")
  ctr.inviteBtnLabel = UIControl(ctr.transform, "btn_invite/Text")
end

local function OnRefresh(ctr, _, data, ui)
  ctr.name:SetText(data.name)
  ctr.level:SetText(string.format("lv.%d", data.level))
  ctr.career:SetText(RoleUtility.GteCareerNameByType(data.career))
  local unionName = string.isNullOrEmpty(data.unionName) and ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_3") or data.unionName
  ctr.guildName:SetText(unionName)
  local roleId = ui:GetIdByType(data, ui.curInviteType)
  local hasInvited = TeamData.HasInvitedId(roleId)
  if TeamData.GetAskTeamCondition() then
    ctr.inviteBtnLabel:SetText(hasInvited and ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_5") or ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_6"))
  else
    ctr.inviteBtnLabel:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_6"))
  end
  if not hasInvited then
    ctr.inviteBtn.roleId = roleId
    ctr.inviteBtn:SetOnClick(ui, ui.Btn_inviteClick)
  end
  ctr.inviteBtn:SetInteractable(not hasInvited)
end

function Team_TeamInfoUI:InitNearRolesUI()
  self.infoContainer = UIContainer(self.sp_dataBg, self, OnCreate, OnRefresh)
end

function Team_TeamInfoUI:Btn_inviteClick(ctr)
  if not TeamData.isInTeam then
    local uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_13")
    FloatingTipUtility.QuickMsg(uiWord)
    return
  end
  local idData = {
    ctr.roleId
  }
  if self.args and self.args.InviteButAction then
    self.args.InviteButAction(ctr.roleId)
  else
    EventManager.Dispatch(Event.Team_InviteInTeam, idData)
  end
end

function Team_TeamInfoUI:UpdateNearbyPlayerItem()
  local players = RoleManager.GetRoleListByType(ERoleType.Player).list
  local tempPlayers = {}
  for i, v in pairs(players) do
    if v.data.teamId == 0 and not TeamData.IsTeammate(v.data.id) then
      local info = {
        id = v.id,
        name = v.name,
        level = v.level,
        career = v.career,
        unionName = v.data.unionName
      }
      table.insert(tempPlayers, info)
    end
  end
  self.curInviteType = "nearBy"
  self.infoContainer:SetData(tempPlayers)
end

function Team_TeamInfoUI:UpdateFriendPlayerItem()
  local players = FriendData.FriendList[FriendTypeEnum.FRIEND]
  local tempPlayers = {}
  local mapTbl
  for i, v in pairs(players) do
    mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(v.info.mapId, "id")
    if v.info.online and ShowBtnItemUtility.IsSelfSpan(mapTbl) and not TeamData.IsTeammate(v.info.roleId) then
      table.insert(tempPlayers, v.info)
    end
  end
  self.curInviteType = "friend"
  self.infoContainer:SetData(tempPlayers)
end

function Team_TeamInfoUI:UpdateGuildPlayerItem()
  local players = WarAllianceData.MemberList
  local tempPlayers = {}
  local mapTbl
  for _, v in pairs(players) do
    if v.mapId ~= 0 then
      mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(v.mapId, "id")
      if not TeamData.IsTeammate(v.id) and ShowBtnItemUtility.IsSelfSpan(mapTbl) then
        local info = {
          id = v.id,
          name = v.name,
          level = v.level,
          career = v.career,
          unionName = ViewData.meData.unionName
        }
        if ViewData.meData.unionName ~= nil then
          table.insert(tempPlayers, info)
        end
      end
    end
  end
  self.curInviteType = "Guild"
  self.infoContainer:SetData(tempPlayers)
end

function Team_TeamInfoUI:GetIdByType(data, inviteType)
  local id
  if inviteType == "friend" then
    id = data.roleId
  else
    id = data.id
  end
  return id
end

function Team_TeamInfoUI:BtnClickNearTeam()
  self.showInfoIndex = ShowTeamType.NearTeamType
  EventManager.Dispatch(Event.Team_OpenTeamsPanel, nil)
end

function Team_TeamInfoUI:ClickNearTeam()
  self.showInfoIndex = ShowTeamType.NearTeamType
  for k, v in pairs(self.showPanel) do
    v:SetActive(false)
  end
  for k, v in pairs(self.showBtn) do
    v:SetActive(false)
  end
  self.showPanel[self.showInfoIndex]:SetActive(true)
  self.showBtn[self.showInfoIndex]:SetActive(true)
  self.teamContainer:SetData(TeamData.nearbyTeams)
end

function Team_TeamInfoUI:InitNearTeam()
  self.teamContainer = nil
end

local function OnCreate(ctr)
  ctr.leaderName = UIControl(ctr.transform, "lab_nearname")
  ctr.guildName = UIControl(ctr.transform, "lab_nearguildName")
  ctr.teamNum = UIControl(ctr.transform, "lab_nearnumber")
  ctr.applyStateLab = UIControl(ctr.transform, "btn_apply/Text")
  ctr.applyBtn = UIControl(ctr.transform, "btn_apply")
end

local function OnRefresh(ctr, _, data, ui)
  local memberInfo = TeamData.GetTeamLeaderInfoByTeamInfo(data)
  ctr.leaderName:SetText(memberInfo.info.name)
  local unionName = string.isNullOrEmpty(memberInfo.info.unionName) and ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_3") or memberInfo.info.unionName
  ctr.guildName:SetText(unionName)
  ctr.teamNum:SetText(tostring(TeamData.GetTeamMemberCountByTeamInfo(data)))
  local inviteData = data.asks
  local invited = false
  for k, v in pairs(inviteData) do
    if ViewData.meData.id == v.rid then
      invited = true
    end
  end
  if TeamData.GetTeamId() == data.teamId then
    ctr.applyStateLab:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("YiJiaRu"))
  elseif invited then
    ctr.applyStateLab:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_7"))
  else
    ctr.applyStateLab:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_8"))
  end
  ctr.applyBtn:SetOnClick(ui, function()
    if not TeamData.IsInTeamState() and TeamData.GetAskTeamCondition() and not invited then
      ctr.applyStateLab:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_7"))
      ctr.applyBtn.button.onClick:RemoveListener(ctr.applyBtn.onClick)
    end
    EventManager.Dispatch(Event.Team_AskEnterTeam, data.teamId)
  end)
end

function Team_TeamInfoUI:InitNearTeamUI()
  self.teamContainer = UIContainer(self.sp_teamInfo, self, OnCreate, OnRefresh)
end

function Team_TeamInfoUI:ClickApplys()
  self.showInfoIndex = ShowTeamType.MyApplyType
  for k, v in pairs(self.showPanel) do
    v:SetActive(false)
  end
  for k, v in pairs(self.showBtn) do
    v:SetActive(false)
  end
  self.showPanel[self.showInfoIndex]:SetActive(true)
  self.showBtn[self.showInfoIndex]:SetActive(true)
  self.teamInfoContainer:SetData(TeamData.GetAskInList())
  self.btn_allAgree:SetActive(TeamData.GetAskInList() ~= nil and table.count(TeamData.GetAskInList()) > 0)
  self.btn_allRefuse:SetActive(TeamData.GetAskInList() ~= nil and table.count(TeamData.GetAskInList()) > 0)
  self.btn_allRefuse.transform.localPosition = self.btnAllRefusePos
end

function Team_TeamInfoUI:InitApply()
  self.teamInfoContainer = nil
end

local function OnCreate(ctr)
  ctr.nameLabel = UIControl(ctr.transform, "lab_name")
  ctr.levelLabel = UIControl(ctr.transform, "lab_level")
  ctr.careerLabel = UIControl(ctr.transform, "lab_career")
  ctr.guildLabel = UIControl(ctr.transform, "lab_guildName")
  ctr.labask = UIControl(ctr.transform, "lab_ask")
  ctr.agreeBtn = UIControl(ctr.transform, "btn_agree")
  ctr.refuseBtn = UIControl(ctr.transform, "btn_refuse")
end

local function OnRefresh(ctr, _, data, ui)
  if ui.applyInvite == ApplyInviteType.Apply then
    ctr.nameLabel:SetText(data.info.name)
    ctr.levelLabel:SetText(string.format("lv.%d", data.info.level))
    ctr.careerLabel:SetText(RoleUtility.GteCareerNameByType(data.info.career))
    local unionName = string.isNullOrEmpty(data.info.unionName) and "Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i" or data.info.unionName
    ctr.guildLabel:SetActive(false)
    ctr.guildLabel:SetText(unionName)
    local uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_14")
    ctr.labask:SetText(uiWord)
    ctr.agreeBtn:SetOnClick(self, function()
      local tt = {
        data.rid
      }
      EventManager.Dispatch(Event.Team_AgreeInMyTeam, tt)
    end)
    ctr.refuseBtn:SetOnClick(self, function()
      local tt = {
        data.rid
      }
      EventManager.Dispatch(Event.Team_RefuseInMyTeam, tt)
    end)
  end
  if ui.applyInvite == ApplyInviteType.Invite then
    ctr.nameLabel:SetText(data.inviterName)
    ctr.levelLabel:SetText(string.format("lv.%d", data.level))
    ctr.careerLabel:SetText(RoleUtility.GteCareerNameByType(data.career))
    ctr.guildLabel:SetActive(false)
    local uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_15")
    ctr.labask:SetText(uiWord)
    ctr.agreeBtn:SetOnClick(self, function()
      EventManager.Dispatch(Event.Team_AgreeInOtherTeam, data.teamId)
    end)
    ctr.refuseBtn:SetOnClick(self, function()
      EventManager.Dispatch(Event.Team_RefuseInOtherTeam, data.teamId)
    end)
  end
end

function Team_TeamInfoUI:InitApplyUI()
  self.teamInfoContainer = UIContainer(self.sp_applydataBg, self, OnCreate, OnRefresh)
  self.btnAllAgreePos = self.btn_allAgree.transform.localPosition
  self.btnAllRefusePos = self.btn_allRefuse.transform.localPosition
end

function Team_TeamInfoUI:btn_allRefuseOnClick(control)
  if self.applyInvite == ApplyInviteType.Apply then
    local data = {}
    for i, v in pairs(TeamData.GetAskInList()) do
      table.insert(data, v.rid)
    end
    EventManager.Dispatch(Event.Team_AllRefuseInTeam, data)
  end
  if self.applyInvite == ApplyInviteType.Invite then
    local data = {}
    for i, v in pairs(InvitationData.GetInvitedToTeamData()) do
      EventManager.Dispatch(Event.Team_RefuseInOtherTeam, v.teamId)
    end
  end
end

function Team_TeamInfoUI:btn_allAgreeOnClick(control)
  local data = {}
  for i, v in pairs(TeamData.GetAskInList()) do
    table.insert(data, v.rid)
  end
  EventManager.Dispatch(Event.Team_AllAgreeInTeam, data)
end

function Team_TeamInfoUI:ClickInvites()
  self.showInfoIndex = ShowTeamType.MyApplyType
  for k, v in pairs(self.showPanel) do
    v:SetActive(false)
  end
  for k, v in pairs(self.showBtn) do
    v:SetActive(false)
  end
  self.showPanel[self.showInfoIndex]:SetActive(true)
  self.showBtn[self.showInfoIndex]:SetActive(true)
  self.teamInfoContainer:SetData(InvitationData.GetInvitedToTeamData())
  self.btn_allAgree:SetActive(false)
  self.btn_allRefuse:SetActive(InvitationData.GetInvitedToTeamData() ~= nil and table.count(InvitationData.GetInvitedToTeamData()) > 0)
  self.btn_allRefuse.transform.localPosition = self.btnAllAgreePos
end
