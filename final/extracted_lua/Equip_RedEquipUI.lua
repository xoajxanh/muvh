Equip_RedEquipUI = class(BaseUI)
Equip_RedEquipUI.layer = UILayer.Panel
Equip_RedEquipUI.orderInLayer = 0
Equip_RedEquipUI.hideType = UIHideType.WaitDestroy
Equip_RedEquipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_RedEquipUI.escClose = UIEscClose.DontClose

function Equip_RedEquipUI:InitControls()
  self.btn_3DItem = self:GetControl("bg_equip/btn_3DItem")
  self.basicAttr = self:GetControl("bg_equip/normalAttribute/Attribute_info1/img_titleico/lab_attributegrow/basicAttr")
  self.excellAttr = self:GetControl("bg_equip/specialAttribute/Attribute_info2/img_titleico/lab_attributegrow/excellAttr")
  self.needMaterial = self:GetControl("bg_equip/needMaterial")
  self.frame_item = self:GetControl("bg_equip/needMaterial/materialParent/frame_item")
  self.btn_LvUp = self:GetControl("bg_equip/btn_LvUp")
  self.text_LvUp = self:GetControl("bg_equip/btn_LvUp/text_LvUp")
  self.img_Signetlevel = self:GetControl("bg_equip/LevelUp/img_Signetlevel")
  self.img_Signetlevelnext = self:GetControl("bg_equip/LevelUp/img_Signetlevelnext")
  self.img_attributeArrow = self:GetControl("bg_equip/LevelUp/img_attributeArrow")
  self.SubPanelRoot = self:GetControl("SubPanelRoot")
  self.lab_item = self:GetControl("bg_item/lab_item")
  self.Img_maxlevel = self:GetControl("Img_maxlevel")
  self.Img_needlevel = self:GetControl("Img_needlevel")
  self.lab_needlevel = self:GetControl("Img_needlevel/lab_needlevel")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
end

function Equip_RedEquipUI:Init()
end

function Equip_RedEquipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_RedEquipUI:InitUI()
  self:InitParam()
  self:InitContainer()
end

function Equip_RedEquipUI:RegistUIEvents()
  self.btn_LvUp:SetOnClick(self, self.btn_LvUpOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Equip_RedEquipUI:btn_LvUpOnClick(control)
  if RoleEquipUtility.CheckRedEquipCanUpGrade() == false then
    return
  end
  if self.curEquipIndex == nil or self.curEquipIndex == 0 then
    return
  end
  if self.redEquipIndexData == nil then
    return
  end
  if self.UpgradeStateCode == ERedEquipUpgradeCode.NotMeetConsumable then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Equip_RedEquip_Resources"))
    return
  end
  if self.UpgradeStateCode ~= nil and 0 < self.UpgradeStateCode then
    networkRequest.ReqRedEquipUpRank(self.curEquipIndex, self.redEquipIndexData.lid, self.redEquipIndexData.redId)
  end
end

function Equip_RedEquipUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_RedEquipUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Equip_RedEquipUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_RedEquipUI)
end

function Equip_RedEquipUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  EquipeInfoData.curView = UIID.Equip_RedEquipUI
  if self:GetRedEquipLevelMgr() then
    EventManager.Dispatch(Event.RedEquipUIChange, self:GetRedEquipLevelMgr():GetSelectIndex())
    EventManager.Dispatch(Event.RedEquipIndexInitalize, nil)
  end
end

function Equip_RedEquipUI:RegistEvents()
  self:RegistEvent(Event.SelectedRedEquip, self.SelectedRedEquipCallBack, self)
  self:RegistEvent(Event.RedEquipUpgradeInfoChanged, self.RedEquipUpgradeInfoChangedCallBack, self)
end

function Equip_RedEquipUI:SelectedRedEquipCallBack(msgId, data)
  if data == nil then
    return
  end
  if self.curEquipIndex ~= nil and data.modelIndex == self.curEquipIndex - 3500 then
    return
  end
  self.curEquipIndex = 3500 + data.modelIndex
  self:Refresh()
end

function Equip_RedEquipUI:RedEquipUpgradeInfoChangedCallBack(msgId, data)
  if data == nil or data.index ~= self.curEquipIndex then
    return
  end
  self:Refresh()
end

function Equip_RedEquipUI:Refresh()
  self:RefreshData()
  self:RefreshView()
end

function Equip_RedEquipUI:OnHide()
  EquipeInfoData.curView = nil
  self.curEquipIndex = nil
end

function Equip_RedEquipUI:OnDestroy()
  if EquipeInfoData.curView == UIID.Equip_RedEquipUI then
    EquipeInfoData.curView = nil
  end
end

