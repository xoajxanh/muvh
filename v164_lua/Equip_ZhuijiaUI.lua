Equip_ZhuijiaUI = class(BaseUI)
Equip_ZhuijiaUI.layer = UILayer.Panel
Equip_ZhuijiaUI.orderInLayer = 1
Equip_ZhuijiaUI.hideType = UIHideType.WaitDestroy
Equip_ZhuijiaUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_ZhuijiaUI.escClose = UIEscClose.DontClose

function Equip_ZhuijiaUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.btn_3DItem = self:GetControl("bg_equip/btn_3DItem")
  self.frame_equip = self:GetControl("bg_equip/frame_equip")
  self.lab_successRate = self:GetControl("bg_equip/lab_successRate")
  self.text_successRate = self:GetControl("bg_equip/lab_successRate/text_successRate")
  self.text_notWingEquip = self:GetControl("bg_equip/tips/text_notWingEquip")
  self.content = self:GetControl("bg_equip/content")
  self.text_physBaseDmgjiantou = self:GetControl("bg_equip/content/lab_physBaseDmg/text_physBaseDmgjiantou")
  self.text_physBaseDmg = self:GetControl("bg_equip/content/lab_physBaseDmg/text_physBaseDmg")
  self.text_physBaseDmgnext = self:GetControl("bg_equip/content/lab_physBaseDmg/text_physBaseDmgnext")
  self.text_physBaseDmgGreen = self:GetControl("bg_equip/content/lab_physBaseDmg/text_physBaseDmgGreen")
  self.text_physBaseDmgGold = self:GetControl("bg_equip/content/lab_physBaseDmg/text_physBaseDmgGold")
  self.text_WizBaseDmgjiantou = self:GetControl("bg_equip/content/lab_wizBaseDmg/text_WizBaseDmgjiantou")
  self.text_WizBaseDmg = self:GetControl("bg_equip/content/lab_wizBaseDmg/text_WizBaseDmg")
  self.text_WizBaseDmgnext = self:GetControl("bg_equip/content/lab_wizBaseDmg/text_WizBaseDmgnext")
  self.text_WizBaseDmgGreen = self:GetControl("bg_equip/content/lab_wizBaseDmg/text_WizBaseDmgGreen")
  self.text_WizBaseDmgGold = self:GetControl("bg_equip/content/lab_wizBaseDmg/text_WizBaseDmgGold")
  self.text_CurseBaseDmgjiantou = self:GetControl("bg_equip/content/lab_curseBaseDmg/text_CurseBaseDmgjiantou")
  self.text_CurseBaseDmg = self:GetControl("bg_equip/content/lab_curseBaseDmg/text_CurseBaseDmg")
  self.text_CurseBaseDmgnext = self:GetControl("bg_equip/content/lab_curseBaseDmg/text_CurseBaseDmgnext")
  self.text_CurseBaseDmgGreen = self:GetControl("bg_equip/content/lab_curseBaseDmg/text_CurseBaseDmgGreen")
  self.text_CurseBaseDmgGold = self:GetControl("bg_equip/content/lab_curseBaseDmg/text_CurseBaseDmgGold")
  self.text_defenseBase = self:GetControl("bg_equip/content/lab_defenseBase/text_defenseBase")
  self.text_defenseBasenext = self:GetControl("bg_equip/content/lab_defenseBase/text_defenseBasenext")
  self.text_defenseRatePvm = self:GetControl("bg_equip/content/lab_defenseRatePvm/text_defenseRatePvm")
  self.text_defenseRatePvmnext = self:GetControl("bg_equip/content/lab_defenseRatePvm/text_defenseRatePvmnext")
  self.text_healthRecoveryMultiplier = self:GetControl("bg_equip/content/lab_healthRecoveryMultiplier/text_healthRecoveryMultiplier")
  self.text_healthRecoveryMultipliernext = self:GetControl("bg_equip/content/lab_healthRecoveryMultiplier/text_healthRecoveryMultipliernext")
  self.lab_material = self:GetControl("bg_equip/lab_material")
  self.frame_item1 = self:GetControl("bg_equip/lab_material/frame_item1")
  self.frame_item2 = self:GetControl("bg_equip/lab_material/frame_item2")
  self.frame_item3 = self:GetControl("bg_equip/lab_material/frame_item3")
  self.img_material = self:GetControl("bg_equip/img_material")
  self.lab_success = self:GetControl("bg_equip/lab_zhui_bg/lab_success")
  self.img_addLevel = self:GetControl("bg_equip/lab_zhui_bg/img_addLevel")
  self.img_addLevelNext = self:GetControl("bg_equip/lab_zhui_bg/img_addLevelNext")
  self.lab_item = self:GetControl("bg_equip/lab_item")
  self.btn_zhuijia = self:GetControl("bg_equip/btn_zhuijia")
  self.text_zhuijia = self:GetControl("bg_equip/btn_zhuijia/text_zhuijia")
  self.img_level = self:GetControl("bg_equip/img_level")
  self.lab_level = self:GetControl("bg_equip/lab_level")
  self.lab_name = self:GetControl("bg_equip/lab_level/lab_name")
  self.lab_num = self:GetControl("bg_equip/lab_level/lab_num")
  self.SubPanelRoot = self:GetControl("SubPanelRoot")
  self.Img_maxlevel = self:GetControl("Img_maxlevel")
  self.descBtn = self:GetControl("descBtn")
  self.lab_failuretips = self:GetControl("lab_failuretips")
  self.btn_zhuanyi = self:GetControl("btn_zhuanyi")
  self.btn_masterattribute = self:GetControl("btn_masterattribute")
  self.Scroll_Master = self:GetControl("btn_masterattribute/Scroll_Master")
  self.btn_masterClose = self:GetControl("btn_masterattribute/Scroll_Master/btn_masterClose")
  self.item_master = self:GetControl("btn_masterattribute/Scroll_Master/Viewport/Content/item_master")
  self.Img_noequip = self:GetControl("Img_noequip")
  self.plane_top = self:GetControl("Img_noequip/plane_top")
  self.Img_noequip1 = self:GetControl("Img_noequip/Img_noequip1")
  self.btn_role = self:GetControl("panel_role/btn_role")
  self.btn_bag = self:GetControl("panel_bag/btn_bag")
  self.btn_close = self:GetControl("btn_close")
  self.Text = self:GetControl("Text")
