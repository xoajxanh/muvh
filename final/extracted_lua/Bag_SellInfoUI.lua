Bag_SellInfoUI = class(BaseUI)
Bag_SellInfoUI.layer = UILayer.Panel
Bag_SellInfoUI.orderInLayer = 3
Bag_SellInfoUI.hideType = UIHideType.Destroy
Bag_SellInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Bag_SellInfoUI.escClose = UIEscClose.DontClose

function Bag_SellInfoUI:InitControls()
  self.tog_item = self:GetControl("img_bg/img_frame/go_SellOption/tog_item")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.sw_sellProfit = self:GetControl("img_bg/sw_sellProfit")
  self.Content = self:GetControl("img_bg/sw_sellProfit/Viewport/Content")
  self.sellProfit = self:GetControl("img_bg/sw_sellProfit/Viewport/Content/sellProfit")
  self.tog_autoSellFan = self:GetControl("img_bg/tog_autoSellFan")
  self.tog_autoSell = self:GetControl("img_bg/tog_autoSell")
  self.btn_sell = self:GetControl("img_bg/btn_sell")
  self.lab_sell = self:GetControl("img_bg/btn_sell/lab_sell")
  self.descBtn = self:GetControl("descBtn")
  self.plane_top = self:GetControl("plane_top")
  self.plane_bottom = self:GetControl("plane_bottom")
  self.btn_obtain = self:GetControl("img_bg/img_recover_txt/btn_obtain")
  self.lab_recover_txt = self:GetControl("img_bg/img_recover_txt/lab_recover_txt")
  self.img_recover_txt = self:GetControl("img_bg/img_recover_txt")
  self.btn_reset = self:GetControl("img_bg/btn_reset")
end

local goldRecoverBuff = 0

function Bag_SellInfoUI:Init()
  self.recycleContainer = nil
  self.toggleInited = false
  self.changeTbl = {}
  self.profitHeight = 0
  self.profitCount = 0
  self.doRefreshCol = nil
  self.curCtrHeight = 44
  self.togObj = {}
end

function Bag_SellInfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Bag_SellInfoUI:InitUI()
  self.sellProfit:SetActive(false)
  self.itemTogContainer = UIContainer(self.tog_item, self, self.OnItemTogCreate, self.OnItemTogRefresh)
  self:RecycelCtrInit()
end

local function OnCreate(control)
  control.lab_num = UIControl(control.transform, "lab_num")
  control.lab_goldExp = UIControl(control.transform, "lab_goldExp")
end

local function OnRefresh(ctr, _, data, ui)
  if not ctr.itemCellData then
    ctr.itemCellData = ItemCellData()
  end
  local item
  if not ctr.itemCellData.itemData or ctr.itemCellData.itemData.itemId ~= data.itemId then
    item = ItemUtility.GenerateItemData(data.itemId)
    ctr.itemCellData:RefreshData(item)
  end
  ctr.itemCellData.itemData.count = data.count
  ctr.itemCellData.customData = {
    clickCallBack = function()
      ItemUtility.TryReSetTipLayer()
      if UIManager.IsVisible(UIID.ItemTipUI) then
        UIManager.SwitchVisible(UIID.ItemTipUI)
      end
      UIManager.Show(UIID.ItemTipUI, {
        item = ctr.itemCellData.itemData,
        rightOperate = EItemOperateType.Show,
        ctrl = ctr
      })
    end
  }
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, self, true)
  local str = ctr.countCtr:GetText()
  if string.contains(str, "w") then
    str = string.replace(str, "w", " v\225\186\161n")
  elseif string.contains(str, "y") then
    str = string.replace(str, "y", " tr\196\131m tri\225\187\135u")
  end
  ctr.lab_num:SetActive(true)
  ctr.lab_num:SetText(data.count)
  if goldRecoverBuff ~= 0 and (data.itemId == ECoinsType.integral or data.itemId == ECoinsType.bindIntegral or data.itemId == ECoinsType.gold) then
    ctr.lab_goldExp:SetActive(true)
    local contentText = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("RecycleCoin_1")
    local numLab = string.format(contentText, tostring(goldRecoverBuff) .. "%")
    ctr.lab_goldExp:SetText(numLab)
  else
    ctr.lab_goldExp:SetActive(false)
  end
  ui.profitHeight = ui.curCtrHeight + 5.5
  ui.profitCount = ui.profitCount + 1
end

