Zhuanzhi_EquipUI = class(BaseUI)
Zhuanzhi_EquipUI.layer = UILayer.Panel
Zhuanzhi_EquipUI.orderInLayer = 3
Zhuanzhi_EquipUI.hideType = UIHideType.WaitDestroy
Zhuanzhi_EquipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Zhuanzhi_EquipUI.escClose = UIEscClose.DontClose

function Zhuanzhi_EquipUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.txtTitle = self:GetControl("img_Bg/txtTitle")
  self.transfer_equipInfo = self:GetControl("img_Bg/transfer_equipInfo")
  self.btn_3DItem_old = self:GetControl("img_Bg/transfer_equipInfo/grid_group/oldEquip/btn_3DItem_old")
  self.add_wing = self:GetControl("img_Bg/transfer_equipInfo/grid_group/oldEquip/btn_3DItem_old/add_wing")
  self.btnInput = self:GetControl("img_Bg/transfer_equipInfo/grid_group/oldEquip/btnInput")
  self.equip_group = self:GetControl("img_Bg/transfer_equipInfo/grid_group/equip_group")
  self.btn_3DItem_new = self:GetControl("img_Bg/transfer_equipInfo/grid_group/equip_group/btn_3DItem_new")
  self.questionMark1 = self:GetControl("img_Bg/transfer_equipInfo/grid_group/equip_group/questionMark1")
  self.imSelect1 = self:GetControl("img_Bg/transfer_equipInfo/grid_group/equip_group/imSelect1")
  self.imgHuo = self:GetControl("img_Bg/transfer_equipInfo/grid_group/imgHuo")
  self.equip_group2 = self:GetControl("img_Bg/transfer_equipInfo/grid_group/equip_group2")
  self.btn_3DItem_new2 = self:GetControl("img_Bg/transfer_equipInfo/grid_group/equip_group2/btn_3DItem_new2")
  self.questionMark2 = self:GetControl("img_Bg/transfer_equipInfo/grid_group/equip_group2/questionMark2")
  self.imSelect2 = self:GetControl("img_Bg/transfer_equipInfo/grid_group/equip_group2/imSelect2")
  self.btnTwoEquip = self:GetControl("img_Bg/transfer_equipInfo/btnTwoEquip")
  self.lab_needStone = self:GetControl("img_Bg/lab_wingStone/img_frame/lab_needStone")
  self.img_itemicon = self:GetControl("img_Bg/lab_wingStone/img_itemicon")
  self.equipTip = self:GetControl("img_Bg/equipTip")
  self.btn_levelUp = self:GetControl("img_Bg/btn_levelUp")
  self.txt = self:GetControl("img_Bg/btn_levelUp/txt")
  self.go_costEquip = self:GetControl("img_Bg/go_costEquip")
  self.btn_closeCostEquipe = self:GetControl("img_Bg/go_costEquip/btn_closeCostEquipe")
  self.sw_costEquip = self:GetControl("img_Bg/go_costEquip/img_smallBg/sw_costEquip")
  self.btn_3DItem = self:GetControl("img_Bg/go_costEquip/img_smallBg/sw_costEquip/Viewport/Content/btn_3DItem")
  self.btn_select = self:GetControl("img_Bg/go_costEquip/img_smallBg/btn_select")
  self.lab_equipdemand = self:GetControl("img_Bg/go_costEquip/img_smallBg/Text/lab_equipdemand")
  self.btn_close = self:GetControl("img_Bg/btn_close")
  self.imName1 = self:GetControl("img_Bg/transfer_equipInfo/grid_group/equip_group/imName")
  self.imName2 = self:GetControl("img_Bg/transfer_equipInfo/grid_group/equip_group2/imName")
end

function Zhuanzhi_EquipUI:Init()
end

