Equip_Decompose = class(BaseUI)
Equip_Decompose.layer = UILayer.Panel
Equip_Decompose.orderInLayer = 1
Equip_Decompose.hideType = UIHideType.WaitDestroy
Equip_Decompose.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_Decompose.escClose = UIEscClose.DontClose

function Equip_Decompose:InitControls()
  self.bg_decompose = self:GetControl("bg_decompose")
  self.sw_decomposeItem = self:GetControl("bg_decompose/sw_decomposeItem")
  self.decomposeItemContent = self:GetControl("bg_decompose/sw_decomposeItem/Viewport/decomposeItemContent")
  self.decomposeItem_Item = self:GetControl("bg_decompose/sw_decomposeItem/Viewport/decomposeItemContent/decomposeItem_Item")
  self.sw_decomposeProfit = self:GetControl("bg_decompose/sw_decomposeProfit")
  self.Content = self:GetControl("bg_decompose/sw_decomposeProfit/Viewport/Content")
  self.decomposeProfit = self:GetControl("bg_decompose/sw_decomposeProfit/Viewport/Content/decomposeProfit")
  self.lab_decomposePrice = self:GetControl("bg_decompose/lmg_titil/lab_decomposePrice")
  self.sw_decomposePrice = self:GetControl("bg_decompose/sw_decomposePrice")
  self.decomposePriceContent = self:GetControl("bg_decompose/sw_decomposePrice/Viewport/decomposePriceContent")
  self.decomposePrice_Item = self:GetControl("bg_decompose/sw_decomposePrice/Viewport/decomposePriceContent/decomposePrice_Item")
  self.btn_decompose = self:GetControl("bg_decompose/btn_decompose")
  self.lab_decompose = self:GetControl("bg_decompose/btn_decompose/lab_decompose")
  self.Img_noItem = self:GetControl("Img_noItem")
  self.btn_close = self:GetControl("btn_close")
  self.descBtn = self:GetControl("descBtn")
end

function Equip_Decompose:OnPreLoad()
end

function Equip_Decompose:Init()
  self.DecomposeObjTbl = {}
  self.consumeObjTbl = {}
  self.clientRewardObjTbl = {}
  self.decomposeData = {
    cellData = {},
    itemData = {}
  }
  self.decomposeItemObj = {}
  self.rewardCellData = {}
end

function Equip_Decompose:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_Decompose:InitUI()
  self:InitContent()
end

function Equip_Decompose:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_Decompose:OnHide()
  self:ClearDecomposeObj()
  self:ResetTipsLayer()
end

function Equip_Decompose:ResetTipsLayer()
  ItemUtility.TryReSetTipLayer()
  UIManager.Hide(UIID.ItemTipUI)
end

function Equip_Decompose:OnDestroy()
end

function Equip_Decompose:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_decompose:SetOnClick(self, self.btn_decomposeOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

local function OnDecomposeProfitCreate(control)
  control.img_icon = UIControl(control.transform, "img_icon")
  control.lab_number = UIControl(control.transform, "lab_number")
end

local function OnDecomposePriceItemCreate(control)
  control.lab_num = UIControl(control.transform, "lab_num")
end

local function OnDecomposeInit(control)
end

local function OnDecomposeRefresh(ctr, _, data, ui)
  if data then
    data:RecycleRes()
  end
  data.customData = {
    clickCallBack = function()
      ItemUtility.TryReSetTipLayer()
      if UIManager.IsVisible(UIID.ItemTipUI) then
        UIManager.SwitchVisible(UIID.ItemTipUI)
      end
      UIManager.Show(UIID.ItemTipUI, {
        item = data.itemData,
        rightOperate = EItemOperateType.Show,
        ctrl = ctr
      })
    end
  }
  ItemUtility.ShowItemCell(ctr, data, ui, true)
end

function Equip_Decompose:InitContent()
  self.decomposeItem_ItemTemp = UIContainer(self.decomposeItem_Item, self, OnDecomposeInit, OnDecomposeRefresh)
  self.decomposeProfitTemp = UIContainer(self.decomposeProfit, self, OnDecomposeProfitCreate)
  self.decomposePrice_ItemTemp = UIContainer(self.decomposePrice_Item, self, OnDecomposePriceItemCreate)
end

function Equip_Decompose:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_Decompose)
end

