System_SmallGameUI = class(BaseUI)
System_SmallGameUI.layer = UILayer.Panel
System_SmallGameUI.orderInLayer = 0
System_SmallGameUI.hideType = UIHideType.WaitDestroy
System_SmallGameUI.hideFunc = UIHideFunc.MoveOutOfScreen
System_SmallGameUI.escClose = UIEscClose.DontClose

function System_SmallGameUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.bg = self:GetControl("img_Bg/bg")
  self.btn_close = self:GetControl("btn_close")
  self.CanvasWebViewPrefab = self:GetControl("img_Bg/bg/img_bgBg/GameView/CanvasWebViewPrefab")
end

function System_SmallGameUI:Init()
  self.loopCoroutine = nil
end

function System_SmallGameUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function System_SmallGameUI:InitUI()
end

function System_SmallGameUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function System_SmallGameUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.System_SmallGameUI)
end

function System_SmallGameUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  CS.MuInterface.Instance:ChangeScreen("Portrait")
  SmallGameData.SetRunningStatus(true)
end

function System_SmallGameUI:RegistEvents()
end

function System_SmallGameUI:Refresh()
  if self.CanvasWebViewPrefab == nil then
    return
  end
  local url = SmallGameData.GetConfigUrl()
  self.webView = self.CanvasWebViewPrefab.gameObject:GetComponent(typeof(CS.Vuplex.WebView.CanvasWebViewPrefab))
  if self.webView then
    if self.loopCoroutine then
      Coroutine.Stop(self.loopCoroutine)
    end
    self.loopCoroutine = Coroutine.Start(function()
      while true do
        Coroutine.Wait(0.5)
        if self.webView.WebView then
          self.webView.WebView:LoadUrl(url)
          Coroutine.Break()
        end
      end
    end)
  end
end

function System_SmallGameUI:OnHide()
  SmallGameData.SetRunningStatus(false)
  CS.MuInterface.Instance:ChangeScreen("Landscape")
  if self.loopCoroutine then
    Coroutine.Stop(self.loopCoroutine)
  end
  EventManager.Dispatch(Event.ChangeScreen)
end

function System_SmallGameUI:OnDestroy()
end