function Zhuanzhi_EquipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Zhuanzhi_EquipUI:InitUI()
  self:RefreshCostEquipTitle()
  self.btn_3DItem_new.index = 1
  self.btn_3DItem_new2.index = 2
  self.btn_3DItem_old.itemCellData = ItemCellData()
  self.btn_3DItem_new.itemCellData = ItemCellData()
  self.btn_3DItem_new2.itemCellData = ItemCellData()
  self.img_itemicon.itemCellData = ItemCellData()
  self.equipGroupList = {}
  local equipGroup = {
    group = nil,
    btnItem = self.btn_3DItem_new,
    questionMark = self.questionMark1,
    huo = nil
  }
  table.insert(self.equipGroupList, equipGroup)
  equipGroup = {
    group = self.equip_group2,
    btnItem = self.btn_3DItem_new2,
    questionMark = self.questionMark2,
    huo = self.imgHuo
  }
  table.insert(self.equipGroupList, equipGroup)
  self.imSelectList = {}
  table.insert(self.imSelectList, self.imSelect1)
  table.insert(self.imSelectList, self.imSelect2)
  self.imNameList = {}
  table.insert(self.imNameList, self.imName1)
  table.insert(self.imNameList, self.imName2)
  self.btn_3DItemContainer = UIContainer(self.btn_3DItem, self, self.OnEquipItemCreate, self.OnEquipItemRefresh)
end

function Zhuanzhi_EquipUI.OnEquipItemCreate(ctr)
  ctr.itemCellData = ItemCellData()
end

function Zhuanzhi_EquipUI.OnEquipItemRefresh(ctr, index, data, ui)
  ctr.itemCellData = ctr.itemCellData or ItemCellData()
  ctr.itemCellData:RefreshData(data)
  if index == ui:GetTransferStoneMgr():GetSelectIndex() then
    ctr.itemCellData.selected = true
  else
    ctr.itemCellData.selected = false
  end
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, false)
  ctr.index = index
  ctr:SetOnClick(ui, ui.btn_3DItemOnClick)
end

function Zhuanzhi_EquipUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_3DItem_old:SetOnClick(self, self.btnInputOnClick)
  self.btnInput:SetOnClick(self, self.btnInputOnClick)
  self.btnTwoEquip:SetOnClick(self, self.btnTwoEquipOnClick)
  self.btn_levelUp:SetOnClick(self, self.btn_levelUpOnClick)
  self.btn_closeCostEquipe:SetOnClick(self, self.btn_closeCostEquipeOnClick)
  self.btn_select:SetOnClick(self, self.btn_selectOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Zhuanzhi_EquipUI:btnInputOnClick(control)
  local costEquipDataList = self:GetTransferStoneMgr():GetCanTransferEquipDataList()
  if table.count(costEquipDataList) > 0 then
    self.go_costEquip:SetActive(true)
    self.btn_3DItemContainer:SetData(costEquipDataList)
  else
    if self.tipCount == nil then
      self.tipCount = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Career_transfer_2")
      if self.tipCount == nil then
        logError("Kh\195\180ng c\195\179 id: Career_transfer_2 trong b\225\186\163ng Ui_word")
        self.tipCount = ""
      end
    end
    FloatingTipUtility.QuickMsg(self.tipCount)
  end
end

function Zhuanzhi_EquipUI:btn_3DItem_newSelectOnClick(control)
  local showEquipData = self:GetTransferStoneMgr():GetSelectEquipData()
  local changIndex = self:GetTransferStoneMgr():GetChangeIndex()
  if changIndex == control.index then
    local itemId = self:GetTransferStoneMgr():GetChangeEquipItemIdList()[control.index]
    local itemData = ItemUtility:GetItemDataByOldItem(itemId, showEquipData)
    UIManager.Show(UIID.ItemTipUI, {
      item = itemData,
      rightOperate = EItemOperateType.Show,
      ctrl = control
    })
  else
    self:GetTransferStoneMgr():SetChangeIndex(control.index)
    self:RefreshEquipGroup()
  end
end

function Zhuanzhi_EquipUI:btnTwoEquipOnClick(control)
end

function Zhuanzhi_EquipUI:btn_levelUpOnClick(control)
  local reqTbl = self:GetTransferStoneMgr():GetReqTbl()
  if reqTbl then
    NetManager.Send(EquipMessage.ReqTransferEquipCareer, reqTbl)
    UIManager.Hide(UIID.Zhuanzhi_EquipUI)
  else
  end
end

function Zhuanzhi_EquipUI:btn_closeCostEquipeOnClick(control)
  self:DestroyBtn_3DItemCell()
  self.go_costEquip:SetActive(false)
end

function Zhuanzhi_EquipUI:btn_3DItemOnClick(control)
  if control.itemCellData.selected then
    self:GetTransferStoneMgr():SetSelectIndex(0)
  else
    self:GetTransferStoneMgr():SetSelectIndex(control.index)
  end
  self.btn_3DItemContainer:SetData(self:GetTransferStoneMgr():GetCanTransferEquipDataList())
end

function Zhuanzhi_EquipUI:btn_selectOnClick(control)
  self:DestroyBtn_3DItemCell()
  self.go_costEquip:SetActive(false)
  self:GetTransferStoneMgr():SetSelectEquipData()
  local selectIndex = self:GetTransferStoneMgr():GetSelectIndex()
  if 0 < selectIndex then
    self:GetTransferStoneMgr():SetChangeIndex(1)
  else
    self:GetTransferStoneMgr():SetChangeIndex(0)
  end
  self:RefreshEquipGroup()
end

function Zhuanzhi_EquipUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Zhuanzhi_EquipUI)
end

