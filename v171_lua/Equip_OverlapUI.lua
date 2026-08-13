Equip_OverlapUI = class(BaseUI)
Equip_OverlapUI.layer = UILayer.Panel
Equip_OverlapUI.orderInLayer = 1
Equip_OverlapUI.hideType = UIHideType.WaitDestroy
Equip_OverlapUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_OverlapUI.escClose = UIEscClose.DontClose

function Equip_OverlapUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.btn_close = self:GetControl("bg_equip/btn_close")
  self.fisrtframe = self:GetControl("bg_equip/panel_euqip/fisrtframe")
  self.state_main = self:GetControl("bg_equip/panel_euqip/fisrtframe/state_main")
  self.secondframe = self:GetControl("bg_equip/panel_euqip/secondframe")
  self.state_second = self:GetControl("bg_equip/panel_euqip/secondframe/state_second")
  self.equipname = self:GetControl("bg_equip/panel_euqip/bg_equipname/equipname")
  self.main_plus = self:GetControl("bg_equip/panel_euqip/main_plus")
  self.vice_plus = self:GetControl("bg_equip/panel_euqip/vice_plus")
  self.viewFrame = self:GetControl("bg_equip/panel_euqip/viewFrame")
  self.qiantie = self:GetControl("bg_equip/panel_result/Grid_Attribute/OverlapAttribute/qiantie")
  self.excellencScrollView = self:GetControl("bg_equip/panel_result/Grid_Attribute/OverlapAttribute/excellencScrollView")
  self.labItem = self:GetControl("bg_equip/panel_result/Grid_Attribute/OverlapAttribute/excellencScrollView/Viewport/Content/labItem")
  self.NormalAttribute = self:GetControl("bg_equip/panel_result/Grid_Attribute/NormalAttribute")
  self.lab = self:GetControl("bg_equip/panel_result/Grid_Attribute/NormalAttribute/lab_normalAttribute/img_titleico/content/lab")
  self.btn_ok = self:GetControl("bg_equip/panel_result/btn_ok")
  self.btn_preview = self:GetControl("bg_equip/panel_result/btn_preview")
  self.bg_preview = self:GetControl("bg_equip/panel_result/bg_preview")
  self.itemPreview = self:GetControl("bg_equip/panel_result/bg_preview/itemPreview")
  self.img_Tips = self:GetControl("bg_equip/panel_result/img_Tips")
  self.Img_noItem = self:GetControl("bg_equip/Img_noItem")
  self.Eff_UI_qianghuachenggong = self:GetControl("bg_equip/Eff_UI_qianghuachenggong")
  self.Eff_UI_qianghuashibai = self:GetControl("bg_equip/Eff_UI_qianghuashibai")
  self.Eff_Ui_taozhuangdiejia = self:GetControl("bg_equip/Eff_Ui_taozhuangdiejia")
  self.descBtn = self:GetControl("descBtn")
  self.cost = self:GetControl("cost")
  self.Viewport = self:GetControl("bg_equip/panel_result/Grid_Attribute/OverlapAttribute/excellencScrollView/Viewport")
  self.Content = self:GetControl("cost/Viewport/Content")
  self.sellProfit = self:GetControl("cost/Viewport/Content/sellProfit")
  self.coin_Item = self:GetControl("cost/Viewport/Content/sellProfit/coin_Item")
  self.lab_num = self:GetControl("cost/Viewport/Content/sellProfit/lab_num")
  self.btn_obtain = self:GetControl("cost/Viewport/Content/sellProfit/btn_obtain")
  self.successRate = self:GetControl("successRate")
  self.sucGreen = self:GetControl("successRate/bg/sucGreen")
  self.sucGreenText = self:GetControl("successRate/bg/sucGreen/sucGreenText")
  self.sucYellow = self:GetControl("successRate/bg/sucYellow")
  self.sucYellowText = self:GetControl("successRate/bg/sucYellow/sucYellowText")
  self.sucItem = self:GetControl("successRate/sucItem")
  self.addSucUI = self:GetControl("addSucUI")
  self.btnAddBgClose = self:GetControl("addSucUI/btnAddBgClose")
  self.addSucGreen = self:GetControl("addSucUI/successRate/bg/addSucGreen")
  self.addSucYellow = self:GetControl("addSucUI/successRate/bg/addSucYellow")
  self.btnAdd = self:GetControl("addSucUI/count/btnAdd")
  self.change_price = self:GetControl("addSucUI/count/change_price")
  self.btnReduce = self:GetControl("addSucUI/count/btnReduce")
  self.addSucItem = self:GetControl("addSucUI/item/addSucItem")
  self.sucItemCount = self:GetControl("addSucUI/item/allCount/sucItemCount")
  self.sucItemNeedCount = self:GetControl("addSucUI/item/needCount/sucItemNeedCount")
  self.btnSureAdd = self:GetControl("addSucUI/btnSureAdd")
  self.TipsUI = self:GetControl("TipsUI")
  self.btnTipClose = self:GetControl("TipsUI/btnTipClose")
  self.Text_TipTitle = self:GetControl("TipsUI/Text_TipTitle")
  self.tipsText = self:GetControl("TipsUI/tipsText")
  self.btnContinue = self:GetControl("TipsUI/btnContinue")
  self.btnOpenAdd = self:GetControl("TipsUI/btnOpenAdd")
  self.btn_TipClose = self:GetControl("TipsUI/btn_TipClose")
  self.tog_item = self:GetControl("tog_item")
  self.lab_tips = self:GetControl("addSucUI/lab_tips")
  self.add_Show = self:GetControl("successRate/sucItem/add_Show")
  self.go_model = self:GetControl("successRate/sucItem/go_model")
  self.lab_name = self:GetControl("successRate/sucItem/lab_name")
end

function Equip_OverlapUI:OnPreLoad()
end

function Equip_OverlapUI:Init()
  ForgeData.EquipOverlapMain = nil
  ForgeData.EquipOverlapSide = nil
  self.lockExcellenceId = {}
  self.newLockExcellenceInfo = {}
  self.sucPosL = Vector2Int(-73, -3)
  self.sucPosM = Vector2Int(-29, -3)
  local Tbl = string.split(GlobalConfig.GetGlobalConfig(4000101), "&")
  self.wingOverlapRate = {}
  for i = 1, table.count(Tbl) do
    local tbl = string.split(Tbl[i], "#")
    self.wingOverlapRate[tonumber(tbl[1])] = tonumber(tbl[2])
  end
