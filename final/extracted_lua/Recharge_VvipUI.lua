Recharge_VvipUI = class(BaseUI)
Recharge_VvipUI.layer = UILayer.Panel
Recharge_VvipUI.orderInLayer = 3
Recharge_VvipUI.hideType = UIHideType.WaitDestroy
Recharge_VvipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Recharge_VvipUI.escClose = UIEscClose.DontClose

function Recharge_VvipUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.tog_vvip = self:GetControl("img_title/Scroll View/Viewport/Content/tog_vvip")
  self.bg_vvip = self:GetControl("bg_vvip")
  self.btn_close = self:GetControl("bg_vvip/btn_close")
  self.descBtn = self:GetControl("bg_vvip/descBtn")
  self.lab_vvipName = self:GetControl("bg_vvip/lab_vvipName")
  self.sw_vvipPower = self:GetControl("bg_vvip/sw_vvipPower")
  self.lab_vvipPower = self:GetControl("bg_vvip/sw_vvipPower/Viewport/Content/lab_vvipPower")
  self.lab_vvipGiftName = self:GetControl("bg_vvip/lab_vvipGiftName")
  self.sw_vvipGift = self:GetControl("bg_vvip/sw_vvipGift")
  self.btn_3DItem = self:GetControl("bg_vvip/sw_vvipGift/Viewport/Content/btn_3DItem")
  self.btn_3DMoney = self:GetControl("bg_vvip/btn_3DMoney")
  self.Count = self:GetControl("bg_vvip/btn_3DMoney/Count")
  self.btn_activation = self:GetControl("bg_vvip/btn_activation")
  self.text_activation = self:GetControl("bg_vvip/text_activation")
end

function Recharge_VvipUI:OnPreLoad()
end

function Recharge_VvipUI:Init()
  self.VvipIdGrop = CommercializeData:GetVvipchargeinfo()
  self.Cellid = CommercializeData:GetEquipCellId()
  self.VVipInfo = CommercializeData:GetVvipInfo()
  self.Newindex = -1
  self.showCellData = {}
end

function Recharge_VvipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function Ontog_vvipCreat(ctr)
  ctr.togger = UIControl(ctr.transform)
  ctr.Label = UIControl(ctr.transform, "Label")
  ctr.img_clickeffect = UIControl(ctr.transform, "img_clickeffect")
end

local function Ontog_vvipRefresh(ctr, _, data, ui)
  ui.Toggrop[_] = ctr
  ctr.Label:SetText(data.equip.name)
  ctr.togger.img_clickeffect = ctr.img_clickeffect
  ctr.togger.index = _
  ctr.togger:SetOnToggleChanged(ui, ui.tog_OnChanged)
end

local function GetUIText(title)
  return LocalizationUtility.GetContentByKey(title)
end

local function OnLabPowerCreat(ctr)
end

local function OnLabPowerRefresh(ctr, _, data, ui)
  local descmian = CommercializeData.GetVviptext(data)
  ctr:SetText(descmian)
end

local function ItemIconCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function ItemIconRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
  ui.showCellData[_] = ctr.modelData
end

function Recharge_VvipUI:InitUI()
  self.modelData = ItemCellData()
  self.Toggrop = {}
  self.tog_vvipContainer = UIContainer(self.tog_vvip, self, Ontog_vvipCreat, Ontog_vvipRefresh)
  self.LabPowerContainer = UIContainer(self.lab_vvipPower, self, OnLabPowerCreat, OnLabPowerRefresh)
  self.ItemIconContainer = UIContainer(self.btn_3DItem, self, ItemIconCreat, ItemIconRefresh)
end

function Recharge_VvipUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Recharge_VvipUI:OnHide()
  self.modelData:RecycleRes()
end

function Recharge_VvipUI:OnDestroy()
  self.modelData:RecycleRes()
  self.modelData = nil
end

function Recharge_VvipUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeBgOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Recharge_VvipUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Recharge_VvipUI)
end

function Recharge_VvipUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Recharge_VvipUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

local function boughtShow(ui)
  ui.sw_vvipPower.rectTransform.sizeDelta = Vector2.New(300, 490)
  ui.lab_vvipGiftName:SetActive(false)
  ui.sw_vvipGift:SetActive(false)
  ui.btn_activation:SetActive(false)
  ui.text_activation:SetActive(true)
end

local function NextBugShow(ui, data)
  ui.sw_vvipPower.rectTransform.sizeDelta = Vector2.New(300, 360)
  ui.lab_vvipGiftName:SetActive(true)
  ui.sw_vvipGift:SetActive(true)
  local boxshow = {}
  for i, v in pairs(data.boxshow) do
    if string.isNullOrEmpty(v.condition) then
      table.insert(boxshow, v)
    elseif ConditionManager.Check4D(v.condition) then
      table.insert(boxshow, v)
    end
  end
  ui.ItemIconContainer:SetData(boxshow)
  if data.bugMethod == VvipBuyType.iten_buy then
    local recharge = ClientTable.cfg_Item_buyManager:TryGetValue(data.shopId, "id")
    local cost = string.split(recharge.cost, "#")
    ui.btn_activation.moneyitem = tonumber(cost[1])
    ui.btn_activation.mun = tonumber(cost[2])
  else
    local recharge = ClientTable.cfg_Item_buyManager:TryGetValue(data.shopId, "id").rmb
    ui.btn_activation.rmb = math.floor(recharge / 100)
  end
  ui.btn_activation.bugMethod = data.bugMethod
  ui.btn_activation.shopId = data.shopId
  ui.btn_activation.Id = data.id
  ui.btn_activation.boxshow = data.boxshow
  ui.btn_activation:SetOnClick(ui, ui.btn_activationOnClick)
