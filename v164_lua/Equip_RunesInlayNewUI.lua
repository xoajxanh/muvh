Equip_RunesInlayNewUI = class(BaseUI)
Equip_RunesInlayNewUI.layer = UILayer.Panel
Equip_RunesInlayNewUI.orderInLayer = 0
Equip_RunesInlayNewUI.hideType = UIHideType.WaitDestroy
Equip_RunesInlayNewUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_RunesInlayNewUI.escClose = UIEscClose.DontClose

function Equip_RunesInlayNewUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.lb_name = self:GetControl("bg_equip/lb_name")
  self.Runes_Item = self:GetControl("bg_equip/Runes/Runes_Item")
  self.img_lock = self:GetControl("bg_equip/Runes/img_lock")
  self.img_choose = self:GetControl("bg_equip/Runes/img_choose")
  self.btn_del = self:GetControl("bg_equip/Runes/btn_del")
  self.img_redPoint = self:GetControl("bg_equip/Runes/img_redPoint")
  self.btn_3DItem = self:GetControl("bg_equip/RunesBag/sw_RunesItem/Viewport/Content/btn_3DItem")
  self.btn_Inlay = self:GetControl("bg_equip/RunesBag/btn_Inlay")
  self.text_Inlay = self:GetControl("bg_equip/RunesBag/btn_Inlay/text_Inlay")
  self.btn_runesMaster = self:GetControl("btn_runesMaster")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
  self.lb_des = self:GetControl("bg_equip/lb_des")
end

function Equip_RunesInlayNewUI:Init()
  self.tip_MaxCanInlayLevel = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Equip_RunesTips1")
end

function Equip_RunesInlayNewUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_RunesInlayNewUI:InitUI()
  self.btn_3DItemTemp = UIUtility.BindUIContainerTemp(self.btn_3DItem, LuaComponentTemplates.EquipBagNewRuneTemplate, self)
end

function Equip_RunesInlayNewUI:RegistUIEvents()
  self.Runes_Item:SetOnClick(self, self.Runes_ItemOnClick)
  self.btn_del:SetOnClick(self, self.btn_delOnClick)
  self.btn_Inlay:SetOnClick(self, self.btn_InlayOnClick)
  self.btn_runesMaster:SetOnClick(self, self.btn_runesMasterOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Equip_RunesInlayNewUI:Runes_ItemOnClick(control)
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

function Equip_RunesInlayNewUI:btn_delOnClick(control)
  if self.chooseHoleIndex == nil or self.chooseHoleRuneData == nil or self.chooseHoleRuneData.runeItem == nil then
    return
  end
  networkRequest.ReqImplantRune(self.chooseHoleIndex, 0)
end

function Equip_RunesInlayNewUI:btn_InlayOnClick(control)
  if self.chooseHoleIndex == nil then
    FloatingTipUtility.QuickMsg("H\195\163y ch\225\187\141n \195\180 tr\198\176\225\187\155c")
    return
  end
  if self.chooseHoleRuneData == nil or self.chooseHoleRuneData.level < ClientTable.cfg_Item_equip_NewRunesCellManager:GetNextCanInlayRuneLevelNeedHoleLevel(self.chooseHoleRuneData.index, 1) then
    FloatingTipUtility.QuickMsg("H\195\163y m\225\187\159 kh\195\179a \195\180 tr\198\176\225\187\155c")
    return
  end
  if self.chooseBagRuneData == nil then
    FloatingTipUtility.QuickMsg("H\195\163y ch\225\187\141n Ph\195\185 V\196\131n c\225\186\167n kh\225\186\163m")
    return
  end
  if self.chooseHoleRuneData.runeItem and self.chooseHoleRuneData.runeItem.itemId == self.chooseBagRuneData.itemId then
    FloatingTipUtility.QuickMsg("Ph\195\185 V\196\131n c\195\185ng lo\225\186\161i c\195\185ng c\225\186\165p, kh\195\180ng c\225\186\167n thay th\225\186\191")
    return
  end
  networkRequest.ReqImplantRune(self.chooseHoleIndex, self.chooseBagRuneData.id)
end

function Equip_RunesInlayNewUI:btn_runesMasterOnClick(control)
  UIManager.Show(UIID.Tip_RunesMaster)
end

function Equip_RunesInlayNewUI:descBtnOnClick(control)
  UIManager.Show(UIID.System_DescUI, {id = 1109})
end

function Equip_RunesInlayNewUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_RunesInlayNewUI)
end

function Equip_RunesInlayNewUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_RunesInlayNewUI:RegistEvents()
  self:RegistEvent(Event.ChooseNewRuneHole, self.OnChooseNewRuneHole, self)
  self:RegistEvent(Event.ChooseNewRuneBagRuneData, self.OnChooseNewRuneBagRuneData, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.Bag_ResBagChange, self)
  self:RegistEvent(Event.RefreshNewRuneHoleData, self.OnUpdateNewRuneHoleData, self)
