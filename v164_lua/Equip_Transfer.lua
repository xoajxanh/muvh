Equip_Transfer = class(BaseUI)
Equip_Transfer.layer = UILayer.Panel
Equip_Transfer.orderInLayer = 1
Equip_Transfer.hideType = UIHideType.WaitDestroy
Equip_Transfer.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_Transfer.escClose = UIEscClose.DontClose

function Equip_Transfer:InitControls()
  self.bg_equip = self:GetControl("bg_equip")
  self.content = self:GetControl("bg_equip/content")
  self.lab_nowLevel = self:GetControl("bg_equip/content/lab_nowLevel")
  self.text_physBaseDmg = self:GetControl("bg_equip/content/lab_nowLevel/text_physBaseDmg")
  self.lab_nextLevel = self:GetControl("bg_equip/content/lab_nextLevel")
  self.text_defenseBase = self:GetControl("bg_equip/content/lab_nextLevel/text_defenseBase")
  self.lab_goldCost = self:GetControl("bg_equip/lab_goldCost")
  self.lab_goldCostValue = self:GetControl("bg_equip/lab_goldCost/lab_goldCostValue")
  self.goldicon = self:GetControl("bg_equip/goldicon")
  self.frame_item = self:GetControl("bg_equip/goldicon/frame_item")
  self.tog_intensify = self:GetControl("bg_equip/tog_intensify")
  self.tog_add = self:GetControl("bg_equip/tog_add")
  self.img_intensigyDark = self:GetControl("bg_equip/imag_parent/img_intensigyDark")
  self.img_intensigyLight = self:GetControl("bg_equip/imag_parent/img_intensigyLight")
  self.img_addDark = self:GetControl("bg_equip/imag_parent/img_addDark")
  self.img_addLight = self:GetControl("bg_equip/imag_parent/img_addLight")
  self.text_warning = self:GetControl("bg_equip/tips/text_warning")
  self.text_chooseFisrtEquip = self:GetControl("bg_equip/tips/text_chooseFisrtEquip")
  self.text_chooseSecondEquip = self:GetControl("bg_equip/tips/text_chooseSecondEquip")
  self.lab_item = self:GetControl("bg_equip/lab_item")
  self.fisrtframe = self:GetControl("bg_equip/fisrtframe")
  self.secondframe = self:GetControl("bg_equip/secondframe")
  self.selectSecond = self:GetControl("bg_equip/img_zhuanyiframe/selectSecond")
  self.selectMain = self:GetControl("bg_equip/img_zhuanyiframe/selectMain")
  self.btn_MainParent = self:GetControl("bg_equip/btn_MainParent")
  self.btn_SecondParent = self:GetControl("bg_equip/btn_SecondParent")
  self.btn_zhuanyi = self:GetControl("bg_equip/btn_zhuanyi")
  self.text_zhuijia = self:GetControl("bg_equip/btn_zhuanyi/text_zhuijia")
  self.Eff_UI_xinanniu = self:GetControl("bg_equip/btn_zhuanyi/Eff_UI_xinanniu")
  self.btn_close = self:GetControl("bg_equip/btn_close")
  self.btn_role = self:GetControl("bg_equip/panel_role/btn_role")
  self.btn_bag = self:GetControl("bg_equip/panel_bag/btn_bag")
  self.btn_return = self:GetControl("bg_equip/btn_return")
  self.lab_return = self:GetControl("bg_equip/btn_return/lab_return")
  self.btn_xiexia = self:GetControl("bg_equip/btn_xiexia")
  self.btn_xiexia_right = self:GetControl("bg_equip/btn_xiexia_right")
  self.descBtn = self:GetControl("descBtn")
  self.img_btn_l = self:GetControl("img_btn_l")
  self.img_btn_r = self:GetControl("img_btn_r")
  self.txt_tip_r = self:GetControl("txt_tip_r")
  self.txt_tip_l = self:GetControl("txt_tip_l")
  self.costInfoUI = self:GetControl("costInfoUI")
  self.Content = self:GetControl("costInfoUI/Viewport/Content")
  self.sellProfit = self:GetControl("costInfoUI/Viewport/Content/sellProfit")
  self.btn_getCost = self:GetControl("costInfoUI/btn_getCost")
  self.costItem = self:GetControl("costInfoUI/costItem")
  self.tog_regene = self:GetControl("bg_equip/tog_regene")
  self.img_regeneDark = self:GetControl("bg_equip/imag_parent/img_regeneDark")
  self.img_regeneLight = self:GetControl("bg_equip/imag_parent/img_regeneLight")
