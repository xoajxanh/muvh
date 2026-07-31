Vip_NewMemberPrivilegeUI = class(BaseUI)
Vip_NewMemberPrivilegeUI.layer = UILayer.Panel
Vip_NewMemberPrivilegeUI.orderInLayer = 0
Vip_NewMemberPrivilegeUI.hideType = UIHideType.WaitDestroy
Vip_NewMemberPrivilegeUI.hideFunc = UIHideFunc.MoveOutOfScreen
Vip_NewMemberPrivilegeUI.escClose = UIEscClose.DontClose

function Vip_NewMemberPrivilegeUI:InitControls()
  self.go_MemberListGroup = self:GetControl("Panel/go_MemberListGroup")
  self.GroupList = self:GetControl("Panel/go_MemberListGroup/Viewport/GroupList")
  self.Tog_Btn = self:GetControl("Panel/go_MemberListGroup/Viewport/GroupList/Tog_Btn")
  self.go_MemberPrivilege = self:GetControl("Panel/go_MemberPrivilege")
  self.left_img_title = self:GetControl("Panel/go_MemberPrivilege/left_Privilege/left_img_title")
  self.Desc = self:GetControl("Panel/go_MemberPrivilege/left_Privilege/sw_PrivilegeDes/Viewport/Content/Desc")
  self.lab_condition = self:GetControl("Panel/go_MemberPrivilege/right_Gift/lab_condition")
  self.img_geted = self:GetControl("Panel/go_MemberPrivilege/right_Gift/img_geted")
  self.btn_active = self:GetControl("Panel/go_MemberPrivilege/right_Gift/btn_active")
  self.lab_active = self:GetControl("Panel/go_MemberPrivilege/right_Gift/btn_active/lab_active")
  self.member_gift = self:GetControl("Panel/go_MemberPrivilege/right_Gift/member_gift")
  self.btn_everydayItem = self:GetControl("Panel/go_MemberPrivilege/right_Gift/member_gift/Viewport/grid_reward/btn_everydayItem")
  self.lab_level = self:GetControl("Panel/go_MemberLevel/MemberLv/lab_level")
  self.lab_level_s = self:GetControl("Panel/go_MemberLevel/MemberLv/lab_level_s")
  self.Fill = self:GetControl("Panel/go_MemberLevel/sl_progress/Fill Area/Fill")
  self.lab_progress = self:GetControl("Panel/go_MemberLevel/sl_progress/lab_progress")
  self.btn_goLv = self:GetControl("Panel/go_MemberLevel/btn_goLv")
  self.lab_goLv = self:GetControl("Panel/go_MemberLevel/btn_goLv/lab_goLv")
  self.lab_levelExp = self:GetControl("Panel/go_MemberLevel/lab_levelExp")
  self.btn_close = self:GetControl("Panel/btn_close")
  self.btn_VipMap = self:GetControl("Panel/go_MemberPrivilege/btn_VipMap")
  self.descBtn = self:GetControl("Panel/descBtn")
end

function Vip_NewMemberPrivilegeUI:GetMemberDataMgr()
  if gameMgr:GetAvatarManager() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr()
  end
  return nil
end

function Vip_NewMemberPrivilegeUI:Init()
end

function Vip_NewMemberPrivilegeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Vip_NewMemberPrivilegeUI:InitUI()
  self:InitParams()
end

function Vip_NewMemberPrivilegeUI:InitParams()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.member
  })
  self.targetIndex = 0
  
  function self.ClickTogCallBack(id, group)
    self:ClickTogCallBackFunc(id, group)
  end
  
  self.upStrFormat = Localization.GetUIWord("Newmember_2")
  self.btnStrFormat = Localization.GetUIWord("Newmember_3")
  self.starStrFormat = Localization.GetUIWord("Newmember_4")
  self.pageContainer = UIUtility.BindUIContainerTemp(self.Tog_Btn, LuaComponentTemplates.Vip_MemberPageTemplat, self, {
    goCallBack = self.ClickTogCallBack
  })
  self.desContainer = UIUtility.BindUIContainerTemp(self.Desc, LuaComponentTemplates.Vip_MemberDesTemplate, self)
  self.rewardContainer = UIUtility.BindUIContainerTemp(self.btn_everydayItem, LuaComponentTemplates.UIItemTemplate, self, {isShowTips = true})
  self.initializedPage = false
  self.originGroupPos = self.GroupList.transform.localPosition
end

