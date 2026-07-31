Main_InteractionUI = class(BaseUI)
Main_InteractionUI.layer = UILayer.Background
Main_InteractionUI.orderInLayer = 6
Main_InteractionUI.hideType = UIHideType.WaitDestroy
Main_InteractionUI.hideFunc = UIHideFunc.MoveOutOfScreen
Main_InteractionUI.escClose = UIEscClose.DontClose

function Main_InteractionUI:InitControls()
  self.sp_teamInviteList = self:GetControl("sp_teamInviteList")
  self.btn_svClose = self:GetControl("sp_teamInviteList/btn_svClose")
  self.sv_list = self:GetControl("sp_teamInviteList/sv_list")
  self.Content = self:GetControl("sp_teamInviteList/sv_list/Viewport/Content")
  self.go_item = self:GetControl("sp_teamInviteList/sv_list/Viewport/Content/go_item")
end

function Main_InteractionUI:Init()
end

function Main_InteractionUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnCreateTeam(ctr)
  ctr.leaderName = UIControl(ctr.transform, "lab_leaderName")
  ctr.lab_join = UIControl(ctr.transform, "lab_leaderName/lab_join")
  ctr.agreeBtn = UIControl(ctr.transform, "btn_agree")
  ctr.refuseBtn = UIControl(ctr.transform, "btn_refuse")
end

local function OnRefreshTeam(ctr, _, data, ui)
  if data.type == InvitationType.InviteToAlliance then
    ctr.leaderName:SetText(data.unionName)
    ctr.lab_join:SetText("Guild m\225\187\157i b\225\186\161n gia nh\225\186\173p")
    ctr.agreeBtn:SetOnClick(ui, function()
      NetManager.Send(UnionMessage.ReqOperateInviteJoinUnion, {
        inviteId = data.inviterId,
        unionId = data.unionId,
        agree = true
      })
      ui.sp_teamInviteList.gameObject:SetActive(false)
    end)
    ctr.refuseBtn:SetOnClick(ui, function()
      NetManager.Send(UnionMessage.ReqOperateInviteJoinUnion, {
        inviteId = data.inviterId,
        unionId = data.unionId,
        agree = false
      })
      ui.sp_teamInviteList.gameObject:SetActive(false)
    end)
  end
  if data.type == InvitationType.InvitedToTeam then
    ctr.leaderName:SetText(data.inviterName)
    ctr.lab_join:SetText("M\225\187\157i ng\195\160i v\195\160o \196\145\225\187\153i")
    ctr.agreeBtn:SetOnClick(ui, function()
      EventManager.Dispatch(Event.Team_AgreeInOtherTeam, data.teamId)
      ui.sp_teamInviteList.gameObject:SetActive(false)
    end)
    ctr.refuseBtn:SetOnClick(ui, function()
      EventManager.Dispatch(Event.Team_RefuseInOtherTeam, data.teamId)
      ui.sp_teamInviteList.gameObject:SetActive(false)
    end)
  end
end

function Main_InteractionUI:InitUI()
  self.contentTeamContainer = UIContainer(self.go_item, self, OnCreateTeam, OnRefreshTeam)
end

function Main_InteractionUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Main_InteractionUI:OnHide()
end

function Main_InteractionUI:OnDestroy()
end

function Main_InteractionUI:RegistUIEvents()
  self.btn_svClose:SetOnClick(self, self.btn_svCloseOnClick)
end

function Main_InteractionUI:btn_svCloseOnClick(control)
  self.sp_teamInviteList.gameObject:SetActive(false)
end

function Main_InteractionUI:RegistEvents()
  self:RegistEvent(Event.WarAlliance_OpenInviteMembershipView, self.ShowInviteMembership, self)
end

function Main_InteractionUI:Refresh()
end

function Main_InteractionUI:ShowSingleInvite()
  local inviteData = InvitationData.GetInvitedToTeamData()[1]
  UIManager.Show(UIID.PromptTipUI, {
    title = "",
    textContent = string.format("%s m\225\187\157i b\225\186\161n gia nh\225\186\173p \196\145\225\187\153i. ", inviteData.inviterName),
    cancelText = "",
    okText = "",
    cancel = function()
      EventManager.Dispatch(Event.Team_RefuseInOtherTeam, inviteData.teamId)
    end,
    ok = function()
      EventManager.Dispatch(Event.Team_AgreeInOtherTeam, inviteData.teamId)
    end
  })
end

function Main_InteractionUI:ShowInviteInfo()
  local count = table.count(InvitationData.GetInvitedToTeamData())
  self.sp_teamInviteList.gameObject:SetActive(1 < count)
  if count == 1 then
    self:ShowSingleInvite()
    return
  end
  self.contentTeamContainer:SetData(InvitationData.GetInvitedToTeamData())
end

function Main_InteractionUI:ShowSingleInviteMembership()
  local inviteData = InvitationData.GetInvitedToAllianceData()[1]
  UIManager.Show(UIID.PromptTipUI, {
    title = "",
    textContent = string.format("%s m\225\187\157i b\225\186\161n gia nh\225\186\173p %s guild. ", inviteData.inviterName, inviteData.unionName),
    cancelText = "",
    okText = "",
    cancel = function()
      NetManager.Send(UnionMessage.ReqOperateInviteJoinUnion, {
        inviteId = inviteData.inviterId,
        unionId = inviteData.unionId,
        agree = false
      })
    end,
    ok = function()
      NetManager.Send(UnionMessage.ReqOperateInviteJoinUnion, {
        inviteId = inviteData.inviterId,
        unionId = inviteData.unionId,
        agree = true
      })
    end
  })
end

function Main_InteractionUI:ShowInviteMembership()
  local count = table.count(InvitationData.GetInvitedToAllianceData())
  self.sp_teamInviteList.gameObject:SetActive(1 < count)
  if count == 1 then
    self:ShowSingleInviteMembership()
    return
  end
  self.contentTeamContainer:SetData(InvitationData.GetInvitedToAllianceData())
end