end

function Equip_OverlapUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_OverlapUI:InitUI()
  self.excellencScrollView:GetChild("Viewport/Content").layoutGroup.enabled = true
  self.labItemContain = UIContainer(self.labItem)
  self.itemPreviewContain = UIContainer(self.itemPreview)
  RoleEquipUtility.EffectOrderLayerSet(self.Eff_UI_qianghuachenggong, 1000)
  RoleEquipUtility.EffectOrderLayerSet(self.Eff_UI_qianghuashibai, 1000)
  RoleEquipUtility.EffectOrderLayerSet(self.Eff_Ui_taozhuangdiejia, 1000)
  self.attributesTemplate = UIUtility.BindUIContainerTemp(self.lab, LuaComponentTemplates.AttributeUnitTemplate, self.newLockExcellenceInfo)
end

function Equip_OverlapUI:OnShow()
  self:RegistEvents()
  self.EquipData = nil
  self:Refresh()
end

function Equip_OverlapUI:OnHide()
  if self.itemCellDataMain then
    self.itemCellDataMain:RecycleRes()
  end
  if self.itemCellDataSecond then
    self.itemCellDataSecond:RecycleRes()
  end
  if self.itemCellDataCoin then
    self.itemCellDataCoin:RecycleRes()
  end
  if self.sucItemCellData then
    self.sucItemCellData:RecycleRes()
  end
  if self.addSucItemCellData then
    self.addSucItemCellData:RecycleRes()
  end
  self:ResetEquipData(true)
  self:SetPanelUIShowState(1)
  self.itemCellDataMain = nil
  self.itemCellDataSecond = nil
  self.sucItemCellData = nil
  self.addSucItemCellData = nil
  ForgeData.EquipOverlapMain = nil
  ForgeData.EquipOverlapSide = nil
  EquipeInfoData.curView = nil
  self.itemCellDataCoin = nil
  self.Eff_UI_qianghuachenggong:SetActive(false)
  self.Eff_UI_qianghuashibai:SetActive(false)
  self.Eff_Ui_taozhuangdiejia:SetActive(false)
  self.addSucUI:SetActive(false)
  self.lastMainControl = nil
  self.lastSideControl = nil
end

function Equip_OverlapUI:OnDestroy()
end