function Equip_RedEquipUI:GetRedEquipLevelMgr()
  if gameMgr:GetAvatarManager() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetRedEquipLevelDataMgr()
  end
  return nil
end

function Equip_RedEquipUI:InitParam()
  self.curEquipIndex = 0
  self.redEquipLevelData = nil
  self.redEquipIndexData = nil
  self.attributeInfo = nil
  self.go_modelData = ItemCellData()
  self.levelPos = {
    [true] = {x = 29, y = 2},
    [false] = {x = -7, y = 2}
  }
end

function Equip_RedEquipUI:InitContainer()
  self.basicAttContainer = UIUtility.BindUIContainerTemp(self.basicAttr, LuaComponentTemplates.AttributeUnitTemplate, self)
  self.excellAttContainer = UIUtility.BindUIContainerTemp(self.excellAttr, LuaComponentTemplates.AttributeUnitTemplate, self)
  self.consumableContainer = UIUtility.BindUIContainerTemp(self.frame_item, LuaComponentTemplates.ConsumableUnitTemplate, self)
end

function Equip_RedEquipUI:RefreshData()
  if self:GetRedEquipLevelMgr() == nil then
    return
  end
  if self.curEquipIndex == 0 or self.curEquipIndex == nil then
    self.curEquipIndex = self:GetRedEquipLevelMgr():GetFirstIndex()
  end
  self.redEquipIndexData = self:GetRedEquipLevelMgr():GetRedEquipIndexData(self.curEquipIndex)
  if self.redEquipIndexData == nil then
    return
  end
  self.redEquipLevelData = self:GetRedEquipLevelMgr():GetRedEquipLevelDataByRedId(self.redEquipIndexData.redId)
  self.UpgradeStateCode = self:GetRedEquipLevelMgr():GetUpgradeStateCodeByIndex(self.curEquipIndex)
  if self.redEquipLevelData == nil then
    return
  end
  self.attributeInfo = self:GetRedEquipLevelMgr():GetEquipAttributeInfo(self.redEquipLevelData.redId)
  self.isMax = self.redEquipLevelData.isMax
  self.isHideBtn = self.isMax or self.UpgradeStateCode == ERedEquipUpgradeCode.NotMeetCondition
end

function Equip_RedEquipUI:RefreshView()
  self:RefreshTopView()
  self:RefreshBasicAttributeView()
  self:RefreshExcellAttributeView()
  self:RefreshConsumableView()
  self:RefreshBtnView()
end

function Equip_RedEquipUI:RefreshTopView()
  if self.redEquipLevelData == nil then
    return
  end
  self.lab_item:SetText(self.redEquipLevelData.name)
  self.img_Signetlevel:SetText(self.redEquipLevelData.level)
  self.img_Signetlevelnext:SetText(self.redEquipLevelData.level + 1)
  self.img_Signetlevel:SetAnchoredPosition(self.levelPos[self.isMax].x, self.levelPos[self.isMax].y)
  self.img_Signetlevelnext:SetActive(not self.isMax)
  self.img_attributeArrow:SetActive(not self.isMax)
  self:RefreshModelView()
end

function Equip_RedEquipUI:RefreshModelView()
  local itemId = self.redEquipLevelData.nextItemId or self.redEquipLevelData.curItemId
  local itemData = ItemUtility.GenerateItemData(itemId)
  self.go_modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.go_modelData, self, false)
end

function Equip_RedEquipUI:RefreshBasicAttributeView()
  if self.attributeInfo then
    self.basicAttContainer:SetData(self.attributeInfo.basic)
  else
    self.basicAttContainer:SetData({})
  end
end

function Equip_RedEquipUI:RefreshExcellAttributeView()
  if self.attributeInfo then
    self.excellAttContainer:SetData(self.attributeInfo.excellence)
  else
    self.excellAttContainer:SetData({})
  end
end

function Equip_RedEquipUI:RefreshConsumableView()
  if self.redEquipLevelData and self.redEquipLevelData.consumable and not self.isHideBtn then
    self.consumableContainer:SetData(self.redEquipLevelData.consumable)
  else
    self.consumableContainer:SetData({})
  end
  self.needMaterial:SetActive(not self.isHideBtn)
end

function Equip_RedEquipUI:RefreshBtnView()
  self.btn_LvUp:SetActive(not self.isHideBtn)
  self.Img_maxlevel:SetActive(self.isMax)
  self.Img_needlevel:SetActive(self.UpgradeStateCode == ERedEquipUpgradeCode.NotMeetCondition)
  self.lab_needlevel:SetText(self.redEquipLevelData ~= nil and self.redEquipLevelData.limitLevelStr .. "A" or "")
end
