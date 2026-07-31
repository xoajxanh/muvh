Vip_MemberUI = class(BaseUI)
Vip_MemberUI.layer = UILayer.Panel
Vip_MemberUI.orderInLayer = 0
Vip_MemberUI.hideType = UIHideType.WaitDestroy
Vip_MemberUI.hideFunc = UIHideFunc.MoveOutOfScreen
Vip_MemberUI.escClose = UIEscClose.DontClose

function Vip_MemberUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("bg_Member/btn_close")
  self.go_MemberListGroup = self:GetControl("bg_Member/go_MemberListGroup")
  self.GroupList = self:GetControl("bg_Member/go_MemberListGroup/Viewport/GroupList")
  self.Tog_Btn = self:GetControl("bg_Member/go_MemberListGroup/Viewport/GroupList/Tog_Btn")
  self.go_MemberPrivilege = self:GetControl("bg_Member/go_MemberPrivilege")
  self.left_img_title = self:GetControl("bg_Member/go_MemberPrivilege/left_Privilege/left_img_title")
  self.btn_member_reward = self:GetControl("bg_Member/go_MemberPrivilege/left_Privilege/btn_member_reward")
  self.text_member_reward = self:GetControl("bg_Member/go_MemberPrivilege/left_Privilege/btn_member_reward/text_member_reward")
  self.btn_member_everydayreward = self:GetControl("bg_Member/go_MemberPrivilege/left_Privilege/btn_member_everydayreward")
  self.text_member_everydayreward = self:GetControl("bg_Member/go_MemberPrivilege/left_Privilege/btn_member_everydayreward/text_member_everydayreward")
  self.member_reward_gift = self:GetControl("bg_Member/go_MemberPrivilege/left_Privilege/member_reward_gift")
  self.btn_3DItem = self:GetControl("bg_Member/go_MemberPrivilege/left_Privilege/member_reward_gift/Viewport/grid_reward/btn_3DItem")
  self.btn_member_buy_gift = self:GetControl("bg_Member/go_MemberPrivilege/left_Privilege/btn_member_buy_gift")
  self.img_redPoint = self:GetControl("bg_Member/go_MemberPrivilege/left_Privilege/btn_member_buy_gift/img_redPoint")
  self.member_everydayreward_gift = self:GetControl("bg_Member/go_MemberPrivilege/left_Privilege/member_everydayreward_gift")
  self.btn_everydayItem = self:GetControl("bg_Member/go_MemberPrivilege/left_Privilege/member_everydayreward_gift/Viewport/grid_reward/btn_everydayItem")
  self.Desc = self:GetControl("bg_Member/go_MemberPrivilege/left_Privilege/sw_PrivilegeDes/Viewport/Content/Desc")
  self.reward_title = self:GetControl("bg_Member/go_MemberPrivilege/left_Privilege/reward_title")
  self.everydayreward_title = self:GetControl("bg_Member/go_MemberPrivilege/left_Privilege/everydayreward_title")
  self.grid_mission = self:GetControl("bg_Member/go_MemberPrivilege/right_Mission/sw_Mission/Viewport/grid_mission")
  self.go_mission = self:GetControl("bg_Member/go_MemberPrivilege/right_Mission/sw_Mission/Viewport/grid_mission/go_mission")
  self.lab_mission = self:GetControl("bg_Member/go_MemberPrivilege/right_Mission/sw_Mission/Viewport/grid_mission/go_mission/lab_mission")
  self.lab_finish = self:GetControl("bg_Member/go_MemberPrivilege/right_Mission/sw_Mission/Viewport/grid_mission/go_mission/lab_finish")
  self.lab_unfinish = self:GetControl("bg_Member/go_MemberPrivilege/right_Mission/sw_Mission/Viewport/grid_mission/go_mission/lab_unfinish")
  self.lab_go = self:GetControl("bg_Member/go_MemberPrivilege/right_Mission/sw_Mission/Viewport/grid_mission/go_mission/btn_go/lab_go")
  self.btn_recharge = self:GetControl("bg_Member/go_MemberPrivilege/right_Mission/btn_recharge")
  self.lab_recharge = self:GetControl("bg_Member/go_MemberPrivilege/right_Mission/btn_recharge/lab_recharge")
  self.Mission_nextPrompt = self:GetControl("bg_Member/go_MemberPrivilege/right_Mission/Mission_nextPrompt")
  self.rechargeMember_des = self:GetControl("bg_Member/go_MemberPrivilege/right_Mission/rechargeMember_des")
  self.lab_member_name = self:GetControl("bg_Member/MyMember/lab_member_name")
end

function Vip_MemberUI:GetMemberDataMgr()
  if gameMgr:GetAvatarManager() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr()
  end
  return nil
end

function Vip_MemberUI:Init()
end

function Vip_MemberUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
  self:SetRewardActiveEffect()
end

function Vip_MemberUI:InitUI()
  self:InitParams()
end