end

function Equip_RunesInlayNewUI:OnChooseNewRuneHole()
  self.chooseBagRuneData = nil
  self:Refresh()
end

function Equip_RunesInlayNewUI:OnChooseNewRuneBagRuneData(_, chooseBagRuneData)
  self.chooseBagRuneData = chooseBagRuneData
  self:RefreshBagChooseState()
  self:RefreshBtnText()
end

function Equip_RunesInlayNewUI:Bag_ResBagChange()
  self:RefreshBag()
end

function Equip_RunesInlayNewUI:OnUpdateNewRuneHoleData(_, upgradeHoleIndex)
  if self.chooseHoleIndex == nil or upgradeHoleIndex == nil or self.chooseHoleIndex ~= upgradeHoleIndex then
    return
  end
  self:Refresh()
end

function Equip_RunesInlayNewUI:Refresh()
  self.chooseHoleIndex = QuickFind.GetNewRuneDataManager():GetCurChooseHoleIndex()
  self.chooseHoleRuneData = QuickFind.GetNewRuneDataManager():GetServerRuneDataByHoleIndex(self.chooseHoleIndex)
  self:RefreshHoleName()
  self:RefreshModel()
  self:RefreshCurCanInlayMaxRuneLevel()
  self:RefreshBag()
  self:RefreshBtnText()
end

function Equip_RunesInlayNewUI:RefreshHoleName()
  local name = self.chooseHoleIndex and string.format("\195\148 %s", self.chooseHoleIndex) or ""
  self.lb_name:SetText(name)
end

function Equip_RunesInlayNewUI:RefreshModel()
  self.btn_del:SetActive(false)
  if table.isNullOrEmpty(self.chooseHoleRuneData) or self.chooseHoleRuneData.runeItem == nil or self.chooseHoleRuneData.runeItem.itemId == nil or self.chooseHoleRuneData.runeItem.itemId == 0 then
    ItemUtility.ResetItemCell(self.Runes_Item)
    return
  end
  ItemUtility.ShowItemCellByItemId(self.chooseHoleRuneData.runeItem.itemId, 1, self.Runes_Item, self)
  self.btn_del:SetActive(true)
end

function Equip_RunesInlayNewUI:RefreshCurCanInlayMaxRuneLevel()
  if self.chooseHoleIndex == nil or self.chooseHoleRuneData == nil or self.chooseHoleRuneData.level < ClientTable.cfg_Item_equip_NewRunesCellManager:GetNextCanInlayRuneLevelNeedHoleLevel(self.chooseHoleRuneData.index, 1) then
    self.lb_des:SetText("")
    return
  end
  self.lb_des:SetActive(true)
  local curCanInlayMaxRunesLevel = ClientTable.cfg_Item_equip_NewRunesCellManager:GetCurCanInlayMaxRunesLevel(self.chooseHoleRuneData.index, self.chooseHoleRuneData.level)
  self.lb_des:SetText(string.format(self.tip_MaxCanInlayLevel, curCanInlayMaxRunesLevel))
end

function Equip_RunesInlayNewUI:RefreshBag()
  local curHoleCanInlayAllRunes = QuickFind.GetNewRuneDataManager():GetBagAllRunes()
  self.btn_3DItemTemp:SetData(curHoleCanInlayAllRunes)
  if table.isNullOrEmpty(curHoleCanInlayAllRunes) and self.chooseBagRuneData then
    self.chooseBagRuneData = nil
  end
end

function Equip_RunesInlayNewUI:RefreshBtnText()
  if self.chooseHoleIndex == nil then
    self.img_lock:SetActive(true)
    self.btn_Inlay:SetActive(false)
    return
  end
  self.img_lock:SetActive(self.chooseHoleRuneData == nil or self.chooseHoleRuneData.level < ClientTable.cfg_Item_equip_NewRunesCellManager:GetNextCanInlayRuneLevelNeedHoleLevel(self.chooseHoleRuneData.index, 1))
  self.btn_Inlay:SetActive(true)
  local text = "Kh\225\186\163m"
  if self.chooseHoleRuneData and self.chooseHoleRuneData.runeItem and self.chooseBagRuneData then
    text = "Thay th\225\186\191"
  end
  self.text_Inlay:SetText(text)
end

function Equip_RunesInlayNewUI:RefreshBagChooseState()
  local items = self.btn_3DItemTemp.items
  for i, item in pairs(items) do
    if item and item.itemTemp then
      item.itemTemp:RefreshChooseState()
    end
  end
end

function Equip_RunesInlayNewUI:OnHide()
  self.chooseHoleIndex = nil
  self.chooseHoleRuneData = nil
  self.chooseBagRuneData = nil
end
