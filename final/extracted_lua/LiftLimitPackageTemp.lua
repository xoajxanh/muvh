local LiftLimitPackageTemp = {}
LiftLimitPackageTemp.RechargeTbl = nil
LiftLimitPackageTemp.BoxTbl = nil
LiftLimitPackageTemp.MainBoxTbl = nil
LiftLimitPackageTemp.Title = nil

function LiftLimitPackageTemp:Init()
  self:InitComponent()
end

local function OnRechItemCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function OnRechItemRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  ctr.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

function LiftLimitPackageTemp:InitComponent()
  self.lab_titleControl = self:GetControl("lab_buyPrizeName")
  self.btn_buyControl = self:GetControl("btn_buyPrize")
  self.obj_buyEffControl = self:GetControl("btn_buyPrize/img_Gift_redPoint")
  self.obj_buytextControl = self:GetControl("btn_buyPrize/lab_buy")
  self.obj_hasBuyControl = self:GetControl("lab_Received")
  self.obj_otherShowControl = self:GetControl("sw_buyPrizeItem/Viewport/Content/btn_3DItem")
  self.obj_centerShowControl = self:GetControl("center_bigItem/btn_3DItem")
  self.content_Container = self:GetControl("sw_buyPrizeItem/Viewport/Content")
  self.obj_limittextControl = self:GetControl("lab_buyPrizelimit")
end

function LiftLimitPackageTemp:BindEvent()
  if self.btn_buyControl then
    self.btn_buyControl:SetOnClick(self, function()
      if self.RechargeTbl == nil then
        logError("L\225\187\151i d\225\187\175 li\225\187\135u b\225\186\163ng n\225\186\161p")
        return
      end
      local PayType = BusinessPayType.LimitBuy
      DataToCSharpMgr.Pay({
        amount = math.ceil(self.RechargeTbl.rmb / 100),
        product_Id = self.RechargeTbl.id,
        product_name = self.RechargeTbl.name,
        BusinessPayType = PayType
      })
    end)
  end
end

local GuideEffecName = "Eff_UI_annuikuang06"

function LiftLimitPackageTemp:Refresh(data, ui)
  self.RechargeTbl = data.rechargeTbl
  self:BindEvent()
  self:DealBoxTbl(data.boxTbl)
  LiftLimitPackageTemp.Title = ClientTable.cfg_Ui_wordManager:TryGetValue(data.rechargeTbl.title)
  if LiftLimitPackageTemp.Title ~= nil and not string.isNullOrEmpty(LiftLimitPackageTemp.Title.content) then
    self.lab_titleControl:SetText(LiftLimitPackageTemp.Title.content)
  end
  self.btn_buyControl:SetActive(not data.isBuy)
  self.obj_hasBuyControl:SetActive(data.isBuy)
  self.obj_limittextControl:SetText(string.format("L\198\176\225\187\163t h\225\186\161n mua: <color=%s>%s / 1</color>", data.isBuy and "#FF2323" or "#1ADD1F", data.isBuy and "0" or "1"))
  if #tostring(self.RechargeTbl.rmb) > 4 then
    self.obj_buytextControl:SetText("" .. math.floor(self.RechargeTbl.rmb / 1000) .. "K VND")
  else
    self.obj_buytextControl:SetText("" .. math.floor(self.RechargeTbl.rmb) .. "VND")
  end
  if self.ItemContainer == nil then
    self.ItemContainer = UIContainer(self.obj_otherShowControl, ui, OnRechItemCreat, OnRechItemRefresh)
  end
  if self.ItemCenterContainer == nil then
    self.ItemCenterContainer = UIContainer(self.obj_centerShowControl, ui, OnRechItemCreat, OnRechItemRefresh)
  end
  self.ItemContainer:SetData(LiftLimitPackageTemp.BoxTbl)
  self.ItemCenterContainer:SetData(LiftLimitPackageTemp.MainBoxTbl)
  local effectItem = self:UIControl().transform:Find(GuideEffecName)
  if ui.args and ui.args.shopID and tonumber(ui.args.shopID) == data.rechargeTbl.id then
    if not effectItem then
      effectItem = UIEffectUtility.SetUIEffect(GuideEffecName, self:UIControl().transform, true, Vector2(2.1, 2.6), Vector3(0, -180, 0))
    else
      effectItem.gameObject:SetActive(true)
    end
  elseif effectItem then
    effectItem.gameObject:SetActive(false)
  end
end

function LiftLimitPackageTemp:DealBoxTbl(boxtbl)
  LiftLimitPackageTemp.BoxTbl = {}
  LiftLimitPackageTemp.MainBoxTbl = {}
  for i = 1, #boxtbl do
    if i == 1 then
      table.insert(LiftLimitPackageTemp.MainBoxTbl, boxtbl[i])
    else
      table.insert(LiftLimitPackageTemp.BoxTbl, boxtbl[i])
    end
  end
end

return LiftLimitPackageTemp
