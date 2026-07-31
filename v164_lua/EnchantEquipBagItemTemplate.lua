local EnchantEquipBagItemTemplate = {}

function EnchantEquipBagItemTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
end

function EnchantEquipBagItemTemplate:InitControls()
  self.img_select = self:GetControl("img_select")
  self.img_arrow = self:GetControl("img_arrow")
  self.this = self:GetControl()
  self.bagCellData = ItemCellData()
end

function EnchantEquipBagItemTemplate:BindUIEvent()
  self.this:SetOnClick(self, self.btn_3DItemOnClick)
end

function EnchantEquipBagItemTemplate:btn_3DItemOnClick(control)
  if self.root == nil or self.data == nil or self.data:CheckDataIsNil() then
    return
  end
  if self.root.bagData and self.root.bagData.m_Id == self.data.m_Id then
    local itemData = ItemUtility.GenerateItemData(self.data.m_ItemId)
    itemData.count = self.data.m_Count
    UIManager.Show(UIID.ItemTipUI, {
      item = itemData,
      rightOperate = EItemOperateType.Show,
      ctrl = control
    })
  else
    EventManager.Dispatch(Event.RefreshSelectEnchantEquipBagData, {
      bagData = self.data
    })
  end
end

function EnchantEquipBagItemTemplate:Refresh(_data, _ui)
  if _data == nil or _data:CheckDataIsNil() then
    self.this:SetActive(false)
    return
  end
  self.this:SetActive(true)
  self.data = _data
  self.root = _ui
  self:RefreshModel()
  self:RefreshUIView()
end

function EnchantEquipBagItemTemplate:RefreshModel()
  if self.bagCellData then
    self.bagCellData:RecycleRes()
  end
  local itemData = ItemUtility.GenerateItemData(self.data.m_ItemId)
  itemData.count = self.data.m_Count
  self.bagCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.this, self.bagCellData, self.root, false, nil, 2, 3)
end

function EnchantEquipBagItemTemplate:RefreshUIView()
  if self.data == nil or self.root == nil then
    return
  end
  self:RefreshSelectState()
  self:RefreshArrowState()
end

function EnchantEquipBagItemTemplate:RefreshSelectState()
  self.img_select:SetActive(false)
  if self.root == nil or self.root.bagData == nil or self.data:CheckDataIsNil() then
    return
  end
  self.img_select:SetActive(self.root.bagData.m_Id == self.data.m_Id)
end

function EnchantEquipBagItemTemplate:RefreshArrowState()
  if self.arrowCoroutine then
    Coroutine.Stop(self.arrowCoroutine)
    self.arrowCoroutine = nil
  end
  self.img_arrow:SetActive(false)
  if self.root == nil or self.root.enchantEquipIndexData == nil or self.data == nil or self.data:CheckDataIsNil() then
    return
  end
  local arrowIcon
  local enchantEquipIndexData, itemInfo, bagQuality = self.root.enchantEquipIndexData, self.root.enchantEquipIndexData.m_ItemInfo, self.data.m_ItemConfig.quality
  if itemInfo == nil then
    if enchantEquipIndexData:IsCanInlayAppointQuality(bagQuality) then
      arrowIcon = "ty_bag_green"
    else
      arrowIcon = "ty_bag_yellow"
    end
  else
    local equipQuality = ItemUtility.GenerateItemDataByServerData(itemInfo).tblItem.quality
    if enchantEquipIndexData:IsCanInlayAppointQuality(bagQuality) and bagQuality > equipQuality then
      arrowIcon = "ty_bag_green"
    elseif not enchantEquipIndexData:IsCanInlayAppointQuality(bagQuality) then
      arrowIcon = "ty_bag_yellow"
    end
  end
  if string.isNullOrEmpty(arrowIcon) then
    return
  end
  self.arrowCoroutine = self.root:SetSprite("Atlas_Common", arrowIcon, self.img_arrow, false)
end

return EnchantEquipBagItemTemplate
