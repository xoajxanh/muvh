Tip_ChristmasNpcTipUI = class(BaseUI)
Tip_ChristmasNpcTipUI.layer = UILayer.Panel
Tip_ChristmasNpcTipUI.orderInLayer = 0
Tip_ChristmasNpcTipUI.hideType = UIHideType.WaitDestroy
Tip_ChristmasNpcTipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_ChristmasNpcTipUI.escClose = UIEscClose.DontClose

function Tip_ChristmasNpcTipUI:InitControls()
  self.btn_Close = self:GetControl("Panel_Tip/Image_TipBg/btn_close")
  self.btn_Cancel = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_Cancel")
  self.btn_OK = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK")
  self.text_TipContent = self:GetControl("Panel_Tip/Image_TipBg/Text_TipContent")
end

function Tip_ChristmasNpcTipUI:Init()
end

function Tip_ChristmasNpcTipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_ChristmasNpcTipUI:InitUI()
  self:InitRechargeGiftData()
  self:InitRechargeTipText()
end

function Tip_ChristmasNpcTipUI:InitRechargeGiftData()
  self.m_RechargeGiftData = CommercialHolidayData:GetChristmasRechargeGiftData()
  if self.m_RechargeGiftData == nil then
    logError("m_RechargeGiftData is nil...")
    return
  end
end

function Tip_ChristmasNpcTipUI:InitRechargeTipText()
  self.m_CanReceiveText = "#N/A"
  self.m_DotReceiveText = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("ChristmasNpcTip_1")
end

function Tip_ChristmasNpcTipUI:RegistUIEvents()
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
  self.btn_Cancel:SetOnClick(self, self.btn_CancelOnClick)
  self.btn_OK:SetOnClick(self, self.btn_OKOnClick)
end

function Tip_ChristmasNpcTipUI:btn_CloseOnClick()
  self:HideView()
end

function Tip_ChristmasNpcTipUI:btn_CancelOnClick()
  self:HideView()
end

function Tip_ChristmasNpcTipUI:btn_OKOnClick()
  if self.m_RechargeGiftData == nil then
    return
  end
  local canReceive = RefreshData.CheckRefreshCountKey(self.m_RechargeGiftData.countKey)
  if canReceive then
    NetManager.Send(RechargeMessage.ReqGetGift, {
      id = {
        self.m_RechargeGiftData.id
      }
    })
  end
  self:HideView()
end

function Tip_ChristmasNpcTipUI:HideView()
  UIManager.Hide(UIID.Tip_ChristmasNpcTipUI)
  if self.m_NpcConfigId == nil then
    return
  end
  local npc = RoleManager.GetNpcByConfigId(self.m_NpcConfigId)
  if npc and npc:OnCancelTouch() then
    npc:OnCancelTouch()
  end
end

function Tip_ChristmasNpcTipUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_ChristmasNpcTipUI:RegistEvents()
end

function Tip_ChristmasNpcTipUI:Refresh()
  if self.args == nil then
    return
  end
  self.m_NpcConfigId = self.args.npcConfigID
  if self.m_NpcConfigId == nil then
    return
  end
  if self.m_RechargeGiftData == nil then
    return
  end
  local canReceive = RefreshData.CheckRefreshCountKey(self.m_RechargeGiftData.countKey)
  self.btn_Cancel:SetActive(canReceive)
  self.btn_OK:SetActive(canReceive)
  if string.isNullOrEmpty(self.m_CanReceiveText) or string.isNullOrEmpty(self.m_DotReceiveText) then
    return
  end
  local text = canReceive and self.m_CanReceiveText or self.m_DotReceiveText
  self.text_TipContent:SetText(text)
end

function Tip_ChristmasNpcTipUI:OnHide()
end

function Tip_ChristmasNpcTipUI:OnDestroy()
end