function Bag_SellInfoUI.OnItemTogCreate(ctr, ui)
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
  ctr.btn_detail = UIControl(ctr.transform, "btn_detail")
end

local function OnItemTogClieck(ui, ctr)
  if UIManager.IsVisible(UIID.Bag_SellInfoConfigUI) then
    EventManager.Dispatch(Event.Bag_SellInfoConfigUI, ctr.extraData)
    return
  end
  UIManager.Show(UIID.Bag_SellInfoConfigUI, ctr.extraData)
end

function Bag_SellInfoUI.OnItemTogRefresh(ctr, _, data, ui)
  if data == nil then
    return
  end
  ctr.index = data[1].sellId
  ctr.lab_name:SetText(data[1].name)
  ctr:SetOnToggleChanged(ui, function()
  end)
  ctr.toggle.isOn = BagSellController.CheckBagSellInfoUITogIsChoose(data[1].sellId)
  ctr:SetOnToggleChanged(ui, ui.OnToggleChanged)
  if 1 < table.count(data) then
    ctr.btn_detail:SetActive(true)
    ctr.btn_detail.extraData = data
    ctr.btn_detail:SetOnClick(ctr, OnItemTogClieck)
  else
    ctr.btn_detail:SetActive(false)
  end
end

function Bag_SellInfoUI:RecycelCtrInit()
  self.curCtrHeight = self.sellProfit.transform.rect.height
  self.Content.layoutGroup.enabled = true
  self.recycleContainer = UIContainer(self.sellProfit, self, OnCreate, OnRefresh)
end

function Bag_SellInfoUI:OnShow()
  BagSellController.RefrashRecycleConfigDic()
  self:ResetData()
  self:LocalInit()
  self:RegistEvents()
  if not string.isNullOrEmpty(GlobalConfig.autoPickupOpen) then
    local openDir = ConditionManager.Check4D(GlobalConfig.autoPickupOpen)
    if openDir == false then
      PlayerControlForceData.autoPickupState = false
    end
  end
  self.tog_autoSell:SetIsOn(PlayerControlForceData.autoRecycleState)
  self.tog_autoSellFan:SetIsOn(PlayerControlForceData.autoPickupState)
  self:InitBtnObtain()
  self:Refresh()
end

function Bag_SellInfoUI:ResetData()
  self.togObj = {}
end

function Bag_SellInfoUI:OnHide()
  self:ResetTipsLayer()
  self.toggleInited = false
  self.changeTbl = {}
  BagInfoData.RecycleCancel = {}
  BagInfoData.RecycleItemTbl = {}
  BagSellController.SaveCurrRecycleTogConfig()
  EventManager.Dispatch(Event.Bag_SellInfoClose)
end

function Bag_SellInfoUI:ResetTipsLayer()
  ItemUtility.TryReSetTipLayer()
  UIManager.Hide(UIID.ItemTipUI)
end

function Bag_SellInfoUI:OnDestroy()
  self.recycleContainer = nil
end

function Bag_SellInfoUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_sell:SetOnClick(self, self.btn_sellOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_reset:SetOnClick(self, self.btn_resetOnClick)
  self.tog_autoSell:SetOnToggleChanged(self, self.ToggleChanged)
  self.tog_autoSellFan:SetOnToggleChanged(self, self.AutoSellFanChanged)
  self.btn_obtain:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function Bag_SellInfoUI:GetTogTbl()
  local togTbl = {}
  for i = 1, table.count(self.togObj) do
    if self.togObj[i].toggle.isOn then
      table.insert(togTbl, self.sellConfigList[i].id)
    end
  end
  return togTbl
end

function Bag_SellInfoUI:OnToggleChanged(ui, status)
  BagSellController.SetSellInfoTogStatus(ui.index, status)
end

function Bag_SellInfoUI:btn_closeOnClick(control)
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.BagSellInfoUI)
end

function Bag_SellInfoUI:btn_sellOnClick(control)
  local sendTbl = {
    recycleItems = {}
  }
  local haveSelect = false
  local showSecondary = false
  for _, recycleTbl in pairs(BagInfoData.RecycleItemTbl) do
    sendTbl.recycleItems[recycleTbl.id] = recycleTbl.count
    haveSelect = true
    local isintensify = recycleTbl and tonumber(recycleTbl.intensify) and recycleTbl.intensify > 0
    local isadditional = recycleTbl and tonumber(recycleTbl.additional) and 0 < recycleTbl.additional
    if isintensify or isadditional then
      showSecondary = true
    end
  end
  if haveSelect or TaskData.GetOrderMainTaskById(TaskIdEnum.RecycleTask) then
    if showSecondary then
      self:SecondaryConfirmation(sendTbl)
    else
      networkRequest.ReqItemRecycle(sendTbl.recycleItems, self:GetRecycleWayType())
    end
  end