function Vip_NewMemberPrivilegeUI:RegistUIEvents()
  self.btn_active:SetOnClick(self, self.btn_activeOnClick)
  self.btn_everydayItem:SetOnClick(self, self.btn_everydayItemOnClick)
  self.btn_goLv:SetOnClick(self, self.btn_goLvOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_VipMap:SetOnClick(self, self.btn_VipMapOnClick)
  self.descBtn:SetOnClick(self, self.descBtnClick)
end

function Vip_NewMemberPrivilegeUI:descBtnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1115})
end

function Vip_NewMemberPrivilegeUI:btn_activeOnClick(control)
  if self.VipRewardState == EMemberRewardState.Get then
    networkRequest.ReqVipMemberLevelReward(self.id)
  end
end

function Vip_NewMemberPrivilegeUI:btn_goLvOnClick(control)
  EventManager.Dispatch(Event.MemberSwitchView, EMemberViewType.Task)
end

function Vip_NewMemberPrivilegeUI:btn_closeOnClick()
  UIManager.Hide(UIID.Vip_NewMemberPrivilegeUI)
  UIManager.Hide(UIID.Vip_NewMemberMainUI)
end

function Vip_NewMemberPrivilegeUI:btn_VipMapOnClick()
  PathFinderManager.FlyTransferScene(400156, nil, {npcId = 1001006, groupId = 101408}, Purpose.ClickNpc, function()
  end)
end

function Vip_NewMemberPrivilegeUI:RegistEvents()
  self:RegistEvent(Event.MemberLevelChanged, self.UpdataLevelCallBack, self)
  self:RegistEvent(Event.MemberRewardChanged, self.UpdataRewardCallBack, self)
  self:RegistEvent(Event.MemberExpChanged, self.UpdataExpCallBack, self)
end

function Vip_NewMemberPrivilegeUI:UpdataGroupCallBack(id, msg)
  self:RefreshAll(true)
end

function Vip_NewMemberPrivilegeUI:UpdataLevelCallBack(id, msg)
  self:RefreshData()
  self:RefreshTopView()
  self:RefreshDesView()
end

function Vip_NewMemberPrivilegeUI:UpdataRewardCallBack(id, msg)
  self:RefreshAll(true)
end

function Vip_NewMemberPrivilegeUI:UpdataExpCallBack(id, msg)
  self:RefreshExpData()
  self:RefrehExpView()
end

function Vip_NewMemberPrivilegeUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Vip_NewMemberPrivilegeUI:Refresh()
  self:RefreshAll(true)
end

function Vip_NewMemberPrivilegeUI:RefreshAll(isInit)
  self:RefreshData(isInit)
  self:RefreshPageView(isInit)
  self:RefreshMemberView()
end

function Vip_NewMemberPrivilegeUI:RefreshData(isInit)
  if self:GetMemberDataMgr() == nil then
    return
  end
  if isInit then
    self.pageList = self:GetMemberDataMgr():GetMeetPageInfoList()
    self.selectGroup = self:GetMeetPageGroup()
    self.id = self:GetMemberDataMgr():GetFirstLevelByGroup(self.selectGroup)
    self.initializedPage = false
  end
  self:RefreshLevelData()
  self:RefreshBasicData()
  self:RefreshExpData()
  self:RefreshDesData()
end

function Vip_NewMemberPrivilegeUI:RefreshDesData()
  self.desList = {}
  local desMemberTbl
  if self.selectGroup == self.nowGroup then
    desMemberTbl = ClientTable.cfg_MemberManager:TryGetValue(self:GetMemberDataMgr():GetMemberLevle())
  else
    desMemberTbl = ClientTable.cfg_MemberManager:TryGetValue(self:GetMemberDataMgr():GetLastLevelByGroup(self.selectGroup))
  end
  if desMemberTbl then
    self.desList = string.split(desMemberTbl.tips, "&")
  end
end

function Vip_NewMemberPrivilegeUI:RefreshBasicData()
  self.isMax = self:GetMemberDataMgr():CheckMax()
  self.memberTbl = ClientTable.cfg_MemberManager:TryGetValue(self.id)
  self.VipRewardState = self:GetMemberDataMgr():GetVipRewardStateByGroup(self.selectGroup)
end

function Vip_NewMemberPrivilegeUI:RefreshLevelData()
  self.nowGroup = self:GetMemberDataMgr():GetCurMemberGroup()
  self.nowStar = self:GetMemberDataMgr():GetCurMemberStar()
  self.nextGroup = self:GetMemberDataMgr():GetNextLevelMemberGroup()
  self.nextStar = self:GetMemberDataMgr():GetNextMemberStar()
