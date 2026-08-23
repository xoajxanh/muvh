Vip_NewMemberTaskUI = class(BaseUI)
Vip_NewMemberTaskUI.layer = UILayer.Panel
Vip_NewMemberTaskUI.orderInLayer = 0
Vip_NewMemberTaskUI.hideType = UIHideType.WaitDestroy
Vip_NewMemberTaskUI.hideFunc = UIHideFunc.MoveOutOfScreen
Vip_NewMemberTaskUI.escClose = UIEscClose.DontClose

function Vip_NewMemberTaskUI:InitControls()
  self.go_task = self:GetControl("Panel/go_MemberTask/Task_info/sw_Task/Viewport/grid_task/go_task")
  self.lab_unfinish = self:GetControl("Panel/go_MemberTask/Task_info/sw_Task/Viewport/grid_task/go_task/lab_unfinish")
  self.lab_memberAdd = self:GetControl("Panel/go_MemberLevel/level_info/lab_member")
  self.MemberLv = self:GetControl("Panel/go_MemberLevel/sw_Level/Viewport/grid_level/MemberLv")
  self.lab_member_name = self:GetControl("Panel/go_MemberExp/MemberLv/lab_member_name")
  self.lab_level = self:GetControl("Panel/go_MemberExp/MemberLv/lab_level")
  self.Fill = self:GetControl("Panel/go_MemberExp/sl_progress/Fill Area/Fill")
  self.lab_progress = self:GetControl("Panel/go_MemberExp/sl_progress/lab_progress")
  self.next_lab_member_name = self:GetControl("Panel/go_MemberExp/NextMemberLv/lab_member_name")
  self.next_lab_level = self:GetControl("Panel/go_MemberExp/NextMemberLv/lab_level")
  self.btn_member = self:GetControl("Panel/go_MemberExp/btn_member")
  self.btn_close = self:GetControl("Panel/btn_close")
end

function Vip_NewMemberTaskUI:Init()
end

function Vip_NewMemberTaskUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
  self:InitParams()
end

function Vip_NewMemberTaskUI:InitUI()
end

function Vip_NewMemberTaskUI:RegistUIEvents()
  self.lab_unfinish:SetOnClick(self, self.lab_unfinishOnClick)
  self.btn_member:SetOnClick(self, self.btn_memberOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Vip_NewMemberTaskUI:lab_unfinishOnClick(control)
end

function Vip_NewMemberTaskUI:btn_memberOnClick(control)
  UIManager.Show(UIID.Vip_exchangeUI)
end

function Vip_NewMemberTaskUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Vip_exchangeUI)
  UIManager.Hide(UIID.Vip_NewMemberTaskUI)
  UIManager.Hide(UIID.Vip_NewMemberMainUI)
end

function Vip_NewMemberTaskUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Vip_NewMemberTaskUI:RegistEvents()
  self:RegistEvent(Event.MemberLevelChanged, self.UpdataLevelCallBack, self)
  self:RegistEvent(Event.MemberMissionChanged, self.MemberMissionChangedCallBack, self)
  self:RegistEvent(Event.MemberExpChanged, self.UpdataExpCallBack, self)
end

function Vip_NewMemberTaskUI:InitParams()
  self.go_taskContainer = UIUtility.BindUIContainerTemp(self.go_task, LuaComponentTemplates.Vip_MemberDailyMissionTemplat, self)
  self.MemberLvContainer = UIUtility.BindUIContainerTemp(self.MemberLv, LuaComponentTemplates.Vip_TaskMemberItemTemplate, self)
end

function Vip_NewMemberTaskUI:Refresh()
  self:RefreshTopMemberLv()
  self:RefreshCenterTaskList()
  self:RefreshDownLevelPanel()
end

function Vip_NewMemberTaskUI:RefreshTopMemberLv()
  self.MemberLvContainer:SetData(self:GetMemberDataMgr():GetCurGroupDetailedInfo())
end

function Vip_NewMemberTaskUI:RefreshCenterTaskList()
  self.go_taskContainer:SetData(self:GetMemberDataMgr():GetCurDailyTaskList(true))
end

function Vip_NewMemberTaskUI:RefreshDownLevelPanel()
  local nowMemInfo = self:GetMemberDataMgr():GetGroupItemDetailedInfo(self:GetMemberDataMgr():GetMemberLevle())
  local nextMemInfo = self:GetMemberDataMgr():GetGroupItemDetailedInfo(self:GetMemberDataMgr():GetNextMemberLevel())
  local nowExp = self:GetMemberDataMgr():GetCurExp()
  local maxExp = self:GetMemberDataMgr():GetCurTotalExp()
  local FillInfo = nowExp / maxExp
  local FillInfoDes = tostring(nowExp) .. "/" .. tostring(maxExp)
  if nowMemInfo ~= nil then
    self.lab_level:SetText(nowMemInfo.name)
  end
  if nextMemInfo ~= nil then
    self.next_lab_level:SetText(nextMemInfo.name)
  else
    self.next_lab_level:SetText("")
  end
  self.Fill:SetFillAmount(FillInfo)
  self.lab_progress:SetText(FillInfoDes)
end

function Vip_NewMemberTaskUI:btn_memberClickCalBack()
  logError("N\195\186t l\195\170n VIP")
end

function Vip_NewMemberTaskUI:UpdataLevelCallBack()
  self:RefreshTopMemberLv()
  self:RefreshDownLevelPanel()
end

function Vip_NewMemberTaskUI:MemberMissionChangedCallBack()
  self:RefreshCenterTaskList()
end

function Vip_NewMemberTaskUI:UpdataExpCallBack()
  self:RefreshDownLevelPanel()
end

function Vip_NewMemberTaskUI:GetMemberDataMgr()
  if gameMgr:GetAvatarManager() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr()
  end
  return nil
end

function Vip_NewMemberTaskUI:OnHide()
end

function Vip_NewMemberTaskUI:OnDestroy()
end
