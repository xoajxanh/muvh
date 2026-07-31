Fruit_FruitAddUI = class(BaseUI)
Fruit_FruitAddUI.layer = UILayer.Panel
Fruit_FruitAddUI.orderInLayer = 2
Fruit_FruitAddUI.hideType = UIHideType.WaitDestroy
Fruit_FruitAddUI.hideFunc = UIHideFunc.MoveOutOfScreen
Fruit_FruitAddUI.escClose = UIEscClose.DontClose

function Fruit_FruitAddUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_closeMain = self:GetControl("img_Bg/btn_closeMain")
  self.resetBtn = self:GetControl("resetBtn")
  self.FruitItem = self:GetControl("Fruit/Viewport/Content/FruitItem")
  self.lab_roleLevel = self:GetControl("lab_roleLevel")
  self.lab_addNum = self:GetControl("lab_roleLevel/usedPoint/lab_addNum")
  self.lab_addMentalityNum = self:GetControl("lab_roleLevel/lab_bg_mentality/lab_addMentalityNum")
  self.lab_addAgilityNum = self:GetControl("lab_roleLevel/lab_bg_agility/lab_addAgilityNum")
  self.lab_addStrengthNum = self:GetControl("lab_roleLevel/lab_bg_strength/lab_addStrengthNum")
  self.lab_addPhysicalNum = self:GetControl("lab_roleLevel/lab_bg_physical/lab_addPhysicalNum")
  self.lab_lianjiAtrr = self:GetControl("lab_roleLevel/lab_lianjiAttr/lab_addPhysicalNum")
  self.lab_sdAtrr = self:GetControl("lab_roleLevel/lab_sdAtrr/lab_addPhysicalNum")
  self.lab_lianji = self:GetControl("lab_roleLevel/lab_lianji/lab_addPhysicalNum")
  self.lab_sd = self:GetControl("lab_roleLevel/lab_sd/lab_addPhysicalNum")
  self.ResetPanel = self:GetControl("ResetPanel")
  self.btn_closeResetPanel = self:GetControl("ResetPanel/btn_closeResetPanel")
  self.lab_distributableValue = self:GetControl("ResetPanel/lab_distributable/lab_distributableValue")
  self.Input_countStrength = self:GetControl("ResetPanel/strengthNum/Input_countStrength")
  self.btn_minusStrength = self:GetControl("ResetPanel/strengthNum/btn_minusStrength")
  self.btn_addStrength = self:GetControl("ResetPanel/strengthNum/btn_addStrength")
  self.Input_countAgility = self:GetControl("ResetPanel/agilityNum/Input_countAgility")
  self.btn_minusAgility = self:GetControl("ResetPanel/agilityNum/btn_minusAgility")
  self.btn_addAgility = self:GetControl("ResetPanel/agilityNum/btn_addAgility")
  self.Input_countPhysical = self:GetControl("ResetPanel/PhysicalNum/Input_countPhysical")
  self.btn_minusPhysical = self:GetControl("ResetPanel/PhysicalNum/btn_minusPhysical")
  self.btn_addPhysical = self:GetControl("ResetPanel/PhysicalNum/btn_addPhysical")
  self.Input_countMentality = self:GetControl("ResetPanel/MentalityNum/Input_countMentality")
  self.btn_minusMentality = self:GetControl("ResetPanel/MentalityNum/btn_minusMentality")
  self.btn_addMentality = self:GetControl("ResetPanel/MentalityNum/btn_addMentality")
  self.Item = self:GetControl("ResetPanel/lab_resetPrice/Item")
  self.lab_resetValue = self:GetControl("ResetPanel/lab_resetPrice/lab_resetValue")
  self.lab_resetPriceValue = self:GetControl("ResetPanel/lab_resetPrice/lab_resetPriceValue")
  self.CancelBtn = self:GetControl("ResetPanel/CancelBtn")
  self.ConfirmBtn = self:GetControl("ResetPanel/ConfirmBtn")
  self.FruitUsePanel = self:GetControl("FruitUsePanel")
  self.FruitUsePanelClose = self:GetControl("FruitUsePanel/FruitUsePanelClose")
  self.fruitItemUseIcon = self:GetControl("FruitUsePanel/fruitItemUseIcon")
  self.lab_Num = self:GetControl("FruitUsePanel/fruitItemUseIcon/lab_Num")
  self.lab_fruitValue = self:GetControl("FruitUsePanel/lab_fruitValue")
  self.storeBtn = self:GetControl("FruitUsePanel/storeBtn")
  self.VIPBtn = self:GetControl("FruitUsePanel/VIPBtn")
  self.LongBiBtn = self:GetControl("FruitUsePanel/LongBiBtn")
  self.UseBtn = self:GetControl("FruitUsePanel/UseBtn")
  self.descBtn = self:GetControl("descBtn")
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.btn_1 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_1")
  self.btn_2 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_2")
  self.btn_3 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_3")
  self.btn_4 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_4")
  self.btn_5 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_5")
  self.btn_6 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_6")
  self.btn_7 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_7")
  self.btn_8 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_8")
  self.btn_9 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_9")
  self.btn_no = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_no")
  self.btn_0 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_0")
  self.btn_closeBgCalculator = self:GetControl("Panel_Tip/btn_closeBg")
  self.btn_closeCalculator = self:GetControl("Panel_Tip/Image_TipBg/btn_close")
  self.btn_no = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_no")
  self.btn_yes = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_yes")
  self.txtCount = self:GetControl("Panel_Tip/Image_TipBg/panel_01/lab_Password/bg/txtCount")