end

function Equip_Transfer:OnPreLoad()
end

function Equip_Transfer:Init()
  self.equipPool = {}
  self.toggleInit = true
end

function Equip_Transfer:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_Transfer:InitUI()
  self.StageType = {
    self.text_chooseFisrtEquip,
    self.text_chooseSecondEquip,
    self.text_warning
  }
  self.StageTypeTwo = {
    self.content,
    self.lab_goldCost,
    self.btn_zhuanyi
  }
end

function Equip_Transfer:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_Transfer:OnHide()
  if ForgeData.EquipTransferMain ~= nil then
    self.itemCellDataMain:RecycleRes()
    ForgeData.EquipTransferMain = nil
    self.itemCellDataMain = nil
  end
  if ForgeData.EquipTransferSecond ~= nil then
    self.itemCellDataSecond:RecycleRes()
    ForgeData.EquipTransferSecond = nil
    self.itemCellDataSecond = nil
  end
  if self.costCellData then
    self.costCellData:RecycleRes()
    self.costCellData = nil
  end
  Equip_Transfer:SetPanelUIShowState(1)
  EquipeInfoData.curView = nil
  if self.btn_SecondParent.inited then
    ItemUtility.HideItemCellUI(self.btn_SecondParent)
  end
  if self.btn_MainParent.inited then
    ItemUtility.HideItemCellUI(self.btn_MainParent)
  end
end

function Equip_Transfer:OnDestroy()
  self:DestroyEquipObj()
end

