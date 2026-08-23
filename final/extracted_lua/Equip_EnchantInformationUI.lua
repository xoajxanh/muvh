Equip_EnchantInformationUI = class(BaseUI)
Equip_EnchantInformationUI.layer = UILayer.Panel
Equip_EnchantInformationUI.orderInLayer = 0
Equip_EnchantInformationUI.hideType = UIHideType.WaitDestroy
Equip_EnchantInformationUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_EnchantInformationUI.escClose = UIEscClose.DontClose

function Equip_EnchantInformationUI:InitControls()
  self.totalAttributeScrollView = self:GetControl("totalAttributeScrollView")
  self.totalAttributeItem = self:GetControl("totalAttributeScrollView/Viewport/Content/totalAttributeItem")
  self.enchant = self:GetControl("Enchant")
  self.lab_EquipName = self:GetControl("Enchant/lab_EquipName")
  self.img_LevelIcon = self:GetControl("Enchant/Level/img_LevelIcon")
  self.lab_Level = self:GetControl("Enchant/Level/lab_Level")
  self.btn_Equip3DItem = self:GetControl("Enchant/btn_Equip3DItem")
  self.btn_Hole3DItem = self:GetControl("Enchant/hole/btn_Hole3DItem")
  self.btn_Choose = self:GetControl("Enchant/hole/btn_Choose")
  self.img_Lock = self:GetControl("Enchant/hole/img_Lock")
  self.partAttributeScrollView = self:GetControl("partAttributeScrollView")
  self.lab_PartName = self:GetControl("partAttributeScrollView/lab_PartName")
  self.lab_PartLevel = self:GetControl("partAttributeScrollView/lab_PartLevel")
  self.partAttributeItem = self:GetControl("partAttributeScrollView/Viewport/Content/partAttributeItem")
  self.btn_Desc = self:GetControl("btn_Desc")
  self.btn_Close = self:GetControl("btn_Close")
  self.btn_UpAttribute = self:GetControl("btn_UpAttribute")
end

function Equip_EnchantInformationUI:Init()
end

function Equip_EnchantInformationUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnAttributeItemCreate(_control)
  _control.lab_AttributeName = UIControl(_control.transform, "lab_AttributeName")
  _control.lab_AttributeValue = UIControl(_control.transform, "lab_AttributeValue")
end

local function OnAttributeItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  local itemAttributeDesTab = string.split(_data, " ")
  if table.count(itemAttributeDesTab) == 0 then
    return
  end
  _control:SetActive(true)
  _control.lab_AttributeName:SetText(itemAttributeDesTab[1])
  _control.lab_AttributeValue:SetText(itemAttributeDesTab[2])
end

function Equip_EnchantInformationUI:InitUI()
  self.totalAttributeContainer = UIContainer(self.totalAttributeItem, self, OnAttributeItemCreate, OnAttributeItemRefresh)
  self.partAttributeContainer = UIContainer(self.partAttributeItem, self, OnAttributeItemCreate, OnAttributeItemRefresh)
end

function Equip_EnchantInformationUI:RegistUIEvents()
  self.btn_Desc:SetOnClick(self, self.btn_DescOnClick)
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
  self.btn_UpAttribute:SetOnClick(self, self.btn_UpAttributeOnClick)
  self.btn_Choose:SetOnClick(self, self.btn_ChooseOnClick)
end

function Equip_EnchantInformationUI:btn_DescOnClick()
  local config = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_EnchantInformationUI")
  if 0 < #config then
    UIManager.Show(UIID.System_DescUI, {
      id = config[1].id
    })
  end
end

function Equip_EnchantInformationUI:btn_CloseOnClick()
  UIManager.Hide(UIID.Equip_EnchantInformationUI)
end

function Equip_EnchantInformationUI:btn_UpAttributeOnClick()
  if self.equipIndex == nil then
    return
  end
  EventManager.Dispatch(Event.EnchantEquipNavChange, {
    panelName = UIID.Equip_EnchantUpgradeUI,
    equipIndex = self.equipIndex
  })
end