function Equip_OverlapUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_ok:SetOnClick(self, self.btn_okOnClick)
  self.fisrtframe:SetOnClick(self, self.main_equipOnClick)
  self.secondframe:SetOnClick(self, self.vice_equipOnClick)
  self.btn_preview:SetOnClick(self, self.btn_previewOnClick)
  self.bg_preview:SetOnClick(self, self.bg_previewOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.sucItem:SetOnClick(self, self.BtnSucItemOnClick)
  self.btnAdd:SetOnClick(self, self.BtnAddOrReduceOnClick)
  self.btnReduce:SetOnClick(self, self.BtnAddOrReduceOnClick)
  self.change_price:SetOnSliderValueChanged(self, self.BtnSucItemSliderChange)
  self.btnSureAdd:SetOnClick(self, self.SetSucceedRateUIShow)
  self.btnAddBgClose:SetOnClick(self, self.BtnAddBgCloseOnClick)
  self.btnTipClose:SetOnClick(self, self.BtnTipCloseOnClick)
  self.btnContinue:SetOnClick(self, self.BtnContinueOnClick)
  self.btnOpenAdd:SetOnClick(self, self.BtnOpenAddOnClick)
  self.btn_TipClose:SetOnClick(self, self.BtnTipCloseOnClick)
end

function Equip_OverlapUI:BtnContinueOnClick()
  local temp = {}
  if self.addCurrentCount and self.addCurrentCount > 0 then
    temp[self.sucItemData.tblItem.id] = self.addCurrentCount
  end
  networkRequest.ReqEquipSuperpose(ForgeData.EquipOverlapMain.id, ForgeData.EquipOverlapSide.id, self.lockExcellenceId, temp, 0, 0, self.newLockExcellenceInfo)
  self.TipsUI:SetActive(false)
end

function Equip_OverlapUI:BtnOpenAddOnClick()
  self.TipsUI:SetActive(false)
  self:BtnSucItemOnClick()
end

function Equip_OverlapUI:BtnTipCloseOnClick()
  self.TipsUI:SetActive(false)
end

function Equip_OverlapUI:BtnAddBgCloseOnClick()
  self.addCurrentCount = 0
  self:SetSucceedRateUIShow()
end

function Equip_OverlapUI:BtnSucItemSliderChange(control, value)
  if self.isBtnClickChange then
    self.isBtnClickChange = false
    return
  end
  local bagCount = BagInfoData.GetItemTotalCountByItemId(self.sucItemData.tblItem.id)
  if value > bagCount then
    control:SetValue(self.addCurrentCount)
    UIManager.Show(UIID.ItemTipUI, {
      item = self.sucItemData,
      rightOperate = EItemOperateType.Show,
      ShowObtain = true
    })
    return
  end
  self.addCurrentCount = Mathf.Floor(value)
  self.sucItemNeedCount:SetText(self.addCurrentCount)
  local addRate
  if self.sucSingleRate * self.addCurrentCount > self.cfg_costMainTable.maxSuccessRate - self.cfg_costMainTable.rateClient then
    addRate = Mathf.Floor((self.cfg_costMainTable.maxSuccessRate - self.cfg_costMainTable.rateClient) * 0.01)
    if addRate == Mathf.Floor(addRate) then
      addRate = Mathf.Floor(addRate)
    end
  else
    addRate = self.sucSingleRate * self.addCurrentCount * 0.01
    if addRate == Mathf.Floor(addRate) then
      addRate = Mathf.Floor(addRate)
    end
  end
  if not string.isNullOrEmpty(addRate) then
    self.addSucYellow:SetText("A" .. addRate .. "B")
  end
end

function Equip_OverlapUI:BtnAddOrReduceOnClick(control)
  if control:GetName() == "btnAdd" then
    if self.addCurrentCount >= BagInfoData.GetItemTotalCountByItemId(self.sucItemData.tblItem.id) then
      self.change_price:SetValue(self.addCurrentCount)
      UIManager.Show(UIID.ItemTipUI, {
        item = self.sucItemData,
        rightOperate = EItemOperateType.Show,
        ShowObtain = true
      })
      return
    end
    if self.addCurrentCount < self.addMaxCount then
      self.isBtnClickChange = true
      self.addCurrentCount = self.addCurrentCount + 1
      self.sucItemNeedCount:SetText(self.addCurrentCount)
      self.change_price:SetValue(self.addCurrentCount)
      local addRate
      if self.sucSingleRate * self.addCurrentCount > self.cfg_costMainTable.maxSuccessRate - self.cfg_costMainTable.rateClient then
        addRate = (self.cfg_costMainTable.maxSuccessRate - self.cfg_costMainTable.rateClient) * 0.01
        if addRate == Mathf.Floor(addRate) then
          addRate = Mathf.Floor(addRate)
        end
      else
        addRate = self.sucSingleRate * self.addCurrentCount * 0.01
        if addRate == Mathf.Floor(addRate) then
          addRate = Mathf.Floor(addRate)
        end
      end
      if not string.isNullOrEmpty(addRate) then
        self.addSucYellow:SetText("A" .. addRate .. "B")
      end
    end
  elseif self.addCurrentCount > 0 then
    self.isBtnClickChange = true
    self.addCurrentCount = self.addCurrentCount - 1
    self.sucItemNeedCount:SetText(self.addCurrentCount)
    self.change_price:SetValue(self.addCurrentCount)
    local addRate
    if self.sucSingleRate * self.addCurrentCount > self.cfg_costMainTable.maxSuccessRate - self.cfg_costMainTable.rateClient then
      addRate = (self.cfg_costMainTable.maxSuccessRate - self.cfg_costMainTable.rateClient) * 0.01
      if addRate == Mathf.Floor(addRate) then
        addRate = Mathf.Floor(addRate)
      end
    else
      addRate = self.sucSingleRate * self.addCurrentCount * 0.01
      if addRate == Mathf.Floor(addRate) then
        addRate = Mathf.Floor(addRate)
      end
    end
    if not string.isNullOrEmpty(addRate) then
      self.addSucYellow:SetText("A" .. addRate .. "B")
    end
  end
end

function Equip_OverlapUI:BtnSucItemOnClick()
  local rate = self.cfg_costMainTable.rateClient * 0.01
  if rate == Mathf.Floor(rate) then
    rate = Mathf.Floor(rate)
  end
  self.addSucGreen:SetText(rate .. "B")
  self.addSucYellow:SetText("A0B")
  if not self.addSucItemCellData then
    self.addSucItemCellData = ItemCellData()
  end
  self.addSucItemCellData:RefreshData(self.sucItemData)
  ItemUtility.ShowItemCell(self.addSucItem, self.addSucItemCellData, self, true)
  self.addCurrentCount = 0
  self.sucItemCount:SetText(BagInfoData.GetItemTotalCountByItemId(self.sucItemData.tblItem.id))
  self.sucItemNeedCount:SetText("0")
  self.change_price.slider.minValue = 0
  self.change_price.slider.maxValue = self.addMaxCount
  self.change_price:SetValue(0)
  self.addSucUI:SetActive(true)
  self.lab_tips:SetActive(0 < self.cfg_costMainTable.maxSuccessRate)
  if 0 < self.cfg_costMainTable.maxSuccessRate then
    self.lab_tips:SetText(string.format("T\225\187\183 l\225\187\135 th\195\160nh c\195\180ng t\225\187\145i \196\145a %d%%", Mathf.Floor(self.cfg_costMainTable.maxSuccessRate * 0.01)))
  end
end

function Equip_OverlapUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_OverlapUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Equip_OverlapUI:main_equipOnClick(control)
  if ForgeData.EquipOverlapMain then
    if self.itemCellDataMain then
      self.EquipData = nil
      self.itemCellDataMain:RecycleRes()
      self:ResetEquipData(true)
      self:SetPanelUIShowState(1)
    end
    if self.itemCellDataSecond then
      self.itemCellDataSecond:RecycleRes()
    end
  else
    ForgeData.isChooseOverlapMain = true
    self.state_main:SetActive(true)
  end
end

function Equip_OverlapUI:vice_equipOnClick(control)
  if not ForgeData.EquipOverlapMain then
    return
  end
  if ForgeData.EquipOverlapSide then
    if self.itemCellDataSecond then
      self.itemCellDataSecond:RecycleRes()
      self:ResetEquipData(false)
      self:SetPanelUIShowState(2)
    end
  else
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Overlap_2"))
    ForgeData.isChooseOverlapSide = true
    self.state_second:SetActive(true)
  end
end

function Equip_OverlapUI:btn_previewOnClick(control)
  if self.bg_preview:GetActive() then
    self.bg_preview:SetActive(false)
    return
  end
  local ExcellenceTab = self:IsHaveDifferentExcellence(ForgeData.EquipOverlapSide)
  self.itemPreviewContain:SetMaxCount(table.count(ExcellenceTab) + 1)
  for i = 1, table.count(ExcellenceTab) + 1 do
    local item = self.itemPreviewContain:GetOrCreateItem(i)
    local itemLab = item:GetChild("Text")
    if i == 1 then
      itemLab:SetText("X\225\186\191p Ch\225\187\147ng ng\225\186\171u nhi\195\170n trong c\195\161c d\195\178ng thu\225\187\153c t\195\173nh sau")
    else
      itemLab:SetText(ExcellenceTab[i - 1])
    end
  end
  self.itemPreviewContain:Refresh()
  self.bg_preview:SetActive(true)
end

function Equip_OverlapUI:bg_previewOnClick(control)
  self.bg_preview:SetActive(false)
end

function Equip_OverlapUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_OverlapUI)
end