end

function Equip_ZhuijiaUI:Init()
  self.equipPool = {}
end

function Equip_ZhuijiaUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnItemMaterInit(control)
end

local function OnItemMaterRefresh(ctr, _, data, ui)
  local lab_name = ctr:GetChild("lab_equipcount")
  local lab_attribute = ctr:GetChild("lab_activeattribute")
  local name, attribute
  local value = data.extraAdditionalAttributeIncrease / 100
  local percent = math.floor(value * 10 + 0.5) / 10
  if ui:IsCompleteIntensify(data.index, data.goalCount) then
    name = string.GetColorText(LocalizationUtility.GetContentByKey("EquipMaster3"), ItemQuality2ColorDic[EItemColorEnum.white])
    name = string.format(name, string.GetColorText(data.goalCount, ItemQuality2ColorDic[EItemColorEnum.green]))
    attribute = string.GetColorText(LocalizationUtility.GetContentByKey("EquipMaster4"), ItemQuality2ColorDic[EItemColorEnum.white])
    attribute = string.format(attribute, string.GetColorText(percent, ItemQuality2ColorDic[EItemColorEnum.yellow]), string.GetColorText("%", ItemQuality2ColorDic[EItemColorEnum.yellow]))
  else
    name = string.GetColorText(string.format(LocalizationUtility.GetContentByKey("EquipMaster3"), data.goalCount), ItemQuality2ColorDic[EItemColorEnum.dark])
    attribute = string.GetColorText(string.format(LocalizationUtility.GetContentByKey("EquipMaster4"), percent, "%"), ItemQuality2ColorDic[EItemColorEnum.dark])
  end
  ctr:GetChild("lab_bg"):SetActive(_ % 2 == 1)
  lab_name:SetText(name)
  lab_attribute:SetText(attribute)