end

function Fruit_FruitAddUI:OnPreLoad()
end

function Fruit_FruitAddUI:Init()
  self.LimitNum = {}
  self.FruitLevel = 0
  self.AllPoint = 0
  self.preAddMap = {}
  self.preAddMap.Strength = 0
  self.preAddMap.Agility = 0
  self.preAddMap.Physical = 0
  self.preAddMap.Mentality = 0
end

function Fruit_FruitAddUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Fruit_FruitAddUI:InitUI()
  self:InitContent()
end

function Fruit_FruitAddUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:btn_closeResetPanelOnClick()
end

function Fruit_FruitAddUI:OnHide()
end

function Fruit_FruitAddUI:OnDestroy()
end

local delayTime = 1
local intervalTime = 0.3

function Fruit_FruitAddUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeMainOnClick)
  self.btn_closeMain:SetOnClick(self, self.btn_closeMainOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.resetBtn:SetOnClick(self, self.resetBtnOnClick)
  self.btn_minusStrength:SetOnClick(self, self.btn_FruitMinusAttributeOnClick)
  self.btn_minusStrength:SetOnPress(self, self.btn_minusStrengthOnLongPress, self.btn_OnLongPressEnd, delayTime)
  self.btn_addStrength:SetOnClick(self, self.btn_FruitAddAttributeOnClick)
  self.btn_addStrength:SetOnPress(self, self.btn_addStrengthOnLongPress, self.btn_OnLongPressEnd, delayTime)
  self.btn_minusAgility:SetOnClick(self, self.btn_FruitMinusAttributeOnClick)
  self.btn_minusAgility:SetOnPress(self, self.btn_minusAgilityOnLongPress, self.btn_OnLongPressEnd, delayTime)
  self.btn_addAgility:SetOnClick(self, self.btn_FruitAddAttributeOnClick)
  self.btn_addAgility:SetOnPress(self, self.btn_addAgilityOnLongPress, self.btn_OnLongPressEnd, delayTime)
  self.btn_minusPhysical:SetOnClick(self, self.btn_FruitMinusAttributeOnClick)
  self.btn_minusPhysical:SetOnPress(self, self.btn_minusPhysicalOnLongPress, self.btn_OnLongPressEnd, delayTime)
  self.btn_addPhysical:SetOnClick(self, self.btn_FruitAddAttributeOnClick)
  self.btn_addPhysical:SetOnPress(self, self.btn_addPhysicalOnLongPress, self.btn_OnLongPressEnd, delayTime)
  self.btn_minusMentality:SetOnClick(self, self.btn_FruitMinusAttributeOnClick)
  self.btn_minusMentality:SetOnPress(self, self.btn_minusMentalityOnLongPress, self.btn_OnLongPressEnd, delayTime)
  self.btn_addMentality:SetOnClick(self, self.btn_FruitAddAttributeOnClick)
  self.btn_addMentality:SetOnPress(self, self.btn_addMentalityOnLongPress, self.btn_OnLongPressEnd, delayTime)
  self.CancelBtn:SetOnClick(self, self.CancelBtnOnClick)
  self.ConfirmBtn:SetOnClick(self, self.ConfirmBtnOnClick)
  self.FruitUsePanelClose:SetOnClick(self, self.FruitUsePanelCloseOnClick)
  self.UseBtn:SetOnClick(self, self.UseBtnOnClick)
  self.storeBtn:SetOnClick(self, self.storeBtnOnClick)
  self.VIPBtn:SetOnClick(self, self.VIPBtnOnClick)
  self.LongBiBtn:SetOnClick(self, self.LongBiBtnOnClick)
  self.Input_countStrength:SetOnEndEdit(self, self.Input_countStrengthOnChanged)
  self.Input_countAgility:SetOnEndEdit(self, self.Input_countAgilityOnChanged)
  self.Input_countPhysical:SetOnEndEdit(self, self.Input_countPhysicalOnChanged)
  self.Input_countMentality:SetOnEndEdit(self, self.Input_countMentalityOnChanged)
  self.btn_closeResetPanel:SetOnClick(self, self.btn_closeResetPanelOnClick)
  self:BindBtnEvent()
  self.btn_addStrength.type = CAttributeFruitAddPointType.Strength
  self.btn_minusStrength.type = CAttributeFruitAddPointType.Strength
  self.btn_minusAgility.type = CAttributeFruitAddPointType.Agility
  self.btn_addAgility.type = CAttributeFruitAddPointType.Agility
  self.btn_minusPhysical.type = CAttributeFruitAddPointType.Physical
  self.btn_addPhysical.type = CAttributeFruitAddPointType.Physical
  self.btn_minusMentality.type = CAttributeFruitAddPointType.Mentality
  self.btn_addMentality.type = CAttributeFruitAddPointType.Mentality
  self.btn_closeBgCalculator:SetOnClick(self, self.btn_closeCalculatorOnClick)
  self.btn_closeCalculator:SetOnClick(self, self.btn_closeCalculatorOnClick)
  self.btn_no:SetOnClick(self, self.btn_noOnClick)
  self.btn_yes:SetOnClick(self, self.btn_yesOnClick)
end

function Fruit_FruitAddUI:BindBtnEvent()
  if self.btnList and table.count(self.btnList) > 0 then
    for i, v in pairs(self.btnList) do
      v:SetOnClick(self, self.InputPointOnClick)
    end
  end
end

function Fruit_FruitAddUI:InputPointOnClick(control)
  if control == nil and control.number == nil then
    return
  end
  local allPoint = self.AllPoint
  local preInputNumber = self.inputNumber
  local lastAllInputNumber = self.preAddMap.Strength + self.preAddMap.Agility + self.preAddMap.Physical + self.preAddMap.Mentality
  local lastInputNumber = self.preAddMap[self.selectControl.type]
  local curInputNumber = control.number > 9 and 9 or control.number < 0 and 0 or control.number
  preInputNumber = tonumber(tostring(preInputNumber) .. tostring(curInputNumber))
  if self.selectState == CAttributeAddPointState.AddAttribute then
    self.inputNumber = preInputNumber >= allPoint - lastAllInputNumber and allPoint - lastAllInputNumber or preInputNumber
    self.addAttributePointEmpty = self.inputNumber >= allPoint - lastAllInputNumber and true or false
  elseif self.selectState == CAttributeAddPointState.ReduceAttribute then
    self.inputNumber = lastInputNumber <= preInputNumber and lastInputNumber or preInputNumber
    self.reduceAttributePointEmpty = lastInputNumber <= self.inputNumber and true or false
  end
  self.txtCount:SetText(self.inputNumber)
end

function Fruit_FruitAddUI:btn_FruitAddAttributeOnClick(control)
  if control == nil and control.type == nil then
    return
  end
  local globalPoint = tonumber(GlobalConfig.GetGlobalConfig(2430201))
  local validAttributePoint = self.AllPoint
  if globalPoint <= validAttributePoint then
    self:ResetCalculatorData()
    self.selectControl = control
    self.selectState = CAttributeAddPointState.AddAttribute
    self.Panel_Tip:SetActive(true)
  else
    self:FruitAddAttribute(control, 1)
  end
end

function Fruit_FruitAddUI:FruitAddAttribute(control, number)
  if self.residuePointNum > 0 then
    self.preAddMap[control.type] = self.preAddMap[control.type] + number
    self.inputTextMap[control.type]:SetInputText(self.preAddMap[control.type])
    self:ResiduePoint()
  end
end

function Fruit_FruitAddUI:btn_FruitMinusAttributeOnClick(control)
  if control == nil and control.type == nil then
    return
  end
  local globalPoint = tonumber(GlobalConfig.GetGlobalConfig(2430201))
  local validAttributePoint = self.AllPoint
  if globalPoint <= validAttributePoint then
    self:ResetCalculatorData()
    self.selectControl = control
    self.selectState = CAttributeAddPointState.ReduceAttribute
    self.Panel_Tip:SetActive(true)
  else
    self:FruitMinusAttribute(control, 1)
  end
end

function Fruit_FruitAddUI:FruitMinusAttribute(control, number)
  local point = self.preAddMap[control.type]
  if 1 <= point then
    self.preAddMap[control.type] = self.preAddMap[control.type] - number
    self.inputTextMap[control.type]:SetInputText(self.preAddMap[control.type])
  end
  self:ResiduePoint()
end

function Fruit_FruitAddUI:btn_noOnClick()
  local inputStr = tostring(self.inputNumber)
  local numLength = string.len(inputStr)
  if numLength <= 1 then
    self.inputNumber = 0
  else
    self.inputNumber = tonumber(string.sub(inputStr, 1, numLength - 1))
  end
  self.txtCount:SetText(self.inputNumber)
end

function Fruit_FruitAddUI:btn_yesOnClick()
  if self.selectState == CAttributeAddPointState.AddAttribute then
    self:FruitAddAttribute(self.selectControl, self.inputNumber)
  elseif self.selectState == CAttributeAddPointState.ReduceAttribute then
    self:FruitMinusAttribute(self.selectControl, self.inputNumber)
  end
  if self.addAttributePointEmpty or self.reduceAttributePointEmpty then
    self.Panel_Tip:SetActive(false)
    return
  end
  self.inputNumber = 0
  self.txtCount:SetText("")
end

function Fruit_FruitAddUI:btn_closeCalculatorOnClick()
  self.Panel_Tip:SetActive(false)
  self:ResetCalculatorData()
end

function Fruit_FruitAddUI:ResetCalculatorData()
  self.inputNumber = 0
  self.txtCount:SetText("")
  self.selectControl = nil
  self.selectState = CAttributeAddPointState.AddAttribute
  self.addAttributePointEmpty = false
  self.reduceAttributePointEmpty = false
end

function Fruit_FruitAddUI:btn_closeMainOnClick(control)
  UIManager.Hide(UIID.Fruit_FruitAddUI)
  self:CancelBtnOnClick()
  for i = 1, #Role_AttributeUI.AttributeChangeTab do
    Role_AttributeUI.AttributeChangeTab[i]:SetActive(false)
  end
end

function Fruit_FruitAddUI:btn_closeResetPanelOnClick(control)
  if self.ResetPanel:GetActive() then
    self:ClearPoint()
    self.ResetPanel:SetActive(false)
  end
end

function Fruit_FruitAddUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Fruit_FruitAddUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Fruit_FruitAddUI:resetBtnOnClick(control)
  local AttributeTime = self.meData.AttributeTime + 1
  local itemInfoStr = self:GetNeedItemInfo()
  local itemId = tonumber(itemInfoStr[1])
  local needCount = tonumber(itemInfoStr[2])
  local bagCount = BagInfoData.GetItemTotalCountByItemId(itemId)
  local strColor = needCount <= bagCount and "#ffffff" or "#ff2323"
  self.residuePointNum = self.AllPoint
  self.lab_distributableValue:SetText(self.AllPoint)
  self.lab_resetValue:SetText(AttributeTime)
  if self.meData.freeReset then
    self.lab_resetPriceValue:SetText(string.GetColorText("Mi\225\187\133n ph\195\173", ItemQuality2ColorDic[5]))
  else
    self.lab_resetPriceValue:SetText(string.GetColorText(needCount, strColor))
  end
  self.ResetPanel:SetActive(true)
  local itemData = ItemUtility.GenerateItemData(itemId)
  if not self.cellData then
    self.cellData = ItemCellData()
  end
  self.cellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.Item, self.cellData, self, true)
  local lab_num = self.Item:GetChild("lab_num")
  if lab_num ~= nil then
    lab_num:SetActive(false)
  end
