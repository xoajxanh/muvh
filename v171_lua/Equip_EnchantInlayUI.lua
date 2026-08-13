Equip_EnchantInlayUI = class(BaseUI)
Equip_EnchantInlayUI.layer = UILayer.Panel
Equip_EnchantInlayUI.orderInLayer = 0
Equip_EnchantInlayUI.hideType = UIHideType.WaitDestroy
Equip_EnchantInlayUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_EnchantInlayUI.escClose = UIEscClose.DontClose

function Equip_EnchantInlayUI:InitControls()
  self.lab_EquipName = self:GetControl("Enchant/lab_EquipName")
  self.img_LevelIcon = self:GetControl("Enchant/Level/img_LevelIcon")
  self.lab_Level = self:GetControl("Enchant/Level/lab_Level")
  self.btn_Equip3DItem = self:GetControl("Enchant/btn_Equip3DItem")
  self.btn_Hole3DItem = self:GetControl("Enchant/hole/btn_Hole3DItem")
  self.btn_Choose = self:GetControl("Enchant/hole/btn_Choose")
  self.img_Lock = self:GetControl("Enchant/hole/img_Lock")
  self.btn_Delete = self:GetControl("Enchant/hole/btn_Delete")
  self.btn_Bag3DItem = self:GetControl("bagScrollView/Viewport/Content/btn_Bag3DItem")
  self.btn_Inlay = self:GetControl("btn_Inlay")
  self.btn_Replace = self:GetControl("btn_Replace")
  self.btn_Desc = self:GetControl("btn_Desc")
  self.btn_Close = self:GetControl("btn_Close")
end

function Equip_EnchantInlayUI:Init()
end

function Equip_EnchantInlayUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_EnchantInlayUI:InitUI()
  self.btn_3DItemTemp = UIUtility.BindUIContainerTemp(self.btn_Bag3DItem, LuaComponentTemplates.EnchantEquipBagItemTemplate, self)
end

function Equip_EnchantInlayUI:RegistUIEvents()
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
  self.btn_Inlay:SetOnClick(self, self.btn_InlayOnClick)
  self.btn_Replace:SetOnClick(self, self.btn_ReplaceOnClick)
  self.btn_Delete:SetOnClick(self, self.btn_DeleteOnClick)
  self.btn_Desc:SetOnClick(self, self.btn_DescOnClick)
end

function Equip_EnchantInlayUI:btn_CloseOnClick()
  UIManager.Hide(UIID.Equip_EnchantInlayUI)
end

function Equip_EnchantInlayUI:btn_InlayOnClick()
  if self.equipIndex == nil or self.bagData == nil or self.enchantEquipIndexData == nil then
    return
  end
  EnchantEquipController.ReqEnchantReplace(self.equipIndex, self.bagData.m_Id)
  if not self.enchantEquipIndexData:IsCanInlayAppointQuality(self.bagData.m_ItemConfig.quality) then
    return
  end
  EnchantEquipUtility:PlayEffect("Eff_UI_FMzhuangbeichenggong", 1)
end

function Equip_EnchantInlayUI:btn_ReplaceOnClick()
  if self.equipIndex == nil or self.bagData == nil then
    return
  end
  EnchantEquipController.ReqEnchantReplace(self.equipIndex, self.bagData.m_Id)
  if not self.enchantEquipIndexData:IsCanInlayAppointQuality(self.bagData.m_ItemConfig.quality) then
    return
  end
  EnchantEquipUtility:PlayEffect("Eff_UI_FMzhuangbeichenggong", 1)
end

function Equip_EnchantInlayUI:btn_DeleteOnClick()
  EnchantEquipController.ReqEnchantReplace(self.equipIndex, 0)
end

function Equip_EnchantInlayUI:btn_DescOnClick()
  local config = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_EnchantInlayUI")
  if 0 < #config then
    UIManager.Show(UIID.System_DescUI, {
      id = config[1].id
    })
  end
end

function Equip_EnchantInlayUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_EnchantInlayUI:RegistEvents()
  self:RegistEvent(Event.RefreshSelectEnchantEquipInlay, self.RefreshSelectEnchantEquipInlay, self)
  self:RegistEvent(Event.RefreshEnchantEquipIndexChange, self.RefreshEnchantEquipInlayView, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshEnchantEquipInlayView, self)
  self:RegistEvent(Event.RefreshSelectEnchantEquipBagData, self.RefreshSelectEnchantEquipBagData, self)
end

function Equip_EnchantInlayUI:Refresh()
end

function Equip_EnchantInlayUI:RefreshSelectEnchantEquipInlay(_eventId, _data)
  self.equipIndex = nil
  self.bagData = nil
  if _data == nil or _data.equipIndex == nil then
    return
  end
  self.equipIndex = _data.equipIndex
  self:RefreshEnchantEquipInlayView()
end

function Equip_EnchantInlayUI:RefreshEnchantEquipInlayView()
  if self.equipIndex == nil then
    return
  end
  local enchantEquipIndexData = gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():GetEnchantEquipIndexDataByEquipIndex(self.equipIndex)
  if enchantEquipIndexData == nil then
    return
  end
  self.bagData = nil
  self.enchantEquipIndexData = enchantEquipIndexData
  self:RefreshLevel(enchantEquipIndexData)
  self:RefreshRedEquip()
  self:RefreshHoleEquip(enchantEquipIndexData)
  self:RefreshBag(enchantEquipIndexData)
  self:RefreshBagSelectState()
  self:RefreshInlayReplaceBtnRedPoint(enchantEquipIndexData)
  self:RefreshBtnState(enchantEquipIndexData)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.Bag_EquipInfoUI
  })
