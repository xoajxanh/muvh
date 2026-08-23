InstanceCountDown = class(BaseUI)
InstanceCountDown.layer = UILayer.Prompt
InstanceCountDown.orderInLayer = 0
InstanceCountDown.hideType = UIHideType.WaitDestroy
InstanceCountDown.hideFunc = UIHideFunc.MoveOutOfScreen
InstanceCountDown.escClose = UIEscClose.DontClose

function InstanceCountDown:InitControls()
  self.Image_TipBg = self:GetControl("Image_TipBg")
  self.Text_TipTitle = self:GetControl("Image_TipBg/Text_TipTitle")
end

function InstanceCountDown:Init()
end

function InstanceCountDown:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function InstanceCountDown:InitUI()
  local surplusTime = 10
  
  local function UpdateTimer()
    local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
    self.Text_TipTitle:SetText(timeStr)
    surplusTime = surplusTime - 1
    if surplusTime == 0 then
      self:Hide()
    end
  end
  
  self.Timer = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function InstanceCountDown:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function InstanceCountDown:OnHide()
end

function InstanceCountDown:OnDestroy()
end

function InstanceCountDown:RegistUIEvents()
end

function InstanceCountDown:RegistEvents()
  self:RegistEvent(Event.Scene_OnEnterScene, self.Scene_ShootSceneFunc, self)
end

function Instance_InstanceUI:Scene_ShootSceneFunc(id, msg)
  self:Hide()
end

function InstanceCountDown:Refresh()
end
