Tip_PromptTipUI = class(BaseUI)
Tip_PromptTipUI.layer = UILayer.Prompt
Tip_PromptTipUI.orderInLayer = 5
Tip_PromptTipUI.hideType = UIHideType.Hide
Tip_PromptTipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_PromptTipUI.escClose = UIEscClose.DontClose

function Tip_PromptTipUI:InitControls()
  self.Bg_Close = self:GetControl("Bg_Close")
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Image_TipBg = self:GetControl("Panel_Tip/Image_TipBg")
  self.Button_OK = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK")
  self.Text_OK = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK/Text_OK")
  self.Btn_Description = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK/Btn_Description")
  self.Button_Cancel = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_Cancel")
  self.Text_Cancel = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_Cancel/Text_Cancel")
  self.Text_TipContent = self:GetControl("Panel_Tip/Image_TipBg/Text_TipContent")
  self.Text_TipLinkContent = self:GetControl("Panel_Tip/Image_TipBg/Text_TipLinkContent")
  self.Text_TipTitle = self:GetControl("Panel_Tip/Image_TipBg/Text_TipTitle")
  self.btn_close = self:GetControl("Panel_Tip/Image_TipBg/btn_close")
  self.ItemShow = self:GetControl("Panel_Tip/Image_TipBg/ItemShow")
  self.Text_TipItemContent = self:GetControl("Panel_Tip/Image_TipBg/ItemShow/Text_TipItemContent")
  self.btn_3DItem = self:GetControl("Panel_Tip/Image_TipBg/ItemShow/btn_3DItem")
  self.lab_count = self:GetControl("Panel_Tip/Image_TipBg/ItemShow/btn_3DItem/lab_count")
  self.tog_checkMark = self:GetControl("Panel_Tip/Image_TipBg/tog_checkMark")
  self.Text_btnTip = self:GetControl("Panel_Tip/Image_TipBg/tog_checkMark/Text_btnTip")
  self.btn_needGold = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK/btn_needGold")
end

function Tip_PromptTipUI:Init()
  self.autoClose = true
  self.isLinkText = false
  self.isframe = false
end

function Tip_PromptTipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_PromptTipUI:InitUI()
  self.showCellData = ItemCellData()
  self.hangUpPunishCellData = ItemCellData()
end

function Tip_PromptTipUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_PromptTipUI:OnHide()
  self.args.ok = nil
  self.args.okArgs = nil
  self.args.cancel = nil
  self.args.cancelArgs = nil
  self.args.okText = nil
  self.args.cancelText = nil
  self.args.link = nil
  self.args.linkArgs = nil
  self.autoClose = true
  self.isframe = false
  self.isLinkText = false
  if self.Button_Cancel then
    self.Button_Cancel:SetActive(true)
  end
  self.showCellData:RecycleRes()
  self.hangUpPunishCellData:RecycleRes()
  if self.OnlyOnceCallBack ~= nil then
    self.OnlyOnceCallBack = nil
    self.onlyOnceArgs = nil
  end
end

function Tip_PromptTipUI:OnDestroy()
  if self.showCellData then
    self.showCellData:RecycleRes()
    self.showCellData = nil
  end
  if self.hangUpPunishCellData then
    self.hangUpPunishCellData:RecycleRes()
    self.hangUpPunishCellData = nil
  end
end

function Tip_PromptTipUI:RegistUIEvents()
  self.Button_OK:SetOnClick(self, self.Button_OKOnClick)
  self.Button_Cancel:SetOnClick(self, self.Button_CancelOnClick)
  self.btn_close:SetOnClick(self, self.OnClose)
  self.Bg_Close:SetOnClick(self, self.OnClose)
  self.tog_checkMark:SetOnToggleChanged(self, self.OnlyOnceToggleChangeCallBack)
  self.Text_TipLinkContent:SetOnTextPointerClick(self, self.ExecuteTextOrder)
end

function Tip_PromptTipUI:ExecuteTextOrder(control, eventData, key)
  if self.args and self.args.link then
    self.args.link(eventData, key, self.args.linkArgs)
  end
end

function Tip_PromptTipUI:Button_OKOnClick(control)
  if self.args.ok then
    self.args.ok(self.args.okArgs)
  end
  if self.autoClose then
    if not self.args.Item then
      UIManager.Hide(UIID.PromptTipUI)
    end
  else
    self.autoClose = true
  end
