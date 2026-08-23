Equip_IntensifyUI = class(BaseUI)
Equip_IntensifyUI.layer = UILayer.Panel
Equip_IntensifyUI.orderInLayer = 1
Equip_IntensifyUI.hideType = UIHideType.WaitDestroy
Equip_IntensifyUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_IntensifyUI.escClose = UIEscClose.DontClose

function Equip_IntensifyUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.img_intensifylevel = self:GetControl("bg_equip/img_equipbg/img_intensifylevel")
  self.img_intensifylevelnext = self:GetControl("bg_equip/img_equipbg/img_intensifylevelnext")
  self.img_arrow = self:GetControl("bg_equip/img_equipbg/img_arrow")
  self.btn_check = self:GetControl("bg_equip/img_equipbg/img_appearanceChange/btn_check")
  self.lab_lgTxt = self:GetControl("bg_equip/img_equipbg/img_appearanceChange/btn_check/lab_lgTxt")
  self.frame_equip = self:GetControl("bg_equip/frame_equip")
  self.content = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content")
  self.text_curse = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_curseP/lab_curse/text_curse")
  self.text_curseArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_curseP/lab_curse/text_curseArrow")
  self.text_cursenext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_curseP/lab_curse/text_cursenext")
  self.text_curseimg = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_curseP/lab_curse/text_curseimg")
  self.text_atk = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_atkP/lab_atk/text_atk")
  self.text_atkArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_atkP/lab_atk/text_atkArrow")
  self.text_atknext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_atkP/lab_atk/text_atknext")
  self.text_atkimg = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_atkP/lab_atk/text_atkimg")
  self.text_hp = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_hp/lab_hp/text_hp")
  self.text_hpArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_hp/lab_hp/text_hpArrow")
  self.text_hpnext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_hp/lab_hp/text_hpnext")
  self.text_hpimg = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_hp/lab_hp/text_hpimg")
  self.text_def = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defP/lab_def/text_def")
  self.text_defArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defP/lab_def/text_defArrow")
  self.text_defnext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defP/lab_def/text_defnext")
  self.text_defimg = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defP/lab_def/text_defimg")
  self.text_defenseRate = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defenseRateP/lab_defenseRate/text_defenseRate")
  self.text_defenseRateArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defenseRateP/lab_defenseRate/text_defenseRateArrow")
  self.text_defenseRatenext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defenseRateP/lab_defenseRate/text_defenseRatenext")
  self.text_defenseRateimg = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defenseRateP/lab_defenseRate/text_defenseRateimg")
  self.text_magic = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_magicP/lab_magic/text_magic")
  self.text_magicArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_magicP/lab_magic/text_magicArrow")
  self.text_magicnext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_magicP/lab_magic/text_magicnext")
  self.text_magicimg = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_magicP/lab_magic/text_magicimg")
  self.text_damageReceive = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_damageReceiveP/lab_damageReceive/text_damageReceive")
  self.text_damageReceiveArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_damageReceiveP/lab_damageReceive/text_damageReceiveArrow")
  self.text_damageReceivenext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_damageReceiveP/lab_damageReceive/text_damageReceivenext")
  self.text_damageReceiveimg = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_damageReceiveP/lab_damageReceive/text_damageReceiveimg")
  self.lab_movespeedP = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_movespeedP")
  self.lab_movespeed = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_movespeedP/lab_movespeed")
  self.text_movespeed = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_movespeedP/lab_movespeed/text_movespeed")
  self.text_movespeedArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_movespeedP/lab_movespeed/text_movespeedArrow")
  self.text_movespeednext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_movespeedP/lab_movespeed/text_movespeednext")
  self.text_movespeedimg = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_movespeedP/lab_movespeed/text_movespeedimg")
  self.lab_appearanceChange = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_appearanceChange")
  self.text_Change = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_appearanceChange/lab_appearanceImag/lab_appearance/text_Change")
  self.btn_3DItem = self:GetControl("bg_equip/btn_3DItem")
  self.lab_material = self:GetControl("bg_equip/lab_material")
  self.text_gold = self:GetControl("bg_equip/lab_material/lab_gold/text_gold")
  self.frame_item1 = self:GetControl("bg_equip/lab_material/materialParent/frame_item1")
  self.frame_item2 = self:GetControl("bg_equip/lab_material/materialParent/frame_item2")
  self.frame_item3 = self:GetControl("bg_equip/lab_material/materialParent/frame_item3")
  self.frame_item4 = self:GetControl("bg_equip/lab_material/materialParent/frame_item4")
  self.text_successRate = self:GetControl("bg_equip/lab_material/text_successRate")
  self.img_successrate = self:GetControl("bg_equip/lab_material/img_successrate")
  self.img_successratetxt = self:GetControl("bg_equip/lab_material/img_successrate/img_successratetxt")
  self.btn_intensify = self:GetControl("bg_equip/btn_intensify")
  self.text_intensify = self:GetControl("bg_equip/btn_intensify/text_intensify")
  self.img_level = self:GetControl("bg_equip/img_level")
  self.lab_level = self:GetControl("bg_equip/lab_level")
  self.lab_name = self:GetControl("bg_equip/lab_level/lab_name")
  self.lab_num = self:GetControl("bg_equip/lab_level/lab_num")
  self.SubPanelRoot = self:GetControl("SubPanelRoot")
  self.lab_item = self:GetControl("bg_item/lab_item")
  self.btn_zhuanyi = self:GetControl("btn_zhuanyi")
  self.Img_maxlevel = self:GetControl("Img_maxlevel")
  self.descBtn = self:GetControl("descBtn")
  self.lab_failuretips = self:GetControl("lab_failuretips")
  self.Img_noequip = self:GetControl("Img_noequip")
  self.plane_top = self:GetControl("Img_noequip/plane_top")
  self.Img_noequip1 = self:GetControl("Img_noequip/Img_noequip1")
  self.panel_role = self:GetControl("toggle/panel_role")
  self.panel_red = self:GetControl("toggle/panel_red")
  self.panel_bag = self:GetControl("toggle/panel_bag")
  self.btn_role = self:GetControl("toggle/panel_role/btn_role")
  self.btn_red = self:GetControl("toggle/panel_red/btn_red")
  self.btn_bag = self:GetControl("toggle/panel_bag/btn_bag")
  self.btn_masterattribute = self:GetControl("btn_masterattribute")
  self.Scroll_Master = self:GetControl("btn_masterattribute/Scroll_Master")
  self.btn_masterClose = self:GetControl("btn_masterattribute/Scroll_Master/btn_masterClose")
  self.item_master = self:GetControl("btn_masterattribute/Scroll_Master/Viewport/Content/item_master")
  self.btn_close = self:GetControl("btn_close")
  self.btn_redmasterattribute = self:GetControl("btn_redmasterattribute")
