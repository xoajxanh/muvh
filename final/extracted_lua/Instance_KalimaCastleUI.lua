Instance_KalimaCastleUI = class(BaseUI)
Instance_KalimaCastleUI.layer = UILayer.Panel
Instance_KalimaCastleUI.orderInLayer = 0
Instance_KalimaCastleUI.hideType = UIHideType.WaitDestroy
Instance_KalimaCastleUI.hideFunc = UIHideFunc.MoveOutOfScreen
Instance_KalimaCastleUI.escClose = UIEscClose.DontClose

function Instance_KalimaCastleUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("btn_close")
  self.ScrollView = self:GetControl("ScrollView")
  self.Content = self:GetControl("ScrollView/Viewport/Content")
  self.tog_instance = self:GetControl("ScrollView/Viewport/Content/tog_instance")
  self.lab_layer = self:GetControl("Middel/layer/lab_layer")
  self.lab_def = self:GetControl("Middel/def/lab_def")
  self.tx_count = self:GetControl("Middel/tx_count")
  self.lab_count = self:GetControl("Middel/tx_count/lab_count")
  self.grid = self:GetControl("Middel/lab_rewards/grid")
  self.btn_3DItem = self:GetControl("Middel/lab_rewards/grid/btn_3DItem")
  self.requirements_item = self:GetControl("Middel/requirements_item")
  self.lab_kalimacount = self:GetControl("Middel/count/lab_kalimacount")
  self.btn_enter = self:GetControl("Middel/btn_enter")
  self.tx_tips = self:GetControl("Middel/tx_tips")
  self.des_btn = self:GetControl("des_btn")
end

function Instance_KalimaCastleUI:Init()
end

function Instance_KalimaCastleUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Instance_KalimaCastleUI:InitUI()
  self:InitParams()
end

function Instance_KalimaCastleUI:InitParams()
  self.curMapId = 0
  self.countKey = 3020601
  self.kalimaData = nil
  self.bgNameList = {
    "img_kundun_men",
    "img_kundun_putong"
  }
  
  function self.mClickPageCallBack(data)
    self:ClickPageCallBack(data)
  end
  
  self.pageContainer = UIUtility.BindUIContainerTemp(self.tog_instance, LuaComponentTemplates.Instance_KalimaCastlePageTemplate, self, {
    goCallBack = self.mClickPageCallBack,
    normalBg = self.bgNameList[2]
  })
  self.rewardContainer = UIUtility.BindUIContainerTemp(self.btn_3DItem, LuaComponentTemplates.UIItemTemplate, self, {isShowTips = true})
  self.costTemplate = luaTemplateManager.GetNewTemplate(self.requirements_item, LuaComponentTemplates.ConsumableUnitTemplate, self)
  self.duplicateIdTab = TranScriptData.GetTypeDatas(TranScriptData.TranScriptSubType.KalimarTemple)
end

function Instance_KalimaCastleUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_3DItem:SetOnClick(self, self.btn_3DItemOnClick)
  self.btn_enter:SetOnClick(self, self.btn_enterOnClick)
  self.des_btn:SetOnClick(self, self.des_btnOnClick)
end

function Instance_KalimaCastleUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Instance_KalimaCastleUI)
end

function Instance_KalimaCastleUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Instance_KalimaCastleUI)
end

function Instance_KalimaCastleUI:btn_3DItemOnClick(control)
end

function Instance_KalimaCastleUI:btn_enterOnClick(control)
  if self.remainCount == 0 then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("KalimaCastle_03"))
    return
  end
  if not self.meetMapCondition then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("KalimaCastle_01"))
    return
  end
  if not self.meetCost then
    if self.costData and next(self.costData) then
      local itemData = ItemUtility.GenerateItemData(self.costData[1].itemId)
      UIManager.Show(UIID.ItemTipUI, {
        item = itemData,
        rightOperate = EItemOperateType.Show,
        ctrl = uiControl,
        ShowObtain = true,
        OpenWay = EOpenTipsType.FastBuy
      })
    end
    return
  end
  networkRequest.ReqCreateTemporaryTransmit(self.kalimaData.transferTable.id)
  self:btn_closeOnClick()
