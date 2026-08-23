Equip_EnchantUpgradeUI = class(BaseUI)
Equip_EnchantUpgradeUI.layer = UILayer.Panel
Equip_EnchantUpgradeUI.orderInLayer = 0
Equip_EnchantUpgradeUI.hideType = UIHideType.WaitDestroy
Equip_EnchantUpgradeUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_EnchantUpgradeUI.escClose = UIEscClose.DontClose

function Equip_EnchantUpgradeUI:InitControls()
  self.lab_EquipName = self:GetControl("Enchant/lab_EquipName")
  self.img_LevelIcon = self:GetControl("Enchant/Level/img_LevelIcon")
  self.lab_Level = self:GetControl("Enchant/Level/lab_Level")
  self.btn_Equip3DItem = self:GetControl("Enchant/btn_Equip3DItem")
  self.btn_Hole3DItem = self:GetControl("Enchant/hole/btn_Hole3DItem")
  self.btn_Choose = self:GetControl("Enchant/hole/btn_Choose")
  self.img_Lock = self:GetControl("Enchant/hole/img_Lock")
  self.itemAttribute = self:GetControl("enchantAttribute/attributeScrollView/Viewport/Content/itemAttribute")
  self.lab_Order = self:GetControl("enchantAttribute/lab_Order")
  self.enchantMaterial = self:GetControl("enchantMaterial")
  self.itemMaterial = self:GetControl("enchantMaterial/materialScrollView/Viewport/Content/itemMaterial")
  self.btn_Upgrade = self:GetControl("btn_Upgrade")
  self.btn_Desc = self:GetControl("btn_Desc")
  self.btn_Close = self:GetControl("btn_Close")
  self.img_MaxLevel = self:GetControl("img_MaxLevel")
end

function Equip_EnchantUpgradeUI:Init()
end

function Equip_EnchantUpgradeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnAttributeItemCreate(_control)
  _control.lab_AttributeName = UIControl(_control.transform, "lab_AttributeName")
  _control.lab_AttributeValue = UIControl(_control.transform, "lab_AttributeValue")
end

local function OnAttributeItemRefresh(_control, _index, _data, _ui)
  if _data == nil or _data.m_AttributeData == nil then
    _control:SetActive(false)
    return
  end
  _control:SetActive(true)
  local color, attributeNameTab, attributeValueTab = _data.m_IsUnlock and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[21], {}, {}
  for i, v in ipairs(_data.m_AttributeData) do
    if v.attributeName == EnchantEquipAttributeDotInAll.labUnlock then
      table.insert(attributeValueTab, string.GetColorText(v.attributeValue, color))
    else
      local formatText = EnchantEquipUtility:GetAttributeFormatText(v.attributeName)
      if not string.isNullOrEmpty(formatText) then
        local itemAttributeDes, itemAttributeName, itemAttributeValue
        if v.attributeName == EnchantEquipAttributeAll.minimumPhysBaseDmg then
          local min, max = tonumber(string.split(v.attributeValue, "#")[1]), tonumber(string.split(v.attributeValue, "#")[2])
          itemAttributeDes = string.format(formatText, min, max)
        else
          itemAttributeDes = string.format(formatText, MathUtility.FormatNum(v.attributeValue))
        end
        local itemAttributeDesTab = string.split(itemAttributeDes, " ")
        if table.count(itemAttributeDesTab) ~= 0 then
          itemAttributeName, itemAttributeValue = itemAttributeDesTab[1], itemAttributeDesTab[2]
          table.insert(attributeNameTab, itemAttributeName)
          table.insert(attributeValueTab, string.GetColorText(itemAttributeValue, color))
        end
      end
    end
  end
  _control.lab_AttributeName:SetText(table.concat(attributeNameTab, "\n"))
  _control.lab_AttributeValue:SetText(table.concat(attributeValueTab, "\n"))
  _control:SetSizeDelta(_control.transform.rect.width, table.count(attributeValueTab) * 20 + 20)
