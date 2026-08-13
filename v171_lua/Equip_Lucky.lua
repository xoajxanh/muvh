Equip_Lucky = class(BaseUI)
Equip_Lucky.layer = UILayer.Panel
Equip_Lucky.orderInLayer = 1
Equip_Lucky.hideType = UIHideType.WaitDestroy
Equip_Lucky.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_Lucky.escClose = UIEscClose.DontClose

function Equip_Lucky:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.frame_equip = self:GetControl("bg_equip/frame_equip")
  self.text_notWingEquip = self:GetControl("bg_equip/tips/text_notWingEquip")
  self.content = self:GetControl("bg_equip/content")
  self.text_defenseRatePvm = self:GetControl("bg_equip/content/lab_defenseRatePvm/text_defenseRatePvm")
  self.text_defenseRatePvmnext = self:GetControl("bg_equip/content/lab_defenseRatePvm/text_defenseRatePvmnext")
  self.img_arrow3 = self:GetControl("bg_equip/content/lab_defenseRatePvm/img_arrow3")
  self.lab_material = self:GetControl("bg_equip/lab_material")
  self.frame_item1 = self:GetControl("bg_equip/lab_material/frame_item1")
  self.frame_item2 = self:GetControl("bg_equip/lab_material/frame_item2")
  self.frame_item3 = self:GetControl("bg_equip/lab_material/frame_item3")
  self.lab_successRate = self:GetControl("bg_equip/lab_successRate")
  self.text_successRate = self:GetControl("bg_equip/lab_successRate/text_successRate")
  self.lab_item = self:GetControl("bg_equip/lab_item")
  self.btn_zhuijia = self:GetControl("bg_equip/btn_zhuijia")
  self.text_zhuijia = self:GetControl("bg_equip/btn_zhuijia/text_zhuijia")
  self.btn_3DItem = self:GetControl("bg_equip/btn_3DItem")
  self.SubPanelRoot = self:GetControl("SubPanelRoot")
  self.Img_noequip = self:GetControl("Img_noequip")
  self.Img_noequip1 = self:GetControl("Img_noequip/Img_noequip1")
  self.btn_role = self:GetControl("panel_role/btn_role")
  self.btn_bag = self:GetControl("panel_bag/btn_bag")
  self.Img_maxlevel = self:GetControl("Img_maxlevel")
  self.descBtn = self:GetControl("descBtn")
  self.btn_zhuanyi = self:GetControl("btn_zhuanyi")
  self.btn_close = self:GetControl("btn_close")
  self.Text = self:GetControl("Text")
end

function Equip_Lucky:Init()
  self.equipPool = {}
end

function Equip_Lucky:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_Lucky:InitUI()
  self.NeedMaterials = {
    self.frame_item1,
    self.frame_item2,
    self.frame_item3
  }
  self.AttributeInfoTab = {
    text_physBaseDmg = "minimumPhysBaseDmg",
    text_defenseBase = "defenseBase",
    text_defenseRatePvm = "defenseRatePvm",
    text_WizBaseDmg = "minimumWizBaseDmg",
    text_healthRecoveryMultiplier = "healthRecoveryMultiplier"
  }
end

function Equip_Lucky:OnShow()
  EquipeInfoData.curView = UIID.Equip_Lucky
  self:RegistEvents()
  self:Refresh()
end

function Equip_Lucky:OnHide()
  self:HideEquipObj()
  EquipeInfoData.curView = nil
  if self.itemCellData then
    self.itemCellData:RecycleRes()
    self.itemCellData = nil
  end
end

function Equip_Lucky:OnDestroy()
  self:DestroyEquipObj()
end