end

function Equip_ZhuijiaUI:InitUI()
  self.NeedMaterials = {
    self.frame_item1,
    self.frame_item2,
    self.frame_item3
  }
  self.AttributeInfoTab = {
    defenseRatePvm = "text_defenseRatePvm",
    career_minimumPhysBaseDmg = "text_physBaseDmg",
    career_minimumWizBaseDmg = "text_WizBaseDmg",
    career_defenseBase = "text_defenseBase",
    career_minimumCurseBaseDmg = "text_CurseBaseDmg"
  }
  self.cellData = {}
  self.itemMasterContain = UIContainer(self.item_master, self, OnItemMaterInit, OnItemMaterRefresh)
end

function Equip_ZhuijiaUI:OnShow()
  EquipeInfoData.curView = UIID.Equip_ZhuijiaUI
  self:RegistEvents()
  self:Refresh()
end

function Equip_ZhuijiaUI:OnHide()
  self:HideEquipObj()
  EquipeInfoData.curView = nil
  for i, v in pairs(self.cellData) do
    if v then
      v:RecycleRes()
    end
  end
  self.cellData = {}
  if self.itemCellData then
    self.itemCellData:RecycleRes()
    self.itemCellData = nil
  end
end

function Equip_ZhuijiaUI:OnDestroy()
  self:DestroyEquipObj()
end