function Equip_OverlapUI:btn_roleOnClick(control)
  if not control then
    return
  end
  if control.gameObject.name == "btn_role" then
    UIManager.Show(UIID.Bag_EquipInfoUI)
  elseif control.gameObject.name == "btn_bag" then
    UIManager.Show(UIID.NewBagInfoUI)
  end
end

function Equip_OverlapUI:btn_bagOnClick(control)
end

function Equip_OverlapUI:btn_okOnClick()
  if ForgeData.EquipOverlapMain == nil or ForgeData.EquipOverlapSide == nil or ForgeData.EquipOverlapMain.id == ForgeData.EquipOverlapSide.id then
    FloatingTipUtility.QuickMsg("M\225\187\157i ch\225\187\141n 1 trang b\225\187\139")
    return
  end
  local strTab = string.split(self.cfg_costMainTable.cost, "#")
  if #strTab == 0 then
    local temp = {}
    if self.addCurrentCount and 0 < self.addCurrentCount then
      temp[self.sucItemData.tblItem.id] = self.addCurrentCount
    end
    networkRequest.ReqEquipSuperpose(ForgeData.EquipOverlapMain.id, ForgeData.EquipOverlapSide.id, self.lockExcellenceId, temp, 0, 0, self.newLockExcellenceInfo)
    return
  end
  if self.isVipPlayer then
    if self.isAllLevel then
      if self.lastMainControl == nil or self.lastSideControl == nil then
        FloatingTipUtility.QuickMsg("M\225\187\157i ch\225\187\141n d\195\178ng thu\225\187\153c t\195\173nh")
        return
      end
    elseif self.lastSideControl == nil then
      FloatingTipUtility.QuickMsg("M\225\187\157i ch\225\187\141n d\195\178ng thu\225\187\153c t\195\173nh")
      return
    end
    local chooseId = self.lastMainControl and self.lastMainControl.excellenceId or 0
    local excellentId = self.lastSideControl and self.lastSideControl.excellenceId or 0
    networkRequest.ReqEquipSuperpose(ForgeData.EquipOverlapMain.id, ForgeData.EquipOverlapSide.id, self.lockExcellenceId, {}, chooseId, excellentId, self.newLockExcellenceInfo)
    return
  end
  if not self.isEnough then
    UIManager.Show(UIID.ItemTipUI, {
      item = self.currentCostItemData,
      rightOperate = EItemOperateType.Show,
      ShowObtain = true
    })
    return
  end
  local temp = {}
  if self.addCurrentCount and 0 < self.addCurrentCount then
    temp[self.sucItemData.tblItem.id] = self.addCurrentCount
  end
  if self.cfg_costMainTable ~= nil and not string.isNullOrEmpty(self.cfg_costMainTable.bonusBuckets) then
    if self.addCurrentCount < self.addMaxCount then
      local curRate = (self.sucSingleRate * self.addCurrentCount + self.cfg_costMainTable.rateClient) * 0.01
      if curRate == Mathf.Floor(curRate) then
        curRate = Mathf.Floor(curRate)
      end
      local maxRate = self.cfg_costMainTable.maxSuccessRate * 0.01
      if maxRate == Mathf.Floor(maxRate) then
        maxRate = Mathf.Floor(maxRate)
      end
      local tempText = string.format(LocalizationUtility.GetContentByKey("Overlap_3"), curRate .. "%", "75%")
      self.tipsText:SetText(tempText)
      self.TipsUI:SetActive(true)
    else
      networkRequest.ReqEquipSuperpose(ForgeData.EquipOverlapMain.id, ForgeData.EquipOverlapSide.id, self.lockExcellenceId, temp, 0, 0, self.newLockExcellenceInfo)
    end
  else
    networkRequest.ReqEquipSuperpose(ForgeData.EquipOverlapMain.id, ForgeData.EquipOverlapSide.id, self.lockExcellenceId, temp, 0, 0, self.newLockExcellenceInfo)
  end
end

function Equip_OverlapUI:RegistEvents()
  self:RegistEvent(Event.SelectedForgeEquip, self.SelectedStrengthenEquip, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.SetEquipCost, self)
  self:RegistEvent(Event.Equip_OverlapSucceed, self.EquipAttriUpdate, self)
end

function Equip_OverlapUI:Refresh()
  self:SetPanelUIShowState(1)
  UIManager.Show(UIID.NewBagInfoUI)
  self:RefreshFilterCareerEquipToggle()
end

function Equip_OverlapUI:SelectedStrengthenEquip(id, msg)
  if msg[1] then
    self:SetEquipIntensifyInfo(msg[1])
    if ForgeData.EquipOverlapMain == msg[1] then
      ForgeData.isChooseOverlapMain = false
      self:SetPanelUIShowState(2)
    elseif ForgeData.EquipOverlapSide == msg[1] then
      ForgeData.isChooseOverlapSide = false
      self:SetPanelUIShowState(3)
    end
  end
end

function Equip_OverlapUI:RefreshFilterCareerEquipToggle()
  if self.filterCareerEquipToggleTemplate == nil then
    self.filterCareerEquipToggleTemplate = luaTemplateManager.GetNewTemplate(self.tog_item, LuaComponentTemplates.Toggle_SingleToggleTemplate)
  end
  local inputData = {}
  inputData.name = "L\225\187\141c Trang B\225\187\139 c\195\185ng Ngh\225\187\129"
  if ForgeData.FilterCanUseEquip == nil then
  end
  inputData.isOn = ForgeData.FilterCanUseEquip
  
  function inputData.toggleCallback(inputdata, state)
    ForgeData.FilterCanUseEquip = state
    EventManager.Dispatch(Event.Bag_RefreshShowOverlap)
  end
  
  self.filterCareerEquipToggleTemplate:RefreshData(inputData)
end

function Equip_OverlapUI:EquipAttriUpdate(_, msg)
  self.itemCellDataSecond:RecycleRes()
  self.itemCellDataSecond = nil
  ForgeData.EquipOverlapSide = nil
  ForgeData.EquipOverlapMain = msg.equipData
  self:SelectedStrengthenEquip(nil, {
    msg.equipData
  })
  EventManager.Dispatch(Event.Bag_RefreshShowOverlap)
  self:SetOverlapEffect(msg.success)