function Equip_Transfer:RegistUIEvents()
  self.btn_MainParent:SetOnClick(self, self.fisrtframeOnClick)
  self.btn_SecondParent:SetOnClick(self, self.secondframeOnClick)
  self.btn_zhuanyi:SetOnClick(self, self.btn_zhuanyiOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_role:SetOnClick(self, self.BtnSelectTag)
  self.btn_bag:SetOnClick(self, self.BtnSelectTag)
  self.btn_return:SetOnClick(self, self.btn_returnOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.tog_intensify:SetOnToggleChanged(self, self.TogChanged)
  self.tog_add:SetOnToggleChanged(self, self.TogChanged)
  self.tog_regene:SetOnToggleChanged(self, self.TogChanged)
  self.btn_MainParent:SetOnLongPress(self, self.OnLongPress_Main)
  self.btn_SecondParent:SetOnLongPress(self, self.OnLongPress_Second)
  self.img_btn_l:SetOnClick(self, self.fisrtframeOnClick)
  self.img_btn_r:SetOnClick(self, self.secondframeOnClick)
end

function Equip_Transfer:OnLongPress_Main()
  if ForgeData.EquipTransferMain then
    UIManager.Show(UIID.ItemTipUI, {
      item = ForgeData.EquipTransferMain,
      rightOperate = EItemOperateType.Show,
      ctrl = ForgeData.EquipTransferMain
    })
  end
end

function Equip_Transfer:OnLongPress_Second()
  if ForgeData.EquipTransferSecond then
    UIManager.Show(UIID.ItemTipUI, {
      item = ForgeData.EquipTransferSecond,
      rightOperate = EItemOperateType.Show,
      ctrl = ForgeData.EquipTransferSecond
    })
  end
end

function Equip_Transfer:TogChanged()
  if self.toggleInit then
    return
  end
  if self.tog_intensify:GetIsOn() then
    ForgeData.isChooseIntensify = true
    self.img_intensigyLight:SetActive(true)
    self.img_intensigyDark:SetActive(false)
    self:SetObjRegeneShow(true)
  else
    self.img_intensigyLight:SetActive(false)
    self.img_intensigyDark:SetActive(true)
    self:SetObjRegeneShow(false)
    ForgeData.isChooseIntensify = false
  end
  if self.tog_add:GetIsOn() then
    ForgeData.isChooseAdd = true
    self.img_addLight:SetActive(true)
    self.img_addDark:SetActive(false)
  else
    ForgeData.isChooseAdd = false
    self.img_addLight:SetActive(false)
    self.img_addDark:SetActive(true)
  end
  if self.tog_intensify:GetIsOn() then
    if self.tog_regene:GetIsOn() then
      ForgeData.isRegene = true
      self.img_regeneLight:SetActive(true)
      self.tog_regene:SetActive(self.img_intensigyLight:GetActive())
      self.img_regeneDark:SetActive(false)
    else
      ForgeData.isRegene = false
      self.img_regeneLight:SetActive(false)
      self.tog_regene:SetActive(self.img_intensigyLight:GetActive())
      self.img_regeneDark:SetActive(true)
    end
  end
  self:ResetEquipData(true)
  self:SetPanelUIShowState(1)
end

function Equip_Transfer:SetObjRegeneShow(bool)
  self.tog_regene:SetActive(bool)
  self.img_regeneLight:SetActive(bool)
  self.img_regeneDark:SetActive(bool)
end

function Equip_Transfer:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_Transfer")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Equip_Transfer:btn_returnOnClick()
  if self.args.OpenType == TransferOpenType.Intensify then
    if not UIManager.IsVisible(UIID.Equip_IntensifyUI) then
      UIManager.Show(UIID.Equip_IntensifyUI, {resetLogic = 1})
      EventManager.Dispatch(Event.RefreshBagEquip, UIID.Equip_IntensifyUI)
    end
  elseif self.args.OpenType == TransferOpenType.Zhuijia and not UIManager.IsVisible(UIID.Equip_ZhuijiaUI) then
    UIManager.Show(UIID.Equip_ZhuijiaUI, {resetLogic = 1})
    EventManager.Dispatch(Event.RefreshBagEquip, UIID.Equip_ZhuijiaUI)
  end
end

function Equip_Transfer:BtnSelectTag(control)
  if not control then
    return
  end
  if control.gameObject.name == "btn_role" then
    UIManager.Show(UIID.Bag_EquipInfoUI)
  elseif control.gameObject.name == "btn_bag" then
    UIManager.Show(UIID.NewBagInfoUI, {
      OpenType = self.args.OpenType
    })
  end
end

function Equip_Transfer:fisrtframeOnClick(control)
  if not ForgeData.EquipTransferMain then
    return
  end
  
  local function PromptOK()
    self:ResetEquipData(true)
    self:SetPanelUIShowState(1)
    EventManager.Dispatch(Event.Bag_RefreshShowTransfer)
  end
  
  local title = {
    title = "",
    textContent = string.GetColorText("X\195\161c nh\225\186\173n g\225\187\161 trang b\225\187\139 kh\195\180ng", "#FFFFFFFF"),
    cancelText = "",
    okText = "",
    cancel = nil,
    ok = PromptOK,
    okArgs = nil
  }
  UIManager.Show(UIID.PromptTipUI, title)
end

function Equip_Transfer:secondframeOnClick(control)
  if ForgeData.EquipTransferSecond ~= nil then
    local function PromptOK()
      self:ResetEquipData(false)
      
      self:SetPanelUIShowState(2)
      ForgeData.EquipTransferSecond = nil
      EventManager.Dispatch(Event.Bag_RefreshShowTransfer)
    end
    
    local title = {
      title = "",
      textContent = string.GetColorText("X\195\161c nh\225\186\173n g\225\187\161 trang b\225\187\139 kh\195\180ng", "#FFFFFFFF"),
      cancelText = "",
      okText = "",
      cancel = nil,
      ok = PromptOK,
      okArgs = nil
    }
    UIManager.Show(UIID.PromptTipUI, title)
  end
end

function Equip_Transfer:btn_zhuanyiOnClick(control)
  if not ForgeData.isChooseAdd and not ForgeData.isChooseIntensify and not ForgeData.isRegene then
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = "H\195\163y ch\225\187\141n c\225\186\165p mu\225\187\145n chuy\225\187\131n"
    })
    return
  end
  if not self.foodsEnough then
    local temp = {}
    if self.costItemID then
      temp.itemData = ItemUtility.GenerateItemData(self.costItemID)
    else
      temp.itemData = ItemUtility.GenerateItemData(ECoinsType.gold)
    end
    UIManager.Show(UIID.ItemTipUI, {
      item = temp.itemData,
      rightOperate = EItemOperateType.Show,
      ctrl = temp,
      ShowObtain = true
    })
    return
  end
  local intensifyMaxLevel, addMaxLevel = MeEquipController.GetEquipIntensifyAndAddMaxLevel(ForgeData.EquipTransferSecond)
  local TransferTypeTbl = {}
  if ForgeData.isChooseIntensify then
    table.insert(TransferTypeTbl, 1)
  end
  if ForgeData.isChooseAdd then
    table.insert(TransferTypeTbl, 2)
  end
  if ForgeData.isRegene then
    table.insert(TransferTypeTbl, 3)
  end
  local intensifyStr = LocalizationUtility.GetContentByKey("transfer_1")
  local addStr = LocalizationUtility.GetContentByKey("transfer_2")
  local Str = LocalizationUtility.GetContentByKey("transfer_3")
  if ForgeData.isChooseIntensify and ForgeData.isChooseAdd then
    if intensifyMaxLevel < ForgeData.EquipTransferMain.intensify and addMaxLevel < ForgeData.EquipTransferMain.additional then
      self:EquipTransferSend(true, TransferTypeTbl, Str, intensifyMaxLevel, addMaxLevel)
      return
    end
    if intensifyMaxLevel < ForgeData.EquipTransferMain.intensify then
      self:EquipTransferSend(true, TransferTypeTbl, intensifyStr, intensifyMaxLevel, addMaxLevel)
      return
    end
    if addMaxLevel < ForgeData.EquipTransferMain.additional then
      self:EquipTransferSend(true, TransferTypeTbl, addStr, intensifyMaxLevel, addMaxLevel)
      return
    end
    self:EquipTransferSend(false, TransferTypeTbl, Str, intensifyMaxLevel, addMaxLevel)
  elseif ForgeData.isChooseIntensify then
    if intensifyMaxLevel < ForgeData.EquipTransferMain.intensify then
      self:EquipTransferSend(true, TransferTypeTbl, intensifyStr, intensifyMaxLevel, addMaxLevel)
    else
      self:EquipTransferSend(false, TransferTypeTbl, intensifyStr, intensifyMaxLevel, addMaxLevel)
    end
  elseif ForgeData.isChooseAdd then
    if addMaxLevel < ForgeData.EquipTransferMain.additional then
      self:EquipTransferSend(true, TransferTypeTbl, addStr, intensifyMaxLevel, addMaxLevel)
    else
      self:EquipTransferSend(false, TransferTypeTbl, addStr, intensifyMaxLevel, addMaxLevel)
    end
  elseif ForgeData.isRegene then
    self:EquipTransferSend(false, TransferTypeTbl, addStr, intensifyMaxLevel, addMaxLevel)
  end