end

function Fruit_FruitAddUI:GetNeedItemInfo()
  if self.itemInfoArray == nil or #self.itemInfoArray <= 0 then
    local unitPrice = ClientTable.cfg_Global_globalManager:TryGetValue(2380002)
    self.itemInfoArray = string.split(unitPrice.effect, "&")
  end
  local AttributeTime = self.meData.AttributeTime + 1
  local itemInfoStr
  if AttributeTime <= #self.itemInfoArray then
    itemInfoStr = string.split(self.itemInfoArray[AttributeTime], "#")
  else
    local maxIndex = #self.itemInfoArray
    itemInfoStr = string.split(self.itemInfoArray[maxIndex], "#")
  end
  return itemInfoStr
end

function Fruit_FruitAddUI:Input_countStrengthOnChanged()
  self.preAddMap.Strength = self.Input_countStrength:GetInputText()
  self:ResiduePoint()
end

function Fruit_FruitAddUI:Input_countAgilityOnChanged()
  self.preAddMap.Agility = self.Input_countAgility:GetInputText()
  self:ResiduePoint()
end

function Fruit_FruitAddUI:Input_countPhysicalOnChanged()
  self.preAddMap.Physical = self.Input_countPhysical:GetInputText()
  self:ResiduePoint()
end

function Fruit_FruitAddUI:Input_countMentalityOnChanged()
  self.preAddMap.Mentality = self.Input_countMentality:GetInputText()
  self:ResiduePoint()