function Equip_Decompose:btn_decomposeOnClick(control)
  local playerPrefs = string.format("%s_ResolveTodayIsShowPromptTipUI", ViewData.meData.id)
  local lastRecordTime = PlayerPrefs.GetInt(playerPrefs, 0)
  local isServerSameDay = TimeUtility.CheckIsServerSameDay(lastRecordTime)
  if lastRecordTime == 0 or isServerSameDay == false then
    TipUtility.QuickShowPrompt({
      id = 50,
      onlyOnce = true,
      onlyOnceArgs = nil,
      onlyOnceAction = function(args, isOn)
        PlayerPrefs.SetInt(playerPrefs, isOn and Time.GetServerSecondTime() or 0)
      end,
      cancelAction = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      okAction = function()
        UIManager.Hide(UIID.PromptTipUI)
        self:Resolve()
      end
    })
  else
    self:Resolve()
  end
end

function Equip_Decompose:Resolve()
  local bagCount = BagInfoData.GetItemTotalCountByItemId(ECoinsType.bindIntegral)
  if bagCount < tonumber(self.coinCount) then
    FloatingWordUtility.QuickBtnMsg({
      parent = self.btn_decompose,
      msgStr = LocalizationUtility.GetUIWord("DecomposeError_2")
    })
    return
  end
  local itemIdList = {}
  local isHaveForge = false
  for i = 1, table.count(BagInfoData.DecomposeItemTbl) do
    local itemshow = true
    for _, v in pairs(itemIdList) do
      if v == BagInfoData.DecomposeItemTbl[i].id then
        itemshow = false
      end
    end
    if itemshow then
      table.insert(itemIdList, BagInfoData.DecomposeItemTbl[i].id)
    end
  end
  NetManager.Send(EquipMessage.ReqEquipDecompose, {equipId = itemIdList})
  self:ClearDecomposeObj()
  self:DestroyDecomposeObj()
  EventManager.Dispatch(Event.Bag_DecomposeInfoClose)
end

function Equip_Decompose:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_Decompose")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Equip_Decompose:RegistEvents()
  self:RegistEvent(Event.Bag_DecomposeItemClick, self.OnDecomposeItemClick, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnResBagChange, self)
  self:RegistEvent(Event.Bag_ResBagInfo, self.OnRefreshShowBag, self)
  self:RegistEvent(Event.Bag_DecomposeInfoClose, self.ResetDecomposeData, self)
end

function Equip_Decompose:Refresh()
  if not UIManager.IsVisible(UIID.NewBagInfoUI) then
    UIManager.Show(UIID.NewBagInfoUI)
  end
  ForgeData.weight = 86
  ForgeData.height = 86
  self.decomposeItemObj = {}
  self:SetDecomposePanel()
end

function Equip_Decompose:OnDecomposeItemClick(_, control)
  self:AddOrReduceObjModel(control)
  self:Refresh()
end

function Equip_Decompose:OnRefreshShowBag()
end

function Equip_Decompose:OnResBagChange()
end

function Equip_Decompose:SetDecomposePanel()
  local decItemTbl = BagInfoData.DecomposeItemTbl
  local decTblCount = table.count(decItemTbl)
  local decTblObjCount = table.count(self.DecomposeObjTbl)
  local consumeItemTbl = BagInfoData.consumeItemTbl
  local conTblCount = table.count(consumeItemTbl)
  local conTblObjCount = table.count(self.consumeObjTbl)
  local clientRewardItemTbl = BagInfoData.acquireItemTbl
  local cliTblCount = table.count(clientRewardItemTbl)
  local cliTblObjCount = table.count(self.clientRewardObjTbl)
  self.decomposeProfitTemp:SetMaxCount(conTblCount)
  self.decomposeProfitTemp:Refresh()
  if 0 < decTblCount then
    self.DecomposeObjTbl = {}
    self.consumeObjTbl = {}
    self.clientRewardObjTbl = {}
    local I = 0
    self.decomposeProfitTemp:SetMaxCount(conTblCount)
    for k, v in pairs(consumeItemTbl) do
      I = I + 1
      local obj = self.decomposeProfitTemp:GetOrCreateItem(I)
      self.coinCount = v
      obj:SetActive(true)
      local btn_get = obj:GetChild("btn_obtain")
      local bagCount = BagInfoData.GetItemTotalCountByItemId(ECoinsType.bindIntegral)
      if bagCount < tonumber(self.coinCount) then
        obj.lab_number:SetText(string.GetColorText(v, ItemQuality2ColorDic[7]))
      else
        obj.lab_number:SetText(string.GetColorText(v, ItemQuality2ColorDic[0]))
      end
      local itemData = ItemUtility.GenerateItemData(ECoinsType.bindIntegral)
      btn_get:SetActive(bagCount < tonumber(self.coinCount))
      btn_get.itemData = itemData
      btn_get.OpenTipsType = EOpenTipsType.FastBuy
      btn_get:SetOnClick(ItemUtility, function()
        self:ResetTipsLayer()
        ItemUtility.ClickObtainItemBtn(_, btn_get)
      end)
      table.insert(self.consumeObjTbl, obj)
    end
    self.decomposeProfitTemp:Refresh()
    self.decomposePrice_ItemTemp:SetMaxCount(cliTblCount)
    local itemCountStr
    for i = 1, cliTblCount do
      local obj = self.decomposePrice_ItemTemp:GetOrCreateItem(i)
      local itemInfo = ItemUtility.GenerateItemData(tonumber(clientRewardItemTbl[i].clientReward))
      if not self.rewardCellData[i] then
        self.rewardCellData[i] = ItemCellData()
      end
      self.rewardCellData[i]:RefreshData(itemInfo)
      self.rewardCellData[i].customData = {
        clickCallBack = function()
          ItemUtility.TryReSetTipLayer()
          if UIManager.IsVisible(UIID.ItemTipUI) then
            UIManager.SwitchVisible(UIID.ItemTipUI)
          end
          UIManager.Show(UIID.ItemTipUI, {
            item = itemInfo,
            rightOperate = EItemOperateType.Show,
            ctrl = obj
          })
        end
      }
      ItemUtility.ShowItemCell(obj, self.rewardCellData[i], self, true)
      if obj.lab_num then
        itemCountStr = clientRewardItemTbl[i].clientRewardNum
        itemCountStr = itemCountStr == "1" and "" or itemCountStr
        obj.lab_num:SetText(itemCountStr)
        obj.lab_num:SetActive(not string.isNullOrEmpty(itemCountStr))
      end
      obj:SetActive(true)
      table.insert(self.clientRewardObjTbl, obj)
    end
    self.decomposePrice_ItemTemp:Refresh()
    self.Img_noItem:SetActive(false)
  else
    self:DestroyDecomposeObj()
    self:ClearDecomposeData()
    self.Img_noItem:SetActive(true)
  end
