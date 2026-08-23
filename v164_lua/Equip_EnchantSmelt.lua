Equip_EnchantSmelt = class(BaseUI)
Equip_EnchantSmelt.layer = UILayer.Panel
Equip_EnchantSmelt.orderInLayer = 0
Equip_EnchantSmelt.hideType = UIHideType.WaitDestroy
Equip_EnchantSmelt.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_EnchantSmelt.escClose = UIEscClose.DontClose

local function decomposeCreate(ctr)
  ctr.probability = UIControl(ctr.transform, "probability")
  if ctr.itemCellData then
    ctr.itemCellData:Reset()
  else
    local itemCellData = ItemCellData()
    ctr.itemCellData = itemCellData
  end
end

local function decomposeOnRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  ctr.itemCellData:RefreshData(itemData)
  ctr.itemCellData.itemData.count = data.count
  ctr.itemCellData.customData = {
    clickCallBack = function()
      ItemUtility.TryReSetTipLayer()
      if UIManager.IsVisible(UIID.ItemTipUI) then
        UIManager.SwitchVisible(UIID.ItemTipUI)
      end
      UIManager.Show(UIID.ItemTipUI, {
        item = itemData,
        rightOperate = EItemOperateType.Show,
        ctrl = ctr
      })
    end
  }
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
  ctr.probability:SetText(tostring(math.floor(data.probability * 0.01)) .. "%")
end

function Equip_EnchantSmelt:InitControls()
  self.bg_equipSmelt = self:GetControl("bg_equipSmelt")
  self.bg_SmeltItem = self:GetControl("bg_equipSmelt/bg_SmeltItem")
  self.equipSmelt_Item = self:GetControl("bg_equipSmelt/bg_SmeltItem/equipSmelt_Item")
  self.lab_decomposePrice = self:GetControl("bg_equipSmelt/lmg_titil/lab_decomposePrice")
  self.sw_smeltOdds = self:GetControl("bg_equipSmelt/sw_smeltOdds")
  self.smeltOddsContent = self:GetControl("bg_equipSmelt/sw_smeltOdds/Viewport/smeltOddsContent")
  self.smeltOdds_Item = self:GetControl("bg_equipSmelt/sw_smeltOdds/Viewport/smeltOddsContent/smeltOdds_Item")
  self.smelt_commonProfit1 = self:GetControl("bg_equipSmelt/Smelt_cost/smelt_commonProfit1")
  self.smelt_commonProfit2 = self:GetControl("bg_equipSmelt/Smelt_cost/smelt_commonProfit2")
  self.Img_noItem = self:GetControl("Img_noItem")
  self.btn_close = self:GetControl("btn_close")
  self.descBtn = self:GetControl("descBtn")
  self.Smelt_cost = self:GetControl("bg_equipSmelt/Smelt_cost")
  self.decomposeList = UIContainer(self.smeltOdds_Item, self, decomposeCreate, decomposeOnRefresh)
end

function Equip_EnchantSmelt:Init()
end

function Equip_EnchantSmelt:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_EnchantSmelt:InitUI()
  self.smelt_commonProfit = {
    self.smelt_commonProfit1,
    self.smelt_commonProfit2
  }
  self.cellData = {}
end

function Equip_EnchantSmelt:RegistUIEvents()
  self.smeltOdds_Item:SetOnClick(self, self.smeltOdds_ItemOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Equip_EnchantSmelt:smeltOdds_ItemOnClick(control)
end

function Equip_EnchantSmelt:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_EnchantSmelt)
end

function Equip_EnchantSmelt:descBtnOnClick(control)
  UIManager.Show(UIID.System_DescUI, {id = 1136})
end

function Equip_EnchantSmelt:OnShow()
  self.SmeltingInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantmentSmeltingManager()
  self:RegistEvents()
  self:Refresh()
end

function Equip_EnchantSmelt:RegistEvents()
  self:RegistEvent(Event.SmeltingBagChoose, self.Refresh, self)
  self:RegistEvent(Event.Bag_EnchantmentSmeltingBagChange, self.SmeltingBagChange, self)
