Tip_killMonsterCardUI = class(BaseUI)
Tip_killMonsterCardUI.layer = UILayer.Panel
Tip_killMonsterCardUI.orderInLayer = 0
Tip_killMonsterCardUI.hideType = UIHideType.Hide
Tip_killMonsterCardUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_killMonsterCardUI.escClose = UIEscClose.DontClose

function Tip_killMonsterCardUI:InitControls()
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Img_TipBg = self:GetControl("Panel_Tip/Img_TipBg")
  self.monsterTime = self:GetControl("Panel_Tip/Img_TipBg/monsterTime")
  self.btn_timeStop = self:GetControl("Panel_Tip/Img_TipBg/btn_timeStop")
  self.btn_add = self:GetControl("Panel_Tip/Img_TipBg/btn_add")
end

function Tip_killMonsterCardUI:OnPreLoad()
end

function Tip_killMonsterCardUI:Init()
end

function Tip_killMonsterCardUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_killMonsterCardUI:InitUI()
end

function Tip_killMonsterCardUI:OnShow()
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {2390002})
  self:RegistEvents()
  self:Refresh()
end

function Tip_killMonsterCardUI:OnHide()
end

function Tip_killMonsterCardUI:OnDestroy()
end

function Tip_killMonsterCardUI:Update()
  self:UpdateCountTimer()
end

function Tip_killMonsterCardUI:RegistUIEvents()
  self.btn_timeStop:SetOnClick(self, self.btn_timeStopOnClick)
  self.btn_add:SetOnClick(self, self.btn_addOnClick)
end

function Tip_killMonsterCardUI:btn_timeStopOnClick(control)
  local isInHookPoint = OnHookData.IsReachLinePoint()
  if isInHookPoint then
    local killMonsterType = false and 13 or 11
    local state = KillMonsterCardData.IsOpenState() and KillMonsterCardType.Close or KillMonsterCardType.Open
    NetManager.Send(UnitMessage.ReqSwitchUnitBuffhUnitBuff, {type = killMonsterType, state = state})
  else
    FloatingWordUtility.QuickMsg("Hi\225\187\135n t\225\186\161i kh\195\180ng \225\187\159 khu v\225\187\177c treo m\195\161y kh\195\180ng th\225\187\131 b\225\186\175t \196\145\225\186\167u treo m\195\161y")
  end
end

function Tip_killMonsterCardUI:btn_addOnClick(control)
  local itemId = false and 3000810 or 3000801
  local itemData = ItemUtility.GenerateItemData(itemId)
  control.itemData = itemData
  control.OpenTipsType = EOpenTipsType.FastBuy
  ItemUtility.ClickObtainItemBtn(_, control)
end

function Tip_killMonsterCardUI:RegistEvents()
  self:RegistEvent(Event.RefreshKillMonsterCardData, self.RefreshKillMonsterCard, self)
  self:RegistEvent(Event.Role_OnArrive, self.OnHookPointChange, self)
  self:RegistEvent(Event.CloseKillMonsterCard, self.CloseKillMonsterCard, self)
  self:RegistEvent(Event.Scene_SceneDataChange, self.JudgeStateWhenSceneChange, self)
  self:RegistEvent(Event.Role_ChangePos, self.RoleChangePosCloseCard, self)
  self:RegistEvent(Event.Me_Dead, self.HidePanel, self)
  self:RegistEvent(Event.Relive, self.OnHookPointChange, self)
end

function Tip_killMonsterCardUI:CloseKillMonsterCard()
  if KillMonsterCardData.IsOpenState() then
    KillMonsterCardData.SetState(KillMonsterCardType.Close)
    local killMonsterType = KillMonsterCardData.openType
    NetManager.Send(UnitMessage.ReqSwitchUnitBuffhUnitBuff, {
      type = killMonsterType,
      state = KillMonsterCardType.Close
    })
  end
end

function Tip_killMonsterCardUI:JudgeStateWhenSceneChange()
  local isInHookPoint, isInHookFightPoint = OnHookData.IsKillMonsterCardLinePoint()
  if not isInHookFightPoint then
    self:CloseKillMonsterCard()
    self:HidePanel()
  end
  self:RefreshKillMonsterCard()
end

function Tip_killMonsterCardUI:RoleChangePosCloseCard(_, id, reason)
  if reason == changeReason == ERoleChangePosReason.Flash and reason == changeReason == ERoleChangePosReason.Transport and reason == changeReason == ERoleChangePosReason.RandomTransport and KillMonsterCardData.IsOpenState() then
    KillMonsterCardData.SetState(KillMonsterCardType.Close)
    local killMonsterType = KillMonsterCardData.openType
    NetManager.Send(UnitMessage.ReqSwitchUnitBuffhUnitBuff, {
      type = killMonsterType,
      state = KillMonsterCardType.Close
    })
  end
end

function Tip_killMonsterCardUI:RefreshKillMonsterCard()
  self.intervalTimeSecond = nil
  self:RefreshCountTime()
  self:RefreshBtnEffect()
  self:RefreshStartBtnEffect()
end

function Tip_killMonsterCardUI:OnHookPointChange()
  local isInHookPoint, isInHookFightPoint = OnHookData.IsKillMonsterCardLinePoint()
  self.Img_TipBg:SetActive(isInHookPoint or KillMonsterCardData.IsOpenState())
  if not isInHookFightPoint then
    self:CloseKillMonsterCard()
  end
end

function Tip_killMonsterCardUI:HidePanel()
  self.Img_TipBg:SetActive(false)
end

function Tip_killMonsterCardUI:Refresh()
  self.intervalTimeSecond = nil
  self:OnHookPointChange()
  self:RefreshBtnEffect()
  self:RefreshStartBtnEffect()
  self:RefreshCountTime()
end

function Tip_killMonsterCardUI:RefreshBtnEffect()
  self.btn_add:GetChild("Eff_UI_annuikuang03"):SetActive(not KillMonsterCardData.IsHasSurplusTime())
end

function Tip_killMonsterCardUI:RefreshStartBtnEffect()
  local intervalTime = self.intervalTimeSecond ~= nil and self.intervalTimeSecond or 0
  self.btn_timeStop:GetChild("Eff_UI_tishi_kuosan"):SetActive(not KillMonsterCardData.IsOpenState() and 0 < intervalTime)
  local switchSprite = KillMonsterCardData.IsOpenState() and "killMonsterbegin" or "killMonsterstop"
  self:SetSprite("Atlas_Common", switchSprite, self.btn_timeStop:GetChild("img_clcikeffct2"))
end

function Tip_killMonsterCardUI:RefreshCountTime()
  if KillMonsterCardData.IsOpenState() then
    local surplusTime = KillMonsterCardData.GetSurplusTimeInterval()
    local intervalTime = surplusTime - Time.GetServerTime()
    local intervalTimeSecond = Mathf.Floor(intervalTime / 1000)
    if self.intervalTimeSecond and self.intervalTimeSecond - intervalTimeSecond < 1 then
      return
    end
    self.intervalTimeSecond = intervalTimeSecond
  else
    local intervalTimeSecond = Mathf.Floor(KillMonsterCardData.GetTotalTime() / 1000)
    self.intervalTimeSecond = intervalTimeSecond
  end
  if self.intervalTimeSecond <= 0 then
    self.intervalTimeSecond = 0
  end
  local countTime = TimeUtility.ShowTimeHour(self.intervalTimeSecond)
  self.monsterTime:SetText(countTime)
end

function Tip_killMonsterCardUI:UpdateCountTimer()
  if KillMonsterCardData.IsOpenState() then
    self:RefreshCountTime()
  end
end