end

function Equip_Decompose:Button_ShowItemTips(control)
  UIManager.Show(UIID.ItemTipUI, {
    item = control,
    rightOperate = EItemOperateType.CancelSelect,
    ctrl = control
  })
end

function Equip_Decompose:DestroyDecomposeObj()
  for i = table.count(self.decomposeData.itemData), 1, -1 do
    self.decomposeData.cellData[i]:RecycleRes()
  end
  self.decomposeItem_ItemTemp:SetData()
  if table.count(self.consumeObjTbl) > 0 then
    for i = 1, table.count(self.consumeObjTbl) do
      self.consumeObjTbl[table.count(self.consumeObjTbl)]:SetActive(false)
    end
  end
  if 0 < table.count(self.rewardCellData) then
    for i = 1, table.count(self.rewardCellData) do
      self.rewardCellData[i]:RecycleRes()
    end
  end
  self.decomposePrice_ItemTemp:SetData()
end

function Equip_Decompose:ClearDecomposeObj()
  self:DestroyDecomposeObj()
  self:ClearDecomposeData()
  self:SetDecomposePanel()
end

function Equip_Decompose:ClearDecomposeData()
  BagInfoData.DecomposeItemTbl = {}
  BagInfoData.consumeItemTbl = {}
  BagInfoData.acquireItemTbl = {}
  BagInfoData.decomposeItemIds = {}
  self.decomposeData = {
    cellData = {},
    itemData = {}
  }
  self.rewardCellData = {}
end

function Equip_Decompose:AddOrReduceObjModel(control)
  local bagCellData = control.data:GetData()
  if bagCellData.selected then
    local itemCellData = ItemCellData()
    itemCellData:RefreshData(control.data.itemData)
    table.insert(self.decomposeData.cellData, itemCellData)
    table.insert(self.decomposeData.itemData, control.data.itemData)
  else
    for i = 1, table.count(self.decomposeData.itemData) do
      if control.data.itemData == self.decomposeData.itemData[i] then
        local obj = self.decomposeItem_ItemTemp:GetOrCreateItem(i)
        self.decomposeData.cellData[i]:RecycleRes()
        self.decomposeData.cellData[i].itemData = nil
        ItemUtility.ShowItemCell(obj, self.decomposeData.cellData[i], self)
        table.remove(self.decomposeData.cellData, i)
        table.remove(self.decomposeData.itemData, i)
        break
      end
    end
  end
  self.decomposeItem_ItemTemp:SetData(self.decomposeData.cellData)
  if table.count(self.decomposeData.cellData) == 0 and UIManager.IsVisible(UIID.ItemTipUI) then
    self:ResetTipsLayer()
  end
end

function Equip_Decompose:ResetDecomposeData()
  self:DestroyDecomposeObj()
  self:ClearDecomposeData()
  self:SetDecomposePanel()
end
