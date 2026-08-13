Equip_RunesUpgradeNewUI = class(BaseUI)
Equip_RunesUpgradeNewUI.layer = UILayer.Panel
Equip_RunesUpgradeNewUI.orderInLayer = 0
Equip_RunesUpgradeNewUI.hideType = UIHideType.WaitDestroy
Equip_RunesUpgradeNewUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_RunesUpgradeNewUI.escClose = UIEscClose.DontClose

function Equip_RunesUpgradeNewUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.lb_name = self:GetControl("bg_equip/lb_name")
  self.Runes_Item = self:GetControl("bg_equip/Runes/Runes_Item")
  self.img_lock = self:GetControl("bg_equip/Runes/img_lock")
  self.img_choose = self:GetControl("bg_equip/Runes/img_choose")
  self.img_redPoint = self:GetControl("bg_equip/Runes/img_redPoint")
  self.RunesAttribute = self:GetControl("bg_equip/RunesIntensify/RunesAttribute")
  self.lab = self:GetControl("bg_equip/RunesIntensify/RunesAttribute/sw_attributegrow/img_titleico/content/lab")
  self.needMaterial = self:GetControl("bg_equip/RunesIntensify/needMaterial")
  self.frame_item = self:GetControl("bg_equip/RunesIntensify/needMaterial/materialParent/frame_item")
  self.btn_intensify = self:GetControl("bg_equip/RunesIntensify/btn_intensify")
  self.text_Inlay = self:GetControl("bg_equip/RunesIntensify/btn_intensify/text_Inlay")
  self.img_intensifylevel = self:GetControl("bg_equip/img_equipbg/img_intensifylevel")
  self.btn_runesMaster = self:GetControl("btn_runesMaster")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
  self.lb_des = self:GetControl("bg_equip/lb_des")
  self.Maxlevel = self:GetControl("bg_equip/RunesIntensify/Maxlevel")
end

function Equip_RunesUpgradeNewUI:Init()
  self.tip_UnLockInlay = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Equip_RunesTips2")
  self.tip_AddInlayLevel = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Equip_RunesTips3")
end

function Equip_RunesUpgradeNewUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_RunesUpgradeNewUI:InitUI()
  self.attributesTemplate = UIUtility.BindUIContainerTemp(self.lab, LuaComponentTemplates.AttributeUnitTemplate, self)
  self.costItemsTemplate = UIUtility.BindUIContainerTemp(self.frame_item, LuaComponentTemplates.ConsumableUnitTemplate, self)
end

function Equip_RunesUpgradeNewUI:RegistUIEvents()
  self.Runes_Item:SetOnClick(self, self.Runes_ItemOnClick)
  self.btn_intensify:SetOnClick(self, self.btn_intensifyOnClick)
  self.btn_runesMaster:SetOnClick(self, self.btn_runesMasterOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Equip_RunesUpgradeNewUI:Runes_ItemOnClick(control)
  if table.isNullOrEmpty(self.chooseHoleRuneData) or self.chooseHoleRuneData.runeItem == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemDataByServerData(self.chooseHoleRuneData.runeItem)
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control
  })
end

function Equip_RunesUpgradeNewUI:btn_intensifyOnClick(control)
  if self.chooseHoleIndex == nil then
    return
  end
  local costItemList = QuickFind.GetNewRuneDataManager():GetHoleCostList(self.chooseHoleIndex, self.chooseHoleRuneData and self.chooseHoleRuneData.level or 0)
  if ItemUtility:IsMeetCost(costItemList) == false then
    FloatingTipUtility.QuickMsg("Nguy\195\170n li\225\187\135u kh\195\180ng \196\145\225\187\167")
    return
  end
  local type = NewRuneHoleUpgradeTypeEnum.Upgrade
  if self.chooseHoleRuneData and self.chooseHoleRuneData.level == 0 or self.chooseHoleRuneData == nil then
    type = NewRuneHoleUpgradeTypeEnum.Unlock
  end
  networkRequest.ReqRuneUp(self.chooseHoleIndex, type)
end

function Equip_RunesUpgradeNewUI:btn_runesMasterOnClick(control)
  UIManager.Show(UIID.Tip_RunesMaster)
end

function Equip_RunesUpgradeNewUI:descBtnOnClick(control)
  UIManager.Show(UIID.System_DescUI, {id = 1108})
end

function Equip_RunesUpgradeNewUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_RunesUpgradeNewUI)
end

function Equip_RunesUpgradeNewUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_RunesUpgradeNewUI:RegistEvents()
  self:RegistEvent(Event.ChooseNewRuneHole, self.OnChooseNewRuneHole, self)
  self:RegistEvent(Event.RefreshNewRuneHoleData, self.OnUpdateNewRuneHoleData, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.Bag_ResBagChange, self)
end

function Equip_RunesUpgradeNewUI:OnChooseNewRuneHole()
  self:Refresh()
end

function Equip_RunesUpgradeNewUI:OnUpdateNewRuneHoleData(_, upgradeHoleIndex)
  if self.chooseHoleIndex == nil or upgradeHoleIndex == nil or self.chooseHoleIndex ~= upgradeHoleIndex then
    return
  end
  if UIManager.IsVisible(UIID.EffectTipUI) then
    EventManager.Dispatch(Event.TipEffect, {
      name = "Eff_UI_fuwenshengjichenggong",
      effectTime = 1
    })
  else
    UIManager.Show(UIID.EffectTipUI, {
      name = "Eff_UI_fuwenshengjichenggong",
      effectTime = 1
    })
  end
  self:Refresh()
