Item_ChooseBoxUI = class(BaseUI)
Item_ChooseBoxUI.layer = UILayer.Panel
Item_ChooseBoxUI.orderInLayer = 7
Item_ChooseBoxUI.hideType = UIHideType.WaitDestroy
Item_ChooseBoxUI.hideFunc = UIHideFunc.MoveOutOfScreen
Item_ChooseBoxUI.escClose = UIEscClose.DontClose

function Item_ChooseBoxUI:InitControls()
  self.btn_bg = self:GetControl("btn_bg")
  self.bg_ornamentsBreach = self:GetControl("bg_ornamentsBreach")
  self.btn_close = self:GetControl("bg_ornamentsBreach/btn_close")
  self.btn_use = self:GetControl("Panel_ExpMedicine/btn_use")
  self.item_number = self:GetControl("Panel_ExpMedicine/item_number")
  self.item_choose = self:GetControl("Panel_ExpMedicine/Scroll View/Viewport/Content/item_choose")
end

function Item_ChooseBoxUI:OnPreLoad()
end

function Item_ChooseBoxUI:Init()
  self.itemCellDataTab = {}
end

function Item_ChooseBoxUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Item_ChooseBoxUI:InitUI()
  self.itemChooseContainer = UIContainer(self.item_choose, self)
end

function Item_ChooseBoxUI:OnShow()
  self:RegistEvents()
  if UIManager.IsVisible(UIID.NewBagInfoUI) then
    UIManager.Hide(UIID.NewBagInfoUI)
  end
  self:Refresh()
end

function Item_ChooseBoxUI:OnHide()
end

function Item_ChooseBoxUI:OnDestroy()
end

function Item_ChooseBoxUI:RegistUIEvents()
  self.btn_bg:SetOnClick(self, self.btn_bgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_use:SetOnClick(self, self.btn_useOnClick)
end

function Item_ChooseBoxUI:btn_bgOnClick(control)
  UIManager.Hide(UIID.Item_ChooseBoxUI)
end

function Item_ChooseBoxUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Item_ChooseBoxUI)
end