function Zhuanzhi_EquipUI:OnShow()
  self:InitData()
  self:RegistEvents()
  self:Refresh()
end

function Zhuanzhi_EquipUI:InitData()
  if self.args then
    self:GetTransferStoneMgr():SetCostInfo(self.args)
  end
end

function Zhuanzhi_EquipUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.OnResBagChange, self)
end

function Zhuanzhi_EquipUI:OnResBagChange()
  if self.go_costEquip:GetActive() then
    self.btn_3DItemContainer:SetData(self:GetTransferStoneMgr():GetCanTransferEquipDataList())
  end
end

function Zhuanzhi_EquipUI:Refresh()
  self:RefreshEquipTip()
  self:RefreshCostItem()
  self:RefreshEquipGroup()
end

function Zhuanzhi_EquipUI:RefreshEquipGroup()
  local showEquipData = self:GetTransferStoneMgr():GetSelectEquipData()
  self:RefreshLeftEquipGroup(showEquipData)
  local changeEquipItemIdList = self:GetTransferStoneMgr():GetChangeEquipItemIdList()
  local itemData
  for i, equipGroup in ipairs(self.equipGroupList) do
    if changeEquipItemIdList[i] then
      itemData = ItemUtility:GetItemDataByOldItem(changeEquipItemIdList[i], showEquipData)
    else
      itemData = nil
    end
    self:RefreshRightEquipGroup(equipGroup, itemData)
  end
  self:RefreshImSelect()
  self:RefreshImName()
end

function Zhuanzhi_EquipUI:RefreshLeftEquipGroup(itemData)
  if itemData then
    self.add_wing:SetActive(false)
    self:RefreshItemCell(self.btn_3DItem_old, itemData)
  else
    self:DestroyItemCell(self.btn_3DItem_old)
    self.add_wing:SetActive(true)
    self.btn_3DItem_old:SetOnClick(self, self.btnInputOnClick)
  end
end

function Zhuanzhi_EquipUI:RefreshRightEquipGroup(equipGroup, itemData)
  if itemData then
    if equipGroup.huo then
      equipGroup.huo:SetActive(true)
    end
    if equipGroup.group then
      equipGroup.group:SetActive(true)
    end
    if equipGroup.questionMark then
      equipGroup.questionMark:SetActive(false)
    end
    if equipGroup.btnItem then
      equipGroup.btnItem:SetActive(true)
      self:RefreshItemCell(equipGroup.btnItem, itemData)
      equipGroup.btnItem:SetOnClick(self, self.btn_3DItem_newSelectOnClick)
    end
  else
    if equipGroup.btnItem then
      self:DestroyItemCell(equipGroup.btnItem)
      equipGroup.btnItem:SetActive(false)
    end
    if equipGroup.questionMark then
      equipGroup.questionMark:SetActive(true)
    end
    if equipGroup.group then
      equipGroup.group:SetActive(false)
    end
    if equipGroup.huo then
      equipGroup.huo:SetActive(false)
    end
  end
