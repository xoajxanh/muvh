FlyShoe_FlyShoeUI = class(BaseUI)
FlyShoe_FlyShoeUI.layer = UILayer.Loading
FlyShoe_FlyShoeUI.orderInLayer = -2
FlyShoe_FlyShoeUI.hideType = UIHideType.WaitDestroy
FlyShoe_FlyShoeUI.hideFunc = UIHideFunc.MoveOutOfScreen
FlyShoe_FlyShoeUI.escClose = UIEscClose.DontClose

function FlyShoe_FlyShoeUI:InitControls()
  self.btn_closeBg = self:GetControl("Panel_Tip/btn_closeBg")
  self.Text_TipTitle = self:GetControl("Panel_Tip/Image_TipBg/Text_TipTitle")
  self.Image_quickpass = self:GetControl("Panel_Tip/Image_quickpass")
  self.img_tips = self:GetControl("Panel_Tip/Image_quickpass/img_tips")
  self.lab_quickequip = self:GetControl("Panel_Tip/Image_quickpass/img_tips/lab_quickequip")
  self.lab_countdown = self:GetControl("Panel_Tip/Image_quickpass/img_tips/lab_countdown")
end

FlyShoe_FlyShoeUI.isClickFlyShoe = false

function FlyShoe_FlyShoeUI:OnPreLoad()
end

function FlyShoe_FlyShoeUI:Init()
  self.eventContainer = EventContainer(EventManager)
end

function FlyShoe_FlyShoeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function FlyShoe_FlyShoeUI:InitUI()
end

function FlyShoe_FlyShoeUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function FlyShoe_FlyShoeUI:OnHide()
  self:StopTimer()
  UIManager.Show(UIID.Exp_ExpShowUI)
end

function FlyShoe_FlyShoeUI:OnDestroy()
end

function FlyShoe_FlyShoeUI:RegistUIEvents()
  self.Image_quickpass:SetOnClick(self, self.Image_quickpassOnClick)
end

function FlyShoe_FlyShoeUI:Image_quickpassOnClick(control)
  self:OnClickFlyShoes()
end

function FlyShoe_FlyShoeUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
end

function FlyShoe_FlyShoeUI:RegistEvents()
  self.eventContainer:Regist(Event.FlyShoeRefresh, self.OnRefresh, self)
end

function FlyShoe_FlyShoeUI:Refresh()
  if UIManager.IsVisible(UIID.Exp_ExpShowUI) then
    UIManager.Hide(UIID.Exp_ExpShowUI)
  end
  self:StopTimer()
  if self.args then
  end
  self.Image_quickpass:SetActive(false)
  goto lbl_74
  if self.args.transferId ~= nil and self.args.transferId ~= 0 then
    self.Image_quickpass:SetActive(true)
    if self.args.purpose == Purpose.ForTask then
      if RoleManager.me.data.level <= tonumber(GlobalConfig.GetGlobalConfig(2240002)) then
        self.img_tips:SetActive(true)
        self:StartTimer()
      else
        self.img_tips:SetActive(false)
      end
    else
      self.img_tips:SetActive(false)
    end
  else
    self.Image_quickpass:SetActive(false)
  end
  ::lbl_74::
end

function FlyShoe_FlyShoeUI:OnClickFlyShoes()
  if not self.args.transferId or self.args.transferId == 0 then
    return
  end
  self:StopTimer()
  PathFinderManager.FlyTransferScene(self.args.transferId, self.args.line, self.args.param, self.args.purpose, self.args.onArrive)
end

function FlyShoe_FlyShoeUI:StartTimer()
  local timeStr = Mathf.Floor(GlobalConfig.GetGlobalConfig(2240003) / 1000)
  self.lab_countdown:SetText("(" .. timeStr .. "s)")
  
  local function UpdateTimerBtn()
    if 1 < timeStr then
      timeStr = timeStr - 1
      self.lab_countdown:SetText("(" .. timeStr .. "s)")
    elseif timeStr == 1 then
      timeStr = timeStr - 1
      self.lab_countdown:SetText("(" .. timeStr .. "s)")
      self:OnClickFlyShoes()
    end
  end
  
  self.flyTimer = Timer.StartLoop(1, timeStr, UpdateTimerBtn)
end

function FlyShoe_FlyShoeUI:StopTimer()
  if self.flyTimer then
    Timer.Stop(self.flyTimer)
  end
  self.flyTimer = nil
  self.img_tips:SetActive(false)
end

function FlyShoe_FlyShoeUI:OnRefresh(id, msg)
  if msg then
    self.args = msg
  else
    self.args = nil
  end
  self:Refresh()
end