end

function Fruit_FruitAddUI:btn_minusStrengthOnLongPress(control, eventData)
  if not self:GetTimeDown() then
    return
  end
  self:btn_FruitMinusAttributeOnClick(control)
end

function Fruit_FruitAddUI:btn_addStrengthOnLongPress(control, eventData)
  if not self:GetTimeDown() then
    return
  end
  self:btn_FruitAddAttributeOnClick(control)
end

function Fruit_FruitAddUI:btn_minusAgilityOnLongPress(control, eventData)
  if not self:GetTimeDown() then
    return
  end
  self:btn_FruitMinusAttributeOnClick(control)
end

function Fruit_FruitAddUI:btn_addAgilityOnLongPress(control, eventData)
  if not self:GetTimeDown() then
    return
  end
  self:btn_FruitAddAttributeOnClick(control)
end

function Fruit_FruitAddUI:btn_minusPhysicalOnLongPress(control, eventData)
  if not self:GetTimeDown() then
    return
  end
  self:btn_FruitMinusAttributeOnClick(control)
end

function Fruit_FruitAddUI:btn_addPhysicalOnLongPress(control, eventData)
  if not self:GetTimeDown() then
    return
  end
  self:btn_FruitAddAttributeOnClick(control)
end

function Fruit_FruitAddUI:btn_minusMentalityOnLongPress(control, eventData)
  if not self:GetTimeDown() then
    return
  end
  self:btn_FruitMinusAttributeOnClick(control)