end

function Bag_SellInfoUI:SecondaryConfirmation(sendTbl)
  TipUtility.QuickShowPrompt({
    id = 67,
    cancelAction = function()
      UIManager.Hide(UIID.PromptTipUI)
    end,
    okAction = function()
      UIManager.Hide(UIID.PromptTipUI)
      networkRequest.ReqItemRecycle(sendTbl.recycleItems, self:GetRecycleWayType())
    end
  })
end

function Bag_SellInfoUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Bag_SellInfoUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Bag_SellInfoUI:btn_resetOnClick()
  local data = ClientTable.cfg_Ui_promptwordManager:GetKoreaTipData(127)
  if data then
    UIManager.Show(UIID.PromptTipUI, {
      title = data.title,
      autoClose = false,
      textContent = data.content,
      okText = data.rightButton,
      ok = function()
        BagSellController.ClearRecycleTogConfigAndSave()
        self:OnShow()
      end
    })
  end
end

function Bag_SellInfoUI:ToggleChanged(control, isOn)
  if isOn then
    local openDir = PlayerControlForceData.AutoRecycle()
    if not openDir then
      TipUtility.QuickShowPrompt({
        id = PromptWordType.AutoRecyclePrompt
      })
      self.tog_autoSell:SetIsOn(false)
    else
      PlayerControlForceData.SetAutoRecycleState(true)
      local flag, tbl = BagInfoData.GetAutoRecycleItemTbl()
      if flag then
        networkRequest.ReqItemRecycle(tbl.recycleItems, self:GetRecycleWayType())
      end
    end
  else
    PlayerControlForceData.SetAutoRecycleState(false)
  end
end

function Bag_SellInfoUI:AutoSellFanChanged(control, isOn)
  if isOn then
    local openDir = PlayerControlForceData.AutoPickup()
    if not openDir then
      TipUtility.QuickShowPrompt({
        id = PromptWordType.AutoPickupPrompt
      })
      self.tog_autoSellFan:SetIsOn(false)
    else
      PlayerControlForceData.SetAutoPickupState(true)
    end
  else
    PlayerControlForceData.SetAutoPickupState(false)
  end
end

function Bag_SellInfoUI:btn_obtainOnClick(control)
  local navTable = ClientTable.cfg_Navigation_barManager:TryGetValue(240000001)
  if navTable ~= nil then
    NavigationUtility.OpenPanel(navTable)
  end
  self:btn_closeOnClick()
end

function Bag_SellInfoUI:RegistEvents()
  self:RegistEvent(Event.Bag_SellItemClick, self.OnSellItemClick, self)
  self:RegistEvent(Event.Bag_RefreshShowSell, self.Refresh, self)
  self:RegistEvent(Event.Bag_ResBagInfo, self.Refresh, self, -1)
end

function Bag_SellInfoUI:OnSellItemClick(id, msg)
  self:OnRefresh()
end

function Bag_SellInfoUI:Refresh()
  BagInfoData.GetItemByCondition()
  self:OnRefresh()
  EventManager.Dispatch(Event.Bag_RefreshSellSelect)
end

function Bag_SellInfoUI:InitBtnObtain()
  local itemData = ItemUtility.GenerateItemData(3000921)
  self.btn_obtain.itemData = itemData
  self.btn_obtain.OpenTipsType = EOpenTipsType.FastBuy
end