end

function Tip_PromptTipUI:Button_CancelOnClick(control)
  if self.args.cancel then
    self.args.cancel(self.args.cancelArgs)
  end
  if self.autoClose then
    UIManager.Hide(UIID.PromptTipUI)
  else
    self.autoClose = true
  end
end

function Tip_PromptTipUI:OnClose()
  if self.closeCallBack then
    self.closeCallBack(self.closeArgs)
    self.closeCallBack = nil
    self.closeArgs = nil
  end
  UIManager.Hide(UIID.PromptTipUI)
end

function Tip_PromptTipUI:RegistEvents()
  if self.args.Item2 then
    self:RegistEvent(Event.Bag_ResUseItem, self.OnRefreshItem, self)
  end
  self:RegistEvent(Event.PromptOnRefresh, self.OnRefreshShow, self)
  self:RegistEvent(Event.RefreshRingBossCountData, self.OnRefreshRingBossCountData, self)
end

function Tip_PromptTipUI:OnRefreshShow(_, msg)
  self.args = msg
  self:Refresh()
end

function Tip_PromptTipUI:OnRefreshItem(_, msg)
  local configId = self.args.Item2.tblItem.id
  self.args.Item2.count = BagInfoData.GetItemTotalCountByItemId(configId)
  self:Refresh()
end

function Tip_PromptTipUI:Refresh()
  if self.args and self.args.autoClose then
    self.autoClose = false
  end
  self.btn_needGold:SetActive(false)
  self.Text_TipTitle:SetText(self.args.title)
  if self.args and self.args.isLinkText then
    self.isLinkText = true
  end
  if self.args.Item2 then
    self.showCellData:RefreshData(self.args.Item2)
    ItemUtility.ShowItemCell(self.btn_3DItem, self.showCellData, self)
    local a = self.args.Item2.count == 0 and string.GetColorText("0", ItemQuality2ColorDic[EItemColorEnum.cRed]) or tostring(self.args.Item2.count)
    self.lab_count:SetText(string.format("%s/1", a))
    self.Text_TipContent:SetActive(false)
    self.Text_TipLinkContent:SetActive(false)
    self.Text_TipItemContent:SetText(self.args.textContent)
    self.ItemShow:SetActive(true)
  else
    self.ItemShow:SetActive(false)
    self.Text_TipContent:SetActive(self.isLinkText == false and self.args.listenEventID == nil)
    self.Text_TipLinkContent:SetActive(self.isLinkText)
    if self.args.showTimeType and self.args.showTimeType == PromptWordTimeType.HangUpPunish then
      local remainderTime = QuickFind:GetThreeVsThreeDataMgr():GetPunishTime() - Time.GetServerTime()
      self:ShowTime(remainderTime * 0.001)
      local activityGlobal = ClientTable.cfg_Activity_globalManager:TryGetValue(500066)
      if activityGlobal ~= nil and not string.isNullOrEmpty(activityGlobal.effect) then
        local effectTab = string.split(activityGlobal.effect, "#")
        self:RefreshCellData(effectTab[2])
      end
    elseif self.isLinkText == true then
      self.Text_TipLinkContent:SetText(self.args.textContent)
    else
      self.Text_TipContent:SetText(self.args.textContent)
    end
  end
  if not string.isNullOrEmpty(self.args.okText) then
    self.Text_OK:SetText(self.args.okText)
  else
    self.Text_OK:SetText(LocalizationUtility.GetContentByKey("queding"))
  end
  if not string.isNullOrEmpty(self.args.okDecs) then
    self.Btn_Description:SetActive(true)
    self.Btn_Description:SetText(self.args.okDecs)
  else
    self.Btn_Description:SetActive(false)
  end
  if not string.isNullOrEmpty(self.args.cancelBtnColor) and self.args then
    self:SetSprite("Atlas_Common", self.args.cancelBtnColor, self.Button_Cancel)
  end
  if not string.isNullOrEmpty(self.args.okBtnColor) then
    self:SetSprite("Atlas_Common", self.args.okBtnColor, self.Button_OK)
  else
    self:SetSprite("Atlas_Common", "ty_btn_short3_new", self.Button_OK)
  end
  if not string.isNullOrEmpty(self.args.cancelText) then
    self.Text_Cancel:SetText(string.format("<color=#dce1e5>%s</color>", self.args.cancelText))
  else
    self.Text_Cancel:SetText(string.format("<color=#dce1e5>%s</color>", LocalizationUtility.GetContentByKey("quxiao")))
  end
  if self.args and self.args.isframe then
    self.isframe = self.args.isframe
    self.Button_Cancel:SetActive(false)
  end
  if self.args and self.args.onlyOnce then
    self.tog_checkMark:SetActive(true)
    self.tog_checkMark:SetIsOn(false)
    if self.args.onlyOnceArgs then
      self.onlyOnceArgs = self.args.onlyOnceArgs
    end
    if self.args.onlyOnceAction then
      self.OnlyOnceCallBack = self.args.onlyOnceAction
    end
  else
    self.tog_checkMark:SetActive(false)
    self.OnlyOnceCallBack = nil
  end
  if self.args then
    self.closeCallBack = self.args.closeCallBack
    self.closeArgs = self.args.closeArgs
  end
  if self.args.refreshCallBack ~= nil then
    self.args.refreshCallBack()
  end