function Item_ChooseBoxUI:btn_plusOnClick(control)
  if self.totalCount >= self.bagCount then
    FloatingTipUtility.QuickMsg(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Zixuanbox"))
    return
  end
  self.itemCountTab[control.index] = self.itemCountTab[control.index] + 1
  self.itemObjTab[control.index].input:SetInputText(self.itemCountTab[control.index])
  local count = 0
  for i = 1, table.count(self.itemCountTab) do
    count = count + self.itemCountTab[i]
  end
  self:SetTextUIShowRefresh(count)
end

function Item_ChooseBoxUI:btn_minusOnClick(control)
  if self.itemCountTab[control.index] > 0 then
    self.itemCountTab[control.index] = self.itemCountTab[control.index] - 1
    self.itemObjTab[control.index].input:SetInputText(self.itemCountTab[control.index])
    local count = 0
    for i = 1, table.count(self.itemCountTab) do
      count = count + self.itemCountTab[i]
    end
    self:SetTextUIShowRefresh(count)
  end
end

function Item_ChooseBoxUI:InputField_OnChanged(control)
  if tonumber(self.itemObjTab[control.index].input:GetInputText()) and tonumber(self.itemObjTab[control.index].input:GetInputText()) >= 0 then
    self.itemCountTab[control.index] = tonumber(self.itemObjTab[control.index].input:GetInputText())
    local count = 0
    for i = 1, table.count(self.itemCountTab) do
      count = count + self.itemCountTab[i]
    end
    self:SetTextUIShowRefresh(count)
  end
end

function Item_ChooseBoxUI:btn_useOnClick(control)
  if self.totalCount > 0 and self.totalCount <= self.bagCount then
    local strTab = {}
    for i = 1, table.count(self.itemCountTab) do
      if 0 < self.itemCountTab[i] then
        local str = self.itemDataTab.id[i] .. "#" .. self.itemCountTab[i]
        table.insert(strTab, str)
      end
    end
    BagInfoController.UseItemReq(self.totalCount, self.itemInfo.id, strTab, self.itemInfo.itemId)
    UIManager.Hide(UIID.Item_ChooseBoxUI)
  else
    FloatingWordUtility.QuickMsg("H\195\163y ch\225\187\141n s\225\187\145 l\198\176\225\187\163ng ch\195\173nh x\195\161c")
  end
end

function Item_ChooseBoxUI:RegistEvents()
end

function Item_ChooseBoxUI:InputFieldOnValueChanged(ui, v)
  if string.isNullOrEmpty(v) then
    v = 0
  end
  v = tonumber(v)
  local last = self.itemCountTab[ui.index]
  local count = 0
  for i = 1, table.count(self.itemCountTab) do
    if i ~= ui.index then
      count = count + self.itemCountTab[i]
    end
  end
  local leftover = self.bagCount - (count + v)
  if leftover < 0 then
    v = last
  end
  self.itemCountTab[ui.index] = v
  self:SetTextUIShowRefresh(v + count)
  ui:SetInputText(v)
end

function Item_ChooseBoxUI:Refresh()
  self.boxId = self.args.boxId
  self.itemInfo = self.args.itemInfo
  self.itemObjTab = {}
  self.itemDataTab = {
    id = {},
    itemId = {}
  }
  self.itemCountTab = {}
  self:GetBoxDataByBoxId(self.boxId)
  self:SetTextUIShowRefresh(0)
  self.itemChooseContainer:SetMaxCount(table.count(self.itemDataTab.itemId))
  for i = 1, table.count(self.itemDataTab.itemId) do
    local obj = self.itemChooseContainer:GetOrCreateItem(i)
    local btn_item = obj:GetChild("btn_3DItem")
    local itemData = ItemUtility.GenerateItemData(self.itemDataTab.itemId[i])
    if not self.itemCellDataTab[i] then
      self.itemCellDataTab[i] = ItemCellData()
      self.itemCellDataTab[i]:RefreshData(itemData)
      ItemUtility.ShowItemCell(btn_item, self.itemCellDataTab[i], self, true)
    else
      self.itemCellDataTab[i].itemData = nil
      ItemUtility.ShowItemCell(btn_item, self.itemCellDataTab[i], self)
      self.itemCellDataTab[i]:RefreshData(itemData)
      ItemUtility.ShowItemCell(btn_item, self.itemCellDataTab[i], self, true)
    end
    obj.btnPlus = obj:GetChild("btn_plus")
    obj.btnPlus.index = i
    obj.btnPlus:SetOnClick(self, self.btn_plusOnClick)
    obj.btnMinus = obj:GetChild("btn_minus")
    obj.btnMinus.index = i
    obj.btnMinus:SetOnClick(self, self.btn_minusOnClick)
    obj.input = obj:GetChild("input_number")
    obj.input:SetInputText("0")
    obj.input.index = i
    obj.textName = obj:GetChild("Txtcitiao")
    obj.scrollName = obj:GetChild("MyName")
    local itemName = ClientTable.cfg_Item_itemManager:TryGetValue(self.itemDataTab.itemId[i]).name
    local color = ItemQuality2ColorDic[EItemColorEnum.white]
    local itemData = ClientTable.cfg_Item_itemManager:TryGetValue(self.itemDataTab.itemId[i])
    if itemData.titleColor ~= nil then
      color = ItemQuality2ColorDic[itemData.colorShow]
    end
    local itemName = string.GetColorText(itemData.name, color)
    obj.textName:SetText(itemName)
    local textWidth = obj.textName.text.preferredWidth
    local bgWith = obj.textName:GetSizeDelta()
    if textWidth > bgWith then
      obj.scrollName.transform:GetComponent("AutoScrollText").text = itemName
      obj.textName:SetActive(false)
      obj.scrollName:SetActive(true)
    else
      obj.textName:SetActive(true)
      obj.scrollName:SetActive(false)
    end
    table.insert(self.itemCountTab, 0)
    obj.input:SetOnValueChanged(self, self.InputFieldOnValueChanged)
    table.insert(self.itemObjTab, obj)
  end
  self.itemChooseContainer:Refresh()
end

function Item_ChooseBoxUI:GetBoxDataByBoxId(boxId)
  local reward = ConfigManager.FindConfigs("cfg_Box_box", "boxId", boxId)
  table.sort(reward, function(a, b)
    return a.layer < b.layer
  end)
  for k, v in ipairs(reward) do
    table.insert(self.itemDataTab.id, v.id)
    table.insert(self.itemDataTab.itemId, v.itemId)
  end
end

function Item_ChooseBoxUI:SetTextUIShowRefresh(itemCount)
  self.totalCount = itemCount
  self.bagCount = BagInfoData.GetItemCountByItemConfigId(self.itemInfo.tblItem.id)
  local str = itemCount .. "/" .. self.bagCount
  local strColor = itemCount <= self.bagCount and "#00FF00" or "#FF0000"
  self.item_number:SetText(string.GetColorText(str, strColor))
end