function Vip_MemberUI:InitParams()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.member
  })
  self.targetIndex = 0
  
  function self.ClickTogCallBack(id)
    self:ClickTogCallBackFunc(id)
  end
  
  self.pageContainer = UIUtility.BindUIContainerTemp(self.Tog_Btn, LuaComponentTemplates.Vip_MemberPageTemplat, self, {
    goCallBack = self.ClickTogCallBack
  })
  self.desContainer = UIUtility.BindUIContainerTemp(self.Desc, LuaComponentTemplates.Vip_MemberDesTemplate, self)
  self.rewardContainer = UIUtility.BindUIContainerTemp(self.btn_3DItem, LuaComponentTemplates.UIItemTemplate, self, {isShowTips = true})
  self.missionContainer = UIUtility.BindUIContainerTemp(self.go_mission, LuaComponentTemplates.Vip_MemberMissionTemplat, self)
  self.everydayrewardContainer = UIUtility.BindUIContainerTemp(self.btn_everydayItem, LuaComponentTemplates.UIItemTemplate, self, {isShowTips = true})
  self.initializedPage = false
  self.originGroupPos = self.GroupList.transform.localPosition
end

function Vip_MemberUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Vip_MemberUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_member_buy_gift:SetOnClick(self, self.btn_member_buy_giftOnClick)
  self.btn_recharge:SetOnClick(self, self.btn_rechargeOnClick)
  self.btn_member_reward:SetOnClick(self, self.btn_member_rewardClick)
  self.btn_member_everydayreward:SetOnClick(self, self.btn_member_everydayrewardClick)
end

function Vip_MemberUI:RegistEvents()
  self:RegistEvent(Event.MemberLevelChanged, self.UpdataLevelCallBack, self)
  self:RegistEvent(Event.MemberMissionChanged, self.UpdataMissionCallBack, self)
  self:RegistEvent(Event.MemberRewardChanged, self.UpdataRewardCallBack, self)
end

function Vip_MemberUI:btn_closeBgOnClick()
  UIManager.Hide(UIID.Vip_MemberUI)
end

function Vip_MemberUI:btn_closeOnClick()
  UIManager.Hide(UIID.Vip_MemberUI)
end

function Vip_MemberUI:btn_member_buy_giftOnClick()
  if self.dailyRewardState == EMemberRewardState.Get then
    networkRequest.ReqVipMemberDailyReward()
  end
end

function Vip_MemberUI:btn_rechargeOnClick()
  if self.buyInfo == nil or self.buyInfo.type == nil then
    return
  end
  if self.buyInfo.type == EBuyMethodType.BuyTips then
    UIManager.Show(UIID.Vip_Member_PromptUI, {
      memberId = self.curMemberLevel + 1,
      buyInfo = self.buyInfo
    })
  elseif self.buyInfo.type == EBuyMethodType.Recharge then
    if self.buyInfo.shopId then
      local rechargeTbl = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(self.buyInfo.shopId)
      if rechargeTbl then
        DataToCSharpMgr.Pay({
          amount = rechargeTbl.rmb,
          product_Id = self.buyInfo.shopId
        })
      end
    end
  elseif self.buyInfo.type == EBuyMethodType.JumpPanel then
    local navTbl = ClientTable.cfg_Navigation_barManager:TryGetValue(tonumber(self.buyInfo.shopId))
    if GradData.GoToNavi(navTbl) then
      NavigationUtility.OpenPanel(navTbl)
    end
  end
end

function Vip_MemberUI:btn_member_rewardClick()
  networkRequest.ReqVipMemberLevelReward(self.id)
end

function Vip_MemberUI:btn_member_everydayrewardClick()
  if self.dailyRewardState == EMemberRewardState.Get then
    networkRequest.ReqVipMemberDailyReward()
  end
end

function Vip_MemberUI:UpdataLevelCallBack(id, msg)
  self:RefreshAll(true)
end

function Vip_MemberUI:UpdataMissionCallBack(id, msg)
  if msg ~= nil and msg.id == self.id then
    self:RefreshMemberMissionVew()
  end
end

function Vip_MemberUI:UpdataRewardCallBack(id, msg)
  self:RefreshAll(true)
end

function Vip_MemberUI:Refresh()
  networkRequest.ReqVipMemberNowTask()
  self:RefreshAll(true)
end

function Vip_MemberUI:RefreshAll(isInit)
  self:RefreshData(isInit)
  self:RefreshPageView(isInit)
  self:RefreshMemberView()
end