end

function Equip_OverlapUI:SetEquipIntensifyInfo(EquipData)
  if EquipData == ForgeData.EquipOverlapMain then
    self.EquipData = EquipData
    if not self.itemCellDataMain then
      self.itemCellDataMain = ItemCellData()
    end
    self.itemCellDataMain:RefreshData(EquipData)
    ItemUtility.ShowItemCell(self.fisrtframe, self.itemCellDataMain, self)
    if not self.viewCellData then
      self.viewCellData = ItemCellData()
    end
    self.viewCellData:RefreshData(EquipData)
    ItemUtility.ShowItemCell(self.viewFrame, self.viewCellData, self)
  elseif EquipData == ForgeData.EquipOverlapSide then
    if not self.itemCellDataSecond then
      self.itemCellDataSecond = ItemCellData()
    end
    self.itemCellDataSecond:RefreshData(EquipData)
    ItemUtility.ShowItemCell(self.secondframe, self.itemCellDataSecond, self)
  end
end

function Equip_OverlapUI:IsHaveDifferentExcellence(itemInfo)
  if not ForgeData.EquipOverlapMain then
    return
  end
  local cfg_table = MeEquipController.GetEquipOverlapCostCfg(ForgeData.EquipOverlapMain)
  local secondItemInfo = table.metatableCopy(nil, itemInfo.excellence)
  if cfg_table.overlapNum == 1 then
    for k, v in pairs(ForgeData.EquipOverlapMain.excellence) do
      for kk, vv in pairs(secondItemInfo) do
        if v == vv then
          table.remove(secondItemInfo, kk)
        end
      end
    end
  else
    for k, v in pairs(ForgeData.EquipOverlapMain.excellence) do
      for kk, vv in pairs(secondItemInfo) do
        if v == vv then
          local num = 0
          for kkk, vvv in pairs(ForgeData.EquipOverlapMain.excellence) do
            if v == vvv then
              num = num + 1
            end
          end
          if num >= cfg_table.overlapNum then
            table.remove(secondItemInfo, kk)
          end
        end
      end
    end
  end
  return RoleEquipUtility.GetEquipExcellence(secondItemInfo, itemInfo.tblEquip)
end

function Equip_OverlapUI:SetPanelUIShowState(id)
  if id == 1 then
    self.main_plus:SetActive(true)
    self.vice_plus:SetActive(true)
    self.equipname:SetText("")
    self.labItemContain:SetMaxCount(0)
    self.labItemContain:Refresh()
    self:RefreshBaseAttribute()
    self.img_Tips:SetActive(false)
    self.state_main:SetActive(true)
    self.state_second:SetActive(false)
    self.bg_preview:SetActive(false)
    self.addSucUI:SetActive(false)
    self.Img_noItem:SetActive(true)
    self.qiantie:SetActive(false)
    self:SetEquipCost()
  elseif id == 2 then
    self.lastMainControl = nil
    self.lastSideControl = nil
    self.lockExcellenceId = {}
    self.newLockExcellenceInfo = {}
    self.isAllLevel = ForgeData.EquipOverlapMain:GetExcellenceCount() == ForgeData.EquipOverlapMain.tblEquip.overlapMax
    if self.isAllLevel then
      self.cfg_costMainTable = MeEquipController.GetEquipOverlapReplaceCostCfg(ForgeData.EquipOverlapMain, 0)
    else
      self.cfg_costMainTable = MeEquipController.GetEquipOverlapCostCfg(ForgeData.EquipOverlapMain)
    end
    self.main_plus:SetActive(false)
    self.vice_plus:SetActive(true)
    self.equipname:SetText(ForgeData.EquipOverlapMain.tblEquip.name)
    self.img_Tips:SetActive(false)
    self.state_main:SetActive(false)
    self.state_second:SetActive(true)
    self.Img_noItem:SetActive(false)
    self.qiantie:SetActive(true)
    self.addCurrentCount = 0
    self:SetEquipCost()
    self:HandleExcellenceShow(ForgeData.EquipOverlapMain, 1)
  elseif id == 3 then
    self.main_plus:SetActive(false)
    self.vice_plus:SetActive(false)
    self.equipname:SetText(ForgeData.EquipOverlapMain.tblEquip.name)
    self.img_Tips:SetActive(false)
    self.state_main:SetActive(false)
    self.state_second:SetActive(true)
    self.Img_noItem:SetActive(false)
    self.qiantie:SetActive(true)
    if not self.cfg_costMainTable and ForgeData.EquipOverlapMain then
      print("\230\156\170\230\137\190\229\136\176\229\175\185\229\186\148\230\182\136\232\128\151itemId\229\146\140equipClass==", ForgeData.EquipOverlapMain.itemId, ForgeData.EquipOverlapMain.tblEquip.equipClass)
      return
    end
    self:HandleExcellenceShow(ForgeData.EquipOverlapMain, 2)
    if self.isVipPlayer then
      self.sucYellow:SetActive(false)
      self.sucYellowText:SetActive(false)
      self.sucItem:SetActive(false)
      self.sucGreen.transform.anchoredPosition = self.sucPosM
      local rate = self.wingOverlapRate[ForgeData.EquipOverlapSide.itemId]
      if rate then
        rate = Mathf.Floor(rate * 0.01)
        if rate == Mathf.Floor(rate) then
          rate = Mathf.Floor(rate)
        end
        self.sucGreenText:SetText(rate .. "B")
      end
      self.cost:SetActive(false)
    else
      if string.isNullOrEmpty(self.cfg_costMainTable.bonusBuckets) then
        self.sucYellow:SetActive(false)
        self.sucYellowText:SetActive(false)
        self.sucItem:SetActive(false)
        self.sucGreen.transform.anchoredPosition = self.sucPosM
      else
        self.sucGreen.transform.anchoredPosition = self.sucPosL
        local strTab = string.split(self.cfg_costMainTable.bonusBuckets, "#")
        local itemId = tonumber(strTab[1])
        self.sucSingleRate = tonumber(strTab[2])
        self.addMaxCount = Mathf.Ceil((self.cfg_costMainTable.maxSuccessRate - self.cfg_costMainTable.rateClient) / self.sucSingleRate)
        self.sucItemData = ItemUtility.GenerateItemData(itemId)
        if not self.sucItemCellData then
          self.sucItemCellData = ItemCellData()
        end
        self.sucItemCellData:RefreshData(self.sucItemData)
        ItemUtility.ShowItemCell(self.sucItem, self.sucItemCellData, self)
        self:SetSucceedRateUIShow(true)
        self.sucYellowText:SetActive(true)
        self.sucYellow:SetActive(true)
        self.sucItem:SetActive(true)
        self:RefreshLuckyStoneBtn()
      end
      local rate = self.cfg_costMainTable.rateClient
      if rate then
        rate = Mathf.Floor(rate * 0.01)
        if rate == Mathf.Floor(rate) then
          rate = Mathf.Floor(rate)
        end
        self.sucGreenText:SetText(rate .. "B")
      end
      local strTab = string.split(self.cfg_costMainTable.cost, "#")
      if 0 < #strTab then
        self.cost:SetActive(true)
      else
        self.cost:SetActive(false)
      end
    end
  end