end

function Equip_IntensifyUI:Init()
  self.equipPool = {}
  self.isCheck = false
end

function Equip_IntensifyUI:OnCreate()
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
  local value = data.extraIntensifyAttributeIncrease / 100
  local percent = math.floor(value * 10 + 0.5) / 10
  if ui:IsCompleteIntensify(data.index, data.goalCount) then
    name = string.GetColorText(LocalizationUtility.GetContentByKey("EquipMaster1"), ItemQuality2ColorDic[EItemColorEnum.white])
    name = string.format(name, string.GetColorText(data.goalCount, ItemQuality2ColorDic[EItemColorEnum.green]))
    attribute = string.GetColorText(LocalizationUtility.GetContentByKey("EquipMaster2"), ItemQuality2ColorDic[EItemColorEnum.white])
    attribute = string.format(attribute, string.GetColorText(percent, ItemQuality2ColorDic[EItemColorEnum.yellow]), string.GetColorText("%", ItemQuality2ColorDic[EItemColorEnum.yellow]))
  else
    name = string.GetColorText(string.format(LocalizationUtility.GetContentByKey("EquipMaster1"), data.goalCount), ItemQuality2ColorDic[EItemColorEnum.dark])
    attribute = string.GetColorText(string.format(LocalizationUtility.GetContentByKey("EquipMaster2"), percent, "%"), ItemQuality2ColorDic[EItemColorEnum.dark])
  end
  ctr:GetChild("lab_bg"):SetActive(_ % 2 == 1)
  lab_name:SetText(name)
  lab_attribute:SetText(attribute)
