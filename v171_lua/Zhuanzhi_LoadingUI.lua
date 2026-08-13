Zhuanzhi_LoadingUI = class(BaseUI)
Zhuanzhi_LoadingUI.layer = UILayer.Tooltip
Zhuanzhi_LoadingUI.orderInLayer = 10
Zhuanzhi_LoadingUI.hideType = UIHideType.WaitDestroy
Zhuanzhi_LoadingUI.hideFunc = UIHideFunc.MoveOutOfScreen
Zhuanzhi_LoadingUI.escClose = UIEscClose.DontClose

function Zhuanzhi_LoadingUI:InitControls()
  self.RawImage_Background = self:GetControl("RawImage_Background")
  self.lab_Message = self:GetControl("lab_Message")
end

function Zhuanzhi_LoadingUI:OnPreLoad()
end

function Zhuanzhi_LoadingUI:Init()
end

function Zhuanzhi_LoadingUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Zhuanzhi_LoadingUI:CoolDown()
  self:CleanCoolDown()
  if self.autoTime and tonumber(self.autoTime) > 0 then
    local function CoolDownTime()
      self.autoTime = self.autoTime - 1
      
      if self.autoTime <= 0 then
        NetManager.Send(UserMessage.ReqLogout, {
          reason = ELogoutType.LogOut
        })
        self:LoadTime()
        self:CoolDown()
      end
    end
    
    self.countDownTimer = Timer.StartLoop(1, self.autoTime, CoolDownTime)
  end
end

function Zhuanzhi_LoadingUI:CloseZhuanzhiLoadingUI()
  self:CleanCoolDown()
  UIManager.Hide(UIID.Zhuanzhi_LoadingUI)
end

function Zhuanzhi_LoadingUI:CleanCoolDown()
  if self.countDownTimer then
    Timer.Stop(self.countDownTimer)
    self.countDownTimer = nil
  end
end

function Zhuanzhi_LoadingUI:LoadTime()
  local tbl = ConfigManager.GetConfig("cfg_Global_global", 2180002, "id")
  self.autoTime = tbl and Mathf.Floor(tonumber(tbl.effect) / 1000) or 10
end

function Zhuanzhi_LoadingUI:InitUI()
end

function Zhuanzhi_LoadingUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:LoadTime()
  self:CoolDown()
  self:LoadBack()
end

function Zhuanzhi_LoadingUI:LoadBack()
  self.backCor = Coroutine.Start(function()
    local name = string.format("Texture/%s", BaseCareerBackEnum[RoleUtility.GetBasicCareer(TransferCareerData.GetTransferCareer())])
    local request = self:LoadAssetAsync(name, typeof(CS.UnityEngine.Texture2D))
    Coroutine.Yield(request)
    if request.isError then
      Coroutine.Break()
    end
    self.RawImage_Background:SetTexture(request.res)
    self.backCor = nil
  end)
end

function Zhuanzhi_LoadingUI:OnHide()
  self:CleanCoolDown()
end

function Zhuanzhi_LoadingUI:OnDestroy()
end

function Zhuanzhi_LoadingUI:RegistUIEvents()
  self:RegistEvent(Event.GamePlay_Leave, self.CloseZhuanzhiLoadingUI, self)
  self:RegistEvent(Event.GamePlay_Back2Choose, self.CloseZhuanzhiLoadingUI, self)
  self:RegistEvent(Event.Role_TransferCareerState, self.RoleTransferCareerState, self)
end

function Zhuanzhi_LoadingUI:RoleTransferCareerState(_, msg)
  if msg.state == ERoleTransferCareerState.END then
  end
end

function Zhuanzhi_LoadingUI:RegistEvents()
end

function Zhuanzhi_LoadingUI:Refresh()
end