function Equip_ZhuijiaUI:RegistUIEvents()
  self.frame_item1:SetOnClick(self, self.frame_item1OnClick)
  self.frame_item2:SetOnClick(self, self.frame_item2OnClick)
  self.frame_item3:SetOnClick(self, self.frame_item3OnClick)
  self.btn_zhuijia:SetOnClick(self, self.btn_zhuijiaOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_role:SetOnToggleChanged(self, self.btn_roleOnClick)
  self.btn_bag:SetOnToggleChanged(self, self.btn_bagOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_zhuanyi:SetOnClick(self, self.btn_zhuanyiOnClick)
  self.btn_masterattribute:SetOnClick(self, self.BtnMasterOnClick)
end

function Equip_ZhuijiaUI:BtnMasterOnClick()
  UIManager.Show(UIID.Tip_CommonTipsUI, {
    showType = CommonTipsEnum.Zhuijia
  })
end

function Equip_ZhuijiaUI:frame_equipOnClick(control)
  if not self.EquipData then
    return
  end
  UIManager.Show(UIID.ItemTipUI, {
    item = self.EquipData,
    rightOperate = EItemOperateType.Show,
    ctrl = control
  })
end

function Equip_ZhuijiaUI:frame_item1OnClick(control)
end

function Equip_ZhuijiaUI:frame_item2OnClick(control)
end

function Equip_ZhuijiaUI:frame_item3OnClick(control)
end

function Equip_ZhuijiaUI:btn_zhuijiaOnClick(control)
  if self.IntensifyTable then
    local costTab = string.split(self.IntensifyTable.cost, "&")
    for i = 1, table.count(costTab) do
      local itemTbl = string.split(costTab[i], "#")
      local id = tonumber(itemTbl[1])
      local itemCount = tonumber(itemTbl[2])
      local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
      if itemCount > bagCount then
        local temp = {}
        temp.itemData = ItemUtility.GenerateItemData(id)
        UIManager.Show(UIID.ItemTipUI, {
          item = temp.itemData,
          rightOperate = EItemOperateType.Show,
          ctrl = temp,
          ShowObtain = true
        })
        return
      end
    end
  end
  local equipId = self.EquipData.id
  MeEquipController.ReqEquipAdditional(equipId)
end

function Equip_ZhuijiaUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_ForgeNavUi)
end

function Equip_ZhuijiaUI:btn_roleOnClick(control)
  UIManager.Show(UIID.Bag_EquipInfoUI)
  EventManager.Dispatch(Event.EquipOrBagChange, UIID.Equip_ZhuijiaUI)
end

function Equip_ZhuijiaUI:btn_bagOnClick(control)
  UIManager.Show(UIID.NewBagInfoUI)
end

function Equip_ZhuijiaUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_ZhuijiaUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Equip_ZhuijiaUI:btn_zhuanyiOnClick()
  UIManager.Show(UIID.Equip_Transfer, {
    resetLogic = 1,
    OpenType = TransferOpenType.Zhuijia
  })
  EventManager.Dispatch(Event.RefreshBagEquip, UIID.Equip_Transfer)
end

function Equip_ZhuijiaUI:RegistEvents()
  self:RegistEvent(Event.SelectedForgeEquip, self.SelectedZhuiJiaEquip, self)
  self:RegistEvent(Event.EquipAddSucceed, self.EquipAttriUpdate, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.SetUIRefresh, self)
end

function Equip_ZhuijiaUI:SelectedZhuiJiaEquip(id, msg)
  local equipData = msg[1]
  self.Img_noequip:SetActive(not equipData)
  self.Img_maxlevel:SetActive(false)
  if not equipData or not equipData.tblEquip then
    return
  end
  if UIManager.IsVisible(UIID.NewBagInfoUI) then
    local bagIndex = string.split(equipData.tblEquip.equipPosition, "#")[1]
    if RoleEquipUtility.EquipTypeUtility(tonumber(bagIndex), ERoleEquipCondition.Archangel) then
      return
    end
  end
  self:HideEquipObj()
  self:SetEquipZhuiJiaInfo(equipData, msg[2])
end

function Equip_ZhuijiaUI:EquipAttriUpdate(id, msg)
  if msg then
    self:UpdateEquipIntensifyInfo(msg)
  end
end

function Equip_ZhuijiaUI:SetUIRefresh(id, msg)
  if msg then
    self:SetDownInfo()
  end
end

function Equip_ZhuijiaUI:Refresh()
  if self.Scroll_Master:GetActive() then
    self.Scroll_Master:SetActive(false)
  end
  self:HideEquipObj()
  EventManager.Dispatch(Event.EquipForgeUIChange)
  self.btn_role.toggle.isOn = true
  self.btn_bag.toggle.isOn = false
end

function Equip_ZhuijiaUI:SetEquipZhuiJiaInfo(EquipData, index)
  self.EquipIndex = index
  self.EquipData = EquipData
  if not EquipData or not EquipData.tblEquip then
    return
  end
  local itemId = EquipData.itemId
  self.IntensifyTable = MeEquipController.GetEquipAddtion(EquipData.itemId, EquipData.additional or 0)
  if not self.IntensifyTable then
    self.IntensifyTable = MeEquipController.GetEquipAddtion(EquipData.tblItem.subType, EquipData.additional or 0)
  end
  self.LastIntensifyTable = MeEquipController.GetEquipAddtion(EquipData.itemId, EquipData.additional + 1 or 0)
  if not self.LastIntensifyTable then
    self.LastIntensifyTable = MeEquipController.GetEquipAddtion(EquipData.tblItem.subType, EquipData.additional + 1 or 0)
  end
  self:SetEquipBasics(EquipData.tblEquip, EquipData)
  self:SetAttributeInfo()
  self:SetConditionInfo(EquipData.tblEquip, EquipData)
  self:SetDownInfo(EquipData.tblEquip, EquipData)
  self:LoadEquipModel(EquipData)
  self:ZhuiJiaCalculateResultChange()
end

function Equip_ZhuijiaUI:UpdateEquipIntensifyInfo(EquipData)
  self.EquipData = EquipData
  local itemId = EquipData.itemId
  if not EquipData.tblEquip then
    return
  end
  self.IntensifyTable = MeEquipController.GetEquipAddtion(EquipData.itemId, EquipData.additional or 0)
  if not self.IntensifyTable then
    self.IntensifyTable = MeEquipController.GetEquipAddtion(EquipData.tblItem.subType, EquipData.additional or 0)
  end
  self.LastIntensifyTable = MeEquipController.GetEquipAddtion(EquipData.itemId, EquipData.additional + 1 or 0)
  if not self.LastIntensifyTable then
    self.LastIntensifyTable = MeEquipController.GetEquipAddtion(EquipData.tblItem.subType, EquipData.additional + 1 or 0)
  end
  self:SetEquipBasics(EquipData.tblEquip, EquipData)
  self:SetAttributeInfo()
  self:SetConditionInfo(EquipData.tblEquip, EquipData)
  self:SetDownInfo(EquipData.tblEquip, EquipData)
  self:ZhuiJiaCalculateResultChange()
end

function Equip_ZhuijiaUI:SetEquipBasics(cfgItem, EquipData)
  local strName = cfgItem.name
  if EquipData.additional and EquipData.additional > 0 then
    strName = string.format("%s +%d", cfgItem.name, EquipData.additional)
  end
  local titleStr = RoleEquipUtility.GetEquipNameColor(strName, EquipData)
  self.lab_item:SetText(titleStr)
  self.img_addLevel:SetText("+" .. self.EquipData.additional)
  self.img_addLevelNext:SetText("+" .. self.EquipData.additional + 1)
  self.img_addLevelNext:SetActive(self.LastIntensifyTable)
  self.lab_success:SetActive(self.LastIntensifyTable)
end

function Equip_ZhuijiaUI:SetAttributeInfo()
  if not self.IntensifyTable then
    self.content:SetActive(false)
    return
  end
  self.content:SetActive(true)
  local rate = self.IntensifyTable.rate
  if rate then
    rate = string.format("%d%s", rate / 100, "A")
    self.text_successRate:SetText(rate)
  end
  for k, v in pairs(self.AttributeInfoTab) do
    self[v].transform.parent.gameObject:SetActive(false)
    local IntensifyTableNor = MeEquipController.GetEquipAddtion(self.EquipData.itemId, 1)
    IntensifyTableNor = IntensifyTableNor or MeEquipController.GetEquipAddtion(self.EquipData.tblItem.subType, 1)
    if IntensifyTableNor and IntensifyTableNor[k] and self:CheckSetAttribute(IntensifyTableNor, k) then
      self:SetAttributeItemInfo(v, k)
    end
  end
end

function Equip_ZhuijiaUI:CheckSetAttribute(zhuijiaTbl, attributeName)
  if type(zhuijiaTbl[attributeName]) == "number" and zhuijiaTbl[attributeName] <= 0 then
    return false
  end
  if type(zhuijiaTbl[attributeName] == "table") and self:CheckHaveCareerAttribute(zhuijiaTbl[attributeName], RoleUtility.GetBasicCareer(RoleManager.me.career)) == false then
    return false
  end
  return true
end

function Equip_ZhuijiaUI:CheckHaveCareerAttribute(attributeTbl, career)
  if type(attributeTbl) ~= "table" then
    return false
  end
  for k, v in pairs(attributeTbl) do
    if type(v) ~= "table" or #v < 2 then
      return false
    end
    if v[1] == career then
      return true
    end
  end
  return false
end

function Equip_ZhuijiaUI:SetAttributeItemInfo(k, v)
  self[k].transform.parent.gameObject:SetActive(true)
  local career = RoleUtility.GetBasicCareer(RoleManager.me.career)
  local num = self.IntensifyTable[v]
  local str, value, value2
  if v == "healthRecoveryMultiplier" then
    value = num / 100
  elseif v == "minimumPhysBaseDmg" then
    value = num ~= nil and AttributeUtility.GetAttributeValue(num, career) or 0
    value2 = self.IntensifyTable.maximumPhysBaseDmg ~= nil and AttributeUtility.GetAttributeValue(self.IntensifyTable.maximumPhysBaseDmg, career) or 0
  elseif v == "career_minimumPhysBaseDmg" then
    value = num ~= nil and AttributeUtility.GetAttributeValue(num, career) or 0
    value2 = self.IntensifyTable.career_maximumPhysBaseDmg ~= nil and AttributeUtility.GetAttributeValue(self.IntensifyTable.career_maximumPhysBaseDmg, career) or 0
  elseif v == "minimumWizBaseDmg" then
    value = num ~= nil and AttributeUtility.GetAttributeValue(num, career) or 0
    value2 = self.IntensifyTable.maximumWizBaseDmg ~= nil and AttributeUtility.GetAttributeValue(self.IntensifyTable.maximumWizBaseDmg, career) or 0
  elseif v == "career_minimumWizBaseDmg" then
    value = num ~= nil and AttributeUtility.GetAttributeValue(num, career) or 0
    value2 = self.IntensifyTable.career_maximumWizBaseDmg ~= nil and AttributeUtility.GetAttributeValue(self.IntensifyTable.career_maximumWizBaseDmg, career) or 0
  elseif v == "career_minimumCurseBaseDmg" then
    value = num ~= nil and AttributeUtility.GetAttributeValue(num, career) or 0
    value2 = self.IntensifyTable.career_maximumCurseBaseDmg ~= nil and AttributeUtility.GetAttributeValue(self.IntensifyTable.career_maximumCurseBaseDmg, career) or 0
  elseif v == "career_defenseBase" then
    value = num ~= nil and AttributeUtility.GetAttributeValue(num, career) or 0
  else
    value = num
  end
  str = self:CombineAttributeDes(v, value, value2)
  self[k]:SetText(str)
  if self.LastIntensifyTable then
    local NextNum = self.LastIntensifyTable[v]
    self[k .. "next"]:SetActive(NextNum and NextNum ~= 0)
    if NextNum and NextNum ~= 0 then
      local str2, value2, value22
      if v == "healthRecoveryMultiplier" then
        value2 = NextNum / 100
      elseif v == "minimumPhysBaseDmg" then
        value2 = NextNum ~= nil and AttributeUtility.GetAttributeValue(NextNum, career) or 0
        value22 = self.LastIntensifyTable.maximumPhysBaseDmg ~= nil and AttributeUtility.GetAttributeValue(self.LastIntensifyTable.maximumPhysBaseDmg, career) or 0
      elseif v == "minimumWizBaseDmg" then
        value2 = NextNum ~= nil and AttributeUtility.GetAttributeValue(NextNum, career) or 0
        value22 = self.LastIntensifyTable.maximumWizBaseDmg ~= nil and AttributeUtility.GetAttributeValue(self.LastIntensifyTable.maximumWizBaseDmg, career) or 0
      elseif v == "minimumCurseBaseDmg" then
        value2 = NextNum ~= nil and AttributeUtility.GetAttributeValue(NextNum, career) or 0
        value22 = self.LastIntensifyTable.maximumCurseBaseDmg ~= nil and AttributeUtility.GetAttributeValue(self.LastIntensifyTable.maximumCurseBaseDmg, career) or 0
      elseif v == "career_minimumPhysBaseDmg" then
        value2 = NextNum ~= nil and AttributeUtility.GetAttributeValue(NextNum, career) or 0
        value22 = self.LastIntensifyTable.career_maximumPhysBaseDmg ~= nil and AttributeUtility.GetAttributeValue(self.LastIntensifyTable.career_maximumPhysBaseDmg, career) or 0
      elseif v == "career_minimumWizBaseDmg" then
        value2 = NextNum ~= nil and AttributeUtility.GetAttributeValue(NextNum, career) or 0
        value22 = self.LastIntensifyTable.career_maximumWizBaseDmg ~= nil and AttributeUtility.GetAttributeValue(self.LastIntensifyTable.career_maximumWizBaseDmg, career) or 0
      elseif v == "career_minimumCurseBaseDmg" then
        value2 = NextNum ~= nil and AttributeUtility.GetAttributeValue(NextNum, career) or 0
        value22 = self.LastIntensifyTable.career_maximumCurseBaseDmg ~= nil and AttributeUtility.GetAttributeValue(self.LastIntensifyTable.career_maximumCurseBaseDmg, career) or 0
      elseif v == "career_defenseBase" then
        value2 = NextNum ~= nil and AttributeUtility.GetAttributeValue(NextNum, career) or 0
      else
        value2 = NextNum
      end
      str2 = self:CombineAttributeDes(v, value2, value22)
      self[k .. "next"]:SetText(str2)
    end
  end
  self[k .. "next"]:SetActive(self.LastIntensifyTable)
  if self[k .. "jiantou"] then
    self[k .. "jiantou"]:SetActive(self.LastIntensifyTable)
  end
end

function Equip_ZhuijiaUI:CombineAttributeDes(attributeName, ...)
  if (...) == nil then
    return
  end
  return string.format(AttributeUtility.GetAttributeFormatDes(attributeName), ...)
end

function Equip_ZhuijiaUI:SetDownInfo(cfgEquipItem, EquipData)
  if not self.IntensifyTable then
    return
  end
  if self.IntensifyTable.rate == 0 or self.IntensifyTable.cost == "" then
    self.Img_maxlevel:SetActive(true)
    self.lab_material:SetActive(false)
    self.lab_successRate:SetActive(false)
    self.btn_zhuijia:SetActive(false)
    self.img_material:SetActive(false)
    self.lab_failuretips:SetActive(false)
    self.img_level:SetActive(false)
    self.lab_level:SetActive(false)
    return
  end
  self.lab_material:SetActive(true)
  self.lab_successRate:SetActive(true)
  self.btn_zhuijia:SetActive(true)
  self.Img_maxlevel:SetActive(false)
  self.img_material:SetActive(true)
  local strFailure = string.format("Th\225\186\165t b\225\186\161i quay v\225\187\129 Lv.%d", self.IntensifyTable.fail or 0)
  self.lab_failuretips:SetText(strFailure)
  local isShowFail = 0 < self.IntensifyTable.fail
  self.lab_failuretips:SetActive(isShowFail)
  local cost = string.split(self.IntensifyTable.cost, "&")
  local goldText = cost[table.count(cost)]
  for i = 1, table.count(self.NeedMaterials) do
    local obj = self.NeedMaterials[i]
    if i <= table.count(cost) then
      local itemTbl = string.split(cost[i], "#")
      local id = tonumber(itemTbl[1])
      local itemData = ItemUtility.GenerateItemData(id)
      local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
      if not self.cellData[i] then
        self.cellData[i] = ItemCellData()
      end
      self.cellData[i]:RefreshData(itemData)
      ItemUtility.ShowItemCell(obj, self.cellData[i], self, true)
      local strColor = bagCount >= tonumber(itemTbl[2]) and "#00FF00" or "#FF0000"
      local strBag = Mathf.NumberShowFormat(bagCount, 1)
      local countT = Mathf.NumberShowFormat(tonumber(itemTbl[2]), 1)
      local countStr
      countStr = string.format("%s%s", string.GetColorText(strBag, strColor), string.GetColorText(string.format("/%s", countT), ItemQuality2ColorDic[EItemColorEnum.white]))
      obj.countCtr:SetText(countStr)
      obj.countCtr:SetActive(true)
      obj.nameCtr:SetText(itemData.tblItem.name)
      obj.nameCtr:SetActive(true)
      local isShow = bagCount < tonumber(itemTbl[2])
      local btn_get = UIControl(obj.transform, "btn_obtain")
      btn_get.itemData = ItemUtility.GenerateItemData(id)
      btn_get.OpenTipsType = EOpenTipsType.FastBuy
      btn_get:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
      btn_get:SetActive(isShow)
      obj:SetActive(true)
    else
      obj:SetActive(false)
    end
  end
end

function Equip_ZhuijiaUI:SetConditionInfo(cfgEquipItem, EquipData)
  if not self.IntensifyTable then
    return
  end
  local isShowConditionInfo = false
  if self.IntensifyTable.condition then
    local condition = self.IntensifyTable.condition
    local param1 = condition[1]
    local param2 = condition[2]
    if param1 == 1009 then
      local equipClass = cfgEquipItem.equipClass
      local strColor = param2 <= equipClass and "#00FF00" or "#FF0000"
      local countStr = string.format("%s%s", string.GetColorText(equipClass, strColor), string.GetColorText(string.format("/%s", param2), ItemQuality2ColorDic[EItemColorEnum.white]))
      self.lab_name:SetText("C\225\186\165p b\225\186\173c Trang B\225\187\139 \196\145\225\186\161t ")
      self.lab_num:SetText(countStr)
      isShowConditionInfo = true
    elseif param1 == 3200 then
      local quality = EquipData.tblItem.quality
      local strColor = param2 < quality and "#00FF00" or "#FF0000"
      local countStr = string.format("%s%s", string.GetColorText(quality, strColor), string.GetColorText(string.format("/%s", param2 + 1), ItemQuality2ColorDic[EItemColorEnum.white]))
      self.lab_name:SetText("C\225\186\165p C\195\161nh hi\225\187\135n t\225\186\161i")
      self.lab_num:SetText(countStr)
      isShowConditionInfo = true
    end
  end
  self.img_level:SetActive(isShowConditionInfo)
  self.lab_level:SetActive(isShowConditionInfo)
end

function Equip_ZhuijiaUI:LoadEquipModel(itemdata)
  local itemCtr = ItemUtility.InitItemCell(self.btn_3DItem)
  local isOr = itemdata.tblItem.subType == EItemSubtype.Ring or itemdata.tblItem.subType == EItemSubtype.Necklace or itemdata.tblItem.subType == EItemSubtype.Earrings
  local scale = isOr and 2 or 1
  itemCtr.go_model:SetLocalScale(scale)
  if not self.itemCellData then
    self.itemCellData = ItemCellData()
  end
  self.itemCellData:RefreshData(itemdata)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.itemCellData, self, true)
