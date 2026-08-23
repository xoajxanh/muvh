Loading_WaitingUI = class(BaseUI)
Loading_WaitingUI.layer = UILayer.Dialog
Loading_WaitingUI.orderInLayer = 1
Loading_WaitingUI.hideType = UIHideType.Destroy
Loading_WaitingUI.hideFunc = UIHideFunc.Deactive
Loading_WaitingUI.escClose = UIEscClose.DontClose

function Loading_WaitingUI:InitControls()
  self.Image_Circle = self:GetControl("Panel_NoClick/Panel_Show/Image_Circle")
  self.Text_WaitTip = self:GetControl("Panel_NoClick/Panel_Show/Text_WaitTip")
  self.waitBgBg = self:GetControl("Panel_NoClick/Panel_Show/waitBgBg")
  self.waitFill = self:GetControl("Panel_NoClick/Panel_Show/waitBgBg/waitBg/waitFill")
end

function Loading_WaitingUI:Init()
  self.progress = -1
  self.step = 0.06
end

function Loading_WaitingUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Loading_WaitingUI:InitUI()
end

function Loading_WaitingUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Loading_WaitingUI:OnHide()
end

function Loading_WaitingUI:OnDestroy()
end

function Loading_WaitingUI:Update()
  if self.progress >= 0 then
    self.progress = self.progress + self.step
    self.waitFill:SetFillAmount(self.progress)
    if self.progress >= 1 then
      self.progress = -1
    end
  end
end

function Loading_WaitingUI:RegistUIEvents()
end

function Loading_WaitingUI:RegistEvents()
end

function Loading_WaitingUI:Refresh()
  if self.args.msg == "\196\144ang \196\145\225\187\149i b\225\186\163n \196\145\225\187\147" then
    self.Image_Circle:SetActive(false)
    self.Text_WaitTip:SetActive(false)
    self.waitBgBg:SetActive(true)
    self.progress = 0
    return
  end
  local para = CS.DG.Tweening.TweenParams()
  para:SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
  self.Image_Circle.transform:DORotate(Vector3(0, 0, -180), 1):SetAs(para)
  self.Text_WaitTip:SetText(self.args.msg)
end