end

function Equip_EnchantInlayUI:RefreshLevel(_enchantEquipIndexData)
  self.lab_Level:SetText(string.format("%dT", _enchantEquipIndexData.m_PointId))
  self.img_LevelIcon:SetActive(false)
  if self.levelIconCoroutine then
    Coroutine.Stop(self.levelIconCoroutine)
    self.levelIconCoroutine = nil
  end
  local enchantUpgradeConfig = _enchantEquipIndexData.m_EnchantUpgradeConfig
  if enchantUpgradeConfig == nil or string.isNullOrEmpty(enchantUpgradeConfig.img_icon) then
    return
  end
  self.levelIconCoroutine = self:SetSprite("Atlas_Common", tostring(enchantUpgradeConfig.img_icon), self.img_LevelIcon)
end

function Equip_EnchantInlayUI:RefreshSelectEnchantEquipBagData(_eventId, _data)
  if _data == nil or _data.bagData == nil then
    return
  end
  self.bagData = _data.bagData
  self:RefreshBagSelectState()
end

function Equip_EnchantInlayUI:RefreshHoleEquip(_enchantEquipIndexData)
  if not self.holeCellData then
    self.holeCellData = ItemCellData()
  end
  local itemInfo = _enchantEquipIndexData.m_ItemInfo
  self.holeCellData:RecycleRes()
  self.btn_Hole3DItem:SetActive(false)
  self.img_Lock:SetActive(not _enchantEquipIndexData:IsUnlock())
  self.btn_Choose:SetActive(_enchantEquipIndexData:IsUnlock() and itemInfo == nil)
  if itemInfo then
    local itemData = ItemUtility.GenerateItemDataByServerData(itemInfo)
    self.holeCellData:RefreshData(itemData)
    ItemUtility.ShowItemCell(self.btn_Hole3DItem, self.holeCellData, self, true)
    self.btn_Hole3DItem:SetActive(true)
    self.btn_Choose:SetActive(false)
  end
end

function Equip_EnchantInlayUI:RefreshRedEquip()
  if not self.equipItemData then
    self.equipItemData = ItemCellData()
  end
  self.equipItemData:RecycleRes()
  self.btn_Equip3DItem:SetActive(false)
  self.lab_EquipName:SetText("")
  local equipDataTab, equipData = RoleManager.me.data.equipsData.Data
  for k, v in pairs(equipDataTab) do
    if v and v.bagGridIndex == self.equipIndex and RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.HongZhuang) then
      equipData = v
      break
    end
  end
  if equipData == nil then
    return
  end
  local equipName = equipData.tblEquip.name
  equipName = RoleEquipUtility.GetEquipNameColor(equipName, equipData)
  self.lab_EquipName:SetText(equipName)
  self.equipItemData:RefreshData(equipData)
  ItemUtility.ShowItemCell(self.btn_Equip3DItem, self.equipItemData, self, true)
  self.btn_Equip3DItem:SetActive(true)
end

function Equip_EnchantInlayUI:RefreshBag(_enchantEquipIndexData)
  self.bagData = nil
  self.btn_3DItemTemp:SetActiveTable()
  local enchantEquipBagData = gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():GetEnchantEquipBagData()
  enchantEquipBagData = EnchantEquipUtility:GetFilterEnchantEquipBagData(_enchantEquipIndexData, enchantEquipBagData)
  if enchantEquipBagData == nil or table.count(enchantEquipBagData) == 0 then
    return
  end
  local canBagData, notBagData = {}, {}
  for i, v in pairs(enchantEquipBagData) do
    if _enchantEquipIndexData:IsCanInlayAppointQuality(v.m_ItemConfig.quality) then
      table.insert(canBagData, v)
    else
      table.insert(notBagData, v)
    end
  end
  table.sort(canBagData, function(a, b)
    return a.m_ItemConfig.quality > b.m_ItemConfig.quality
  end)
  table.sort(notBagData, function(a, b)
    return a.m_ItemConfig.quality > b.m_ItemConfig.quality
  end)
  table.combine(canBagData, notBagData)
  self.btn_3DItemTemp:SetData(canBagData)
end

function Equip_EnchantInlayUI:RefreshBagSelectState()
  if self.btn_3DItemTemp == nil or self.btn_3DItemTemp.items == nil then
    return
  end
  for i, item in pairs(self.btn_3DItemTemp.items) do
    if item and item.itemTemp then
      item.itemTemp:RefreshUIView()
    end
  end
end

function Equip_EnchantInlayUI:RefreshInlayReplaceBtnRedPoint(_enchantEquipIndexData)
  local enchantEquipBagData = gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():GetEnchantEquipBagData()
  self.btn_Inlay:GetChild("img_RedPoint"):SetActive(_enchantEquipIndexData:CheckEnchantEquipIndexBagHaveBetter(enchantEquipBagData))
  self.btn_Replace:GetChild("img_RedPoint"):SetActive(_enchantEquipIndexData:CheckEnchantEquipIndexBagHaveBetter(enchantEquipBagData))
end

function Equip_EnchantInlayUI:RefreshBtnState(_enchantEquipIndexData)
  local itemInfo = _enchantEquipIndexData.m_ItemInfo
  self.btn_Inlay:SetActive(itemInfo == nil)
  self.btn_Replace:SetActive(itemInfo ~= nil)
  self.btn_Delete:SetActive(itemInfo ~= nil)
end

function Equip_EnchantInlayUI:OnHide()
end

function Equip_EnchantInlayUI:OnDestroy()
end