end

function Recharge_VvipUI:tog_OnChanged(control, eventData)
  if eventData then
    local data = self.VvipShowInfo[control.index]
    if not data then
      return
    end
    self.btn_activation:SetActive(true)
    self.text_activation:SetActive(false)
    self.btn_3DMoney:SetActive(false)
    self.lab_vvipName:SetText(data.equip.name)
    if control.index < self.Nextindex then
      boughtShow(self)
    elseif control.index == self.Nextindex then
      NextBugShow(self, data)
      if data.bugMethod == VvipBuyType.iten_buy then
        self.btn_3DMoney:SetActive(true)
        local itemData = ItemUtility.GenerateItemData(self.btn_activation.moneyitem)
        itemData.count = self.btn_activation.mun
        self.modelData:RefreshData(itemData)
        ItemUtility.ShowItemCell(self.btn_3DMoney, self.modelData, self, true)
        local Color = BagInfoData.GetItemCountByItemConfigId(self.btn_activation.moneyitem) < self.btn_activation.mun and "<color=#ED2E2E>" or "<color=#3CD937>"
        local count = string.format("%s%s</color>", Color, self.btn_activation.mun)
        self.Count:SetText(count)
      end
    elseif control.index > self.Nextindex then
      self.btn_activation:SetActive(false)
      NextBugShow(self, data)
    end
    self.LabPowerContainer:SetData(data.descdata)
  end
end

local function PromptOK()
  UIManager.Hide(UIID.Recharge_VvipUI)
  UIManager.Hide(UIID.PromptTipUI)
  RechargeData.BuyDiamond()
end

function Recharge_VvipUI:btn_activationOnClick(control)
  if not BagInfoData.SafeBagSpaceJudge(control.Id, 1, true) then
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = "T\195\186i \196\145\225\187\147 \196\145\225\186\167y, h\195\163y d\225\187\141n b\225\187\155t"
    })
    return
  end
  if control.bugMethod == VvipBuyType.iten_buy then
    if BagInfoData.GetItemCountByItemConfigId(control.moneyitem) < control.mun then
      UIManager.Show(UIID.PromptTipUI, {
        title = "Nh\225\186\175c nh\225\187\159",
        textContent = "KC kh\195\180ng \196\145\225\187\167, mu\225\187\145n \196\145\225\186\191n n\225\186\161p kh\195\180ng?",
        cancelText = "",
        okText = "",
        cancel = nil,
        ok = PromptOK
      })
      return
    end
    NetManager.Send(ItemBuyMessage.ReqBuy, {
      goodId = control.shopId,
      buyCount = 1
    })
  else
    DataToCSharpMgr.Pay({
      amount = control.rmb,
      product_Id = control.shopId
    })
  end
end

function Recharge_VvipUI:RegistEvents()
  self:RegistEvent(Event.PutOnEquip, self.OnResEquipChange, self)
  self:RegistEvent(Event.TakeOffEquip, self.TakeOffEquipFunc, self)
  self:RegistEvent(Event.Bag_CoinChanged, self.OnCoinChanged, self)
end

function Recharge_VvipUI:OnResEquipChange(_, data)
  if self.Cellid == data.bagGridIndex then
    self:Refresh()
  end
end

function Recharge_VvipUI:TakeOffEquipFunc(_, data)
  if self.Cellid == data.position then
    self:Refresh()
  end
end

function Recharge_VvipUI:OnCoinChanged()
  local Color = BagInfoData.GetItemCountByItemConfigId(self.btn_activation.moneyitem) < self.btn_activation.mun and "<color=#ED2E2E>" or "<color=#3CD937>"
  local count = string.format("%s%s</color>", Color, self.btn_activation.mun)
  self.Count:SetText(count)
end

function Recharge_VvipUI:Refresh()
  self.Newindex = -1
  self:RefreshValue()
  self:RefreshTog()
end

function Recharge_VvipUI:RefreshValue()
  local data = RoleManager.me.data.equipsData.Data
  self.VvipBuyCell = data[self.Cellid] and data[self.Cellid] or nil
  if self.VvipBuyCell and self.VvipBuyCell.tblItem.quality == -1 then
    self.VvipBuyCell = nil
  end
  self.VvipShowInfo = CommercializeData:GetVvipInfo()
  if self.VvipBuyCell == nil then
    if self.Newindex == 1 then
      return
    end
    self.Newindex = 0
    return
  end
  local Vvioid = self.VvipBuyCell.itemId
  if self.Newindex == Vvioid then
    return
  end
  for i, v in pairs(self.VvipIdGrop) do
    if v == Vvioid then
      self.Newindex = i
      break
    end
  end
end

function Recharge_VvipUI:RefreshTog()
  self.Nextindex = self.Newindex + 1
  self.tog_vvipContainer:SetData(self.VVipInfo)
  local index = self.Nextindex > #self.VVipInfo and #self.VVipInfo or self.Nextindex
  if self.args and self.args.level then
    index = self.args.level
  end
  self.Toggrop[index].toggle.isOn = true
  self.Toggrop[index].index = index
  self:tog_OnChanged(self.Toggrop[index], true)
end