end

local function OnMaterialItemCreate(_control)
  _control.itemCtr = ItemUtility.InitItemCell(UIControl(_control.transform))
  _control.modelData = ItemCellData()
  _control.lab_Num = UIControl(_control.transform, "lab_num")
  _control.btn_Obtain = UIControl(_control.transform, "btn_obtain")
end

local function OnMaterialItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    _control:SetActive(false)
    return
  end
  _control:SetActive(true)
  local bagCount, itemData = BagInfoData.GetItemTotalCountByItemId(_data.itemId), ItemUtility.GenerateItemData(_data.itemId)
  _control.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(_control.itemCtr, _control.modelData, _ui, true)
  local numDes, color = string.format("%s/%s", bagCount, _data.count), bagCount >= _data.count and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]
  _control.lab_Num:SetText(string.GetColorText(numDes, color))
  _control.btn_Obtain.itemData = itemData
  _control.btn_Obtain:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function Equip_EnchantUpgradeUI:InitUI()
  self.attributeContainer = UIContainer(self.itemAttribute, self, OnAttributeItemCreate, OnAttributeItemRefresh)
  self.materialContainer = UIContainer(self.itemMaterial, self, OnMaterialItemCreate, OnMaterialItemRefresh)
end

function Equip_EnchantUpgradeUI:RegistUIEvents()
  self.btn_Desc:SetOnClick(self, self.btn_DescOnClick)
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
  self.btn_Upgrade:SetOnClick(self, self.btn_UpgradeOnClick)
  self.btn_Choose:SetOnClick(self, self.btn_ChooseOnClick)
end

function Equip_EnchantUpgradeUI:btn_DescOnClick()
  local config = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_EnchantUpgradeUI")
  if 0 < #config then
    UIManager.Show(UIID.System_DescUI, {
      id = config[1].id
    })
  end
end

function Equip_EnchantUpgradeUI:btn_CloseOnClick()
  UIManager.Hide(UIID.Equip_EnchantUpgradeUI)
end

function Equip_EnchantUpgradeUI:btn_UpgradeOnClick(_control)
  if self.equipIndex == nil then
    return
  end
  local enchantEquipIndexData = gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():GetEnchantEquipIndexDataByEquipIndex(self.equipIndex)
  if enchantEquipIndexData == nil then
    return
  end
  local nextEnchantEquipIndexUpgradeItemData = enchantEquipIndexData:GetNextPointGradeUpgradeData()
  if nextEnchantEquipIndexUpgradeItemData == nil then
    return
  end
  if nextEnchantEquipIndexUpgradeItemData.m_MaterialData then
    for i, v in pairs(nextEnchantEquipIndexUpgradeItemData.m_MaterialData) do
      if v and v.count and v.itemId and v.count > BagInfoData.GetItemTotalCountByItemId(v.itemId) then
        _control.itemData = ItemUtility.GenerateItemData(v.itemId)
        ItemUtility.ClickObtainItemBtn(nil, _control)
        return
      end
    end
  end
  EnchantEquipController.ReqEnchantUpgrade(self.equipIndex)
  EnchantEquipUtility:PlayEffect("Eff_UI_FMdengjitisheng", 1)
end

function Equip_EnchantUpgradeUI:btn_ChooseOnClick()
  EventManager.Dispatch(Event.EnchantEquipNavChange, {
    panelName = UIID.Equip_EnchantInlayUI,
    equipIndex = self.equipIndex
  })
end

function Equip_EnchantUpgradeUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_EnchantUpgradeUI:RegistEvents()
  self:RegistEvent(Event.RefreshSelectEnchantEquipUpgrade, self.RefreshSelectEnchantEquipUpgrade, self)
  self:RegistEvent(Event.RefreshEnchantEquipIndexChange, self.RefreshEnchantEquipUpgradeView, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshEnchantEquipUpgradeView, self)
