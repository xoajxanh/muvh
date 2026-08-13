Warning_TipsUI = class(BaseUI)
Warning_TipsUI.layer = UILayer.Tip
Warning_TipsUI.orderInLayer = 0
Warning_TipsUI.hideType = UIHideType.WaitDestroy
Warning_TipsUI.hideFunc = UIHideFunc.MoveOutOfScreen
Warning_TipsUI.escClose = UIEscClose.DontClose

function Warning_TipsUI:InitControls()
  self.btn_close = self:GetControl("btn_close")
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.description4 = self:GetControl("description4")
  self.description2 = self:GetControl("description2")
  self.description3 = self:GetControl("description3")
  self.btn_confirm = self:GetControl("btn_confirm")
  self.btn_unsealing = self:GetControl("btn_unsealing")
  self.btn_3Dcost = self:GetControl("btn_unsealing/btn_3Dcost")
  self.lab_consumeCount = self:GetControl("btn_unsealing/lab_consumeCount")
end

function Warning_TipsUI:OnPreLoad()
end

function Warning_TipsUI:Init()
end

function Warning_TipsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Warning_TipsUI:InitUI()
end

function Warning_TipsUI:OnShow()
  self:RegistEvents()
  NetManager.Send(MapMessage.ReqBlackRoomInfo)
end

function Warning_TipsUI:OnHide()
  self:StopTimer()
  if self.costItemCellData then
    self.costItemCellData:RecycleRes()
    self.costItemCellData = nil
  end
  EventManager.Dispatch(Event.CancelClickNpc)
end

function Warning_TipsUI:OnDestroy()
end

function Warning_TipsUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_confirm:SetOnClick(self, self.btn_confirmOnClick)
  self.btn_unsealing:SetOnClick(self, self.btn_unsealingOnClick)
  self.btn_3Dcost:SetOnClick(self, self.btn_3DcostOnClick)
end

function Warning_TipsUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Warning_TipsUI)
end

function Warning_TipsUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Warning_TipsUI)
end

function Warning_TipsUI:btn_confirmOnClick(control)
  UIManager.Hide(UIID.Warning_TipsUI)
end

function Warning_TipsUI:btn_unsealingOnClick(control)
  local bagCount = BagInfoData.GetItemTotalCountByItemId(self.costItemCellData.itemData.itemId)
  if bagCount < self.costCount then
    FloatingTipUtility.QuickMsg("Ti\225\187\129n kh\195\180ng \196\145\225\187\167")
  else
    local function PromptOK()
      NetManager.Send(MapMessage.ReqBlackRoomByFine)
      
      UIManager.Hide(UIID.Warning_TipsUI)
    end
    
    local title = {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = string.format("R\225\187\157i kh\225\187\143i c\225\186\167n ti\195\170u hao %d %s", self.costCount, self.costItemCellData.itemData.tblItem.name),
      cancelText = "",
      okText = "",
      cancel = nil,
      ok = PromptOK
    }
    UIManager.Show(UIID.PromptTipUI, title)
  end
end

function Warning_TipsUI:btn_3DcostOnClick(control)
end

function Warning_TipsUI:RegistEvents()
  self:RegistEvent(Event.Map_BlackRoomInfo, self.Refresh, self)
end

function Warning_TipsUI:Refresh(_, msg)
  if msg.time > 0 then
    self:StartTimer(msg.time, self.description2)
  else
    self.description2:SetText(TimeUtility.ShowTimeWithColon(0))
  end
  local data = ClientTable.cfg_Global_globalManager:GetWarnTipConsum()
  if data == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  self.costCount = data.count * Mathf.Ceil(msg.time * 0.001 / 60)
  self.costItemCellData = ItemCellData()
  self.costItemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_3Dcost, self.costItemCellData, self, true)
  self.lab_consumeCount:SetText(self.costCount)
end

function Warning_TipsUI:StartTimer(surplusTime, lab_countdown)
  if 0 < surplusTime then
    surplusTime = surplusTime * 0.001
    local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
    lab_countdown:SetText(timeStr)
    self.warningTimer = Timer.StartLoop(1, surplusTime, function()
      if surplusTime <= 1 then
        lab_countdown:SetText(TimeUtility.ShowTimeWithColon(0))
        self:StopTimer()
      end
      surplusTime = surplusTime - 1
      local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
      lab_countdown:SetText(timeStr)
    end)
  else
    lab_countdown:SetText(TimeUtility.ShowTimeWithColon(0))
  end
end

function Warning_TipsUI:StopTimer()
  if self.warningTimer then
    Timer.Stop(self.warningTimer)
    self.warningTimer = nil
  end
end