end

function Equip_Transfer:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_Transfer)
end

function Equip_Transfer:RegistEvents()
  self:RegistEvent(Event.SelectedForgeEquip, self.SelectedStrengthenEquip, self)
  self:RegistEvent(Event.Bag_CancelTransferSelect, self.CancelTransferSelect, self)
  self:RegistEvent(Event.Equip_TransferSucceed, self.Equip_TransferSucceed, self)
end

function Equip_Transfer:Refresh()
  UIManager.Show(UIID.NewBagInfoUI, {
    OpenType = TransferOpenType.IntensifyAndAdd
  })
  if ForgeData.isFastTransferOpen then
    ForgeData.isFastTransferOpen = false
    ForgeData.EquipTransferMain = EquipData(ForgeData.EquipTransferMain)
    self:SelectedStrengthenEquip(nil, {
      ForgeData.EquipTransferMain,
      ForgeData.EquipTransferMain.bagGridIndex
    })
    ForgeData.EquipTransferSecond = EquipData(ForgeData.EquipTransferSecond)
    self:SelectedStrengthenEquip(nil, {
      ForgeData.EquipTransferSecond,
      ForgeData.EquipTransferSecond.bagGridIndex
    })
    self:SetPanelUIShowState(3)
  else
    ForgeData.EquipTransferMain = nil
    ForgeData.EquipTransferSecond = nil
    self:SetPanelUIShowState(1)
  end
  self:ToggleStateInit()
  self:SetTogFuncShow()
  self.img_regeneLight:SetActive(self.img_intensigyLight:GetActive())
  self.tog_regene:SetActive(self.img_intensigyLight:GetActive())
end

function Equip_Transfer:SetTogFuncShow()
  local condition = ClientTable.cfg_Function_functionManager:TryGetValue(2090004, "id").condition
  if condition ~= nil then
    local isOpen = ConditionManager.Check4D(condition)
    self.tog_regene:SetActive(isOpen)
    self.img_regeneLight:SetActive(isOpen)
    ForgeData.isRegene = isOpen
  end
end

function Equip_Transfer:Equip_TransferSucceed()
  self:ClearPanelData()
end

function Equip_Transfer:Bag_CancelTransferSelect(id, msg)
  if msg[1] == TransferOpenType.Intensify then
    self:fisrtframeOnClick()
  else
    self:secondframeOnClick()
  end
end

function Equip_Transfer:SelectedStrengthenEquip(id, msg)
  local equipData = msg[1]
  if not equipData then
    return
  end
  self:SetEquipTransferInfo(equipData, msg[2])
end

