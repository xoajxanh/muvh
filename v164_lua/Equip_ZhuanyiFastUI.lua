Equip_ZhuanyiFastUI = class(BaseUI)
Equip_ZhuanyiFastUI.layer = UILayer.MessageBox
Equip_ZhuanyiFastUI.orderInLayer = 2
Equip_ZhuanyiFastUI.hideType = UIHideType.WaitDestroy
Equip_ZhuanyiFastUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_ZhuanyiFastUI.escClose = UIEscClose.DontClose

function Equip_ZhuanyiFastUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.lab_description = self:GetControl("lab_description")
  self.btn_close = self:GetControl("btn_close")
  self.lefticon = self:GetControl("lefticon")
  self.righticon = self:GetControl("righticon")
  self.gold = self:GetControl("cost/gold")
  self.btn_get = self:GetControl("cost/gold/btn_get")
  self.lab_goldText = self:GetControl("cost/gold/lab_goldText")
  self.lab_goldValue = self:GetControl("cost/gold/lab_goldValue")
  self.goldItem = self:GetControl("cost/gold/goldItem")
  self.lab_diamondValue = self:GetControl("cost/diamond/lab_diamondValue")
  self.btn_cancel = self:GetControl("btn_cancel")
  self.btn_confirm = self:GetControl("btn_confirm")
end

function Equip_ZhuanyiFastUI:OnPreLoad()
end

function Equip_ZhuanyiFastUI:Init()
end

function Equip_ZhuanyiFastUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_ZhuanyiFastUI:InitUI()
  self.TransferType = {}
  self.oldItem = nil
  self.newItem = nil
end

function Equip_ZhuanyiFastUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_ZhuanyiFastUI:OnHide()
  if self.oldCellData then
    self.oldCellData.itemData = nil
    ItemUtility.ShowItemCell(self.lefticon, self.oldCellData, self)
  end
  if self.newCellData then
    self.newCellData.itemData = nil
    ItemUtility.ShowItemCell(self.righticon, self.newCellData, self)
  end
  if self.goldCellData then
    self.goldCellData.itemData = nil
    ItemUtility.ShowItemCell(self.goldItem, self.goldCellData, self)
  end
  self.args = nil
  self.oldItem = nil
  self.newItem = nil
end

function Equip_ZhuanyiFastUI:OnDestroy()
end

function Equip_ZhuanyiFastUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_confirmOnClick)
  self.btn_cancel:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_confirm:SetOnClick(self, self.btn_confirmOnClick)
  self.lefticon:SetOnClick(self, self.btn_lefticonOnClick)
  self.righticon:SetOnClick(self, self.btn_righticonOnClick)
end

function Equip_ZhuanyiFastUI:btn_closeBgOnClick(control)
  ForgeData.EquipTransferMain = nil
  ForgeData.EquipTransferSecond = nil
  UIManager.Hide(UIID.Equip_ZhuanyiFastUI)
end

local oldID, newID

function Equip_ZhuanyiFastUI:btn_confirmOnClick(control)
  if not self.isEnoughCoin then
    FloatingWordUtility.QuickBtnMsg({
      parent = self.btn_confirm,
      msgStr = LocalizationUtility.GetUIWord("transfer_warning")
    })
    return
  end
  local str = tostring(RoleManager.me.id)
  local isFirst = PlayerPrefs.GetString(str, "")
  if string.isNullOrEmpty(isFirst) then
    PlayerPrefs.SetString(str, "noFirst")
    ForgeData.isFastTransferOpen = true
    EquipData:FirstOpenPanelArgs(IndexerEnum.set, {
      isFirstOpen = true,
      position = self.args.position,
      equipId = self.args.equipId
    })
    UIManager.JumpShow(UIPanelType.SortAndHide, UIID.Equip_ForgeNavUi, {
      uiID = UIID.Equip_Transfer
    })
    UIManager.Hide(UIID.Equip_ZhuanyiFastUI)
  else
    EquipData:FirstOpenPanelArgs(IndexerEnum.set, {isFirstOpen = false})
    local intensifyMaxLevel, addMaxLevel = MeEquipController.GetEquipIntensifyAndAddMaxLevel(self.newItem)
    if intensifyMaxLevel < self.oldItem.intensify or addMaxLevel < self.oldItem.additional then
      FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("transfer_3"))
      return
    end
    NetManager.Send(EquipMessage.ReqEquipTransfer, {
      equipId = newID,
      traEquipId = oldID,
      type = self.TransferType,
      maxIntensify = intensifyMaxLevel,
      maxAdditional = addMaxLevel
    })
    NetManager.Send(EquipMessage.ReqPutOnTheEquip, {
      position = self.args.position,
      equipId = self.args.equipId
    })
    EventManager.Dispatch(Event.Bag_RefreshShowTransfer)
    self:btn_closeBgOnClick()
  end
end

function Equip_ZhuanyiFastUI:btn_lefticonOnClick(control)
  if self.oldItem then
    UIManager.Show(UIID.ItemTipUI, {
      item = self.oldItem,
      rightOperate = EItemOperateType.Disboard,
      ctrl = control,
      openType = TipsOpenType.RoleEquipOpen
    })
  end
