Vip_NewMemberMainUI = class(BaseUI)
Vip_NewMemberMainUI.layer = UILayer.Panel
Vip_NewMemberMainUI.orderInLayer = 0
Vip_NewMemberMainUI.hideType = UIHideType.WaitDestroy
Vip_NewMemberMainUI.hideFunc = UIHideFunc.MoveOutOfScreen
Vip_NewMemberMainUI.escClose = UIEscClose.DontClose

function Vip_NewMemberMainUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Btns = self:GetControl("Btns")
  self.btn_privilege = self:GetControl("Btns/btn_privilege")
  self.lab_p_a = self:GetControl("Btns/btn_privilege/lab_p_a")
  self.privilegeCheckmark = self:GetControl("Btns/btn_privilege/privilegeCheckmark")
  self.lab_p_b = self:GetControl("Btns/btn_privilege/privilegeCheckmark/lab_p_b")
  self.btn_levelUp = self:GetControl("Btns/btn_levelUp")
  self.lab_m_a = self:GetControl("Btns/btn_levelUp/lab_m_a")
  self.levelUpCheckmark = self:GetControl("Btns/btn_levelUp/levelUpCheckmark")
  self.lab_m_b = self:GetControl("Btns/btn_levelUp/levelUpCheckmark/lab_m_b")
  self.btn_close = self:GetControl("btn_close")
end

function Vip_NewMemberMainUI:Init()
end

function Vip_NewMemberMainUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Vip_NewMemberMainUI:InitUI()
  self:InitParam()
end

function Vip_NewMemberMainUI:InitParam()
  function self.hidePanel(ui)
    if ui and UIManager.IsVisible(ui) then
      UIManager.Hide(ui)
    end
  end
  
  function self.showPanel(ui)
    if ui and not UIManager.IsVisible(ui) then
      UIManager.Show(ui, self.args)
      self.args = nil
    end
  end
  
  self.switchFunc = {
    [true] = self.showPanel,
    [false] = self.hidePanel
  }
  self.viewRule = {
    [EMemberViewType.Member] = UIID.Vip_NewMemberPrivilegeUI,
    [EMemberViewType.Task] = UIID.Vip_NewMemberTaskUI
  }
end

function Vip_NewMemberMainUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_privilege:SetOnClick(self, self.btn_privilegeOnClick)
  self.btn_levelUp:SetOnClick(self, self.btn_levelUpOnClick)
end

function Vip_NewMemberMainUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Vip_NewMemberMainUI)
  UIManager.Hide(UIID.Vip_NewMemberPrivilegeUI)
  UIManager.Hide(UIID.Vip_NewMemberTaskUI)
end

function Vip_NewMemberMainUI:btn_privilegeOnClick(control)
  self:SetType(EMemberViewType.Member)
end

function Vip_NewMemberMainUI:btn_levelUpOnClick(control)
  self:SetType(EMemberViewType.Task)
end

function Vip_NewMemberMainUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Vip_NewMemberMainUI:RegistEvents()
  self:RegistEvent(Event.MemberSwitchView, self.MemberSwitchViewCallBack, self)
end

function Vip_NewMemberMainUI:MemberSwitchViewCallBack(id, type)
  if type then
    self:SetType(type)
  end
end

function Vip_NewMemberMainUI:Refresh()
  local viewType = EMemberViewType.Member
  if self.args and self.args.openFirstTab then
    viewType = self.args.openFirstTab
    self.args.openFirstTab = nil
  end
  self:SetType(viewType)
end

function Vip_NewMemberMainUI:SetType(type)
  if self.viewType == type then
    return
  end
  self.viewType = type
  self:RefreshBtnState()
  self:RefreshPanelState()
end

function Vip_NewMemberMainUI:RefreshBtnState()
  self.privilegeCheckmark:SetActive(self.viewType == EMemberViewType.Member)
  self.levelUpCheckmark:SetActive(self.viewType == EMemberViewType.Task)
end

function Vip_NewMemberMainUI:RefreshPanelState()
  for type, v in pairs(self.viewRule) do
    self.switchFunc[type == self.viewType](v)
  end
end

function Vip_NewMemberMainUI:OnHide()
  self.viewType = nil
  for type, v in pairs(self.viewRule) do
    self.switchFunc[false](v)
  end
  UIManager.Hide(UIID.Vip_exchangeUI)
end

function Vip_NewMemberMainUI:OnDestroy()
end