function Equip_Transfer:SetEquipTransferInfo(equipData, index)
  self.EquipIndex = index
  self.EquipData = equipData
  local itemId = equipData.itemId
  if not equipData.tblEquip then
    return
  end
  self:SetTransferRefresh()
  if ForgeData.EquipTransferMain ~= nil and ForgeData.EquipTransferSecond ~= nil then
    self:SetPanelUIShowState(3)
  elseif ForgeData.EquipTransferMain ~= nil and ForgeData.EquipTransferSecond == nil then
    self:SetPanelUIShowState(2)
  end
  if equipData == ForgeData.EquipTransferMain then
    if not self.itemCellDataMain then
      self.itemCellDataMain = ItemCellData()
    end
    self.itemCellDataMain:RefreshData(equipData)
    ItemUtility.ShowItemCell(self.btn_MainParent, self.itemCellDataMain, self)
    self.btn_MainParent.img_isEquip:SetActive(false)
  elseif equipData == ForgeData.EquipTransferSecond then
    if not self.itemCellDataSecond then
      self.itemCellDataSecond = ItemCellData()
    end
    self.itemCellDataSecond:RefreshData(equipData)
    ItemUtility.ShowItemCell(self.btn_SecondParent, self.itemCellDataSecond, self)
    self.btn_SecondParent.img_isEquip:SetActive(false)
  end
end

function Equip_Transfer:ShowChange()
  local mainData = ForgeData.EquipTransferMain
  local SecondData = ForgeData.EquipTransferSecond
  if self.args.OpenType == TransferOpenType.Intensify then
    if mainData ~= nil and SecondData ~= nil then
      self:SetNeedItem(TransferOpenType.Intensify, mainData, SecondData)
      self:SetPanelUIStage(3)
      self:SetSelectName(SecondData.tblEquip.name, SecondData.intensify)
    elseif mainData ~= nil and SecondData == nil then
      self:SetPanelUIStage(2)
      self:SetSelectName(mainData.tblEquip.name, mainData.intensify)
    elseif mainData == nil and SecondData ~= nil then
      self:SetPanelUIStage(1)
      self:SetSelectName(SecondData.tblEquip.name, SecondData.intensify)
    elseif mainData == nil and SecondData == nil then
      self:SetPanelUIStage(1)
      self:SetSelectName(nil, nil)
    end
  elseif self.args.OpenType == TransferOpenType.Zhuijia then
    if mainData ~= nil and SecondData ~= nil then
      self:SetNeedItem(TransferOpenType.additional, mainData, SecondData)
      self:SetPanelUIStage(3)
      self:SetSelectName(SecondData.tblEquip.name, SecondData.additional)
    elseif mainData ~= nil and SecondData == nil then
      self:SetPanelUIStage(2)
      self:SetSelectName(mainData.tblEquip.name, mainData.additional)
    elseif mainData == nil and SecondData ~= nil then
      self:SetPanelUIStage(1)
      self:SetSelectName(SecondData.tblEquip.name, SecondData.additional)
    elseif mainData == nil and SecondData == nil then
      self:SetPanelUIStage(1)
      self:SetSelectName(nil, nil)
    end
  end
end

function Equip_Transfer:SetSelectName(Name, TypeLevel)
  local strName
  if Name ~= nil then
    strName = string.format("%s +%d", Name, TypeLevel)
  else
    strName = ""
  end
  self.lab_item:SetText(strName)
end

function Equip_Transfer:SetAttributeInfo(EquipData)
end

function Equip_Transfer:LoadEquipModel(itemdata)
  Coroutine.Start(self.InitShowModel, self, itemdata)
end

function Equip_Transfer:InitShowModel(itemdata)
  Equip_ForgeNavUi.InitShowModelInTransfer(self, itemdata)
end