function Equip_EnchantInformationUI:btn_ChooseOnClick()
  EventManager.Dispatch(Event.EnchantEquipNavChange, {
    panelName = UIID.Equip_EnchantInlayUI,
    equipIndex = self.equipIndex
  })
end

function Equip_EnchantInformationUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_EnchantInformationUI:RegistEvents()
  self:RegistEvent(Event.RefreshSelectEnchantEquipInformation, self.RefreshSelectEnchantEquipInformation, self)
end

function Equip_EnchantInformationUI:Refresh()
  self:RefreshTotalAttribute()
  self.enchant:SetActive(false)
  self.partAttributeScrollView:SetActive(false)
  self.btn_UpAttribute:SetActive(false)
end

function Equip_EnchantInformationUI:RefreshTotalAttribute()
  self.totalAttributeScrollView:SetActive(true)
  self.totalAttributeContainer:SetActiveTable()
  local enchantEquipIndexData = gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager().m_EnchantEquipIndexData
  local totalAttribute = EnchantEquipUtility:GetAppointEquipIndexAllAttributeDes(enchantEquipIndexData)
  if totalAttribute == nil or table.count(totalAttribute) == 0 then
    return
  end
  self.totalAttributeContainer:SetData(totalAttribute)
end

function Equip_EnchantInformationUI:RefreshSelectEnchantEquipInformation(_eventId, _data)
  self.equipIndex = nil
  if _data == nil or _data.equipIndex == nil then
    return
  end
  self.equipIndex = _data.equipIndex
  self:RefreshEnchantEquipInformationView()
end

function Equip_EnchantInformationUI:RefreshEnchantEquipInformationView()
  if self.equipIndex == nil then
    return
  end
  local enchantEquipIndexData = gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():GetEnchantEquipIndexDataByEquipIndex(self.equipIndex)
  if enchantEquipIndexData == nil then
    return
  end
  self.totalAttributeScrollView:SetActive(false)
  self.enchant:SetActive(true)
  self.partAttributeScrollView:SetActive(true)
  self:RefreshLevel(enchantEquipIndexData)
  self:RefreshRedEquip()
  self:RefreshHoleEquip(enchantEquipIndexData)
  self:RefreshPartNameAndLevel(enchantEquipIndexData)
  self:RefreshPartAttribute(enchantEquipIndexData)
  self:RefreshBtnState(enchantEquipIndexData)
end

function Equip_EnchantInformationUI:RefreshLevel(_enchantEquipIndexData)
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

function Equip_EnchantInformationUI:RefreshRedEquip()
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

function Equip_EnchantInformationUI:RefreshHoleEquip(_enchantEquipIndexData)
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

function Equip_EnchantInformationUI:RefreshPartNameAndLevel(_enchantEquipIndexData)
  self.lab_PartName:SetText("")
  self.lab_PartLevel:SetText(_enchantEquipIndexData.m_EnchantUpgradeConfig.labGrade)
  local equipIndex, effect = _enchantEquipIndexData.m_EquipIndex, GlobalConfig.GetGlobalConfig(65001002)
  if string.isNullOrEmpty(effect) then
    return
  end
  for i, v in pairs(string.split(effect, "&")) do
    if v and tonumber(string.split(v, "#")[1]) == equipIndex then
      self.lab_PartName:SetText(string.split(v, "#")[2])
      break
    end
  end
end

function Equip_EnchantInformationUI:RefreshPartAttribute(_enchantEquipIndexData)
  self.partAttributeContainer:SetActiveTable()
  local totalAttribute = EnchantEquipUtility:GetAppointEquipIndexAllAttributeDes({
    [1] = _enchantEquipIndexData
  })
  if totalAttribute == nil or table.count(totalAttribute) == 0 then
    return
  end
  self.partAttributeContainer:SetData(totalAttribute)
end

function Equip_EnchantInformationUI:RefreshBtnState(_enchantEquipIndexData)
  self.btn_UpAttribute:SetActive(not _enchantEquipIndexData:IsMaxPointGrade())
end

function Equip_EnchantInformationUI:OnHide()
end

function Equip_EnchantInformationUI:OnDestroy()
end