function Equip_Lucky:RegistUIEvents()
  self.frame_item1:SetOnClick(self, self.frame_item1OnClick)
  self.frame_item2:SetOnClick(self, self.frame_item2OnClick)
  self.frame_item3:SetOnClick(self, self.frame_item3OnClick)
  self.btn_zhuijia:SetOnClick(self, self.btn_zhuijiaOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_role:SetOnToggleChanged(self, self.btn_roleOnClick)
  self.btn_bag:SetOnToggleChanged(self, self.btn_bagOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_zhuanyi:SetOnClick(self, self.btn_zhuanyiOnClick)
end

function Equip_Lucky:frame_equipOnClick(control)
  if not self.EquipData then
    return
  end
  UIManager.Show(UIID.ItemTipUI, {
    item = self.EquipData,
    rightOperate = EItemOperateType.Show,
    ctrl = control
  })
end

function Equip_Lucky:frame_item1OnClick(control)
end

function Equip_Lucky:frame_item2OnClick(control)
end

function Equip_Lucky:frame_item3OnClick(control)
end

function Equip_Lucky:btn_zhuijiaOnClick(control)
  if self.equipLuckyTab then
    local costTab = string.split(self.equipLuckyTab.cost, "&")
    for i = 1, table.count(costTab) do
      local itemTbl = string.split(costTab[i], "#")
      local id = tonumber(itemTbl[1])
      local itemCount = tonumber(itemTbl[2])
      local bagCount = BagInfoData.GetItemCountByItemConfigId(id)
      if itemCount > bagCount then
        local itemName = ClientTable.cfg_Item_itemManager:TryGetValue(id).name
        UIManager.Show(UIID.PromptTipUI, {
          title = "Nh\225\186\175c nh\225\187\159",
          textContent = itemName .. "Kh\195\180ng \196\145\225\187\167"
        })
        return
      end
    end
  end
  local equipId = self.EquipData.id
  MeEquipController.ReqEquipLuckyIntensify(equipId)
end

function Equip_Lucky:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_Lucky)
  UIManager.Hide(UIID.Equip_ForgeNavUi)
end

function Equip_Lucky:btn_roleOnClick(control)
  UIManager.Show(UIID.Bag_EquipInfoUI)
end

function Equip_Lucky:btn_bagOnClick(control)
  UIManager.Show(UIID.NewBagInfoUI)
end

function Equip_Lucky:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_Lucky")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Equip_Lucky:btn_zhuanyiOnClick()
  UIManager.Show(UIID.Equip_Transfer, {
    resetLogic = 1,
    OpenType = TransferOpenType.Zhuijia
  })
  EventManager.Dispatch(Event.RefreshBagEquip, UIID.Equip_Transfer)
end

function Equip_Lucky:RegistEvents()
  self:RegistEvent(Event.SelectedForgeEquip, self.SelectedZhuiJiaEquip, self)
  self:RegistEvent(Event.EquipAttriUpdate, self.EquipAttriUpdate, self)
end

function Equip_Lucky:SelectedZhuiJiaEquip(id, msg)
  local equipData = msg[1]
  self.Img_maxlevel:SetActive(false)
  if not equipData then
    self.Img_noequip:SetActive(true)
    return
  end
  self:HideEquipObj()
  self:SetEquipZhuiJiaInfo(equipData, msg[2])
end

function Equip_Lucky:EquipAttriUpdate(id, msg)
  if msg then
    self:UpdateEquipIntensifyInfo(msg)
  end
end

function Equip_Lucky:Refresh()
  self:HideEquipObj()
  EventManager.Dispatch(Event.EquipForgeUIChange)
end

function Equip_Lucky:SetEquipZhuiJiaInfo(EquipData, index)
  self.EquipIndex = index
  self.EquipData = EquipData
  if not EquipData or not EquipData.tblEquip then
    return
  end
  local itemId = EquipData.itemId
  if not self:IsCanLuckyIntensify(EquipData.tblEquip.id) then
    self.Img_noequip:SetActive(true)
    return
  else
    self.Img_noequip:SetActive(false)
  end
  self.equipLuckyTab = MeEquipController.GetEquipLuckyCfg(EquipData.tblEquip.id, EquipData.luckLevel or 0)
  self:SetEquipBasics(EquipData.tblEquip, EquipData)
  self:SetDownInfo(EquipData.tblEquip, EquipData)
  self:LoadEquipModel(EquipData)
end

function Equip_Lucky:UpdateEquipIntensifyInfo(EquipData)
  self.EquipData = EquipData
  local itemId = EquipData.itemId
  if not EquipData.tblEquip then
    return
  end
  self.equipLuckyTab = MeEquipController.GetEquipLuckyCfg(EquipData.tblEquip.id, EquipData.luckLevel or 0)
  self:SetEquipBasics(EquipData.tblEquip, EquipData)
  self:SetDownInfo(EquipData.tblEquip, EquipData)
end

function Equip_Lucky:SetEquipBasics(cfgItem, EquipData)
  local titleStr = string.GetColorText(cfgItem.name, ItemQuality2ColorDic[EquipData.tblItem.quality])
  self.lab_item:SetText(titleStr)
  local rate = self.equipLuckyTab.rate
  if rate then
    rate = string.format("%d%s", rate / 100, "%")
    self.text_successRate:SetText(rate)
  end
  local level = self.equipLuckyTab.level
  self.text_defenseRatePvm:SetText("+" .. level)
  self.text_defenseRatePvmnext:SetText("+" .. 1)
  self.img_arrow3:SetActive(false)
  if self.equipLuckyTab.level == 1 then
    self.text_defenseRatePvm:SetActive(false)
    self.text_defenseRatePvmnext:SetActive(true)
  else
    self.text_defenseRatePvm:SetActive(true)
    self.text_defenseRatePvmnext:SetActive(true)
  end
end

function Equip_Lucky:SetAttributeInfo()
end

function Equip_Lucky:SetAttributeItemInfo(k, v)
  self[k].transform.parent.gameObject:SetActive(true)
  local num = self.IntensifyTable[v]
  local str
  if v == "healthRecoveryMultiplier" then
    str = string.format("+%d%s", num / 100, "%")
  else
    str = string.format("+%d", num)
  end
  self[k]:SetText(str)
  if self.LastIntensifyTable then
    local NextNum = self.LastIntensifyTable[v]
    self[k .. "next"]:SetActive(NextNum and NextNum ~= 0)
    if NextNum and NextNum ~= 0 then
      local str2
      if v == "healthRecoveryMultiplier" then
        str2 = string.format("%d%s", NextNum / 100, "%")
      else
        str2 = string.format("+%d", NextNum)
      end
      self[k .. "next"]:SetText(str2)
    end
  else
    self[k .. "next"]:SetActive(self.LastIntensifyTable)
  end
end

function Equip_Lucky:SetDownInfo(cfgEquipItem, EquipData)
  if not self.equipLuckyTab then
    return
  end
  if self.equipLuckyTab.level == 1 then
    self.lab_material:SetActive(false)
    self.lab_successRate:SetActive(false)
    self.btn_zhuijia:SetActive(false)
    self.Img_maxlevel:SetActive(true)
    return
  end
  self.lab_material:SetActive(true)
  self.lab_successRate:SetActive(true)
  self.btn_zhuijia:SetActive(true)
  self.Img_maxlevel:SetActive(false)
  local cost = string.split(self.equipLuckyTab.cost, "&")
  for i = 1, table.count(self.NeedMaterials) do
    local obj = self.NeedMaterials[i]
    if i <= table.count(cost) then
      local itemTbl = string.split(cost[i], "#")
      local id = tonumber(itemTbl[1])
      Equip_ForgeNavUi.SetItemIcon(self, id, obj, itemTbl[2])
      local bagCount = BagInfoData.GetItemCountByItemConfigId(id)
      local isShow = bagCount < tonumber(itemTbl[2])
      local btn_get = UIControl(obj.transform, "btn_obtain")
      btn_get.itemData = ItemUtility.GenerateItemData(id)
      btn_get:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
      btn_get:SetActive(isShow)
      obj:SetActive(true)
    else
      obj:SetActive(false)
    end
  end
end

function Equip_Lucky:LoadEquipModel(itemdata)
  if not self.itemCellData then
    self.itemCellData = ItemCellData()
  end
  self.itemCellData:RefreshData(itemdata)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.itemCellData, self, true)
end

function Equip_Lucky:InitShowModel(itemdata)
  Equip_ForgeNavUi.InitShowModel(self, itemdata)
end

function Equip_Lucky:HideEquipObj()
  if self.itemCellData then
    self.itemCellData:RecycleRes()
  end
end

function Equip_Lucky:DestroyEquipObj()
  if self.LoadEquipObject then
    local go = self.LoadEquipObject
    self.LoadEquipObject = nil
  end
  self.equipPool = {}
end

function Equip_Lucky:GetAttributeNameByType(intType)
  for k, v in pairs(EAttributeType) do
    if v == intType then
      return k
    end
  end
end

function Equip_Lucky:IsCanLuckyIntensify(id)
  local equipLuckyAllTab = MeEquipController.EquipLuckyConfigTable
  if equipLuckyAllTab and equipLuckyAllTab[id] ~= nil then
    return true
  end
  return false
end