function Equip_Transfer:SetNeedItem(type, mainData, secondData)
  local itemStr, bagCount, NumStr
  if type == TransferOpenType.Intensify then
    local tbl_item = ConfigManager.FindConfigs("cfg_Item_equip_zhuanyi", "type", TransferOpenType.Intensify)
    local item
    for k, v in pairs(tbl_item) do
      if v.level == mainData.intensify then
        item = v
      end
    end
    itemStr = string.split(item.cost, "#")
    bagCount = BagInfoData.GetItemCountByItemConfigId(tonumber(itemStr[1]))
    self.text_physBaseDmg:SetText(secondData.intensify)
    self.text_defenseBase:SetText(mainData.intensify)
    self.text_warning:SetText(string.format("Ch\195\186 \195\189: Sau khi chuy\225\187\131n d\225\187\139ch c\225\186\165p c\198\176\225\187\157ng h\195\179a [%s+%d] s\225\186\189 x\195\179a h\225\186\191t", mainData.tblEquip.name, mainData.intensify))
  elseif type == TranScriptData.Zhuijia then
    local tbl_item = ConfigManager.FindConfigs("cfg_Item_equip_zhuanyi", "type", TransferOpenType.Zhuijia)
    local item
    for k, v in pairs(tbl_item) do
      if v.level == mainData.additional then
        item = v
      end
    end
    itemStr = string.split(item.cost, "#")
    bagCount = BagInfoData.GetItemCountByItemConfigId(tonumber(itemStr[1]))
    self.text_physBaseDmg:SetText(secondData.additional)
    self.text_defenseBase:SetText(mainData.additional)
    self.text_warning:SetText(string.format("Ch\195\186 \195\189: Sau khi chuy\225\187\131n d\225\187\139ch c\225\186\165p buff [%s+%d] s\225\186\189 x\195\179a h\225\186\191t", mainData.tblEquip.name, mainData.additional))
  end
  local strColor = bagCount < tonumber(itemStr[2]) and "#FF0000" or "#00FF0E"
  NumStr = string.format("%s%s", string.GetColorText(bagCount, strColor), string.GetColorText(string.format("/%s", itemStr[2]), ItemQuality2ColorDic[EItemColorEnum.white]))
  local btn_get = self.frame_item:GetChild("btn_obtain")
  btn_get.itemData = ItemUtility.GenerateItemData(tonumber(itemStr[1]))
  btn_get:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
  local isShow = bagCount < tonumber(itemStr[2])
  logError(isShow, bagCount, tonumber(itemStr[2]))
  btn_get:SetActive(isShow)
  self.lab_goldCostValue:SetText(NumStr)
end

function Equip_Transfer:SetPanelUIStage(stage)
  for i = 1, table.count(self.StageType) do
    if i == stage then
      self.StageType[i]:SetActive(true)
    else
      self.StageType[i]:SetActive(false)
    end
  end
  for i = 1, table.count(self.StageTypeTwo) do
    if stage == 3 then
      self.StageTypeTwo[i]:SetActive(true)
    else
      self.StageTypeTwo[i]:SetActive(false)
    end
  end
end

function Equip_Transfer:HideEquipObj()
  self:HideEquipObjFirst()
  self:HideEquipObjSecond()
end

function Equip_Transfer:HideEquipObjFirst()
  if self.LoadEquipObjectFirst then
    local go = self.LoadEquipObjectFirst
    go:SetActive(false)
    self.LoadEquipObjectFirst = nil
  end
end

function Equip_Transfer:HideEquipObjSecond()
  if self.LoadEquipObjectSecondE then
    local go = self.LoadEquipObjectSecondE
    go:SetActive(false)
  end
end

function Equip_Transfer:DestroyEquipObj()
  self:DestroyEquipObjFirst()
  self:DestroyEquipObjSecond()
end

function Equip_Transfer:DestroyEquipObjFirst()
  if self.LoadEquipObjectFirst then
    local go = self.LoadEquipObjectFirst
    self.LoadEquipObjectFirst = nil
  end
  self.equipPool = {}
end

function Equip_Transfer:DestroyEquipObjSecond()
  if self.LoadEquipObjectSecondE then
    local go = self.LoadEquipObjectSecondE
    self.LoadEquipObjectSecondE = nil
  end
  self.equipPool = {}
end

function Equip_Transfer:ClearPanelData()
  self:SetPanelUIShowState(1)
  self:ResetEquipData(true)
  EquipeInfoData.curView = nil
  EventManager.Dispatch(Event.Bag_TransferClose)
end