end

function Equip_IntensifyUI:InitUI()
  self.NeedMaterials = {
    self.frame_item1,
    self.frame_item2,
    self.frame_item3,
    self.frame_item4
  }
  self.cellData = {}
  self.AttributeInfoTab = {
    text_atk = {
      "career_minimumPhysBaseDmg",
      "career_maximumPhysBaseDmg"
    },
    text_magic = {
      "career_minimumWizBaseDmg",
      "career_maximumWizBaseDmg"
    },
    text_def = {
      "career_defenseBase"
    },
    text_damageReceive = {
      "career_damageReceiveDecrement"
    },
    text_hp = {
      "career_maximumHealth"
    },
    text_curse = {
      "career_minimumCurseBaseDmg",
      "career_maximumCurseBaseDmg"
    }
  }
  self.itemMasterContain = UIContainer(self.item_master, self, OnItemMaterInit, OnItemMaterRefresh)
end

function Equip_IntensifyUI:OnShow()
  EquipeInfoData.curView = UIID.Equip_IntensifyUI
  self:RegistEvents()
  self:Refresh()
end

function Equip_IntensifyUI:OnHide()
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

function Equip_IntensifyUI:OnDestroy()
  self:DestroyEquipObj()
end

function Equip_IntensifyUI:RegistUIEvents()
  self.img_Bg2:SetOnPointerDown(self, function(control, eventData)
    UIManager.Hide(UIID.Equip_IntensifyUI)
  end)
  self.btn_close:SetOnClick(self, function(control, eventData)
    UIManager.Hide(UIID.Equip_IntensifyUI)
  end)
  self.btn_intensify:SetOnClick(self, self.EquipIntensifyFunc)
  self.btn_role:SetOnToggleChanged(self, self.BtnSelectTag)
  self.btn_bag:SetOnToggleChanged(self, self.BtnSelectTag)
  self.btn_red:SetOnToggleChanged(self, self.BtnSelectTag)
  self.btn_zhuanyi:SetOnClick(self, self.btn_zhuanyiOnClick)
  self.btn_check:SetOnClick(self, self.btn_CheckOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_masterattribute:SetOnClick(self, self.BtnMasterOnClick)
  self.btn_redmasterattribute:SetOnClick(self, self.BtnMasterSuitOnClick)
end

function Equip_IntensifyUI:BtnMasterOnClick()
  UIManager.Show(UIID.Tip_CommonTipsUI, {
    showType = CommonTipsEnum.Intensify
  })
end

function Equip_IntensifyUI:BtnMasterSuitOnClick()
  UIManager.Show(UIID.Tip_CommonTipsUI, {
    showType = CommonTipsEnum.Intensify_Suit
  })
end

function Equip_IntensifyUI:BtnMasterCloseOnClick()
  self.Scroll_Master:SetActive(false)
end

function Equip_IntensifyUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_IntensifyUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Equip_IntensifyUI:BtnSelectTag(control)
  if not control then
    return
  end
  if control.gameObject.name == "btn_role" and control:GetIsOn() then
    UIManager.Show(UIID.Bag_EquipInfoUI)
    local equipChangeInfo = {}
    equipChangeInfo.cellType = EquipCellType.NORMAL
    equipChangeInfo.from = UIID.Equip_IntensifyUI
    EventManager.Dispatch(Event.SuitEquipChange, equipChangeInfo)
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      type = ERedPointType.Bag_EquipInfoUI
    })
  elseif control.gameObject.name == "btn_bag" and control:GetIsOn() then
    UIManager.Show(UIID.NewBagInfoUI)
  elseif control.gameObject.name == "btn_red" and control:GetIsOn() then
    UIManager.Show(UIID.Bag_EquipInfoUI)
    EventManager.Dispatch(Event.SuitEquipChange, {
      cellType = EquipCellType.HONGZHUANG,
      from = UIID.Equip_IntensifyUI
    })
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      type = ERedPointType.Bag_EquipInfoUI
    })
  end