function Vip_MemberUI:RefreshData(isInit)
  if self:GetMemberDataMgr() == nil then
    return
  end
  if isInit then
    self.pageList = self:GetMemberDataMgr():GetMeetPageInfoList()
    self.id = self:GetMeetPageId()
    self.initializedPage = false
  end
  self.memberTbl = ClientTable.cfg_MemberManager:TryGetValue(self.id)
  self.desList = {}
  if self.memberTbl then
    self.desList = string.split(self.memberTbl.tips, "&")
  end
  self.curMemberLevel = self:GetMemberDataMgr():GetMemberLevle()
  self.nextMemberTbl = ClientTable.cfg_MemberManager:TryGetValue(self.curMemberLevel + 1)
  self.surState = self:GetMemberDataMgr():GetMemberSrcStateByGroup(self.id)
  self.buyState = self:GetMemberDataMgr():GetSrcBuyStateByGroup(self.id)
  self.dailyRewardState = self:GetMemberDataMgr():GetDailyRewardStateByGroup(self.id)
  self.VipRewardState = self:GetMemberDataMgr():GetVipRewardStateByGroup(self.id)
  self.buyInfo = self:GetMemberDataMgr():GetMemberCurBuyInfo()
end

function Vip_MemberUI:RefreshPageView(isInit)
  if isInit then
    if self:GetMemberDataMgr() then
      self.pageContainer:SetData(self.pageList)
    end
    local y = 0
    if self.id >= 9 then
      y = self.originGroupPos.y + (self.id - 9) * 57
    end
    self.GroupList.transform.localPosition = Vector3(self.originGroupPos.x, y, 0)
  end
  self:SetSprite("Atlas_Language", "img_myMem_" .. self.curMemberLevel, self.lab_member_name)
  self.pageContainer:SetTemplateData(self.id, self.SetTemplatDataCallBack)
end

function Vip_MemberUI:RefreshMemberView()
  self:RefreshDesAndRewardView()
  self:RefreshMemberMissionVew()
  self:SetRewardActive()
end

function Vip_MemberUI:RefreshDesAndRewardView()
  if self.memberTbl == nil then
    return
  end
  self:SetSprite("Atlas_Language", "img_member_lv" .. self.memberTbl.id, self.left_img_title)
  self.desContainer:SetData(self.desList)
  self.rewardContainer:SetData(self:GetMemberDataMgr():TryGetRewardByMemberId(self.memberTbl.id))
  self.everydayrewardContainer:SetData(self:GetMemberDataMgr():TryGetDailyRewardByMemberId(self.memberTbl.id))
  self.btn_recharge:SetActive(self.buyState == EMemberBuyState.CanBuy)
  self.img_redPoint:SetActive(self.dailyRewardState == EMemberRewardState.Get)
  self.rechargeMember_des:SetText(self.nextMemberTbl and self.nextMemberTbl.tips2 or "")
  self.rechargeMember_des:SetActive(self.buyState == EMemberBuyState.CanBuy)
end

function Vip_MemberUI:SetRewardActive()
  local IsShowVipReward = self.VipRewardState ~= EMemberRewardState.Geted
  self.reward_title:SetActive(IsShowVipReward)
  self.member_reward_gift:SetActive(IsShowVipReward)
  self.btn_member_reward:SetActive(self.VipRewardState == EMemberRewardState.Get)
  self.everydayreward_title:SetActive(not IsShowVipReward and self.dailyRewardState == EMemberRewardState.Get)
  self.member_everydayreward_gift:SetActive(not IsShowVipReward and self.dailyRewardState == EMemberRewardState.Get)
  self.btn_member_everydayreward:SetActive(not IsShowVipReward and self.dailyRewardState == EMemberRewardState.Get)
end

function Vip_MemberUI:SetRewardActiveEffect()
  UIEffectUtility.SetUIEffect("Eff_UI_annuikuang03", self.btn_member_reward, true, Vector3(1.3, 1.1, 1), Vector3(0, 0, 0))
  UIEffectUtility.SetUIEffect("Eff_UI_annuikuang03", self.btn_member_everydayreward, true, Vector3(1.3, 1.1, 1), Vector3(0, 0, 0))
end

function Vip_MemberUI:RefreshMemberMissionVew()
  if self.surState == EMemberSrcState.UnLock and self:GetMemberDataMgr() then
    self.missionContainer:SetData(self:GetMemberDataMgr():GetTaskItemByLevel(self.id))
  else
    self.missionContainer:SetData({})
  end
  self.Mission_nextPrompt:SetActive(self.surState == EMemberSrcState.Lock)
end

function Vip_MemberUI:ClickTogCallBackFunc(id)
  if id == self.id then
    return
  end
  self.id = id
  self:RefreshData()
  self:RefreshPageView()
  self:RefreshMemberView()
end

function Vip_MemberUI.SetTemplatDataCallBack(templat, id)
  templat:RefreshToggleState(id)
  templat:RefreshRedPointView()
end

function Vip_MemberUI:GetMeetPageId()
  if self.args and self.args.openFirstTab then
    local id = self.args.openFirstTab
    self.args.openFirstTab = nil
    return id
  end
  if self:GetMemberDataMgr() then
    return self:GetMemberDataMgr():GetFirstPageGroup()
  end
  return 1
end

function Vip_MemberUI:OnHide()
end

function Vip_MemberUI:OnDestroy()
end