function Bag_SellInfoUI:OnRefresh()
  local tempTbl = {}
  for _, recycleTbl in pairs(BagInfoData.RecycleItemTbl) do
    local recycle = string.split(recycleTbl.sell, "#")
    local itemId = tonumber(recycle[1])
    local count = tonumber(recycle[2])
    count = count * recycleTbl.count
    if recycleTbl.bind == 2 and itemId == ECoinsType.integral then
      itemId = ECoinsType.bindIntegral
    end
    if tempTbl[itemId] ~= nil then
      tempTbl[itemId] = tempTbl[itemId] + count
    else
      tempTbl[itemId] = count
    end
  end
  local sellGoldUpRatio = 0
  local sellBlueDiamondsUpRatio = 0
  local StoneData = RoleManager.me.data.equipsData.Data
  local vip = StoneData[CommercializeEquipCell.Vvip] and StoneData[CommercializeEquipCell.Vvip] or nil
  if vip then
    sellGoldUpRatio = math.floor(vip.attributeMap[1].sellGoldUpRatio)
    sellBlueDiamondsUpRatio = math.floor(vip.attributeMap[1].sellBlueDiamondsUpRatio)
  end
  local sellTbl = {}
  for itemId, count in pairs(tempTbl) do
    local tempTab = {
      itemId = itemId,
      count = count,
      tip = ""
    }
    if itemId == ECoinsType.gold and 0 < sellGoldUpRatio then
      local sCount = Mathf.Floor(count * sellGoldUpRatio * 1.0E-4)
      if 0 < sCount then
        tempTab.count = tempTab.count + sCount
        tempTab.tip = tempTab.tip .. string.format(LocalizationUtility.GetContentByKey("sellVipAdd"), sellGoldUpRatio * 0.01, "%")
      end
    end
    if itemId == ECoinsType.integral and 0 < sellBlueDiamondsUpRatio then
      local sCount = Mathf.Floor(count * sellBlueDiamondsUpRatio * 1.0E-4)
      if 0 < sCount then
        tempTab.count = tempTab.count + sCount
        tempTab.tip = tempTab.tip .. string.format(LocalizationUtility.GetContentByKey("sellVipAdd"), sellBlueDiamondsUpRatio * 0.01, "%")
      end
    end
    if itemId == ECoinsType.bindIntegral and 0 < sellBlueDiamondsUpRatio then
      local sCount = Mathf.Floor(count * sellBlueDiamondsUpRatio * 1.0E-4)
      if 0 < sCount then
        tempTab.count = tempTab.count + sCount
        tempTab.tip = tempTab.tip .. string.format(LocalizationUtility.GetContentByKey("sellVipAdd"), sellBlueDiamondsUpRatio * 0.01, "%")
      end
    end
    table.insert(sellTbl, tempTab)
  end
  goldRecoverBuff = 0
  if BuffData.GetBuff(ViewData.meData.id, GoldRecoverCardType.Mid) then
    goldRecoverBuff = goldRecoverBuff + 25
  end
  if BuffData.GetBuff(ViewData.meData.id, GoldRecoverCardType.High) then
    goldRecoverBuff = goldRecoverBuff + 50
  end
  if BuffData.GetBuff(ViewData.meData.id, GoldRecoverCardType.Max) then
    goldRecoverBuff = goldRecoverBuff + 100
  end
  if table.count(sellTbl) == 0 and UIManager.IsVisible(UIID.ItemTipUI) then
    self:ResetTipsLayer()
  end
  self.profitCount = 0
  self.profitHeight = 0
  self.recycleContainer:SetData(sellTbl)
  self.sw_sellProfit.scrollRect.enabled = self.sw_sellProfit.transform.rect.height < self.profitCount * self.profitHeight
  if not self.sw_sellProfit.scrollRect.enabled then
    self.Content.transform:SetAnchoredPosition(Vector2.zero)
  end
  local isActive = false
  local funcTable = ClientTable.cfg_Function_functionManager:TryGetValue(8000003)
  if funcTable ~= nil and ConditionManager.Check4D(funcTable.condition) then
    isActive = true
  end
  self.img_recover_txt:SetActive(isActive)
  if isActive then
    local recoverStr
    if goldRecoverBuff == 0 then
      recoverStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("RecycleCoin_2_1")
    else
      local contentText = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("RecycleCoin_2")
      recoverStr = string.format(contentText, tostring(goldRecoverBuff) .. "%")
    end
    self.lab_recover_txt:SetText(recoverStr)
  end
end

function Bag_SellInfoUI:LocalInit()
  self.sellConfigList = BagSellController.GetShowSellConfigDataList()
  self.defaultStr = ""
  self.itemTogContainer:SetMaxCount(table.count(self.sellConfigList))
  self.itemTogContainer:Refresh()
  self.itemTogContainer:SetDataKTable(self.sellConfigList)
end

function Bag_SellInfoUI:GetRecycleWayType()
  local defaultRecycleWayType = RecycleWayType.Bag
  if self.args ~= nil and self.args.npcConfigID ~= nil then
    defaultRecycleWayType = RecycleWayType.BlackSmith
  end
  return defaultRecycleWayType
end