end

function Zhuanzhi_EquipUI:RefreshImSelect()
  local changeIndex = self:GetTransferStoneMgr():GetChangeIndex()
  for i, ctr in ipairs(self.imSelectList) do
    ctr:SetActive(changeIndex == i)
  end
end

function Zhuanzhi_EquipUI:RefreshImName()
  local equipTitleList = self:GetTransferStoneMgr():GetChangeEquipTitle()
  for i, ctr in ipairs(self.imNameList) do
    if equipTitleList[i] == nil or string.isNullOrEmpty(equipTitleList[i]) then
      ctr:SetActive(false)
    else
      ctr:SetActive(true)
      self:SetSprite("Atlas_Language", equipTitleList[i], ctr)
    end
  end
end

function Zhuanzhi_EquipUI:RefreshCostEquipTitle()
  if self.costEquipTitleCount == nil then
    self.costEquipTitleCount = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Career_transfer_1")
    if self.costEquipTitleCount == nil then
      logError("Kh\195\180ng c\195\179 id: Career_transfer_1 trong b\225\186\163ng Ui_wordManager")
      self.costEquipTitleCount = ""
    end
  end
  self.lab_equipdemand:SetText(self.costEquipTitleCount)
end

function Zhuanzhi_EquipUI:RefreshEquipTip()
  local costInfo = self:GetTransferStoneMgr():GetCostItemInfo()
  local transferInfo
  local itemInfos = ClientTable.cfg_Career_transfer_itemManager:GetItemDic()[costInfo.itemId]
  if itemInfos == nil then
    return
  end
  for i, v in pairs(itemInfos) do
    transferInfo = ClientTable.cfg_Global_globalManager:GetTransferInfoDic()[v.type]
    break
  end
  if transferInfo and transferInfo.titleSprite and transferInfo.equipTip then
    self:SetSprite("Atlas_Language", transferInfo.titleSprite, self.txtTitle)
    self.equipTip:SetText(transferInfo.equipTip)
  end
end

function Zhuanzhi_EquipUI:RefreshCostItem()
  local costInfo = self:GetTransferStoneMgr():GetCostItemInfo()
  local itemData = ItemUtility.GenerateItemData(costInfo.itemId)
  self:RefreshItemCell(self.img_itemicon, itemData)
  local count = BagInfoData.GetItemTotalCountByItemId(costInfo.itemId)
  local text = tostring(count) .. "/" .. tostring(costInfo.count)
  if count < costInfo.count then
    text = string.GetColorText(text, ItemQuality2ColorDic[EItemColorEnum.red])
  else
    text = string.GetColorText(text, ItemQuality2ColorDic[EItemColorEnum.green])
  end
  self.lab_needStone:SetText(text)
end

function Zhuanzhi_EquipUI:RefreshItemCell(ctr, itemData)
  ctr.itemCellData = ctr.itemCellData or ItemCellData()
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, self, true)
end

function Zhuanzhi_EquipUI:OnHide()
  self:DestroyBtn_3DItemCell()
  self.go_costEquip:SetActive(false)
  self:DestroyItemCell(self.btn_3DItem_old)
  self:DestroyItemCell(self.btn_3DItem_new)
  self:DestroyItemCell(self.btn_3DItem_new2)
  self:DestroyItemCell(self.img_itemicon)
  self:GetTransferStoneMgr():DestroyData()
end

function Zhuanzhi_EquipUI:DestroyBtn_3DItemCell()
  for i, ctr in ipairs(self.btn_3DItemContainer.items) do
    self:DestroyItemCell(ctr)
  end
end

function Zhuanzhi_EquipUI:DestroyItemCell(ctr)
  ItemUtility.ReleaseItemCell(ctr, ctr.itemCellData)
end

function Zhuanzhi_EquipUI:OnDestroy()
end

function Zhuanzhi_EquipUI:GetTransferStoneMgr()
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetTransferStoneDataMgr()
  end
end
