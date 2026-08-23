GuideMaskUI = class(BaseUI)
GuideMaskUI.layer = UILayer.Prompt
GuideMaskUI.orderInLayer = 10
GuideMaskUI.hideType = UIHideType.WaitDestroy
GuideMaskUI.hideFunc = UIHideFunc.MoveOutOfScreen
GuideMaskUI.escClose = UIEscClose.DontClose

function GuideMaskUI:InitControls()
  self.MaskPanel = self:GetControl("MaskPanel")
  self.GuideMask = self:GetControl("MaskPanel/GuideMask")
  self.TargetArea = self:GetControl("MaskPanel/GuideMask/TargetArea")
end

function GuideMaskUI:OnPreLoad()
end

function GuideMaskUI:Init()
end

function GuideMaskUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function GuideMaskUI:InitUI()
end

function GuideMaskUI:OnShow()
  if self.recTimer ~= nil then
    Timer.Stop(self.recTimer)
    self.recTimer = nil
  end
  self:RegistEvents()
  self:Refresh()
end

function GuideMaskUI:OnHide()
  self:CloseTimer()
end

function GuideMaskUI:OnDestroy()
end

function GuideMaskUI:RegistUIEvents()
end

function GuideMaskUI:btn_CloseOnClick(control)
end

function GuideMaskUI:RegistEvents()
end

function GuideMaskUI:Refresh()
  self.GuideMask.canvasGroup.alpha = 1
  local guideMask = self.MaskPanel.transform.gameObject:GetComponentInChildren(typeof(CS.Framework.GuideMask))
  
  local function Hide()
    local quence = DOTween.Sequence()
    quence:Append(self.GuideMask.canvasGroup:DOFade(0, 0.5)):OnComplete(function()
      UIManager.Hide(UIID.GuideMaskUI)
    end)
  end
  
  if self.args and self.args.obj then
    local obj = self.args.obj
    if guideMask ~= nil then
      guideMask:Init()
      guideMask:Play(obj.rectTransform, UIManager.uiCamera)
    end
    if self.args.isTimer then
      self.recTimer = Timer.Start(1, Hide)
    end
  elseif self.args and self.args.id then
    local uiName = ClientTable.cfg_Guide_stepManager:TryGetValue(self.args.id, "order").uiName
    if GuideManager.GuideBtn[uiName] and GuideManager.GuideBtn[uiName][self.args.id] then
      local obj = GuideManager.GuideBtn[uiName][self.args.id].obj
      if guideMask ~= nil then
        guideMask:Init()
        guideMask:Play(obj.rectTransform, UIManager.uiCamera)
      end
    end
    self.recTimer = Timer.Start(1, Hide)
  end
end

function GuideMaskUI:CloseTimer()
  if self.recTimer ~= nil then
    Timer.Stop(self.recTimer)
    self.recTimer = nil
  end
end