end

function Equip_OverlapUI:ResetEquipData(isAll)
  if isAll then
    ForgeData.EquipOverlapMain = nil
    ForgeData.EquipOverlapSide = nil
  else
    ForgeData.EquipOverlapSide = nil
  end
  EventManager.Dispatch(Event.Bag_RefreshShowOverlap)
end

local function GetDiffExcellence(mainData, sideData)
  if not mainData then
    return
  end
  local cfg_table
  local mExcellence, sExcellence = mainData:GetEquipExcellenceList(), sideData:GetEquipExcellenceList()
  if mainData:GetExcellenceCount() == mainData.tblEquip.overlapMax then
    cfg_table = MeEquipController.GetEquipOverlapReplaceCostCfg(mainData, 0)
  else
    cfg_table = MeEquipController.GetEquipOverlapCostCfg(mainData)
  end
  local secondItemInfo = table.metatableCopy(nil, sExcellence)
  if cfg_table.overlapNum == 1 then
    for k, v in pairs(mExcellence) do
      for kk, vv in pairs(secondItemInfo) do
        if v.id == vv.id then
          table.remove(secondItemInfo, kk)
        end
      end
    end
  else
    for k, v in pairs(mExcellence) do
      for kk, vv in pairs(secondItemInfo) do
        if v.id == vv.id then
          local num = 0
          for kkk, vvv in pairs(mExcellence) do
            if v.id == vvv.id then
              num = num + 1
            end
          end
          if num >= cfg_table.overlapNum then
            table.remove(secondItemInfo, kk)
          end
        end
      end
    end
  end
  return secondItemInfo
end

function Equip_OverlapUI:HandleExcellenceShow(itemInfo, condition)
  if condition == 1 then
    local count = itemInfo:GetExcellenceCount()
    local excellence = itemInfo:GetEquipExcellenceDesList()
    self.labItemContain:SetMaxCount(count)
    local index = 1
    for k, v in pairs(excellence) do
      local obj = self.labItemContain:GetOrCreateItem(index)
      obj:GetChild("Text"):SetText(v)
      obj.select = obj:GetChild("select")
      obj.nSelect = obj:GetChild("nSelect")
      obj.lab_newExcellence = obj:GetChild("lab_newExcellence")
      obj.lab_newAdd = obj:GetChild("lab_newAdd")
      obj.select:SetActive(false)
      obj.nSelect:SetActive(false)
      obj.lab_newExcellence:SetActive(false)
      obj.canLock = false
      obj.lab_newAdd:SetActive(false)
      obj.wingSelectBg = obj:GetChild("wingSelectBg")
      obj.wingText = obj:GetChild("wingSelectBg/Label")
      obj.wingSelect = obj:GetChild("wingSelect")
      obj.wingSelectBg:SetActive(false)
      obj.wingSelect:SetActive(false)
      obj.isWingChoose = false
      index = index + 1
    end
    self.labItemContain:Refresh()
    self:RefreshBaseAttribute()
    self.excellencScrollView:GetChild("Viewport/Content"):SetSizeDelta(4, 40 * count)
  elseif condition == 2 then
    local excellenceTab = itemInfo:GetEquipExcellenceList()
    local diffExcellenceTab = GetDiffExcellence(ForgeData.EquipOverlapMain, ForgeData.EquipOverlapSide)
    local excCount = itemInfo:GetExcellenceCount()
    local diffCount = table.count(diffExcellenceTab)
    local totalCount = excCount + diffCount
    self.labItemContain:SetMaxCount(totalCount)
    self.isVipPlayer = ForgeData.EquipOverlapSide.tblItem.type == EItemType.Material and ForgeData.EquipOverlapSide.tblItem.subType == EItemSubtype.wingOverlap
    for i = 1, totalCount do
      local obj = self.labItemContain:GetOrCreateItem(i)
      obj.select = obj:GetChild("select")
      obj.nSelect = obj:GetChild("nSelect")
      obj.lab_newExcellence = obj:GetChild("lab_newExcellence")
      obj.lab_newAdd = obj:GetChild("lab_newAdd")
      obj.select:SetActive(false)
      obj.lab_newAdd:SetActive(false)
      obj.wingSelectBg = obj:GetChild("wingSelectBg")
      obj.wingText = obj:GetChild("wingSelectBg/Label")
      obj.wingSelect = obj:GetChild("wingSelect")
      obj.wingText:SetText("")
      obj.wingSelectBg:SetActive(false)
      obj.wingSelect:SetActive(false)
      obj.isWingChoose = self.isVipPlayer
      if self.isVipPlayer then
        obj.lab_newExcellence:SetActive(false)
        obj.canLock = false
        obj.nSelect:SetActive(false)
        if i > diffCount and i <= totalCount then
          local str = excellenceTab[i - diffCount].des
          obj:GetChild("Text"):SetText(str)
          obj.isMain = true
          obj.wingText:SetText("C\195\179 th\225\187\131 thay th\225\186\191")
          if self.isAllLevel then
            obj.excellenceId = excellenceTab[i - diffCount].id
            obj.excellenceServerData = excellenceTab[i - diffCount].serverData
            obj.wingSelectBg:SetActive(true)
          else
            obj.isWingChoose = false
          end
        else
          obj.wingText:SetText("Ch\225\187\141n 1 d\195\178ng")
          local str = diffExcellenceTab[i].des
          local tStr = string.GetColorText(str, "#1ADD1F")
          obj:GetChild("Text"):SetText(tStr)
          obj.wingSelectBg:SetActive(true)
          obj.isMain = false
          obj.excellenceId = diffExcellenceTab[i].id
          obj.excellenceServerData = diffExcellenceTab[i].serverData
        end
      elseif i > diffCount and i <= totalCount then
        local str = excellenceTab[i - diffCount].des
        obj:GetChild("Text"):SetText(str)
        obj.nSelect:SetActive(self.isAllLevel)
        obj.lab_newExcellence:SetActive(false)
        obj.isMain = true
        if self.isAllLevel then
          obj.excellenceId = excellenceTab[i - diffCount].id
          obj.excellenceServerData = excellenceTab[i - diffCount].serverData
          obj.canLock = true
          obj.isLock = false
        else
          obj.canLock = false
        end
      else
        local str = diffExcellenceTab[i].des
        local tStr = string.GetColorText(str, "#1ADD1F")
        obj:GetChild("Text"):SetText(tStr)
        obj.nSelect:SetActive(false)
        obj.canLock = false
        obj.isMain = false
        obj.lab_newExcellence:SetActive(1 < diffCount)
        obj.excellenceId = diffExcellenceTab[i].id
        obj.excellenceServerData = diffExcellenceTab[i].serverData
      end
      obj:SetOnClick(self, self.BtnLockOnClick)
    end
    self.labItemContain:Refresh()
    self:RefreshBaseAttribute()
    self.excellencScrollView:GetChild("Viewport/Content"):SetSizeDelta(4, 40 * totalCount)
    if 5 < excCount then
      local offset = 38 * (excCount - 5)
      self.excellencScrollView:GetChild("Viewport/Content").transform.anchoredPosition = Vector2(0, offset)
    else
      self.excellencScrollView:GetChild("Viewport/Content").transform.anchoredPosition = Vector2.zero
    end
  end