function Equip_Transfer:SetTransferRefresh()
  if not ForgeData.EquipTransferMain then
    return
  end
  if ForgeData.EquipTransferMain then
    self.text_physBaseDmg:SetText(ForgeData.EquipTransferMain.intensify)
    self.text_defenseBase:SetText(ForgeData.EquipTransferMain.additional)
    self.text_warning:SetText(string.format("Ch\195\186 \195\189: Sau khi chuy\225\187\131n d\225\187\139ch c\225\186\165p chuy\225\187\131n d\225\187\139ch t\198\176\198\161ng \225\187\169ng [%s] s\225\186\189 x\195\179a h\225\186\191t", ForgeData.EquipTransferMain.tblEquip.name))
  else
    self.text_physBaseDmg:SetText("")
    self.text_defenseBase:SetText("")
    self.text_warning:SetText("")
  end
  local tbl_item = ClientTable.cfg_Item_equip_zhuanyiManager:GetDic()
  local intensifyStr, additionalStr, costItemID, bagCount, totalCount, costStr, intensifyTab, additionalTab, intensifyCount, additionalCount, regenerateStr, regenerateCount, regenerateTab
  for k, v in pairs(tbl_item) do
    if v.type == 1 and v.level == ForgeData.EquipTransferMain.intensify then
      intensifyStr = v.cost
    end
    if v.type == 2 and v.level == ForgeData.EquipTransferMain.additional then
      additionalStr = v.cost
    end
    if v.type == 3 and v.level == ForgeData.EquipTransferMain.serverInfo.regenerateLevel then
      regenerateStr = v.cost
    end
  end
  if not intensifyStr or intensifyStr == "" or not ForgeData.isChooseIntensify then
    intensifyCount = 0
  else
    intensifyTab = string.split(intensifyStr, "#")
    costItemID = tonumber(intensifyTab[1])
    intensifyCount = tonumber(intensifyTab[2])
  end
  if not additionalStr or additionalStr == "" or not ForgeData.isChooseAdd then
    additionalCount = 0
  else
    additionalTab = string.split(additionalStr, "#")
    costItemID = tonumber(additionalTab[1])
    additionalCount = tonumber(additionalTab[2])
  end
  if not regenerateStr or regenerateStr == "" or not ForgeData.isRegene then
    regenerateCount = 0
  else
    regenerateTab = string.split(regenerateStr, "#")
    costItemID = tonumber(regenerateTab[1])
    regenerateCount = tonumber(regenerateTab[2])
  end
  totalCount = intensifyCount + additionalCount + regenerateCount
  bagCount = BagInfoData.GetItemTotalCountByItemId(costItemID)
  local bagStr = Mathf.NumberShowFormat(bagCount, 1)
  local needStr = Mathf.NumberShowFormat(totalCount, 1)
  self.foodsEnough = totalCount <= bagCount
  local strColor = self.foodsEnough and "#00FF00" or "#FF0000"
  self.costItemID = costItemID
  if needStr == 0 then
    needStr = "Mi\225\187\133n ph\195\173"
  end
  local costStr = string.format("%s%s", string.GetColorText(bagStr, strColor), string.GetColorText(string.format("/%s", needStr), ItemQuality2ColorDic[EItemColorEnum.white]))
  local itemData = ItemUtility.GenerateItemData(costItemID)
  if not self.costCellData then
    if not self.costCellData then
      self.costCellData = ItemCellData()
    end
    self.costCellData:RefreshData(itemData)
    ItemUtility.ShowItemCell(self.costItem, self.costCellData, self, true)
  end
  self.sellProfit:GetChild("lab_num"):SetText(costStr)
  self.btn_getCost.itemData = itemData
  self.btn_getCost:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
  self.btn_getCost:SetActive(not self.foodsEnough)
end

function Equip_Transfer:CancelTransferSelect(id, msg)
  if not UIManager.IsVisible(UIID.Equip_Transfer) then
    return
  end
  local mainData = ForgeData.EquipTransferMain
  local SecondData = ForgeData.EquipTransferSecond
  if msg[1] == mainData then
    self:ResetEquipData(true)
    self:SetPanelUIShowState(1)
  elseif msg[1] == SecondData then
    self:ResetEquipData(false)
  end
end

function Equip_Transfer:ResetEquipData(isAll)
  if isAll then
    if ForgeData.EquipTransferMain ~= nil then
      self.itemCellDataMain:RecycleRes()
      if ForgeData.MainSelectImageCtr ~= nil then
        ForgeData.MainSelectImageCtr = nil
      end
      ForgeData.EquipTransferMain = nil
      self.itemCellDataMain = nil
    end
    if ForgeData.EquipTransferSecond ~= nil then
      self.itemCellDataSecond:RecycleRes()
      if ForgeData.SecondSelectImageCtr ~= nil then
        ForgeData.SecondSelectImageCtr = nil
      end
      ForgeData.EquipTransferSecond = nil
      self.itemCellDataSecond = nil
    end
    if self.btn_SecondParent.inited then
      ItemUtility.HideItemCellUI(self.btn_SecondParent)
    end
    if self.btn_MainParent.inited then
      ItemUtility.HideItemCellUI(self.btn_MainParent)
    end
  elseif ForgeData.EquipTransferSecond ~= nil then
    self.itemCellDataSecond:RecycleRes()
    if ForgeData.SecondSelectImageCtr ~= nil then
      ForgeData.SecondSelectImageCtr = nil
    end
    ForgeData.EquipTransferSecond = nil
    self.itemCellDataSecond = nil
    if self.btn_SecondParent.inited then
      ItemUtility.HideItemCellUI(self.btn_SecondParent)
    end
  end
  EventManager.Dispatch(Event.Bag_RefreshShowTransfer)
  self:ShowChange()
