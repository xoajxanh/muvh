Team_TeamUpQuicklyUI = class(BaseUI)
Team_TeamUpQuicklyUI.layer = UILayer.Panel
Team_TeamUpQuicklyUI.orderInLayer = 0
Team_TeamUpQuicklyUI.hideType = UIHideType.Hide
Team_TeamUpQuicklyUI.hideFunc = UIHideFunc.MoveOutOfScreen
Team_TeamUpQuicklyUI.escClose = UIEscClose.DontClose

function Team_TeamUpQuicklyUI:InitControls()
  self.txt_title = self:GetControl("img_bg/txt_title")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.btn_minimize = self:GetControl("img_bg/btn_minimize")
  self.go_teamList = self:GetControl("img_bg/go_teamList")
  self.go_teamMemberFrame = self:GetControl("img_bg/go_teamList/go_teamMemberFrame")
  self.go_notStarted = self:GetControl("img_bg/go_notStarted")
  self.btn_InviteFriends = self:GetControl("img_bg/go_notStarted/btn_InviteFriends")
  self.btn_startMatching = self:GetControl("img_bg/go_notStarted/btn_startMatching")
  self.btn_worldInvitation = self:GetControl("img_bg/go_notStarted/btn_worldInvitation")
  self.go_matching = self:GetControl("img_bg/go_matching")
  self.btn_signOut = self:GetControl("img_bg/go_matching/btn_signOut")
  self.txt_matchingCountown = self:GetControl("img_bg/go_matching/txt_matchingCountown")
  self.go_matchSucceeded = self:GetControl("img_bg/go_matchSucceeded")
  self.btn_getReady = self:GetControl("img_bg/go_matchSucceeded/btn_getReady")
  self.txt_readyCountown = self:GetControl("img_bg/go_matchSucceeded/txt_readyCountown")
end

function Team_TeamUpQuicklyUI:OnPreLoad()
end

function Team_TeamUpQuicklyUI:Init()
end

function Team_TeamUpQuicklyUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local this = Team_TeamUpQuicklyUI
local countownCount, countownText
local matchState = 0

local function OnRoleInforCreate(ctr)
  ctr.iconText = UIControl(ctr.transform, "img_teamMemberHead")
  ctr.nameLab = UIControl(ctr.transform, "txt_teamMemberName")
  ctr.state = UIControl(ctr.transform, "img_state")
end

local function OnRoleInforReflesh(ctr, index, data, ui)
  ctr.iconText:SetSprite(this.sprite)
  ctr.nameLab:SetText(data.roleName)
  ctr.state.gameObject:SetActive(data.confirm)
end

local function fixedUpdate()
  countownCount = countownCount - UnityEngineLua.Time.fixedDeltaTime
  if countownCount < 0 then
    countownCount = 0
  end
  local ceilNum = math.ceil(countownCount)
  countownText:SetText(string.format("%s gi\195\162y", ceilNum))
  EventManager.Dispatch(Event.Team_MatchingCountown, ceilNum)
end

function Team_TeamUpQuicklyUI.SetMatchingState(state)
  this.go_notStarted:SetActive(not state)
  this.go_matching:SetActive(state)
  if state then
    this.monoCallback.fixedUpdate = fixedUpdate
    countownText = this.txt_matchingCountown
  else
    if this.visible then
      this.monoCallback.fixedUpdate = nil
    end
    this.go_matchSucceeded:SetActive(state)
    countownCount = 0
  end
end

function Team_TeamUpQuicklyUI:InitUI()
  self.roleInforContainer = UIContainer(self.go_teamMemberFrame, self, OnRoleInforCreate, OnRoleInforReflesh)
  self.monoCallback = CS.Main.instance
  this.sprite = UIControl(self.go_teamMemberFrame.transform, "img_teamMemberHead").image.sprite
end

function Team_TeamUpQuicklyUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Team_TeamUpQuicklyUI:OnHide()
end

function Team_TeamUpQuicklyUI:OnDestroy()
end

function Team_TeamUpQuicklyUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_minimize:SetOnClick(self, self.btn_minimizeOnClick)
  self.btn_InviteFriends:SetOnClick(self, self.btn_InviteFriendsOnClick)
  self.btn_startMatching:SetOnClick(self, self.btn_startMatchingOnClick)
  self.btn_worldInvitation:SetOnClick(self, self.btn_worldInvitationOnClick)
  self.btn_signOut:SetOnClick(self, self.btn_signOutOnClick)
  self.btn_getReady:SetOnClick(self, self.btn_getReadyOnClick)
end

function Team_TeamUpQuicklyUI:btn_closeOnClick(control)
  if 0 < matchState then
    return
  end
  UIManager.Hide(UIID.Team_TeamUpQuicklyUI)
  NetManager.Send(InstanceMatchMessage.ReqInstanceMatchCancelMatch)
  this.SetMatchingState(false)
  TeamUpQuicklyData.TeamInfor = nil
end

function Team_TeamUpQuicklyUI:btn_minimizeOnClick(control)
  if 1 < matchState then
    return
  end
  UIManager.Hide(UIID.Team_TeamUpQuicklyUI)
  local id, UIName = TeamUpQuicklyData.GetInstanceInfor()
  if UIName then
    UIManager.Hide(UIName)
  end
  UIManager.Hide(UIID.PromptTipUI)
  EventManager.Dispatch(Event.Team_TeamUpQuicklyMinimize, true)
