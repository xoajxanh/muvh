local PandoraActivityShopTemplate = {}

function PandoraActivityShopTemplate:Init(root)
  self.root = root
  self:InitControls()
  self:InitUI()
end

function PandoraActivityShopTemplate:InitControls()
  self.shopItem = self:GetControl("sw_Suit/Viewport/Content/suit1")
end

function PandoraActivityShopTemplate:InitUI()
  self.shopItemContainer = UIContainer(self.shopItem, self, self.ShopItemCreate, self.ShopItemRefresh)
  self.uiWord_ChaKan = ClientTable.cfg_Ui_wordManager:TryGetValue("pandoraBtn1").content or ""
  self.uiWord_ShouQi = ClientTable.cfg_Ui_wordManager:TryGetValue("pandoraBtn2").content or ""
end

function PandoraActivityShopTemplate:Refresh()
  local viewRoleDataList = PandoraActivityData.GetPandoraActivityShopShowInfo()
  self.shopItemContainer:SetData(viewRoleDataList)
end

function PandoraActivityShopTemplate.ShopItemCreate(ctr)
  ctr.role_model = UIControl(ctr.transform, "setPresentation/model")
  ctr.btn_get = UIControl(ctr.transform, "btn_get")
  ctr.btn_show = UIControl(ctr.transform, "btn_show")
  ctr.lab_get = UIControl(ctr.transform, "btn_show/lab_get")
  ctr.sw_Gift = UIControl(ctr.transform, "btn_show/sw_Gift")
  ctr.btn_rewardx = UIControl(ctr.transform, "btn_show/sw_Gift/Viewport/Content/btn_rewardx")
  ctr.isOpen = false
end

function PandoraActivityShopTemplate.ShopItemRefresh(ctr, _, data, ui)
  local viewRoleData = PandoraActivityData.GetPandoraActivityRoleModelShowInfo(data, ctr.role_model.transform)
  if ctr.lookRole then
    ctr.lookRole:Destroy()
    ctr.lookRole = ViewRole(viewRoleData)
  else
    ctr.lookRole = ViewRole(viewRoleData)
  end
  ctr.lookRole:SetPosition(-2, -125, -150)
  ctr.lookRole:SetRotation(0, 180, 0)
  if ctr.shopInfoContainer == nil then
    ctr.shopInfoContainer = UIContainer(ctr.btn_rewardx, ctr, ui.ShopInfoCreate, ui.ShopInfoRefresh)
  end
  local itemList = ui:GetShowInfoItemId(data)
  ctr.shopInfoContainer:SetData(itemList)
  ctr.btn_get:SetOnClick(ui, function()
    UIManager.Show(UIID.Pandora_BuyUI, {data = data})
  end)
  ctr.btn_show:SetOnClick(ui, function()
    ctr.isOpen = not ctr.isOpen
    ctr.sw_Gift:SetActive(ctr.isOpen)
    ctr.lab_get:SetText(ctr.isOpen and ui.uiWord_ShouQi or ui.uiWord_ChaKan)
    for i, v in ipairs(ui.shopItemContainer.items) do
      if v ~= ctr then
        v.isOpen = false
        v.sw_Gift:SetActive(false)
        v.lab_get:SetText(ui.uiWord_ChaKan)
      end
    end
  end)
  ui:ResetShopInfoShowState()
end

function PandoraActivityShopTemplate.ShopInfoCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(ctr)
  ctr.go_modelData = ItemCellData()
end

function PandoraActivityShopTemplate.ShopInfoRefresh(ctr, _, data, ui)
  if data == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(data)
  itemData.count = 1
  ctr.go_modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.go_modelData, ui.root, true)
end

function PandoraActivityShopTemplate:GetShowInfoItemId(data)
  local itemList = {}
  for i, v in ipairs(data) do
    table.insert(itemList, v)
  end
  if table.count(itemList) > 0 then
    return itemList
  end
  return nil
end

function PandoraActivityShopTemplate:CloseUI()
  for i, v in pairs(self.shopItemContainer.items) do
    if v.lookRole then
      v.lookRole:DestroyModel()
      v.lookRole:DestroyEquip()
      v.lookRole:Destroy()
      v.lookRole = nil
    end
    v.isOpen = false
    v.sw_Gift:SetActive(false)
    v.lab_get:SetText(self.uiWord_ChaKan)
  end
end

function PandoraActivityShopTemplate:ResetShopInfoShowState()
  for i, v in ipairs(self.shopItemContainer.items) do
    v.isOpen = false
    v.sw_Gift:SetActive(false)
    v.lab_get:SetText(self.uiWord_ChaKan)
  end
end

return PandoraActivityShopTemplate