end

function Vip_NewMemberPrivilegeUI:RefreshExpData()
  self.curExp = self:GetMemberDataMgr():GetCurExp()
  self.totalExp = self:GetMemberDataMgr():GetCurTotalExp()
end

function Vip_NewMemberPrivilegeUI:RefreshPageView(isInit)
  if isInit then
    if self:GetMemberDataMgr() then
      self.pageContainer:SetData(self.pageList)
    end
    local y = 0
    if self.selectGroup >= 9 then
      y = self.originGroupPos.y + (self.selectGroup - 8) * 57
    end
    self.GroupList.transform.localPosition = Vector3(self.originGroupPos.x, y, 0)
  end
  self.pageContainer:SetTemplateData(self.selectGroup, self.SetTemplatDataCallBack)
end

function Vip_NewMemberPrivilegeUI:RefreshMemberView()
  self:RefreshTopView()
  self:RefrehExpView()
  self:RefreshBtnView()
  self:RefreshDesView()
  self:RefreshRewardView()
end

function Vip_NewMemberPrivilegeUI:RefreshTopView()
  local nowemberName = self:GetMemberDataMgr():GetMemberStrByGroupTxt(self.nowGroup)
  self.lab_level:SetText(nowemberName)
  self.lab_level_s:SetText(string.format(self.starStrFormat, self.nowStar))
  self:RefrehExpView()
end

function Vip_NewMemberPrivilegeUI:RefrehExpView()
  if not self.isMax then
    local nextMemberName = self:GetMemberDataMgr():GetMemberStrByGroup(self.nextGroup)
    self.lab_levelExp:SetText(string.format(self.upStrFormat, tostring(self.totalExp - self.curExp), nextMemberName, tostring(self.nextStar)))
  else
    self.lab_levelExp:SetText("")
  end
  self.lab_progress:SetText(self.curExp .. "/" .. self.totalExp)
  self.Fill.image.fillAmount = self.curExp / self.totalExp
end

function Vip_NewMemberPrivilegeUI:RefreshDesView()
  if self.memberTbl == nil then
    return
  end
  self:SetSprite("Atlas_Language", "img_member_lv" .. self.selectGroup, self.left_img_title)
  self.desContainer:SetData(self.desList)
end

function Vip_NewMemberPrivilegeUI:RefreshRewardView()
  if self.memberTbl == nil then
    return
  end
  self.rewardContainer:SetData(self:GetMemberDataMgr():TryGetRewardByMemberId(self.memberTbl.id))
end

function Vip_NewMemberPrivilegeUI:RefreshBtnView()
  local curMemberName = self:GetMemberDataMgr():GetMemberStrByGroup(self.selectGroup)
  local maxStar = self:GetMemberDataMgr():GetMaxMemberStarByGroup(self.selectGroup)
  self.lab_condition:SetText(string.format(self.btnStrFormat, curMemberName, maxStar))
  self.btn_active:SetActive(self.VipRewardState == EMemberRewardState.Get)
  self.img_geted:SetActive(self.VipRewardState == EMemberRewardState.Geted)
  self.lab_condition:SetActive(self.VipRewardState == EMemberRewardState.NotGet)
end

function Vip_NewMemberPrivilegeUI:ClickTogCallBackFunc(id, group)
  if id == self.id then
    return
  end
  self.id = id
  self.selectGroup = group
  self.desId = self:GetMemberDataMgr():GetLastLevelByGroup(group)
  self:RefreshDesData()
  self:RefreshBasicData()
  self:RefreshPageView()
  self:RefreshBtnView()
  self:RefreshDesView()
  self:RefreshRewardView()
end

function Vip_NewMemberPrivilegeUI.SetTemplatDataCallBack(templat, id)
  templat:RefreshToggleState(id)
  templat:RefreshRedPointView()
end

function Vip_NewMemberPrivilegeUI:GetMeetPageGroup()
  if self.args and self.args.openSecondTab then
    local id = self.args.openSecondTab
    self.args.openSecondTab = nil
    return id
  end
  if self:GetMemberDataMgr() then
    return self:GetMemberDataMgr():GetFirstPageGroup()
  end
  return 1
end

function Vip_NewMemberPrivilegeUI:OnHide()
end

function Vip_NewMemberPrivilegeUI:OnDestroy()
end