end

function Fruit_FruitAddUI:btn_addMentalityOnLongPress(control, eventData)
  if not self:GetTimeDown() then
    return
  end
  self:btn_FruitAddAttributeOnClick(control)
end

function Fruit_FruitAddUI:GetTimeDown()
  intervalTime = intervalTime - Time.deltaTime
  if intervalTime <= 0 then
    intervalTime = 0.3
    return true
  end
  return false
end

function Fruit_FruitAddUI:btn_OnLongPressEnd(control)
  intervalTime = 0.3
end

function Fruit_FruitAddUI:ResiduePoint()
  local residuePointNum = math.floor(self.AllPoint - (self.preAddMap.Strength + self.preAddMap.Agility + self.preAddMap.Physical + self.preAddMap.Mentality))
  if residuePointNum <= 0 then
    residuePointNum = 0
  end
  self.residuePointNum = residuePointNum
  self.lab_distributableValue:SetText(residuePointNum)
end

function Fruit_FruitAddUI:ClearPoint()
  self.preAddMap.Strength = 0
  self.preAddMap.Agility = 0
  self.preAddMap.Physical = 0
  self.preAddMap.Mentality = 0
  self.Input_countStrength:SetInputText(self.preAddMap.Strength)
  self.Input_countAgility:SetInputText(self.preAddMap.Agility)
  self.Input_countPhysical:SetInputText(self.preAddMap.Physical)
  self.Input_countMentality:SetInputText(self.preAddMap.Mentality)
  self.ResetPanel:SetActive(false)