end

function Equip_IntensifyUI:btn_zhuanyiOnClick()
  UIManager.Show(UIID.Equip_Transfer, {
    resetLogic = 1,
    OpenType = TransferOpenType.Intensify
  })
  EventManager.Dispatch(Event.RefreshBagEquip, UIID.Equip_Transfer)
end

function Equip_IntensifyUI:btn_CheckOnClick()
  if self.isCheck then
    if self.itemCellData and self.itemCellData.model.modelObject then
      EquipEffectSet:SetModelEffecByIntensify(self.EquipData, self.itemCellData.model.modelObject)
    end
    self.lab_lgTxt:SetActive(false)
  elseif self.itemCellData and self.itemCellData.model.modelObject then
    local dataTab = {}
    dataTab.intensify = self.IntensifyTable.apperanceChangeTips
    dataTab.tblEquip = self.EquipData.tblEquip
    EquipEffectSet:SetModelEffecByIntensify(dataTab, self.itemCellData.model.modelObject)
    local grade = self.IntensifyTable.apperanceChangeTips
    if grade < 7 then
      grade = 7
    end
    self.lab_lgTxt:SetText(string.format("C%dB", grade))
    self.lab_lgTxt:SetActive(true)
  end
  self.isCheck = not self.isCheck
end

function Equip_IntensifyUI:EquipIntensifyFunc(control)
  self.isCheck = false
  if not self.EquipData then
    return
  end
  local equipId = self.EquipData.id
  if not self:IsMeetCondition() then
    return
  end
  MeEquipController.ReqEquipIntensify(equipId)
end

function Equip_IntensifyUI:BtnOnClickEquip(control)
  if not self.EquipData then
    return
  end
  UIManager.Show(UIID.ItemTipUI, {
    item = self.EquipData,
    rightOperate = EItemOperateType.Show,
    ctrl = control
  })
end