end

function Tip_PromptTipUI:ShowTime(surplusTime)
  if self.normalTimer then
    Timer.Stop(self.normalTimer)
  end
  local timeStr = TimeUtility.ShowTime(surplusTime)
  if self.isLinkText == true then
    if not IsNil(self.Text_TipLinkContent.transform) then
      self.Text_TipLinkContent:SetText(string.format(self.args.textContent, timeStr))
    end
  elseif not IsNil(self.Text_TipContent.transform) then
    self.Text_TipContent:SetText(string.format(self.args.textContent, timeStr))
  end
  
  local function UpdateTimer()
    surplusTime = surplusTime - 1
    local timeStr = TimeUtility.ShowTime(surplusTime)
    if self.isLinkText == true then
      if not IsNil(self.Text_TipLinkContent.transform) then
        self.Text_TipLinkContent:SetText(string.format(self.args.textContent, timeStr))
      end
    elseif not IsNil(self.Text_TipContent.transform) then
      self.Text_TipContent:SetText(string.format(self.args.textContent, timeStr))
    end
    if surplusTime <= 0 then
      if self.normalTimer then
        Timer.Stop(self.normalTimer)
        self.normalTimer = nil
        if self.isLinkText == true then
          if not IsNil(self.Text_TipLinkContent.transform) then
            self.Text_TipLinkContent:SetText(string.format(self.args.textContent, "0"))
          end
        elseif not IsNil(self.Text_TipContent.transform) then
          self.Text_TipContent:SetText(string.format(self.args.textContent, "0"))
        end
      end
      UIManager.Hide(UIID.PromptTipUI)
    end
  end
  
  self.normalTimer = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function Tip_PromptTipUI:RefreshCellData(itemId)
  if self.hangUpPunishCellData then
    self.hangUpPunishCellData:RecycleRes()
  end
  self.btn_needGold:SetActive(true)
  local itemData = ItemUtility.GenerateItemData(tonumber(itemId))
  itemData.count = MathUtility.FormatNum(QuickFind:GetThreeVsThreeDataMgr():GetPunishCount() <= 2 and Mathf.Pow(10, QuickFind:GetThreeVsThreeDataMgr():GetPunishCount() + 1) or 10000)
  self.hangUpPunishCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_needGold, self.hangUpPunishCellData, self, true)
end

function Tip_PromptTipUI:OnlyOnceToggleChangeCallBack(control, isOn)
  if self.OnlyOnceCallBack ~= nil then
    self.OnlyOnceCallBack(self.onlyOnceArgs, isOn)
    TipUtility.IsOpenCombineUI = not isOn
  end
end

function Tip_PromptTipUI:TipReset(arg)
  self.autoClose = false
  self.args = arg
  self:Refresh()
end

function Tip_PromptTipUI:OnRefreshRingBossCountData(id)
  if self.args == nil or self.args.listenEventID ~= id then
    return
  end
  local FormatArgs = ""
  if SceneData.RingBoss_nowcount ~= nil and SceneData.RingBoss_totalCount ~= nil then
    FormatArgs = tostring(SceneData.RingBoss_nowcount) .. " / " .. tostring(SceneData.RingBoss_totalCount)
    local textContent = string.format(self.args.tblData.content, FormatArgs)
    self.Text_TipContent:SetActive(true)
    self.Text_TipContent:SetText(textContent)
    self.args.textContent = textContent
  end
end