end

function Equip_EnchantUpgradeUI:Refresh()
end

function Equip_EnchantUpgradeUI:RefreshSelectEnchantEquipUpgrade(_eventId, _data)
  self.equipIndex = nil
  if _data == nil or _data.equipIndex == nil then
    return
  end
  self.equipIndex = _data.equipIndex
  self:RefreshEnchantEquipUpgradeView()
end

function Equip_EnchantUpgradeUI:RefreshEnchantEquipUpgradeView()
  if self.equipIndex == nil then
    return
  end
  local enchantEquipIndexData = gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():GetEnchantEquipIndexDataByEquipIndex(self.equipIndex)
  if enchantEquipIndexData == nil then
    return
  end
  self:RefreshLevel(enchantEquipIndexData)
  self:RefreshRedEquip()
  self:RefreshHoleEquip(enchantEquipIndexData)
  self:RefreshAttribute(enchantEquipIndexData)
  self:RefreshMaterial(enchantEquipIndexData)
  self:RefreshUpgradeBtnRedPoint(enchantEquipIndexData)
  self:RefreshBtnState(enchantEquipIndexData)
  self:RefreshIsMaxUIState(enchantEquipIndexData)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.Bag_EquipInfoUI
  })
end

function Equip_EnchantUpgradeUI:RefreshLevel(_enchantEquipIndexData)
  self.lab_Level:SetText(string.format("T%d", _enchantEquipIndexData.m_PointId))
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

function Equip_EnchantUpgradeUI:RefreshRedEquip()
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

function Equip_EnchantUpgradeUI:RefreshHoleEquip(_enchantEquipIndexData)
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

function Equip_EnchantUpgradeUI:RefreshAttribute(_enchantEquipIndexData)
  self.lab_Order:SetText(_enchantEquipIndexData.m_EnchantUpgradeConfig.labGrade)
  self.attributeContainer:SetActiveTable()
  local currentPointIdUpgradeData = _enchantEquipIndexData:GetCurrentPageShowAttribute()
  if currentPointIdUpgradeData == nil or table.count(currentPointIdUpgradeData) == 0 then
    return
  end
  self.attributeContainer:SetData(currentPointIdUpgradeData)
end

function Equip_EnchantUpgradeUI:RefreshMaterial(_enchantEquipIndexData)
  self.enchantMaterial:SetActive(not _enchantEquipIndexData:IsMaxPointGrade())
  self.materialContainer:SetActiveTable()
  local nextEnchantEquipIndexUpgradeItemData = _enchantEquipIndexData:GetNextPointGradeUpgradeData()
  if nextEnchantEquipIndexUpgradeItemData == nil then
    return
  end
  self.materialContainer:SetData(nextEnchantEquipIndexUpgradeItemData.m_MaterialData)
end

function Equip_EnchantUpgradeUI:RefreshUpgradeBtnRedPoint(_enchantEquipIndexData)
  self.btn_Upgrade:GetChild("img_RedPoint"):SetActive(_enchantEquipIndexData:CheckEnchantEquipIndexCanUpgrade())
end

function Equip_EnchantUpgradeUI:RefreshBtnState(_enchantEquipIndexData)
  self.btn_Upgrade:GetChild("text_Upgrade"):SetText(_enchantEquipIndexData:IsInThroughState() and "\196\144\225\187\153t ph\195\161" or "C\198\176\225\187\157ng h\195\179a")
end

function Equip_EnchantUpgradeUI:RefreshIsMaxUIState(_enchantEquipIndexData)
  self.img_MaxLevel:SetActive(_enchantEquipIndexData:IsMaxPointGrade())
  self.btn_Upgrade:SetActive(not _enchantEquipIndexData:IsMaxPointGrade())
end

function Equip_EnchantUpgradeUI:OnHide()
end

function Equip_EnchantUpgradeUI:OnDestroy()
end