end

function Equip_ZhuijiaUI:InitShowModel(itemdata)
  Equip_ForgeNavUi.InitShowModel(self, itemdata)
end

function Equip_ZhuijiaUI:HideEquipObj()
  if self.itemCellData then
    self.itemCellData.itemData = nil
    ItemUtility.ShowItemCell(self.btn_3DItem, self.itemCellData, self)
  end
end

function Equip_ZhuijiaUI:DestroyEquipObj()
  if self.LoadEquipObject then
    local go = self.LoadEquipObject
    self.LoadEquipObject = nil
  end
  self.equipPool = {}
end

function Equip_ZhuijiaUI:GetAttributeNameByType(intType)
  for k, v in pairs(EAttributeType) do
    if v == intType then
      return k
    end
  end
end

function Equip_ZhuijiaUI:GetEquipMasterData()
  local Tab = ClientTable.cfg_Equip_masterManager:GetDic()
  local dataTab = {}
  for k, v in pairs(Tab) do
    if string.contains(v.career, RoleUtility.GetBasicCareer(RoleManager.me.career)) and v.type == 2 then
      table.insert(dataTab, v)
      if not self:IsCompleteIntensify(v.index, v.goalCount) then
        return dataTab
      end
    end
  end
  return dataTab
end

function Equip_ZhuijiaUI:IsCompleteIntensify(bagIndex, level)
  local strTab = string.split(bagIndex, "#")
  local totalLevel = 0
  local equipData = ViewData.meData.equipsData.Data
  for i = 1, table.count(strTab) do
    if equipData[tonumber(strTab[i])] and equipData[tonumber(strTab[i])].additional then
      totalLevel = totalLevel + equipData[tonumber(strTab[i])].additional
    end
  end
  return level <= totalLevel
end

function Equip_ZhuijiaUI:ZhuiJiaCalculateResultChange()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.Bag_EquipInfoUI
  })
end
