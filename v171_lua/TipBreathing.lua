TipBreathing = class(BaseUI)
TipBreathing.layer = UILayer.Background
TipBreathing.orderInLayer = 3
TipBreathing.hideType = UIHideType.WaitDestroy
TipBreathing.hideFunc = UIHideFunc.MoveOutOfScreen
TipBreathing.escClose = UIEscClose.DontClose

function TipBreathing:InitControls()
  self.BreathingText = self:GetControl("BreathingText")
end

function TipBreathing:OnPreLoad()
end

function TipBreathing:Init()
end

function TipBreathing:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function TipBreathing:InitUI()
end

function TipBreathing:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function TipBreathing:OnHide()
end

function TipBreathing:OnDestroy()
end

local beginTime = 0
local breathe_IN = true
local method_IN = true
local breathe_OUT = false
local method_OUT = false
local JiShi = 0
local Maxtime = 5

function TipBreathing:Update()
  if breathe_IN then
    beginTime = beginTime + Time.deltaTime
  end
  if method_IN then
    self:BreatheIn()
    method_IN = false
  end
  if 1.25 <= beginTime then
    breathe_IN = false
    breathe_OUT = true
    method_OUT = true
  end
  if breathe_OUT then
    beginTime = beginTime - Time.deltaTime
  end
  if method_OUT then
    self:BreatheOut()
    method_OUT = false
  end
  if beginTime <= 0 then
    breathe_IN = true
    breathe_OUT = false
    method_IN = true
  end
  JiShi = JiShi + Time.deltaTime
  if JiShi >= Maxtime then
    JiShi = 0
    UIManager.Hide(UIID.TipBreathing)
  end
end

function TipBreathing:BreatheIn()
  self.BreathingText.transform:DOScale(1.5, 1.25)
end

function TipBreathing:BreatheOut()
  self.BreathingText.transform:DOScale(1, 1.25)
end

function TipBreathing:RegistUIEvents()
end

function TipBreathing:RegistEvents()
end

function TipBreathing:Refresh()
  local name = self.args.text
  self.BreathingText:SetText(name)
end