end

function Equip_OverlapUI:SetEquipCost()
  self.cost:SetActive(false)
  if not ForgeData.EquipOverlapMain or not self.cfg_costMainTable then
    self.coin_Item:GetChild("lab_name"):SetText("")
    self.lab_num:SetText("")
    if self.itemCellDataCoin then
      self.itemCellDataCoin:RecycleRes()
    end
    self.btn_obtain:SetActive(false)
    self.successRate:SetActive(false)
    self.addCurrentCount = 0
    self.addMaxCount = 0
    if not self.cfg_costMainTable and ForgeData.EquipOverlapMain then
      print("\230\156\170\230\137\190\229\136\176\229\175\185\229\186\148\230\182\136\232\128\151itemId\229\146\140equipClass==", ForgeData.EquipOverlapMain.itemId, ForgeData.EquipOverlapMain.tblEquip.equipClass)
    end
    return
  end
  self.successRate:SetActive(true)
  if string.isNullOrEmpty(self.cfg_costMainTable.bonusBuckets) then
    self.sucYellow:SetActive(false)
    self.sucYellowText:SetActive(false)
    self.sucItem:SetActive(false)
    self.sucGreen.transform.anchoredPosition = self.sucPosM
  else
    self.sucGreen.transform.anchoredPosition = self.sucPosL
    local strTab = string.split(self.cfg_costMainTable.bonusBuckets, "#")
    local itemId = tonumber(strTab[1])
    self.sucSingleRate = tonumber(strTab[2])
    self.addMaxCount = Mathf.Ceil((self.cfg_costMainTable.maxSuccessRate - self.cfg_costMainTable.rateClient) / self.sucSingleRate)
    self.sucItemData = ItemUtility.GenerateItemData(itemId)
    if not self.sucItemCellData then
      self.sucItemCellData = ItemCellData()
    end
    self.sucItemCellData:RefreshData(self.sucItemData)
    ItemUtility.ShowItemCell(self.sucItem, self.sucItemCellData, self)
    self:SetSucceedRateUIShow(true)
    self.sucYellowText:SetActive(true)
    self.sucYellow:SetActive(true)
    self.sucItem:SetActive(true)
    self:RefreshLuckyStoneBtn()
  end
  local rate = self.cfg_costMainTable.rateClient
  if rate then
    rate = Mathf.Floor(rate * 0.01)
    if rate == Mathf.Floor(rate) then
      rate = Mathf.Floor(rate)
    end
    self.sucGreenText:SetText(rate .. "B")
  end
  local strTab = string.split(self.cfg_costMainTable.cost, "#")
  if 0 < #strTab then
    local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(strTab[1]))
    local count = tonumber(strTab[2])
    local strColor = bagCount >= count and "#00FF00" or "#FF0000"
    local strBag = Mathf.NumberShowFormat(bagCount, 1)
    local countT = Mathf.NumberShowFormat(count, 1)
    local countStr = string.format("%s%s", string.GetColorText(strBag, strColor), string.GetColorText(string.format("/%s", countT), ItemQuality2ColorDic[EItemColorEnum.white]))
    self.lab_num:SetText(countStr)
    local itemData = ItemUtility.GenerateItemData(tonumber(strTab[1]))
    self.currentCostItemData = itemData
    self.isEnough = bagCount >= tonumber(strTab[2])
    if not self.itemCellDataCoin then
      self.itemCellDataCoin = ItemCellData()
    end
    self.itemCellDataCoin:RefreshData(itemData)
    ItemUtility.ShowItemCell(self.coin_Item, self.itemCellDataCoin, self, true)
    self.btn_obtain.itemData = itemData
    self.btn_obtain:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
    self.btn_obtain:SetActive(bagCount < count)
    self.cost:SetActive(true)
  else
    self.cost:SetActive(false)
    self.isEnough = true
  end
end

local function EffectFuc(obj)
  obj:SetActive(true)
end

