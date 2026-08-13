Team_TeamInviteInfoUI = class(BaseUI)
Team_TeamInviteInfoUI.layer = UILayer.Panel
Team_TeamInviteInfoUI.orderInLayer = 0
Team_TeamInviteInfoUI.hideType = UIHideType.WaitDestroy
Team_TeamInviteInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Team_TeamInviteInfoUI.escClose = UIEscClose.DontClose

function Team_TeamInviteInfoUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_InvitationBg/btn_close")
  self.tg_group = self:GetControl("img_InvitationBg/tg_group")
  self.tog_nearby = self:GetControl("img_InvitationBg/tg_group/tog_nearby")
  self.img_clickeffectNear = self:GetControl("img_InvitationBg/tg_group/tog_nearby/img_Target/img_Pressed/img_clickeffectNear")
  self.tog_friends = self:GetControl("img_InvitationBg/tg_group/tog_friends")
  self.img_clickeffectFriend = self:GetControl("img_InvitationBg/tg_group/tog_friends/img_Target/img_Pressed/img_clickeffectFriend")
  self.tog_guild = self:GetControl("img_InvitationBg/tg_group/tog_guild")
  self.img_clickeffectGuild = self:GetControl("img_InvitationBg/tg_group/tog_guild/img_Target/img_Pressed/img_clickeffectGuild")
  self.sv_memberList = self:GetControl("img_InvitationBg/img_show/sv_memberList")
  self.Content = self:GetControl("img_InvitationBg/img_show/sv_memberList/Viewport/Content")
  self.sp_dataBg = self:GetControl("img_InvitationBg/img_show/sv_memberList/Viewport/Content/sp_dataBg")
end

function Team_TeamInviteInfoUI:Init()
  self.infoContainer = nil
  self.curInviteType = ""
end

function Team_TeamInviteInfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
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

function Team_TeamInviteInfoUI:InitUI()
  self.img_clickeffectNear.gameObject:SetActive(true)
  self.img_clickeffectFriend.gameObject:SetActive(false)
  self.img_clickeffectGuild.gameObject:SetActive(false)
  self.infoContainer = UIContainer(self.sp_dataBg, self, OnCreate, OnRefresh)
end

function Team_TeamInviteInfoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Team_TeamInviteInfoUI:TogChanged(control, bool)
  if not bool then
    return
  end
  if self.tog_nearby:GetIsOn() then
    self.img_clickeffectNear.gameObject:SetActive(true)
    self.img_clickeffectFriend.gameObject:SetActive(false)
    self.img_clickeffectGuild.gameObject:SetActive(false)
    self:UpdateNearbyPlayerItem()
  elseif self.tog_friends:GetIsOn() then
    self.img_clickeffectNear.gameObject:SetActive(false)
    self.img_clickeffectFriend.gameObject:SetActive(true)
    self.img_clickeffectGuild.gameObject:SetActive(false)
    self:ShowFriend()
  elseif self.tog_guild:GetIsOn() then
    self.img_clickeffectNear.gameObject:SetActive(false)
    self.img_clickeffectFriend.gameObject:SetActive(false)
    self.img_clickeffectGuild.gameObject:SetActive(true)
    self:UpdateGuildPlayerItem()
  end
end

function Team_TeamInviteInfoUI:ShowFriend()
  NetManager.Send(FriendMessage.ReqOpenFriendPanel, {
    type = FriendTypeEnum.FRIEND
  })
end

function Team_TeamInviteInfoUI:OnHide()
end

function Team_TeamInviteInfoUI:OnDestroy()
end

function Team_TeamInviteInfoUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.tog_nearby:SetOnToggleChanged(self, self.TogChanged)
  self.tog_friends:SetOnToggleChanged(self, self.TogChanged)
  self.tog_guild:SetOnToggleChanged(self, self.TogChanged)
end

function Team_TeamInviteInfoUI:btn_closeOnClick(control)
  UIManager.Hide(self.name)
end

function Team_TeamInviteInfoUI:Btn_inviteClick(ctr)
  local idData = {
    ctr.roleId
  }
  if self.args and self.args.InviteButAction then
    self.args.InviteButAction(ctr.roleId)
  else
    EventManager.Dispatch(Event.Team_InviteInTeam, idData)
  end
end

function Team_TeamInviteInfoUI:RegistEvents()
  self:RegistEvent(Event.Friend_ResFriendList, self.UpdateFriendPlayerItem, self)
  self:RegistEvent(Event.Team_ResTeamInfo, self.OnTeamInfo, self)
end

function Team_TeamInviteInfoUI:Refresh()
  self:ReqUnionMemberInfo()
  if self.tog_nearby:GetIsOn() then
    self:UpdateNearbyPlayerItem()
  else
    self.tog_nearby:SetIsOn(true)
  end
end

function Team_TeamInviteInfoUI:OnTeamInfo()
  if self.tog_nearby:GetIsOn() then
    self.img_clickeffectNear.gameObject:SetActive(true)
    self.img_clickeffectFriend.gameObject:SetActive(false)
    self.img_clickeffectGuild.gameObject:SetActive(false)
    self:UpdateNearbyPlayerItem()
  elseif self.tog_friends:GetIsOn() then
    self.img_clickeffectNear.gameObject:SetActive(false)
    self.img_clickeffectFriend.gameObject:SetActive(true)
    self.img_clickeffectGuild.gameObject:SetActive(false)
    self:UpdateFriendPlayerItem()
  elseif self.tog_guild:GetIsOn() then
    self.img_clickeffectNear.gameObject:SetActive(false)
    self.img_clickeffectFriend.gameObject:SetActive(false)
    self.img_clickeffectGuild.gameObject:SetActive(true)
    self:UpdateGuildPlayerItem()
  end
end

function Team_TeamInviteInfoUI:UpdateNearbyPlayerItem()
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

function Team_TeamInviteInfoUI:UpdateFriendPlayerItem()
  local players = FriendData.FriendList[FriendTypeEnum.FRIEND]
  local tempPlayers = {}
  for i, v in pairs(players) do
    if v.info.online and not TeamData.IsTeammate(v.info.roleId) then
      table.insert(tempPlayers, v.info)
    end
  end
  self.curInviteType = "friend"
  self.infoContainer:SetData(tempPlayers)
end

function Team_TeamInviteInfoUI:ReqUnionMemberInfo()
  if WarAllianceData.IsHaveUnion then
    NetManager.Send(UnionMessage.ReqMemberList)
  end
end

function Team_TeamInviteInfoUI:UpdateGuildPlayerItem()
  local players = WarAllianceData.MemberList
  local tempPlayers = {}
  for _, v in pairs(players) do
    if v.mapId ~= 0 and not TeamData.IsTeammate(v.id) then
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
  self.curInviteType = "Guild"
  self.infoContainer:SetData(tempPlayers)
end

function Team_TeamInviteInfoUI:GetIdByType(data, inviteType)
  local id
  if inviteType == "friend" then
    id = data.roleId
  else
    id = data.id
  end
  return id
end
