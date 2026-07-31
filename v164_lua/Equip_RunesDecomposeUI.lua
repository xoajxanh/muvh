Equip_RunesDecomposeUI = class(BaseUI)
Equip_RunesDecomposeUI.layer = UILayer.Panel
Equip_RunesDecomposeUI.orderInLayer = 1
Equip_RunesDecomposeUI.hideType = UIHideType.WaitDestroy
Equip_RunesDecomposeUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_RunesDecomposeUI.escClose = UIEscClose.DontClose

function Equip_RunesDecomposeUI:InitControls()
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

function Equip_RunesDecomposeUI:Init()
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

function Equip_RunesDecomposeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_RunesDecomposeUI:InitUI()
  self:InitContent()
end

function Equip_RunesDecomposeUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_RunesDecomposeUI:OnHide()
  self:ClearDecomposeObj()
end

function Equip_RunesDecomposeUI:RegistUIEvents()
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
  ItemUtility.ShowItemCell(ctr, data, ui, true)
end

function Equip_RunesDecomposeUI:InitContent()
  self.decomposeItem_ItemTemp = UIContainer(self.decomposeItem_Item, self, OnDecomposeInit, OnDecomposeRefresh)
  self.decomposeProfitTemp = UIContainer(self.decomposeProfit, self, OnDecomposeProfitCreate)
  self.decomposePrice_ItemTemp = UIContainer(self.decomposePrice_Item, self, OnDecomposePriceItemCreate)
end

function Equip_RunesDecomposeUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_RunesDecomposeUI)
end

function Equip_RunesDecomposeUI:btn_decomposeOnClick(control)
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
    if BagInfoData.DecomposeItemTbl[i].intensify and BagInfoData.DecomposeItemTbl[i].intensify > 0 then
      isHaveForge = true
    end
    if not isHaveForge and BagInfoData.DecomposeItemTbl[i].additional and 0 < BagInfoData.DecomposeItemTbl[i].additional then
      isHaveForge = true
    end
  end
  if isHaveForge then
    local prompTipArgs = {
      textContent = "\196\144ang t\195\161ch trang b\225\187\139 \196\145\195\163 r\195\168n, sau khi t\195\161ch s\225\186\189 kh\195\180ng th\225\187\131 ho\195\160n nguy\195\170n, ti\225\186\191p t\225\187\165c t\195\161ch?",
      ok = function()
        NetManager.Send(EquipMessage.ReqEquipDecompose, {equipId = itemIdList})
      end
    }
    UIManager.Show(UIID.PromptTipUI, prompTipArgs)
    isHaveForge = false
    return
  end
  NetManager.Send(EquipMessage.ReqEquipDecompose, {equipId = itemIdList})
  self:ClearDecomposeObj()
  self:DestroyDecomposeObj()
  EventManager.Dispatch(Event.Bag_DecomposeInfoClose)
end

function Equip_RunesDecomposeUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_RunesDecomposeUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Equip_RunesDecomposeUI:RegistEvents()
  self:RegistEvent(Event.Bag_DecomposeItemClick, self.OnDecomposeItemClick, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnResBagChange, self)
  self:RegistEvent(Event.Bag_ResBagInfo, self.OnRefreshShowBag, self)
  self:RegistEvent(Event.Bag_DecomposeInfoClose, self.ResetDecomposeData, self)
end

function Equip_RunesDecomposeUI:Refresh()
  if not UIManager.IsVisible(UIID.NewBagInfoUI) then
    UIManager.Show(UIID.NewBagInfoUI)
  end
  ForgeData.weight = 86
  ForgeData.height = 86
  self.decomposeItemObj = {}
  self:SetDecomposePanel()
end

function Equip_RunesDecomposeUI:OnDecomposeItemClick(_, control)
  self:AddOrReduceObjModel(control)
  self:Refresh()
end

function Equip_RunesDecomposeUI:OnRefreshShowBag()
end

function Equip_RunesDecomposeUI:OnResBagChange()
end

function Equip_RunesDecomposeUI:SetDecomposePanel()
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
      btn_get:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
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

function Equip_RunesDecomposeUI:Button_ShowItemTips(control)
  UIManager.Show(UIID.ItemTipUI, {
    item = control,
    rightOperate = EItemOperateType.CancelSelect,
    ctrl = control
  })
end

function Equip_RunesDecomposeUI:DestroyDecomposeObj()
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

function Equip_RunesDecomposeUI:ClearDecomposeObj()
  self:DestroyDecomposeObj()
  self:ClearDecomposeData()
  self:SetDecomposePanel()
end

function Equip_RunesDecomposeUI:ClearDecomposeData()
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

function Equip_RunesDecomposeUI:AddOrReduceObjModel(control)
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
end

function Equip_RunesDecomposeUI:ResetDecomposeData()
  self:DestroyDecomposeObj()
  self:ClearDecomposeData()
  self:SetDecomposePanel()
end