end

function Fruit_FruitAddUI:CancelBtnOnClick(control)
  self:ClearPoint()
end

function Fruit_FruitAddUI:ConfirmBtnOnClick(control)
  local pointNum = self.preAddMap.Strength + self.preAddMap.Agility + self.preAddMap.Physical + self.preAddMap.Mentality
  if pointNum ~= self.AllPoint then
    local text = LocalizationUtility.GetContentByKey("FruitResetFail_1")
    self:PromptTipUI(text)
    return
  end
  if 0 == self.AllPoint then
    local text = LocalizationUtility.GetContentByKey("FruitResetFail_2")
    self:PromptTipUI(text)
    return
  end
  local itemInfoStr = Fruit_FruitAddUI:GetNeedItemInfo()
  local itemId = tonumber(itemInfoStr[1])
  local needCount = tonumber(itemInfoStr[2])
  local bagGem = BagInfoData.GetItemTotalCountByItemId(itemId)
  if self.meData.freeReset == false and needCount > bagGem then
    local coinData = ItemUtility.GenerateItemData(itemId)
    UIManager.Show(UIID.ItemTipUI, {
      item = coinData,
      rightOperate = EItemOperateType.Show,
      ctrl = control,
      ShowObtain = true
    })
    return
  end
  local restFruitList = {
    strength = self.preAddMap.Strength,
    agility = self.preAddMap.Agility,
    vitality = self.preAddMap.Physical,
    energy = self.preAddMap.Mentality
  }
  NetManager.Send(FruitMessage.ReqResetFruit, {fruitAttribute = restFruitList})
  self:ClearPoint()
end

function Fruit_FruitAddUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.OnResFruitItemChange, self)
  self:RegistEvent(Event.Bag_ResUseItem, self.OnRefreshFruitAttribute, self)
  self:RegistEvent(Event.Role_MyAttributeChanged, self.OnRefreshFruitAttribute, self)
end

function Fruit_FruitAddUI:Refresh()
  self.meData = ViewData.meData
  self.inputNumber = 0
  self:UpdateAddPoint()
  self:UpdateFruitList()
end

local function FruitItemCre(control)
  control.itemCtr = ItemUtility.InitItemCell(UIControl(control.transform))
  control.modelData = ItemCellData()
end