end

function Instance_KalimaCastleUI:des_btnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Instance_KalimaCastleUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Instance_KalimaCastleUI:ClickPageCallBack(temp)
  if temp.data == nil or temp.data.instanceTbl == nil or temp.data.instanceTbl.mapId == self.curMapId then
    return
  end
  self:ParseData(temp.data)
  self:RefreshMainView()
  self:RefresPageEffectView()
end

function Instance_KalimaCastleUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Instance_KalimaCastleUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.BagChangedCallBack, self)
end

function Instance_KalimaCastleUI:BagChangedCallBack()
  self:RefreshCostData()
  self:RefreshCostView()
end

function Instance_KalimaCastleUI:Refresh()
  self:RefreshPageView()
  self.remainCount = RefreshData.GetInstanceCount(self.countKey)
  self.remainCount = self.remainCount < 0 and 0 or self.remainCount
end

function Instance_KalimaCastleUI:ParseData(data)
  self.kalimaData = data
  self.mapCondition = nil
  self.meetMapCondition = false
  if data.transferTable then
    self.mapCondition = data.transferTable.condition
    self.meetMapCondition = ConditionManager.Check4D(self.mapCondition)
  end
  self.rewardList = nil
  if data.instanceTbl then
    self.rewardList = TableParse:SpliteStringToItemCountList(data.instanceTbl.dropItem)
  end
  self:RefreshCostData()
end

function Instance_KalimaCastleUI:RefreshCostData()
  self.costData = nil
  if self.kalimaData.transferTable then
    self.costData = TableParse:SpliteStringToItemCountList(self.kalimaData.transferTable.cost)
  end
  self.meetCost = ItemUtility:IsMeetCost(self.costData)
end

function Instance_KalimaCastleUI:RefreshPageView()
  self.ScrollView:SetNormalizedPosition(0, 0)
  if self.duplicateIdTab then
    self.pageContainer:SetData(self.duplicateIdTab)
    self:ResetTimer()
    self.delayRefreshTemplate = Timer.Start(0.1, function()
      local obj = self.pageContainer:GetOrCreateItem(1)
      if obj and obj.itemTemp then
        obj.itemTemp:RefreshBgView(self.bgNameList[1])
        obj.itemTemp:ClickGoCallBack()
      end
    end)
  else
    self.pageContainer:SetData({})
  end
end

function Instance_KalimaCastleUI:RefresPageEffectView()
  if self.pageContainer == nil then
    return
  end
  if self.kalimaData == nil or self.kalimaData.instanceTbl == nil then
    return
  end
  for i, v in pairs(self.pageContainer.items) do
    if v and v.itemTemp then
      v.itemTemp:RefresPageEffectView(self.kalimaData.instanceTbl.mapId)
    end
  end
end

function Instance_KalimaCastleUI:RefreshMainView()
  self:RefreshTopView()
  self:RefreshRewardView()
  self:RefreshCostView()
  self:RefreshCountView()
end

function Instance_KalimaCastleUI:RefreshTopView()
  self.lab_layer:SetText(self.kalimaData.instanceTbl.name)
  self.lab_def:SetText(self.kalimaData.instanceTbl.showName)
end

function Instance_KalimaCastleUI:RefreshRewardView()
  if self.rewardList then
    self.rewardContainer:SetData(self.rewardList)
  else
    self.rewardContainer:SetData({})
  end
end

function Instance_KalimaCastleUI:RefreshCostView()
  if self.costData and next(self.costData) then
    self.costTemplate:Refresh(self.costData[1], nil)
  end
end

function Instance_KalimaCastleUI:RefreshCountView()
  self.lab_kalimacount:SetText(self.remainCount)
end

function Instance_KalimaCastleUI:ResetTimer()
  if self.delayRefreshTemplate then
    Timer.Stop(self.delayRefreshTemplate)
    self.delayRefreshTemplate = nil
  end
end

function Instance_KalimaCastleUI:OnHide()
end

function Instance_KalimaCastleUI:OnDestroy()
  self:ResetTimer()
end