function Equip_OverlapUI:SetOverlapEffect(isSucceed)
  self.Eff_UI_qianghuachenggong:SetActive(false)
  self.Eff_UI_qianghuashibai:SetActive(false)
  self.Eff_Ui_taozhuangdiejia:SetActive(false)
  if self.showEffectCoroutine ~= nil then
    Coroutine.Stop(self.showEffectCoroutine)
    self.showEffectCoroutine = nil
  end
  if self.showEffectCoroutineS ~= nil then
    Coroutine.Stop(self.showEffectCoroutineS)
    self.showEffectCoroutineS = nil
  end
  if isSucceed then
    self.showEffectCoroutine = Coroutine.Start(EffectFuc, self.Eff_UI_qianghuachenggong)
    self.showEffectCoroutineS = Coroutine.Start(EffectFuc, self.Eff_Ui_taozhuangdiejia)
  else
    self.showEffectCoroutine = Coroutine.Start(EffectFuc, self.Eff_UI_qianghuashibai)
  end
end

function Equip_OverlapUI:BtnLockOnClick(control)
  if control.canLock then
    if ForgeData.EquipOverlapMain.tblEquip.overlapReplaceMax == 0 then
      FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Overlap_1"))
      return
    end
    if not control.isLock then
      if table.count(self.lockExcellenceId) == ForgeData.EquipOverlapMain.tblEquip.overlapReplaceMax then
        FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Overlap_1"))
        return
      end
      table.insert(self.lockExcellenceId, control.excellenceId)
      self:AddExcellenceInfo(control.excellenceId, control.excellenceServerData)
      control.select:SetActive(true)
      control.nSelect:SetActive(false)
      control.isLock = true
      self.cfg_costMainTable = MeEquipController.GetEquipOverlapReplaceCostCfg(ForgeData.EquipOverlapMain, table.count(self.lockExcellenceId))
      self:SetEquipCost()
    else
      for i = 1, table.count(self.lockExcellenceId) do
        if self.lockExcellenceId[i] == control.excellenceId then
          table.remove(self.lockExcellenceId, i)
          break
        end
      end
      self:RemoveExcellenceInfo(control.excellenceId, control.excellenceServerData)
      control.isLock = false
      control.select:SetActive(false)
      control.nSelect:SetActive(true)
      self.cfg_costMainTable = MeEquipController.GetEquipOverlapReplaceCostCfg(ForgeData.EquipOverlapMain, table.count(self.lockExcellenceId))
      self:SetEquipCost()
    end
  elseif control.isWingChoose then
    if control.isMain then
      if self.lastMainControl then
        self.lastMainControl.wingSelect:SetActive(false)
      end
      self.lastMainControl = control
    else
      if self.lastSideControl then
        self.lastSideControl.wingSelect:SetActive(false)
      end
      self.lastSideControl = control
    end
    control.wingSelect:SetActive(true)
  end
end

function Equip_OverlapUI:SetSucceedRateUIShow(isSetCost)
  if self.addCurrentCount and self.addCurrentCount > 0 then
    local addRate
    if self.sucSingleRate * self.addCurrentCount > self.cfg_costMainTable.maxSuccessRate - self.cfg_costMainTable.rateClient then
      addRate = (self.cfg_costMainTable.maxSuccessRate - self.cfg_costMainTable.rateClient) * 0.01
      if addRate == Mathf.Floor(addRate) then
        addRate = Mathf.Floor(addRate)
      end
    else
      addRate = self.sucSingleRate * self.addCurrentCount * 0.01
      if addRate == Mathf.Floor(addRate) then
        addRate = Mathf.Floor(addRate)
      end
    end
    if not string.isNullOrEmpty(addRate) then
      self.sucYellowText:SetText("A" .. addRate .. "B")
    end
    self.sucItem.countCtr:SetText(self.addCurrentCount)
    self.sucItem.countCtr:SetActive(true)
    self:RefreshLuckyStoneBtn()
  else
    self.sucYellowText:SetText("A0B")
    self.sucItem.countCtr:SetActive(false)
    self:RefreshLuckyStoneBtn()
  end
  if isSetCost ~= true then
    self.addSucUI:SetActive(false)
  end
end

function Equip_OverlapUI:RefreshLuckyStoneBtn()
  local addLuckyStone = self.addCurrentCount ~= nil and self.addCurrentCount > 0
  self.add_Show:SetActive(addLuckyStone == false)
  self.go_model:SetActive(addLuckyStone)
  self.lab_name:SetActive(addLuckyStone)
end

function Equip_OverlapUI:RefreshBaseAttribute()
  if self.EquipData == nil then
    self.NormalAttribute:SetActive(false)
    self:RefreshOverlapEffectScrollViewHeight(false)
    return
  end
  local baseAttributeViewInfoList = ClientTable.cfg_Item_equip_redManager:GetAttributeViewInfoList(self.EquipData)
  if type(baseAttributeViewInfoList) ~= "table" or next(baseAttributeViewInfoList) == nil then
    self.NormalAttribute:SetActive(false)
    self:RefreshOverlapEffectScrollViewHeight(false)
    return
  end
  self.NormalAttribute:SetActive(true)
  self:RefreshOverlapEffectScrollViewHeight(true)
  self.attributesTemplate:SetData(baseAttributeViewInfoList)
end

function Equip_OverlapUI:RefreshOverlapEffectScrollViewHeight(haveBaseAttribute)
  local height = haveBaseAttribute == true and 168 or 195
  self.Viewport:SetSizeDelta(356, height)
end

function Equip_OverlapUI:AddExcellenceInfo(id, excelleneceServerData)
  if type(self.newLockExcellenceInfo) ~= "table" then
    return
  end
  table.insert(self.newLockExcellenceInfo, {configId = id, excellentAttribute = excelleneceServerData})
end

function Equip_OverlapUI:RemoveExcellenceInfo(id, excellenceServerData)
  if type(self.newLockExcellenceInfo) ~= "table" then
    return
  end
  for k = 1, #self.newLockExcellenceInfo do
    if self.newLockExcellenceInfo[k].configId == id and self.newLockExcellenceInfo[k].excellentAttribute == excellenceServerData then
      table.remove(self.newLockExcellenceInfo, k)
      return
    end
  end
end