end

function Equip_ZhuanyiFastUI:btn_righticonOnClick(control)
  if self.newItem then
    UIManager.Show(UIID.ItemTipUI, {
      item = self.newItem,
      rightOperate = EItemOperateType.Disboard,
      ctrl = control,
      openType = TipsOpenType.RoleEquipOpen
    })
  end
end

function Equip_ZhuanyiFastUI:RegistEvents()
end

function Equip_ZhuanyiFastUI:Refresh()
  self:SetPanel()
end

function Equip_ZhuanyiFastUI:SetPanel()
  self.oldItem = EquipData(ForgeData.EquipTransferMain)
  self.newItem = EquipData(ForgeData.EquipTransferSecond)
  oldID = self.oldItem.id
  newID = self.newItem.id
  if self.oldItem == nil or self.newItem == nil or oldID == newID then
    UIManager.Hide(UIID.Equip_ZhuanyiFastUI)
    return
  end
  self.oldCellData = ItemCellData()
  self.oldCellData:RefreshData(self.oldItem)
  ItemUtility.ShowItemCell(self.lefticon, self.oldCellData, self, false)
  self.newCellData = ItemCellData()
  self.newCellData:RefreshData(self.newItem)
  ItemUtility.ShowItemCell(self.righticon, self.newCellData, self, false)
  local tbl_Intensify = ConfigManager.FindConfigs("cfg_Item_equip_zhuanyi", "type", TransferOpenType.Intensify)
  local tbl_Zhuijia = ConfigManager.FindConfigs("cfg_Item_equip_zhuanyi", "type", TransferOpenType.Zhuijia)
  local item, IntensifyStr, ZhuijiaStr, inHave
  local costAdd, costIntensify = 0, 0
  for k, v in pairs(tbl_Intensify) do
    if v.level == self.oldItem.intensify then
      item = v
    end
  end
  if not string.isNullOrEmpty(item.cost) then
    IntensifyStr = string.split(item.cost, "#")
    costIntensify = tonumber(IntensifyStr[2])
  end
  for k, v in pairs(tbl_Zhuijia) do
    if v.level == self.oldItem.additional then
      item = v
    end
  end
  if not string.isNullOrEmpty(item.cost) then
    ZhuijiaStr = string.split(item.cost, "#")
    costAdd = tonumber(ZhuijiaStr[2])
  end
  local costId = table.count(IntensifyStr) == 2 and tonumber(IntensifyStr[1]) or tonumber(ZhuijiaStr[1])
  inHave = BagInfoData.GetItemTotalCountByItemId(costId)
  local bagStr = Mathf.NumberShowFormat(inHave, 1)
  local itemData = ItemUtility.GenerateItemData(costId)
  self.btn_get.itemData = itemData
  self.btn_get:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
  self.goldCellData = ItemCellData()
  self.goldCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.goldItem, self.goldCellData, self, true)
  self.TransferType = {
    [1] = 1,
    [2] = 2,
    [3] = 3
  }
  self.isEnoughCoin = inHave >= costAdd + costIntensify
  self.gold:SetActive(costAdd + costIntensify ~= 0)
  local strColor = inHave >= costAdd + costIntensify and "#00FF00" or "#FF0000"
  local costStr = Mathf.NumberShowFormat(costAdd + costIntensify, 1)
  local countStr = string.format("%s", costStr)
  self.lab_goldText:SetText(LocalizationUtility.GetUIWord("transfer_fast"))
  self.lab_goldValue:SetText(string.GetColorText(countStr, strColor))
  local regenerateStr = 0 < table.count(self.oldItem.serverInfo.RegenerateAttributeList) and "Thu\225\187\153c t\195\173nh T\195\161i Sinh" or ""
  self.lab_description:SetText(string.format("Trang b\225\187\139 hi\225\187\135n t\225\186\161i c\195\179 th\225\187\131 k\225\186\191 th\225\187\171a [%s]" .. "\n" .. "C\225\186\165p c\198\176\225\187\157ng h\195\179a: %d " .. "\n" .. "C\225\186\165p Buff: %d " .. "\n" .. "%s" .. "\n" .. "X\195\161c nh\225\186\173n Chuy\225\187\131n Nhanh", self.oldItem.tblEquip.name, self.oldItem.intensify, self.oldItem.additional, regenerateStr))
  self.btn_get:SetActive(not self.isEnoughCoin)
end

function Equip_ZhuanyiFastUI:SetTransFerType(newData, oldData)
  if newData.intensify == 0 and newData.additional == 0 then
    if oldData.intensify > 0 and 0 < oldData.additional then
      self.TransferType = 3
    elseif oldData.intensify > 0 then
      self.TransferType = 1
    elseif 0 < oldData.additional then
      self.TransferType = 2
    end
  elseif newData.intensify == 0 then
    if oldData.intensify > 0 then
      self.TransferType = 1
    end
  elseif newData.additional == 0 and 0 < oldData.additional then
    self.TransferType = 2
  end
end