end

function Team_TeamUpQuicklyUI:btn_InviteFriendsOnClick(control)
  local openType = {
    openType = ShowTeamType.nearGuideType
  }
  UIManager.Show(UIID.Team_TeamInfoUI, {
    type = openType,
    InviteButAction = function(roleId)
      NetManager.Send(InstanceMatchMessage.ReqInstanceMatchInviteFriend, {id = roleId})
    end
  })
end

function Team_TeamUpQuicklyUI:btn_startMatchingOnClick(control)
  NetManager.Send(InstanceMatchMessage.ReqInstanceMatchStartMatch)
end

function Team_TeamUpQuicklyUI:btn_worldInvitationOnClick(control)
  NetManager.Send(InstanceMatchMessage.ReqInstanceMatchInviteAll)
end

function Team_TeamUpQuicklyUI:btn_signOutOnClick(control)
  NetManager.Send(InstanceMatchMessage.ReqInstanceMatchCancelMatch)
end

function Team_TeamUpQuicklyUI:btn_getReadyOnClick(control)
  NetManager.Send(InstanceMatchMessage.ReqInstanceMatchConfirmReady)
end

function Team_TeamUpQuicklyUI:RegistEvents()
end

function Team_TeamUpQuicklyUI:Refresh()
  if TeamUpQuicklyData.State == 3 then
    this.monoCallback.fixedUpdate = nil
    TeamUpQuicklyData.State = 0
  end
  local titleInfor = TeamUpQuicklyData.GetInterfaceTitleInfor()
  self.txt_title:SetText(string.format("Lv.%s (%s-%s)%s", titleInfor.instanceLevel, titleInfor.minLevel, titleInfor.maxLevel, titleInfor.name))
end

function Team_TeamUpQuicklyUI:RefreshTeamInfor()
  if #TeamUpQuicklyData.TeamInfor.members == 0 then
    UIManager.Hide(this.name)
    EventManager.Dispatch(Event.Team_TeamUpQuicklyMinimize, false)
    if not TeamUpQuicklyData.IsLeader() then
      local prompTipArgs = {
        title = LocalizationUtility.GetContentByKey("tishi"),
        textContent = LocalizationUtility.GetContentByKey("TeamDissolve")
      }
      UIManager.Show(UIID.PromptTipUI, prompTipArgs)
    end
  end
  local membersInfor = TeamUpQuicklyData.GetTeamMemberInfor()
  this.roleInforContainer:SetDataKTable(membersInfor)
  local isAllReady = true
  for k, v in pairs(membersInfor) do
    if not v.confirm then
      isAllReady = false
    end
  end
  if TeamUpQuicklyData.IsLeader() then
    this.btn_worldInvitation.gameObject:SetActive(true)
    this.btn_startMatching.gameObject:SetActive(true)
    this.btn_signOut.gameObject:SetActive(true)
  else
    this.btn_worldInvitation.gameObject:SetActive(false)
    this.btn_startMatching.gameObject:SetActive(false)
    this.btn_signOut.gameObject:SetActive(false)
  end
  if isAllReady then
    TeamUpQuicklyData.TeamInfor = nil
    this.SetMatchingState(false)
    matchState = 0
    UIManager.Hide(this.name)
    UIManager.Hide(UIID.Instance_BloodCastleUI)
    UIManager.Hide(UIID.Instance_DemonPlazaUI)
  end
end

function Team_TeamUpQuicklyUI:SignOutMatching()
  if 0 < matchState then
    EventManager.Dispatch(Event.Team_MatchingFail)
    this.SetMatchingState(false)
    matchState = 0
    TeamUpQuicklyData.State = 3
  end
end

function Team_TeamUpQuicklyUI:MatchingSuccessful(endTime)
  matchState = 2
  this.go_notStarted:SetActive(false)
  this.go_matching:SetActive(false)
  this.go_matchSucceeded:SetActive(true)
  if not this.monoCallback.fixedUpdate then
    this.monoCallback.fixedUpdate = fixedUpdate
  end
  countownCount = endTime - Time.GetServerSecondTime()
  countownText = this.txt_readyCountown
end

function Team_TeamUpQuicklyUI:StartMatch(endTime)
  matchState = 1
  countownCount = endTime - Time.GetServerSecondTime()
  this.SetMatchingState(true)
end

function Team_TeamUpQuicklyUI:MatchFail()
  if not TeamUpQuicklyData.IsLeader() then
    return
  end
  if 1 < countownCount then
    return
  end
  local prompTipArgs = {
    title = LocalizationUtility.GetContentByKey("tishi"),
    textContent = LocalizationUtility.GetContentByKey("MatchFail"),
    ok = function()
      EventManager.Dispatch(Event.Team_TeamUpQuicklyMinimize, true)
      this.monoCallback.fixedUpdate = nil
      NetManager.Send(InstanceMatchMessage.ReqInstanceMatchStartMatch)
    end,
    cancel = function()
      NetManager.Send(InstanceMatchMessage.ReqInstanceMatchCancelMatch)
      UIManager.Hide(this.name)
      this.monoCallback.fixedUpdate = nil
      TeamUpQuicklyData.State = 0
      EventManager.Dispatch(Event.Team_TeamUpQuicklyMinimize, false)
      this.SetMatchingState(false)
    end
  }
  UIManager.Show(UIID.PromptTipUI, prompTipArgs)
end