function Fruit_FruitAddUI:InitContent()
  self.FruitItemTemp = UIContainer(self.FruitItem, self, FruitItemCre)
  local attributeLimit = ClientTable.cfg_Global_globalManager:TryGetValue(2380001)
  if attributeLimit ~= nil then
    self.maxAllPoint = string.split(string.split(attributeLimit.effect, "&")[1], "#")[2]
  else
    self.maxAllPoint = 450
  end
  local Limit = string.split(attributeLimit.effect, "&")
  for i = 1, #Limit do
    table.insert(self.LimitNum, tonumber(Limit[i]))
  end
  self.btnList = {
    [1] = self.btn_1,
    [2] = self.btn_2,
    [3] = self.btn_3,
    [4] = self.btn_4,
    [5] = self.btn_5,
    [6] = self.btn_6,
    [7] = self.btn_7,
    [8] = self.btn_8,
    [9] = self.btn_9,
    [0] = self.btn_0
  }
  self.btn_1.number = 1
  self.btn_2.number = 2
  self.btn_3.number = 3
  self.btn_4.number = 4
  self.btn_5.number = 5
  self.btn_6.number = 6
  self.btn_7.number = 7
  self.btn_8.number = 8
  self.btn_9.number = 9
  self.btn_0.number = 0
  self.inputTextMap = {}
  self.inputTextMap.Strength = self.Input_countStrength
  self.inputTextMap.Agility = self.Input_countAgility
  self.inputTextMap.Physical = self.Input_countPhysical
  self.inputTextMap.Mentality = self.Input_countMentality
end

function Fruit_FruitAddUI:UpdateAddPoint()
  local Strength = self.meData.attributeAddPoint.strength or 0
  local Agility = self.meData.attributeAddPoint.agility or 0
  local Physical = self.meData.attributeAddPoint.vitality or 0
  local Mentality = self.meData.attributeAddPoint.energy or 0
  local DoubleHit = self.meData.attributeAddPoint.comboRecovery_mul or 0
  local Sd = self.meData.attributeAddPoint.shieldRecoveryMultiplier_mul or 0
  local AllPoint = Strength + Agility + Physical + Mentality
  local doubleHitRatio = ConfigManager.FindConfigs("cfg_Global_global", "id", 11110102)
  local sdRatio = ConfigManager.FindConfigs("cfg_Global_global", "id", 11110101)
  doubleHitRatio = doubleHitRatio ~= nil and tonumber(doubleHitRatio[1]) ~= nil and tonumber(doubleHitRatio[1].effect) or 20
  sdRatio = sdRatio ~= nil and tonumber(sdRatio[1]) ~= nil and tonumber(sdRatio[1].effect) or 20
  self.lab_addStrengthNum:SetText("S\225\187\169c M\225\186\161nh + " .. Strength)
  self.lab_addAgilityNum:SetText("Nhanh Nh\225\186\185n + " .. Agility)
  self.lab_addPhysicalNum:SetText("Th\225\187\131 L\225\187\177c + " .. Physical)
  self.lab_addMentalityNum:SetText("Tr\195\173 L\225\187\177c + " .. Mentality)
  self.lab_lianji:SetText("Li\195\170n K\195\173ch + " .. DoubleHit * 0.01 .. "%")
  self.lab_sd:SetText("SD+ " .. Sd * 0.01 .. "%")
  self.lab_lianjiAtrr:SetText("T\225\187\145c \196\145\225\187\153 kh\195\180i ph\225\187\165c Li\195\170n K\195\173ch: " .. DoubleHit * 0.01 .. "%/200%")
  self.lab_sdAtrr:SetText("T\225\187\145c \196\145\225\187\153 kh\195\180i ph\225\187\165c SD: " .. Sd * 0.01 .. "%/200%")
  self.lab_addNum:SetText(string.format("%d/%d", AllPoint, self.maxAllPoint))
  self.FruitLevel = 1
  self.AllPoint = AllPoint
end

function Fruit_FruitAddUI:SetFilled(Point)
  local AllPoint = Point
  local percent = AllPoint / self.LimitNum[6]
  local posX = 300
  local pos = posX * percent
  if AllPoint >= self.LimitNum[1] and AllPoint <= self.LimitNum[2] then
    self.FruitLevel = 1
    self.addCountFilledOne.image.fillAmount = AllPoint / self.LimitNum[2]
    self.addCountFilledTwo.image.color = Color.black
    self.addCountFilledThree.image.color = Color.black
  elseif AllPoint >= self.LimitNum[3] and AllPoint < self.LimitNum[4] then
    self.FruitLevel = 2
    local TwoLimitNum = self.LimitNum[4] - self.LimitNum[3]
    local TwoNum = AllPoint - self.LimitNum[2]
    self.addCountFilledOne.image.fillAmount = 1
    self.addCountFilledTwo.image.fillAmount = TwoNum / TwoLimitNum
    self.addCountFilledTwo.image.color = Color(0, 233, 245, 255)
    self.addCountFilledThree.image.color = Color.black
  else
    self.FruitLevel = 3
    local ThreeLimitNum = self.LimitNum[6] - self.LimitNum[5]
    local ThreeNum = AllPoint - self.LimitNum[4]
    self.addCountFilledOne.image.fillAmount = 1
    self.addCountFilledTwo.image.fillAmount = 1
    self.addCountFilledThree.image.fillAmount = ThreeNum / ThreeLimitNum
    self.addCountFilledThree.image.color = Color(0, 233, 245, 255)
  end