function Equip_IntensifyUI:RegistEvents()
  self:RegistEvent(Event.SelectedForgeEquip, self.SelectedStrengthenEquip, self)
  self:RegistEvent(Event.Equip_IntensifyEffect, self.Equip_IntensifyEffect, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
  self:RegistEvent(Event.EquipBtnClick, self.OnEquipBtnClick, self)
end

function Equip_IntensifyUI:SelectedStrengthenEquip(id, msg)
  self.isCheck = false
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
  self:SetEquipIntensifyInfo(equipData, msg[2])
end

function Equip_IntensifyUI:EquipAttriUpdate(id, msg)
  if msg then
    self:UpdateEquipIntensifyInfo(msg)
  end
end

function Equip_IntensifyUI:Refresh()
  if self.Scroll_Master:GetActive() then
    self.Scroll_Master:SetActive(false)
  end
  self:RefreshSuitEntry()
  self.lab_lgTxt:SetActive(false)
  local equipData = ViewData.meData.equipsData.Data
  if self.args and self.args.itemData then
    if self.args.openType == TipsOpenType.RoleEquipOpen then
      if not UIManager.IsVisible(UIID.Bag_EquipInfoUI) then
        UIManager.Show(UIID.Bag_EquipInfoUI)
      end
      self.btn_role:SetIsOn(true)
    elseif self.args.openType == TipsOpenType.RoleRedEquipOpen then
      if not UIManager.IsVisible(UIID.Bag_EquipInfoUI) then
        UIManager.Show(UIID.Bag_EquipInfoUI)
      end
      self.btn_red:SetIsOn(true)
    elseif self.args.openType == TipsOpenType.BagOpen then
      if not UIManager.IsVisible(UIID.NewBagInfoUI) then
        UIManager.Show(UIID.NewBagInfoUI)
      end
      self.btn_bag:SetIsOn(true)
    end
    EventManager.Dispatch(Event.Equip_ChangeEquipSelect, self.args.itemData)
    self:SelectedStrengthenEquip(nil, {
      self.args.itemData,
      self.args.itemData
    })
  elseif self.args and self.args.openSecondTab ~= nil and equipData[self.args.openSecondTab] then
    EventManager.Dispatch(Event.Equip_ChangeEquipSelect, equipData[self.args.openSecondTab])
    self.btn_role:SetIsOn(true)
    self:SelectedStrengthenEquip(nil, {
      equipData[self.args.openSecondTab],
      self.args.openSecondTab
    })
  else
    self.btn_role:SetIsOn(true)
    EventManager.Dispatch(Event.EquipForgeUIChange)
  end
end

function Equip_IntensifyUI:RefreshSuitEntry()
  local systemIsOpen = FucShowOrHideController.FuncSystemIsOpen(FunctionSystemEnumId.Intensify_Suit)
  self.btn_redmasterattribute:SetActive(systemIsOpen)
  self.btn_red:SetActive(systemIsOpen)
end

function Equip_IntensifyUI:SetEquipIntensifyInfo(EquipData, index)
  self.EquipIndex = index
  self.EquipData = EquipData
  local itemId = EquipData.itemId
  if not EquipData.tblEquip then
    return
  end
  self.IntensifyTable = MeEquipController.GetEquipIntensifyCfgByEquipData(EquipData)
  if not self.IntensifyTable then
    return
  end
  self.LastIntensifyTable = MeEquipController.GetEquipIntensifyCfg(EquipData.itemId, EquipData.intensify + 1 or 0)
  if not self.LastIntensifyTable then
    self.LastIntensifyTable = MeEquipController.GetEquipIntensifyCfg(EquipData.tblItem.subType, EquipData.intensify + 1 or 0)
  end
  self:SetEquipBasics(EquipData.tblEquip, EquipData)
  self:SetAttributeInfo(EquipData)
  self:SetDownInfo(EquipData.tblEquip, EquipData)
  self:SetConditionInfo(EquipData.tblEquip, EquipData)
  self:SetDownInfo(EquipData.tblEquip, EquipData)
  self:LoadEquipModel(EquipData)
end

function Equip_IntensifyUI:UpdateEquipIntensifyInfo(EquipData)
  self.EquipData = EquipData
  local itemId = EquipData.itemId
  if not EquipData.tblEquip then
    return
  end
  self.IntensifyTable = MeEquipController.GetEquipIntensifyCfgByEquipData(EquipData)
  if not self.IntensifyTable then
    logError("B\225\186\163ng cfg_Item_equip_intensify kh\195\180ng c\195\179 trang b\225\187\139 n\195\160y==" .. EquipData.tblItem.name)
    return
  end
  self.LastIntensifyTable = MeEquipController.GetEquipIntensifyCfg(EquipData.itemId, EquipData.intensify + 1 or 0)
  if not self.LastIntensifyTable then
    self.LastIntensifyTable = MeEquipController.GetEquipIntensifyCfg(EquipData.tblItem.subType, EquipData.intensify + 1 or 0)
  end
  self:SetEquipBasics(EquipData.tblEquip, EquipData)
  self:SetAttributeInfo(EquipData)
  self:SetDownInfo(EquipData.tblEquip, EquipData)
  self:SetConditionInfo(EquipData.tblEquip, EquipData)
end

function Equip_IntensifyUI:SetEquipBasics(cfgItem, EquipData)
  local strName = cfgItem.name
  local level = "+" .. 0
  local levelNext = "+" .. 1
  if EquipData.intensify and 0 < EquipData.intensify then
    strName = string.format("%s +%d", cfgItem.name, EquipData.intensify)
    level = "+" .. EquipData.intensify
    levelNext = "+" .. EquipData.intensify + 1
  end
  local titleStr = RoleEquipUtility.GetEquipNameColor(strName, EquipData)
  self.lab_item:SetText(titleStr)
  self.img_intensifylevel:SetText(level)
  self.img_intensifylevelnext:SetText(levelNext)
  local k = EquipData.tblItem.subType
  if k == EItemSubtype.Earrings or k == EItemSubtype.Necklace or k == EItemSubtype.Ring or k == EItemSubtype.Wing then
    self.btn_check:SetActive(false)
  elseif EquipData.intensify and self.IntensifyTable and EquipData.intensify >= self.IntensifyTable.apperanceChangeTips then
    self.btn_check:SetActive(false)
  else
    self.btn_check:SetActive(true)
  end
  self.lab_lgTxt:SetActive(false)
end

function Equip_IntensifyUI:SetAttributeInfo(EquipData)
  if not self.IntensifyTable then
    return
  end
  local rate = self.IntensifyTable.rateClient
  if rate then
    local strColor = 10000 <= rate and "#00FF00" or "#FF0000"
    if rate / 100 == Mathf.Floor(rate / 100) then
      self.img_successratetxt:SetText(Mathf.Floor(rate / 100) .. "A")
    elseif rate / 10 == Mathf.Floor(rate / 10) then
      self.img_successratetxt:SetText(string.format("%.1fA", rate / 100))
    else
      self.img_successratetxt:SetText(string.format("%.2fA", rate / 100))
    end
  end
  local changeTip = self.IntensifyTable.apperanceChangeTips
  local strFormat = ""
  self.text_Change:SetText(changeTip)
  for k, v in pairs(self.AttributeInfoTab) do
    local attributeDes = TableParse:GetAttributeValueDes(self.IntensifyTable, v)
    if string.isNullOrEmpty(attributeDes) then
      self[k].transform.parent.parent.gameObject:SetActive(false)
    else
      self[k]:SetText(attributeDes)
      local nextAttribute = self.LastIntensifyTable and TableParse:GetAttributeValueDes(self.LastIntensifyTable, v)
      local haveNextValue = string.isNullOrEmpty(nextAttribute) == false
      if haveNextValue then
        self[k .. "next"]:SetText(nextAttribute)
        self[k].transform.anchoredPosition = Vector2(74, 0)
      else
        self[k].transform.anchoredPosition = Vector2(141, 0)
      end
      self[k .. "next"]:SetActive(haveNextValue)
      self[k .. "Arrow"]:SetActive(haveNextValue)
      self[k].transform.parent.parent.gameObject:SetActive(true)
    end
  end
  self.lab_movespeedP:SetActive(false)
end

function Equip_IntensifyUI:SetDownInfo(cfgEquipItem, EquipData)
  if not self.IntensifyTable then
    return
  end
  if self.IntensifyTable.type == EItemSubtype.Ring or self.IntensifyTable.type == EItemSubtype.Necklace or self.IntensifyTable.type == EItemSubtype.Earrings then
    if self.IntensifyTable.condition then
      local level = self.IntensifyTable.condition[2]
      if self.EquipData.level < tonumber(level) then
        self.lab_material:SetActive(false)
        self.img_successrate:SetActive(false)
        self.btn_intensify:SetActive(false)
        self.img_arrow:SetActive(false)
        self.img_intensifylevelnext:SetActive(false)
        self.lab_failuretips:SetActive(false)
        self.Img_maxlevel:SetActive(true)
        return
      elseif not self.LastIntensifyTable then
        self.lab_material:SetActive(false)
        self.img_successrate:SetActive(false)
        self.btn_intensify:SetActive(false)
        self.lab_failuretips:SetActive(false)
        self.Img_maxlevel:SetActive(true)
        self.img_arrow:SetActive(false)
        self.img_intensifylevelnext:SetActive(false)
        return
      end
    end
  elseif self.LastIntensifyTable == nil then
    self.lab_material:SetActive(false)
    self.img_successrate:SetActive(false)
    self.btn_intensify:SetActive(false)
    self.lab_failuretips:SetActive(false)
    self.Img_maxlevel:SetActive(true)
    self.img_arrow:SetActive(false)
    self.img_intensifylevelnext:SetActive(false)
    return
  end
  self.lab_material:SetActive(true)
  self.img_successrate:SetActive(true)
  self.btn_intensify:SetActive(true)
  self.Img_maxlevel:SetActive(false)
  self.img_arrow:SetActive(true)
  self.img_intensifylevelnext:SetActive(true)
  local strFailure = string.format("Th\225\186\165t b\225\186\161i quay v\225\187\129 Lv.%d", self.IntensifyTable.fail)
  self.lab_failuretips:SetText(strFailure)
  self.lab_failuretips:SetActive(self.IntensifyTable.fail > 0)
  local tempCost = string.split(self.IntensifyTable.cost, "&")
  local cost = {}
  for i = 2, table.count(tempCost) do
    table.insert(cost, tempCost[i])
  end
  table.insert(cost, tempCost[1])
  local goldText = string.split(cost[1], "#")
  self.text_gold:SetText(goldText[2])
  self.costItemInfo = nil
  for i = 1, table.count(self.NeedMaterials) do
    local obj = self.NeedMaterials[i]
    if i <= table.count(cost) then
      local itemTbl = string.split(cost[i], "#")
      local id = tonumber(itemTbl[1])
      local count = tonumber(itemTbl[2])
      local itemData = ItemUtility.GenerateItemData(id)
      local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
      if not self.cellData[i] then
        self.cellData[i] = ItemCellData()
      end
      self.cellData[i]:RefreshData(itemData)
      ItemUtility.ShowItemCell(obj, self.cellData[i], self, true)
      local strColor = count <= bagCount and "#00FF00" or "#FF0000"
      local strBag = Mathf.NumberShowFormat(bagCount, 1)
      local countT = Mathf.NumberShowFormat(count, 1)
      local countStr
      countStr = string.format("%s%s", string.GetColorText(strBag, strColor), string.GetColorText(string.format("/%s", countT), ItemQuality2ColorDic[EItemColorEnum.white]))
      obj.countCtr:SetText(countStr)
      obj.countCtr:SetActive(true)
      obj.nameCtr:SetText(itemData.tblItem.name)
      obj.nameCtr:SetActive(true)
      obj:SetActive(true)
      local btn_get = obj:GetChild("btn_obtain")
      btn_get:SetActive(count > bagCount)
      btn_get.itemData = itemData
      btn_get.OpenTipsType = EOpenTipsType.FastBuy
      btn_get:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
      if not self.costItemInfo and count > bagCount then
        self.costItemInfo = btn_get.itemData
      end
    else
      obj:SetActive(false)
    end
  end
  self:IntensifyCalculateResultChange()
end

function Equip_IntensifyUI:GetItem_equip_intensify(subtype, level)
  local cfg_equip_intensify = ClientTable.cfg_Item_equip_intensifyManager:GetDic()
  for k, v in pairs(cfg_equip_intensify) do
    if v then
    end
  end
end

function Equip_IntensifyUI:SetConditionInfo(cfgEquipItem, EquipData)
  if not self.IntensifyTable then
    return
  end
  local isShowConditionInfo = false
  self.img_level:SetActive(isShowConditionInfo)
  self.lab_level:SetActive(isShowConditionInfo)
end

function Equip_IntensifyUI:LoadEquipModel(itemdata)
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

function Equip_IntensifyUI:InitShowModel(itemdata)
  Equip_ForgeNavUi.InitShowModel(self, itemdata)
end

function Equip_IntensifyUI:HideEquipObj()
  if self.itemCellData then
    self.itemCellData:RecycleRes()
  end
end

function Equip_IntensifyUI:DestroyEquipObj()
  if self.LoadEquipObject then
    local go = self.LoadEquipObject
    self.LoadEquipObject = nil
  end
  self.equipPool = {}
end

function Equip_IntensifyUI:IsMeetCondition()
  if self.IntensifyTable == nil then
    return false
  end
  local tempCost = string.split(self.IntensifyTable.cost, "&")
  local cost = {}
  for i = 2, table.count(tempCost) do
    table.insert(cost, tempCost[i])
  end
  table.insert(cost, tempCost[1])
  for i = 1, table.count(cost) do
    local itemTbl = string.split(cost[i], "#")
    local id = tonumber(itemTbl[1])
    local needCount = tonumber(itemTbl[2])
    local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
    local temp = {}
    temp.itemData = ItemUtility.GenerateItemData(id)
    if needCount > bagCount then
      UIManager.Show(UIID.ItemTipUI, {
        item = temp.itemData,
        rightOperate = EItemOperateType.Show,
        ctrl = temp,
        ShowObtain = true
      })
      return false
    end
  end
  return true
end

function Equip_IntensifyUI:Equip_StartIntensifyTimer()
end

function Equip_IntensifyUI:Equip_StopIntensifyTimer()
end

function Equip_IntensifyUI:Equip_IntensifyEffect(_, data)
  if self.itemCellData and self.itemCellData.model.modelObject then
    EquipEffectSet:SetModelEffecByIntensify(data, self.itemCellData.model.modelObject)
  end
  self:UpdateEquipIntensifyInfo(data)
end

function Equip_IntensifyUI:Btn_ObtainOnClick(control)
  local obtainTab = ClientTable.cfg_Obtain_obtainManager:GetDic()
  for i, v in pairs(obtainTab) do
    if v.id == control.itemId and v.route == control.ui then
      UIManager.Show(v.uiName)
    end
  end
end

function Equip_IntensifyUI:OnBagChange()
  if not self.IntensifyTable then
    return
  end
  local tempCost = string.split(self.IntensifyTable.cost, "&")
  if table.count(tempCost) == 0 then
    return
  end
  local cost = {}
  for i = 2, table.count(tempCost) do
    table.insert(cost, tempCost[i])
  end
  table.insert(cost, tempCost[1])
  local goldText = string.split(cost[1], "#")
  self.text_gold:SetText(goldText[2])
  for i = 1, table.count(self.NeedMaterials) do
    local obj = self.NeedMaterials[i]
    if i <= table.count(cost) then
      local itemTbl = string.split(cost[i], "#")
      local id = tonumber(itemTbl[1])
      local count = tonumber(itemTbl[2])
      local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
      local strColor = count <= bagCount and "#00FF00" or "#FF0000"
      local strBag = Mathf.NumberShowFormat(bagCount, 1)
      local countT = Mathf.NumberShowFormat(count, 1)
      local countStr = string.format("%s%s", string.GetColorText(strBag, strColor), string.GetColorText(string.format("/%s", countT), ItemQuality2ColorDic[EItemColorEnum.white]))
      obj:GetChild("btn_obtain"):SetActive(count > bagCount)
      obj.countCtr:SetText(countStr)
      obj.countCtr:SetActive(true)
      obj:SetActive(true)
    else
      obj:SetActive(false)
    end
  end
  self:IntensifyCalculateResultChange()
end

function Equip_IntensifyUI:OnEquipBtnClick(id, msg)
  if msg == nil then
    return
  end
  if msg == EquipCellType.NORMAL then
    self.btn_role:SetIsOn(true)
  elseif msg == EquipCellType.HONGZHUANG then
    self.btn_red:SetIsOn(true)
  end
end

function Equip_IntensifyUI:GetEquipMasterData()
  local Tab = ClientTable.cfg_Equip_masterManager:GetDic()
  local dataTab = {}
  for k, v in pairs(Tab) do
    if string.contains(v.career, RoleUtility.GetBasicCareer(RoleManager.me.career)) and v.type == 1 then
      table.insert(dataTab, v)
      if not self:IsCompleteIntensify(v.index, v.goalCount) then
        return dataTab
      end
    end
  end
  return dataTab
end

function Equip_IntensifyUI:IsCompleteIntensify(bagIndex, level)
  local strTab = string.split(bagIndex, "#")
  local totalLevel = 0
  local equipData = ViewData.meData.equipsData.Data
  for i = 1, table.count(strTab) do
    if equipData[tonumber(strTab[i])] and equipData[tonumber(strTab[i])].intensify then
      totalLevel = totalLevel + equipData[tonumber(strTab[i])].intensify
    end
  end
  return level <= totalLevel
end

function Equip_IntensifyUI:IntensifyCalculateResultChange()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.Bag_EquipInfoUI
  })
end