end

function Equip_EnchantSmelt:Refresh()
  if not self.itemCellData then
    self.itemCellData = ItemCellData()
  end
  local itemInfo = self.SmeltingInfo:GetSelectItemData()
  if not table.isNullOrEmpty(itemInfo) and not table.isNullOrEmpty(itemInfo.itemData) then
    self.Img_noItem:SetActive(false)
    self.sw_smeltOdds:SetActive(true)
    self.Smelt_cost:SetActive(true)
    self.equipSmelt_Item:SetActive(true)
    self.itemCellData:RefreshData(itemInfo.itemData)
    ItemUtility.ShowItemCell(self.equipSmelt_Item, self.itemCellData, self, true)
    self:ShowSmeltList(itemInfo)
  else
    self.Img_noItem:SetActive(true)
    self.sw_smeltOdds:SetActive(false)
    self.Smelt_cost:SetActive(false)
    self.itemCellData:RecycleRes()
    ItemUtility.ShowItemCell(self.equipSmelt_Item, {}, self, false)
    self.equipSmelt_Item:SetActive(false)
  end
end

function Equip_EnchantSmelt:SmeltingBagChange()
  self.SmeltingInfo:SetSelectItemData(nil)
  self:Refresh()
end

function Equip_EnchantSmelt:ShowSmeltList(data)
  if table.isNullOrEmpty(data) or table.isNullOrEmpty(data.itemData) then
    self.sw_smeltOdds:SetActive(false)
    return
  end
  local showItem = {}
  local equipInfo = data.itemData.tblEquip
  local equipClass = equipInfo.equipClass
  if equipClass and equipInfo.beSmelt and equipInfo.beSmelt ~= 0 then
    local equip_smelt = ClientTable.cfg_equip_smeltManager:TryGetValue(equipClass, "equipClass")
    if equip_smelt then
      self:ShowCost(equip_smelt, data.itemData)
      local smeltOdds = equip_smelt.smeltOdds
      local array = string.split(smeltOdds, "&")
      for i, v in pairs(array) do
        local itemInfo = string.split(v, "#")
        local info = {}
        info.itemId = tonumber(itemInfo[1])
        info.count = tonumber(itemInfo[2])
        info.probability = tonumber(itemInfo[3])
        table.insert(showItem, info)
      end
    end
  end
  if 0 < table.count(showItem) then
    self.decomposeList:SetData(showItem)
  end
end

function Equip_EnchantSmelt:ShowCost(equip_smelt, equipInfo)
  local cost = {
    [1] = equip_smelt.commonCost,
    [2] = equip_smelt.DiamondCost
  }
  for i = 1, table.count(self.smelt_commonProfit) do
    local obj = self.smelt_commonProfit[i]
    local btn_smelt = obj:GetChild("btn_smelt")
    local lab_number = obj:GetChild("lab_number")
    local itemTbl = string.split(cost[i], "#")
    local id = tonumber(itemTbl[1])
    local count = tonumber(itemTbl[2])
    local itemData = ItemUtility.GenerateItemData(id)
    local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
    local strColor = count <= bagCount and "#00FF00" or "#FF0000"
    if not self.cellData[i] then
      self.cellData[i] = ItemCellData()
    end
    self.cellData[i]:RefreshData(itemData)
    ItemUtility.ShowItemCell(obj, self.cellData[i], self, true)
    lab_number:SetText(string.GetColorText(count, strColor))
    if i == 1 then
      btn_smelt:SetOnClick(self, function()
        networkRequest.ReqEquipSmelt(equipInfo.id, 1)
      end)
    elseif i == 2 then
      btn_smelt:SetOnClick(self, function()
        networkRequest.ReqEquipSmelt(equipInfo.id, 2)
      end)
    end
  end
end

function Equip_EnchantSmelt:OnHide()
  for i, v in pairs(self.cellData) do
    if v then
      v:RecycleRes()
    end
  end
  self.cellData = {}
  self.itemCellData:RecycleRes()
  self.itemCellData = nil
end

function Equip_EnchantSmelt:OnDestroy()
end