end

function Equip_RunesUpgradeNewUI:Bag_ResBagChange()
  self:RefreshHoleCost()
end

function Equip_RunesUpgradeNewUI:Refresh()
  self.chooseHoleIndex = QuickFind.GetNewRuneDataManager():GetCurChooseHoleIndex()
  self.chooseHoleRuneData = QuickFind.GetNewRuneDataManager():GetServerRuneDataByHoleIndex(self.chooseHoleIndex)
  self:RefreshHoleName()
  self:RefreshModel()
  self:RefreshHoleAttribute()
  self:RefreshHoleCost()
  self:RefreshLockState()
  self:RefreshHoleLevel()
  self:RefreshUpgradeTip()
  self:RefreshMaxLevelState()
end

function Equip_RunesUpgradeNewUI:RefreshHoleName()
  local name = self.chooseHoleIndex and string.format("\195\148 %s", self.chooseHoleIndex) or ""
  self.lb_name:SetText(name)
end

function Equip_RunesUpgradeNewUI:RefreshModel()
  if table.isNullOrEmpty(self.chooseHoleRuneData) or self.chooseHoleRuneData.runeItem == nil or self.chooseHoleRuneData.runeItem.itemId == nil or self.chooseHoleRuneData.runeItem.itemId == 0 then
    ItemUtility.ResetItemCell(self.Runes_Item)
    return
  end
  ItemUtility.ShowItemCellByItemId(self.chooseHoleRuneData.runeItem.itemId, 1, self.Runes_Item, self)
end

function Equip_RunesUpgradeNewUI:RefreshHoleAttribute()
  local attributeList = self.chooseHoleIndex and QuickFind.GetNewRuneDataManager():GetHoleAttributeList(self.chooseHoleIndex, self.chooseHoleRuneData and self.chooseHoleRuneData.level or 0) or {}
  self.attributesTemplate:SetData(attributeList)
  self.RunesAttribute:SetActive(not table.isNullOrEmpty(attributeList))
end

function Equip_RunesUpgradeNewUI:RefreshHoleCost()
  local costItemList = self.chooseHoleIndex and QuickFind.GetNewRuneDataManager():GetHoleCostList(self.chooseHoleIndex, self.chooseHoleRuneData and self.chooseHoleRuneData.level or 0) or {}
  self.costItemsTemplate:SetData(costItemList)
end

function Equip_RunesUpgradeNewUI:RefreshLockState()
  if self.chooseHoleIndex == nil then
    self.img_lock:SetActive(false)
    return
  end
  local curHoleIndexUnLockNeedLevel = ClientTable.cfg_Item_equip_NewRunesCellManager:GetNextCanInlayRuneLevelNeedHoleLevel(self.chooseHoleIndex, 1)
  if self.chooseHoleRuneData == nil or curHoleIndexUnLockNeedLevel > self.chooseHoleRuneData.level then
    self.img_lock:SetActive(true)
  else
    self.img_lock:SetActive(false)
  end
end

function Equip_RunesUpgradeNewUI:RefreshHoleLevel()
  if self.chooseHoleIndex == nil then
    return
  end
  local holeLevel = self.chooseHoleRuneData and self.chooseHoleRuneData.level or 0
  self.img_intensifylevel:SetText(holeLevel)
end

function Equip_RunesUpgradeNewUI:RefreshUpgradeTip()
  if self.chooseHoleIndex == nil then
    self.lb_des:SetText("")
    return
  end
  self.lb_des:SetActive(true)
  local curHoleIndexUnLockNeedLevel = ClientTable.cfg_Item_equip_NewRunesCellManager:GetNextCanInlayRuneLevelNeedHoleLevel(self.chooseHoleIndex, 1)
  if self.chooseHoleRuneData == nil or curHoleIndexUnLockNeedLevel > self.chooseHoleRuneData.level then
    self.lb_des:SetText(string.format(self.tip_UnLockInlay, curHoleIndexUnLockNeedLevel))
  else
    local curCanInlayMaxRunesLevel = ClientTable.cfg_Item_equip_NewRunesCellManager:GetCurCanInlayMaxRunesLevel(self.chooseHoleRuneData.index, self.chooseHoleRuneData.level)
    local curHoleIndexUnLockNeedLevel = ClientTable.cfg_Item_equip_NewRunesCellManager:GetNextCanInlayRuneLevelNeedHoleLevel(self.chooseHoleIndex, curCanInlayMaxRunesLevel + 1)
    self.lb_des:SetText(string.format(self.tip_AddInlayLevel, curHoleIndexUnLockNeedLevel))
  end
end

function Equip_RunesUpgradeNewUI:RefreshMaxLevelState()
  if self.chooseHoleIndex == nil then
    return
  end
  local curHoleLevel = self.chooseHoleRuneData and self.chooseHoleRuneData.level or 0
  local maxHoleLevel = ClientTable.cfg_Item_equip_NewRunesCellManager:GetHoleMaxLevel(self.chooseHoleIndex)
  local isMaxLevel = curHoleLevel >= maxHoleLevel
  self.needMaterial:SetActive(not isMaxLevel)
  self.btn_intensify:SetActive(not isMaxLevel)
  self.Maxlevel:SetActive(isMaxLevel)
  self.lb_des:SetActive(not isMaxLevel)
end

function Equip_RunesUpgradeNewUI:OnHide()
  self.chooseHoleIndex = nil
  self.chooseHoleRuneData = nil
end