end

function Equip_Transfer:SetPanelUIShowState(state)
  if state == 1 then
    self.text_chooseFisrtEquip:SetActive(true)
    self.text_chooseSecondEquip:SetActive(false)
    self.text_warning:SetActive(false)
    self.lab_nowLevel:SetActive(false)
    self.lab_nextLevel:SetActive(false)
    self.goldicon:SetActive(false)
    self.btn_zhuanyi:SetActive(false)
    self.btn_MainParent:GetChild("bg_additem"):SetActive(true)
    self.btn_SecondParent:GetChild("bg_additem"):SetActive(false)
    self.selectMain:SetActive(true)
    self.selectSecond:SetActive(false)
    self.costInfoUI:SetActive(false)
    self.txt_tip_l:SetActive(true)
    self.txt_tip_r:SetActive(true)
    self.img_btn_l:SetActive(false)
    self.img_btn_r:SetActive(false)
  elseif state == 2 then
    self.text_chooseFisrtEquip:SetActive(false)
    self.text_chooseSecondEquip:SetActive(true)
    self.text_warning:SetActive(true)
    if ForgeData.isChooseIntensify then
      self.lab_nowLevel:SetActive(true)
    end
    if ForgeData.isChooseAdd then
      self.lab_nextLevel:SetActive(true)
    end
    self.btn_zhuanyi:SetActive(false)
    self.btn_MainParent:GetChild("bg_additem"):SetActive(false)
    self.btn_SecondParent:GetChild("bg_additem"):SetActive(true)
    self.selectMain:SetActive(false)
    self.selectSecond:SetActive(true)
    self.costInfoUI:SetActive(true)
    self.txt_tip_l:SetActive(false)
    self.txt_tip_r:SetActive(true)
    self.img_btn_l:SetActive(true)
    self.img_btn_r:SetActive(false)
  elseif state == 3 then
    self.text_chooseFisrtEquip:SetActive(false)
    self.text_chooseSecondEquip:SetActive(false)
    self.text_warning:SetActive(true)
    if ForgeData.isChooseIntensify then
      self.lab_nowLevel:SetActive(true)
    end
    if ForgeData.isChooseAdd then
      self.lab_nextLevel:SetActive(true)
    end
    self.goldicon:SetActive(true)
    if not self.foodsEnough then
      self.Eff_UI_xinanniu:SetActive(false)
    else
      self.Eff_UI_xinanniu:SetActive(true)
    end
    self.btn_zhuanyi:SetActive(true)
    self.btn_MainParent:GetChild("bg_additem"):SetActive(false)
    self.btn_SecondParent:GetChild("bg_additem"):SetActive(false)
    self.selectMain:SetActive(false)
    self.selectSecond:SetActive(false)
    self.costInfoUI:SetActive(true)
    self.txt_tip_l:SetActive(false)
    self.txt_tip_r:SetActive(false)
    self.img_btn_l:SetActive(true)
    self.img_btn_r:SetActive(true)
  end
end

function Equip_Transfer:ToggleStateInit()
  self.tog_intensify:SetIsOn(true)
  self.tog_add:SetIsOn(true)
  self.toggleInit = false
end

function Equip_Transfer:EquipTransferSend(isShow, TransferType, tips, intensifyMaxLevel, addMaxLevel)
  local function PromptOK()
    NetManager.Send(EquipMessage.ReqEquipTransfer, {
      equipId = ForgeData.EquipTransferSecond.id,
      
      traEquipId = ForgeData.EquipTransferMain.id,
      type = TransferType,
      maxIntensify = intensifyMaxLevel,
      maxAdditional = addMaxLevel
    })
    local firstOpenPanelArgs = EquipData:FirstOpenPanelArgs(IndexerEnum.get)
    if firstOpenPanelArgs and firstOpenPanelArgs.isFirstOpen then
      NetManager.Send(EquipMessage.ReqPutOnTheEquip, {
        position = firstOpenPanelArgs.position,
        equipId = firstOpenPanelArgs.equipId
      })
      EquipData:FirstOpenPanelArgs(IndexerEnum.set, {isFirstOpen = false})
    end
  end
  
  if isShow then
    FloatingTipUtility.QuickMsg(tips)
    return
  else
    PromptOK()
  end
end