end

function Fruit_FruitAddUI:UpdateFruitList()
  local fruitLevel = FruitData.FruitDataItemData[self.FruitLevel]
  for i = 1, #fruitLevel do
    local item = BagInfoData.GetItemByConfigID(fruitLevel[i])
    local obj = self.FruitItemTemp:GetOrCreateItem(i)
    local itemData = ItemUtility.GenerateItemData(fruitLevel[i])
    local count = BagInfoData.GetItemCountByItemConfigId(fruitLevel[i])
    local color = count <= 0 and "#FF2323" or "#1add1f"
    itemData.count = string.GetColorText(count, color)
    obj.modelData:RefreshData(itemData)
    ItemUtility.ShowItemCell(obj.itemCtr, obj.modelData, self)
    obj:SetOnClick(self, function()
      obj.modelData.itemData.count = count
      if obj.modelData.itemData.count > 10 then
        obj.modelData.itemData.count = 10
      end
      if item then
        obj.modelData.itemData.id = item.id
        UIManager.Show(UIID.ItemTipUI, {
          item = obj.modelData.itemData,
          rightOperate = EItemOperateType.JumpPanelOrUse,
          ctrl = obj.itemCtr,
          openSource = UIID.Fruit_FruitAddUI
        })
      else
        UIManager.Show(UIID.ItemTipUI, {
          item = obj.modelData.itemData,
          rightOperate = EItemOperateType.Show,
          ctrl = obj.itemCtr,
          ShowObtain = true
        })
      end
    end)
  end
end

local Item

function Fruit_FruitAddUI:ShowFruitUsePanel(itemData, FruitItem, item, count)
  Item = item
  ItemUtility.ShowItem(self, self.fruitItemUseIcon, itemData, true)
  self.lab_fruitValue:SetText(FruitItem.content)
  self.FruitUsePanel:SetActive(true)
end

function Fruit_FruitAddUI:UseBtnOnClick()
  local itemData = Item
  if itemData == nil then
    self:PromptTipUI("V\225\186\173t ph\225\186\169m kh\195\180ng \196\145\225\187\167")
    return
  end
  local useItemTbl = {
    useCount = 1,
    useItemId = itemData.id,
    configId = itemData.itemId,
    params = nil
  }
  ItemUtility.UseItem(useItemTbl)
  EventManager.Dispatch(Event.Role_FruitUse)
  self:FruitUsePanelCloseOnClick()
end

function Fruit_FruitAddUI:FruitUsePanelCloseOnClick()
  self.FruitUsePanel:SetActive(false)
end

function Fruit_FruitAddUI:storeBtnOnClick()
  UIManager.Hide(UIID.Role_AttributeUI)
  UIManager.Show(UIID.Shop)
end

function Fruit_FruitAddUI:VIPBtnOnClick()
  self:PromptTipUI("Kh\195\180ng c\195\179 s\225\187\177 ki\225\187\135n VIP")
end

function Fruit_FruitAddUI:LongBiBtnOnClick()
  self:PromptTipUI("Kh\195\180ng c\195\179 Shop Xu R\225\187\147ng")
end

function Fruit_FruitAddUI:OnResFruitItemChange()
  self:Refresh()
end

function Fruit_FruitAddUI:OnRefreshFruitAttribute()
  self:Refresh()
end

function Fruit_FruitAddUI:PromptTipUI(str)
  UIManager.Show(UIID.PromptTipUI, {
    tile = "Nh\225\186\175c nh\225\187\159",
    textContent = str
  })
end
