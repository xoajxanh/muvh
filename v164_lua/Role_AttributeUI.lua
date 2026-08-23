Role_AttributeUI = class(BaseUI)
Role_AttributeUI.layer = UILayer.Panel
Role_AttributeUI.orderInLayer = 0
Role_AttributeUI.hideType = UIHideType.WaitDestroy
Role_AttributeUI.hideFunc = UIHideFunc.MoveOutOfScreen
Role_AttributeUI.escClose = UIEscClose.DontClose

function Role_AttributeUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_closeMain = self:GetControl("btn_closeMain")
  self.lab_roleName = self:GetControl("lab_roleName")
  self.lab_serverName = self:GetControl("lab_serverName")
  self.btn_showAllAttr = self:GetControl("btn_showAllAttr")
  self.btn_showFruit = self:GetControl("btn_showFruit")
  self.btn_recommend = self:GetControl("btn_recommend")
  self.lab_recommend = self:GetControl("btn_recommend/lab_recommend")
  self.TransferSelectSSUI = self:GetControl("TransferSelectSSUI")
  self.choCha = self:GetControl("TransferSelectSSUI/choCha")
  self.btnYes_Brains = self:GetControl("TransferSelectSSUI/choCha/content/occupationOne/btnYes_Brains")
  self.btnYes_Agility = self:GetControl("TransferSelectSSUI/choCha/content/occupationTwo/btnYes_Agility")
  self.plane_top = self:GetControl("TransferSelectSSUI/plane_top")
  self.btn_resetPoint = self:GetControl("btn_resetPoint")
  self.lab_level = self:GetControl("roleMessage/level/lab_level")
  self.lab_exp = self:GetControl("roleMessage/exp/lab_exp")
  self.lab_strength = self:GetControl("roleMessage/strength/firstAttribute/lab_strength")
  self.btn_plusStrength = self:GetControl("roleMessage/strength/firstAttribute/btn_plusStrength")
  self.input_preValueStrength = self:GetControl("roleMessage/strength/firstAttribute/input_preValueStrength")
  self.lbl_addStrengthSign = self:GetControl("roleMessage/strength/firstAttribute/lbl_addStrengthSign")
  self.btn_minusStrength = self:GetControl("roleMessage/strength/firstAttribute/btn_minusStrength")
  self.lab_strengthChangeNum = self:GetControl("roleMessage/strength/firstAttribute/lab_strengthChangeNum")
  self.lab_damage = self:GetControl("roleMessage/strength/damage/lab_damage")
  self.lab_attackRatePvm = self:GetControl("roleMessage/strength/attackRatePvm/lab_attackRatePvm")
  self.extraDamage = self:GetControl("roleMessage/strength/extraDamage")
  self.lab_extraDamage = self:GetControl("roleMessage/strength/extraDamage/lab_extraDamage")
  self.lab_agility = self:GetControl("roleMessage/agility/firstAttribute/lab_agility")
  self.btn_plusAgility = self:GetControl("roleMessage/agility/firstAttribute/btn_plusAgility")
  self.input_preValueAgility = self:GetControl("roleMessage/agility/firstAttribute/input_preValueAgility")
  self.lbl_addAgilitySign = self:GetControl("roleMessage/agility/firstAttribute/lbl_addAgilitySign")
  self.btn_minusAgility = self:GetControl("roleMessage/agility/firstAttribute/btn_minusAgility")
  self.lab_agilityChangeNum = self:GetControl("roleMessage/agility/firstAttribute/lab_agilityChangeNum")
  self.lab_defense = self:GetControl("roleMessage/agility/defense/lab_defense")
  self.lab_attackSpeed = self:GetControl("roleMessage/agility/attackSpeed/lab_attackSpeed")
  self.lab_defenseRatePvm = self:GetControl("roleMessage/agility/defenseRatePvm/lab_defenseRatePvm")
  self.lab_vitality = self:GetControl("roleMessage/vitality/firstAttribute/lab_vitality")
  self.btn_plusVitality = self:GetControl("roleMessage/vitality/firstAttribute/btn_plusVitality")
  self.input_preValueVitality = self:GetControl("roleMessage/vitality/firstAttribute/input_preValueVitality")
  self.btn_minusVitality = self:GetControl("roleMessage/vitality/firstAttribute/btn_minusVitality")
  self.lbl_addVitalitySign = self:GetControl("roleMessage/vitality/firstAttribute/lbl_addVitalitySign")
  self.lab_physicalChangeNum = self:GetControl("roleMessage/vitality/firstAttribute/lab_physicalChangeNum")
  self.lab_maximumHealth = self:GetControl("roleMessage/vitality/maximumHealth/lab_maximumHealth")
  self.lab_energy = self:GetControl("roleMessage/energy/firstAttribute/lab_energy")
  self.btn_plusEnergy = self:GetControl("roleMessage/energy/firstAttribute/btn_plusEnergy")
  self.input_preValueEnergy = self:GetControl("roleMessage/energy/firstAttribute/input_preValueEnergy")
  self.btn_minusEnergy = self:GetControl("roleMessage/energy/firstAttribute/btn_minusEnergy")
  self.lbl_addEnergySign = self:GetControl("roleMessage/energy/firstAttribute/lbl_addEnergySign")
  self.lab_mentalityChangeNum = self:GetControl("roleMessage/energy/firstAttribute/lab_mentalityChangeNum")
  self.lab_maximumMana = self:GetControl("roleMessage/energy/maximumMana /lab_maximumMana ")
  self.skillMultiplier = self:GetControl("roleMessage/energy/skillMultiplier")
  self.lab_skillMultiplier = self:GetControl("roleMessage/energy/skillMultiplier/lab_skillMultiplier")
  self.magicDamage = self:GetControl("roleMessage/energy/magicDamage")
  self.lab_magicDamage = self:GetControl("roleMessage/energy/magicDamage/lab_magicDamage")
  self.curseDamage = self:GetControl("roleMessage/energy/curseDamage")
  self.magicExtraDamage = self:GetControl("roleMessage/energy/magicExtraDamage")
  self.lab_magicExtraDamage = self:GetControl("roleMessage/energy/magicExtraDamage/lab_magicExtraDamage")
  self.btn_comfirm = self:GetControl("btn_comfirm")
  self.lab_levelupPoint = self:GetControl("levelupPoint/lab_levelupPoint")
  self.descBtn = self:GetControl("descBtn")
  self.resetPointPanel = self:GetControl("resetPointPanel")
  self.resetPointPanelClose = self:GetControl("resetPointPanel/resetPointPanelClose")
  self.btn_resetPointPanelClose = self:GetControl("resetPointPanel/btn_resetPointPanelClose")
  self.lab_resPointValue = self:GetControl("resetPointPanel/lab_resPoint/lab_resPointValue")
  self.btn_get2 = self:GetControl("resetPointPanel/lab_price/btn_get2")
  self.consumeItem = self:GetControl("resetPointPanel/lab_price/consumeItem")
  self.lab_priceValue = self:GetControl("resetPointPanel/lab_price/lab_priceValue")
  self.cancelBtn = self:GetControl("resetPointPanel/cancelBtn")
  self.confirmBtn = self:GetControl("resetPointPanel/confirmBtn")
  self.text_freePoints = self:GetControl("resetPointPanel/text_freePoints")
  self.Image_ItemBg = self:GetControl("Image_ItemBg")
  self.Button_Cance = self:GetControl("Image_ItemBg/Button_Cance")
  self.Button_Ok = self:GetControl("Image_ItemBg/Button_Ok")
  self.Text_OK = self:GetControl("Image_ItemBg/Button_Ok/Text_OK")
  self.needItem = self:GetControl("Image_ItemBg/needItem")
  self.btn_needGold = self:GetControl("Image_ItemBg/btn_needGold")
  self.lab_num = self:GetControl("Image_ItemBg/btn_needGold/lab_num")
end

local Refreshpaneljia
local stcbol = false
local resurageGoldId = 2430010
local archerTransferLevel = 1100007

function Role_AttributeUI:Init()
end

function Role_AttributeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Role_AttributeUI:InitUI()
  self.goldId = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(resurageGoldId))
  self.archerLevel = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(archerTransferLevel))
  self.resurageGoldTbl = ClientTable.cfg_Item_buyManager:TryGetValue(self.goldId)
  self.costTbl = self.resurageGoldTbl and ParseUtility.ParseSingleCost(self.resurageGoldTbl.cost) or {}
  self.needTbl = self.resurageGoldTbl and ParseUtility.ParseSingleCost(self.resurageGoldTbl.reward) or {}
  self.isOnPress = false
  self.AttributeChangeTab = {
    [1] = self.lab_strengthChangeNum,
    [2] = self.lab_agilityChangeNum,
    [3] = self.lab_physicalChangeNum,
    [4] = self.lab_mentalityChangeNum
  }
  self.recommendPoint = {}
  self.recommendPointEffect = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2430013)
  local occupation = string.split(self.recommendPointEffect, "&")
  for i, v in ipairs(occupation) do
    local recommendPoint = string.split(v, "#")
    local pationTable = {}
    for i, v in ipairs(recommendPoint) do
      table.insert(pationTable, tonumber(v))
    end
    table.insert(self.recommendPoint, pationTable)
  end
  self.careerDes = {
    [11] = 1002,
    [12] = 1025,
    [13] = 1026,
    [14] = 1078,
    [16] = 1125
  }
  self.Proportion = {}
  self.HavePoint = {}
  self.recommendAddPoint = {}
  self.magicExtraDamageStartPos = self.magicExtraDamage.transform.localPosition
end

function Role_AttributeUI:OnShow()
  self:RegistEvents()
  if self.args.FristPanelUI == true then
    self.FristPanelUI = true
  end
  self:Refresh()
  networkRequest.ReqPlayerAttribute()
end

function Role_AttributeUI:OnHide()
end

function Role_AttributeUI:OnDestroy()
end

function Role_AttributeUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeMainOnClick)
  self.btn_closeMain:SetOnClick(self, self.btn_closeMainOnClick)
  self.btn_showAllAttr:SetOnClick(self, self.btn_showAllAttrOnClick)
  self.btn_showFruit:SetOnClick(self, self.btn_showFruitOnClick)
  local pressDelay = 1
  self.btn_plusStrength.attrType = C_AttributeType_Key.strength
  self.btn_plusStrength:SetOnClick(self, self.btn_plusAttributeOnClick)
  self.btn_plusStrength:SetOnPress(self, self.btn_plusAttributeOnPress, self.btn_attributeOnStopPress, pressDelay)
  self.btn_plusAgility.attrType = C_AttributeType_Key.agility
  self.btn_plusAgility:SetOnClick(self, self.btn_plusAttributeOnClick)
  self.btn_plusAgility:SetOnPress(self, self.btn_plusAttributeOnPress, self.btn_attributeOnStopPress, pressDelay)
  self.btn_plusVitality.attrType = C_AttributeType_Key.vitality
  self.btn_plusVitality:SetOnClick(self, self.btn_plusAttributeOnClick)
  self.btn_plusVitality:SetOnPress(self, self.btn_plusAttributeOnPress, self.btn_attributeOnStopPress, pressDelay)
  self.btn_plusEnergy.attrType = C_AttributeType_Key.energy
  self.btn_plusEnergy:SetOnClick(self, self.btn_plusAttributeOnClick)
  self.btn_plusEnergy:SetOnPress(self, self.btn_plusAttributeOnPress, self.btn_attributeOnStopPress, pressDelay)
  self.btn_minusStrength.attrType = C_AttributeType_Key.strength
  self.btn_minusStrength:SetOnClick(self, self.btn_minusAttributeOnClick)
  self.btn_minusStrength:SetOnPress(self, self.btn_minusAttributeOnPress, self.btn_attributeOnStopPress, pressDelay)
  self.btn_minusAgility.attrType = C_AttributeType_Key.agility
  self.btn_minusAgility:SetOnClick(self, self.btn_minusAttributeOnClick)
  self.btn_minusAgility:SetOnPress(self, self.btn_minusAttributeOnPress, self.btn_attributeOnStopPress, pressDelay)
  self.btn_minusVitality.attrType = C_AttributeType_Key.vitality
  self.btn_minusVitality:SetOnClick(self, self.btn_minusAttributeOnClick)
  self.btn_minusVitality:SetOnPress(self, self.btn_minusAttributeOnPress, self.btn_attributeOnStopPress, pressDelay)
  self.btn_minusEnergy.attrType = C_AttributeType_Key.energy
  self.btn_minusEnergy:SetOnClick(self, self.btn_minusAttributeOnClick)
  self.btn_minusEnergy:SetOnPress(self, self.btn_minusAttributeOnPress, self.btn_attributeOnStopPress, pressDelay)
  self.btn_comfirm:SetOnClick(self, self.btn_comfirmOnClick)
  self.btn_recommend:SetOnClick(self, self.btn_recommendOnClick)
  self.btn_resetPoint:SetOnClick(self, self.btn_resetPointOnClick)
  self.cancelBtn:SetOnClick(self, self.resetPointPanelCloseOnClick)
  self.confirmBtn:SetOnClick(self, self.confirmBtnOnClick)
  self.resetPointPanelClose:SetOnClick(self, self.resetPointPanelCloseOnClick)
  self.btn_resetPointPanelClose:SetOnClick(self, self.resetPointPanelCloseOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.Button_Cance:SetOnClick(self, self.Button_CanceOnClick)
  self.Button_Ok:SetOnClick(self, self.Button_OkOnClick)
end

function Role_AttributeUI:btn_closeMainOnClick(_)
  UIManager.Hide(UIID.Role_AttributeUI)
  self:CloseAttributeChange()
  Refreshpaneljia = false
  stcbol = false
  networkRequest.ReqCloseAttribute()
end

function Role_AttributeUI:LevelNum()
  local PlayerLevel = ClientTable.cfg_Global_globalManager:TryGetValue(60000026)
  local level = string.split(PlayerLevel.effect, "#")
  local lev = tonumber(level[2])
  if lev <= RoleManager.me.level then
    return true
  end
  return false
end

function Role_AttributeUI:btn_showAllAttrOnClick(_)
  local level
  level = self:LevelNum()
  if level then
    if UIManager.IsVisible(UIID.Role_AllAttrPanelUI) then
      UIManager.Hide(UIID.Role_AllAttrPanelUI)
      self.btn_showAllAttr.transform.rotation = Vector3.zero
    else
      UIManager.Show(UIID.Role_AllAttrPanelUI)
      self.btn_showAllAttr.transform.rotation = Vector3(0, 0, 180)
    end
  elseif UIManager.IsVisible(UIID.Role_AllAttFristPanelUI) then
    UIManager.Hide(UIID.Role_AllAttFristPanelUI)
    self.btn_showAllAttr.transform.rotation = Vector3.zero
  else
    UIManager.Show(UIID.Role_AllAttFristPanelUI)
    self.btn_showAllAttr.transform.rotation = Vector3(0, 0, 180)
  end
end

function Role_AttributeUI:btn_showFruitOnClick()
  if UIManager.IsVisible(UIID.Fruit_FruitAddUI) then
    UIManager.Hide(UIID.Fruit_FruitAddUI)
    Refreshpaneljia = false
  else
    UIManager.Show(UIID.Fruit_FruitAddUI)
    Refreshpaneljia = true
  end
end

function Role_AttributeUI:btn_closeAllAttrPanelOnClick(_)
  self.allAttrPanel:SetActive(false)
end

function Role_AttributeUI:btn_plusAttributeOnClick(control)
  local globalPoint = GlobalConfig.GetGlobalConfig(2430201)
  local validAttributePoint = QuickFind.LuaMainPlayerViewAttrData().validAttributePoint
  if not string.isNullOrEmpty(globalPoint) and validAttributePoint >= tonumber(globalPoint) and self.usedPreviewAttrPoint < QuickFind.LuaMainPlayerViewAttrData().validAttributePoint then
    UIManager.Show(UIID.Role_AddPointUI, {
      state = CAttributeAddPointState.AddAttribute,
      control = control
    })
    EventManager.Dispatch(Event.RolePreAddMapChanged, {
      preAddMapData = self.preAddMap
    })
    return
  end
  if not self.recommendAdd then
    self:btn_recommendOnClick(control.attrType, 1)
  else
    self.isChange = false
    if self.usedPreviewAttrPoint >= QuickFind.LuaMainPlayerViewAttrData().validAttributePoint then
      return
    end
    self.preAddMap[control.attrType] = self.preAddMap[control.attrType] + 1
    self:SetUsedPreviewAttrPoint(self.usedPreviewAttrPoint + 1)
    self:CalcPreviewAttrMap()
    self:RefreshAttributesInfo()
    self:CloseAttributeChange()
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.btnFunc,
      state = true
    })
  end
end

function Role_AttributeUI:btn_minusAttributeOnClick(control)
  if self.usedPreviewAttrPoint <= 0 then
    return
  end
  local globalPoint = GlobalConfig.GetGlobalConfig(2430201)
  local validAttributePoint = QuickFind.LuaMainPlayerViewAttrData().validAttributePoint
  if not string.isNullOrEmpty(globalPoint) and validAttributePoint >= tonumber(globalPoint) then
    UIManager.Show(UIID.Role_AddPointUI, {
      state = CAttributeAddPointState.ReduceAttribute,
      control = control
    })
    EventManager.Dispatch(Event.RolePreAddMapChanged, {
      preAddMapData = self.preAddMap
    })
    return
  end
  self.preAddMap[control.attrType] = self.preAddMap[control.attrType] - 1
  self:SetUsedPreviewAttrPoint(self.usedPreviewAttrPoint - 1)
  self:CalcPreviewAttrMap()
  self:RefreshAttributesInfo()
end

function Role_AttributeUI:btn_plusAttributeOnPress(control)
  if not self.recommendAdd then
    self:btn_recommendOnClick(control.attrType, 1)
    return
  end
  self.isOnPress = true
  self.isChange = false
  if self.usedPreviewAttrPoint >= QuickFind.LuaMainPlayerViewAttrData().validAttributePoint then
    return
  end
  self.preAddMap[control.attrType] = self.preAddMap[control.attrType] + 1
  self.usedPreviewAttrPoint = self.usedPreviewAttrPoint + 1
  self:CalcPreviewAttrMap()
  self:RefreshAttributesInfo()
  self:RefreshValidAttributePointInfo()
  self:SetChangeNum()
end

function Role_AttributeUI:Select_AgilityArcher()
  self.careerDirection = 1
  stcbol = true
  if self.resetlevelLimit > ViewData.meData.level then
    NetManager.Send(RoleMessage.ReqWashAttrPoints)
  else
    self:RecommendAddPoint()
  end
  self:SetRecommendState()
end

function Role_AttributeUI:Select_BrainsArcher()
  if self.washCount > 0 then
    self.IsTransferRestPoint = true
  end
  self.careerDirection = 2
  stcbol = true
  if self.resetlevelLimit > ViewData.meData.level then
    NetManager.Send(RoleMessage.ReqWashAttrPoints)
  else
    self:RecommendAddPoint()
  end
  self:SetRecommendState()
end

function Role_AttributeUI:btn_minusAttributeOnPress(control)
  if self.usedPreviewAttrPoint <= 0 then
    return
  end
  self.preAddMap[control.attrType] = self.preAddMap[control.attrType] - 1
  self:SetUsedPreviewAttrPoint(self.usedPreviewAttrPoint - 1)
  self:RefreshValidAttributePointInfo()
end

function Role_AttributeUI:btn_attributeOnStopPress(control)
  self:SetUsedPreviewAttrPoint(self.usedPreviewAttrPoint)
  self.isOnPress = false
  self.isChange = false
  self:CalcPreviewAttrMap()
  self:RefreshAttributesInfo()
  self:SetChangeNum()
end

function Role_AttributeUI:input_preValueOnSubmit(control)
  local inputValStr = control:GetInputText()
  if inputValStr == nil or inputValStr == "" then
    return
  end
  local oldAddVal = self.preAddMap[control.attrType]
  local validPoint = self.validAttributePoint + oldAddVal
  local curInputVal = math.min(tonumber(inputValStr), validPoint)
  self.preAddMap[control.attrType] = curInputVal
  local delta = self.preAddMap[control.attrType] - oldAddVal
  self:SetUsedPreviewAttrPoint(self.usedPreviewAttrPoint + delta)
  self:CalcPreviewAttrMap()
  self:RefreshAttributesInfo()
end

function Role_AttributeUI:btn_comfirmOnClick(control)
  self.changeAttributeReason = control
  if stcbol then
    ServerDataRecordData.IntDataChange(SerRecordIntType.archerDirection, self.careerDirection)
    ServerDataRecordData.SendSaveData({
      dataInt = {
        [SerRecordIntType.archerDirection] = self.careerDirection
      }
    })
    stcbol = false
  end
  self:ConfirmAddPoint()
  self.recommendAdd = false
  self.btn_comfirm:SetActive(false)
  self:SetActiveFalse(false)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
end

function Role_AttributeUI:btn_recommendOnClick(_, num)
  if not self.isRecommend then
    self:RecommendAddPoint(_, num)
  elseif num then
    self:RecommendAddPoint(_, num)
  else
    UIManager.Show(UIID.TransferSelectUI)
  end
end

function Role_AttributeUI:RecommendAddPoint(_, num)
  self:ResetPreAddPoints()
  self.recommendAdd = true
  self.btn_comfirm:SetActive(true)
  self:CalculateRecommendPoint()
  if type(_) == "string" then
    self.recommendAddPoint = {}
    self.recommendAddPoint[_] = num
  end
  for k, v in pairs(self.recommendAddPoint) do
    self.preAddMap[k] = self.preAddMap[k] + v
    self:SetUsedPreviewAttrPoint(self.usedPreviewAttrPoint + v)
    self:CalcPreviewAttrMap()
    self:RefreshAttributesInfo()
    self:CloseAttributeChange()
  end
  self.recommendAddPoint = {}
  self.Proportion = {}
  self.HavePoint = {}
  self.recommendAddPoint = {}
  self:recommendAddShow()
  return
end

function Role_AttributeUI:btn_resetPointOnClick()
  self.resetPointPanel:SetActive(true)
  NetManager.Send(RoleMessage.ReqWashCounts)
end

local function CheckCountPriceEnough(itemId, count)
  if not itemId then
    return false
  end
  local bagCoinCount = BagInfoData.GetItemTotalCountByItemId(itemId)
  return count <= bagCoinCount
end

function Role_AttributeUI:Role_WashCounts(_, msg)
  self:SetRecommendState()
  if msg.washCount == 0 then
  else
    self.btn_resetPoint:SetActive(true)
  end
  local washedCount, washCount
  if msg then
    self.washCount = msg.washCount
    washCount = msg.washCount
    washedCount = msg.washedCount
  else
    self.washCount = 0
    washCount = 0
    washedCount = 0
  end
  local resPointPrice = ClientTable.cfg_Global_globalManager:TryGetValue(2430008, "id").effect
  local priceTb = string.split(resPointPrice, "#")
  self.resetItemId = tonumber(priceTb[1])
  self.resetItemCount = tonumber(priceTb[3])
  self.currentCount = washedCount
  self.lab_resPointValue:SetText(washCount)
  self.resetlevelLimit = tonumber(priceTb[4]) or 0
  local itemData = ItemUtility.GenerateItemData(self.resetItemId)
  self.consumeItem.itemCellData = self.consumeItem.itemCellData or ItemCellData()
  self.consumeItem.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.consumeItem, self.consumeItem.itemCellData, self, true)
  self.needItem.itemCellData = self.needItem.itemCellData or ItemCellData()
  self.needItem.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.needItem, self.needItem.itemCellData, self, true)
  if self.costTbl and self.costTbl.itemId then
    local itemCoinData = ItemUtility.GenerateItemData(self.costTbl.itemId)
    self.btn_needGold.itemCellData = self.btn_needGold.itemCellData or ItemCellData()
    itemCoinData.count = self.costTbl.count
    self.btn_needGold.itemCellData:RefreshData(itemCoinData)
    ItemUtility.ShowItemCell(self.btn_needGold, self.btn_needGold.itemCellData, self, true)
  end
  if ViewData.meData.level < self.resetlevelLimit then
    self.text_freePoints:SetActive(true)
    local str = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Role_AddPointUI")
    self.text_freePoints:SetText(string.format(str, self.resetlevelLimit))
  else
    self.text_freePoints:SetActive(false)
  end
  if self.currentCount == 0 then
    self.lab_priceValue:SetText("L\225\186\167n \196\145\225\186\167u mi\225\187\133n ph\195\173")
  else
    self.lab_priceValue:SetText(self.resetItemCount)
    self:OnBagChange()
  end
  self.consumeItem:SetActive(self.currentCount ~= 0)
  if self.args and self.args.uiID then
    self.resetPointPanel:SetActive(true)
  end
  if not CheckCountPriceEnough(self.resetItemId, self.resetItemCount) and self.currentCount ~= 0 then
    self.lab_priceValue:SetColor("0xFF0000FF")
  else
    self.lab_priceValue:SetColor("0x00FF00FF")
  end
end

function Role_AttributeUI:confirmBtnOnClick()
  if not CheckCountPriceEnough(self.resetItemId, self.resetItemCount) and self.currentCount ~= 0 then
    if not CheckCountPriceEnough(self.costTbl.itemId, self.costTbl.count) then
      self.lab_num:SetText(string.GetColorText(self.costTbl.count, ItemQuality2ColorDic[EItemColorEnum.red]))
    else
      self.lab_num:SetText(string.GetColorText(self.costTbl.count, ItemQuality2ColorDic[EItemColorEnum.white]))
    end
    self.Image_ItemBg:SetActive(true)
    self.resetPointPanel:SetActive(false)
    return
  end
  if self.IsTransferRestPoint then
    ServerDataRecordData.IntDataChange(SerRecordIntType.archerDirection, 0)
    ServerDataRecordData.SendSaveData({
      dataInt = {
        [SerRecordIntType.archerDirection] = 0
      }
    })
    self.careerDirection = 0
    self:SetRecommendState()
    self.IsTransferRestPoint = false
  else
    ServerDataRecordData.IntDataChange(SerRecordIntType.archerDirection, 0)
    ServerDataRecordData.SendSaveData({
      dataInt = {
        [SerRecordIntType.archerDirection] = 0
      }
    })
    self.careerDirection = 0
  end
  NetManager.Send(RoleMessage.ReqWashAttrPoints)
  self.washCount = 0
  self:resetPointPanelCloseOnClick()
end

function Role_AttributeUI:Button_CanceOnClick()
  if self.IsTransferRestPoint then
    self.IsTransferRestPoint = false
  end
  self:SetRecommendState()
  self.Image_ItemBg:SetActive(false)
end

function Role_AttributeUI:Button_OkOnClick()
  if not CheckCountPriceEnough(self.costTbl.itemId, self.costTbl.count) then
    local tipStr = LocalizationUtility.GetContentByKey("huobibuzu")
    UIManager.Hide(UIID.Role_AttributeUI)
    FloatingWordUtility.QuickMsg(tipStr)
    RechargeData.BuyDiamond()
    return
  end
  NetManager.Send(ItemBuyMessage.ReqBuy, {
    goodId = self.goldId,
    buyCount = 1
  })
  self.Image_ItemBg:SetActive(false)
end

function Role_AttributeUI:resetPointPanelCloseOnClick()
  if self.IsTransferRestPoint then
    self.IsTransferRestPoint = false
  end
  self:SetRecommendState()
  self.resetPointPanel:SetActive(false)
end

function Role_AttributeUI:descBtnOnClick()
  local roleCareer = tonumber(QuickFind.LuaMainPlayerViewAttrData().career)
  local career = RoleUtility.GetBasicCareer(roleCareer)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "id", self.careerDes[career])
  if lvCfg then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Role_AttributeUI:RegistEvents()
  self:RegistEvent(Event.Role_MyLvChanged, self.OnRole_MyLvChanged, self)
  self:RegistEvent(Event.Role_MyExpChanged, self.OnRole_MyExpChanged, self)
  self:RegistEvent(Event.Role_MyAttributePointChanged, self.OnRole_MyAttributePointChanged, self)
  self:RegistEvent(Event.Role_MyAttributeChanged, self.OnRole_MyAttributeChanged, self)
  self:RegistEvent(Event.Role_FruitUse, self.Role_FruitUse, self)
  self:RegistEvent(Event.Role_FruitAttribute, self.Role_FruitAttribute, self)
  self:RegistEvent(Event.Role_WashCounts, self.Role_WashCounts, self)
  self:RegistEvent(Event.Role_RefreshHp, self.OnRole_RefreshHp, self)
  self:RegistEvent(Event.Role_RefreshMp, self.OnRole_RefreshMp, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
  self:RegistEvent(Event.RefreshRedName, self.RefreshRedName, self)
  self:RegistEvent(Event.Select_AgilityArcher, self.Select_AgilityArcher, self)
  self:RegistEvent(Event.Select_BrainsArcher, self.Select_BrainsArcher, self)
  self:RegistEvent(Event.RoleAddAttributeChanged, self.RoleAddAttributeChanged, self)
  Refreshpaneljia = false
end

function Role_AttributeUI:RefreshRedName()
  if RoleManager.me.evilLevel ~= EvilRoleType.Level0 then
    local name = string.format("[<color=%s>%s\239\188\154%d</color>]%s", ERoleEvilNameColor16[RoleManager.me.evilLevel], ERoleEvilName[RoleManager.me.evilLevel], RoleManager.me.notoriety, self.meData.name)
    self.lab_roleName:SetText(name)
  else
    self.lab_roleName:SetText(QuickFind.LuaMainPlayerViewAttrData().name)
  end
end

function Role_AttributeUI:OnBagChange(id, msg)
  if not CheckCountPriceEnough(self.resetItemId, self.resetItemCount) and self.currentCount ~= 0 then
    self.lab_priceValue:SetColor("0xFF0000FF")
  else
    self.lab_priceValue:SetColor("0x00FF00FF")
  end
  if msg and msg.showItemTbl then
    local isClose = false
    for k, v in pairs(msg.showItemTbl) do
      if k == 6000840 then
        isClose = true
        break
      end
    end
    if self.Image_ItemBg:GetActive() and isClose then
      if self.IsTransferRestPoint then
        ServerDataRecordData.IntDataChange(SerRecordIntType.archerDirection, 2)
        ServerDataRecordData.SendSaveData({
          dataInt = {
            [SerRecordIntType.archerDirection] = 2
          }
        })
        self.careerDirection = 2
        self:SetRecommendState()
        self.IsTransferRestPoint = false
      end
      NetManager.Send(RoleMessage.ReqWashAttrPoints)
      self.Image_ItemBg:SetActive(false)
      self:resetPointPanelCloseOnClick()
    end
  end
end

function Role_AttributeUI:OnRole_RefreshHp(_, msg)
  if msg.roleId == QuickFind.LuaMainPlayerViewAttrData().id then
    local str = string.format("%d/%d", QuickFind.LuaMainPlayerViewAttrData().hp, QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumHealth))
    self.lab_maximumHealth:SetText(str)
  end
end

function Role_AttributeUI:OnRole_RefreshMp(_, msg)
  if msg.id == QuickFind.LuaMainPlayerViewAttrData().id then
    local str = string.format("%d/%d", QuickFind.LuaMainPlayerViewAttrData().mp, QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumMana))
    self.lab_maximumMana:SetText(str)
  end
end

function Role_AttributeUI:OnRole_MyLvChanged(_)
  self.isChange = true
  self:UpdateRoleLvInfo()
  self:CalcPreviewAttrMap()
  self:RefreshAttributesInfo()
end

function Role_AttributeUI:OnRole_MyExpChanged(_)
  self:UpdateRoleLvInfo()
end

function Role_AttributeUI:OnRole_MyAttributePointChanged(_)
  if stcbol then
    self:RecommendAddPoint()
    return
  end
  self.isChange = true
  self:ResetPreAddPoints()
  self:CalcPreviewAttrMap()
  self:RefreshAttributesInfo()
end

function Role_AttributeUI:OnRole_MyAttributeChanged(_)
  self.isChange = true
  self:CalcPreviewAttrMap()
  self:RefreshAttributesInfo()
  self:RefreshLab_serverName()
end

function Role_AttributeUI:Role_FruitUse()
  self:ResetPreAddPoints()
  self:CloseAttributeChange()
end

function Role_AttributeUI:Role_FruitAttribute(_)
  self.lab_strengthChangeNum:SetActive(false)
  self.lab_agilityChangeNum:SetActive(false)
  self.lab_physicalChangeNum:SetActive(false)
  self.lab_mentalityChangeNum:SetActive(false)
  if QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.strength) == FruitData.FruitAttributeOldData.strength then
    self.lab_strengthChangeNum:SetActive(false)
  end
  if QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.agility) == FruitData.FruitAttributeOldData.agility then
    self.lab_agilityChangeNum:SetActive(false)
  end
  if QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.vitality) == FruitData.FruitAttributeOldData.vitality then
    self.lab_physicalChangeNum:SetActive(false)
  end
  if QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.energy) == FruitData.FruitAttributeOldData.energy then
    self.lab_mentalityChangeNum:SetActive(false)
  end
  FruitData.FruitAttributeOldData.strength = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.strength)
  FruitData.FruitAttributeOldData.agility = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.agility)
  FruitData.FruitAttributeOldData.vitality = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.vitality)
  FruitData.FruitAttributeOldData.energy = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.energy)
end

function Role_AttributeUI:Refresh()
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
  self.meData = ViewData.meData
  if QuickFind.LuaMainPlayerViewAttrData().level >= 70 then
    self.btn_showFruit:SetActive(true)
  end
  self.btn_showAllAttr.transform.rotation = Vector3(0, 0, 180)
  self.magicDamage:SetActive(true)
  self.magicExtraDamage:SetActive(true)
  self.extraDamage:SetActive(true)
  self.resetPointPanel:SetActive(false)
  self.Image_ItemBg:SetActive(false)
  self.lab_roleName:SetText("")
  self.previewAttrMap = {}
  self.previewAttrMapUpFlagMap = {}
  self.careerDirection = ServerDataRecordData.SaveData.dataInt[SerRecordIntType.archerDirection] or 0
  self:SetRecommendState()
  self:UpdateFruitAttributeData()
  self:ResetPreAddPoints()
  self:UpdateRoleLvInfo()
  self:RefreshAttributesInfo()
  self:RefreshLab_serverName()
  if self.recommendAdd then
    self.recommendAdd = false
  end
  NetManager.Send(RoleMessage.ReqWashCounts)
  NetManager.Send(RoleMessage.ReqRoleRedName)
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {2380001, 2430002})
end

function Role_AttributeUI:RefreshLab_serverName()
  local serverText = string.format("[%s-%s]", LoginData.GetServerName(), RoleUtility.GteCareerNameByType(QuickFind.LuaMainPlayerViewAttrData().career))
  serverText = serverText .. QiJiHelperData.GetCareerNameDes()
  self.lab_serverName:SetText(serverText)
end

function Role_AttributeUI:SetRecommendState()
  local careerID = tonumber(string.sub(tostring(QuickFind.LuaMainPlayerViewAttrData().career), -1))
  local ArcherJobType = self.careerDirection
  if careerID == 4 and QuickFind.LuaMainPlayerViewAttrData().level >= self.archerLevel and ArcherJobType == 0 then
    self.lab_recommend:SetText("Thay \196\145\225\187\149i Ngh\225\187\129")
    self.isRecommend = true
  else
    self.lab_recommend:SetText("\196\144\225\187\129 xu\225\186\165t t\196\131ng \196\145i\225\187\131m")
    self.isRecommend = false
  end
end

function Role_AttributeUI:RefreshAttributesInfo()
  self:RefreshValidAttributePointInfo()
  self:UpdateRoleBasicAttrInfo()
  self:UpdateAttributeChangeTips()
  self:RefreshAllAttributesInfo()
  self:UpdateHPInfo()
  self:UpdateMPInfo()
end

function Role_AttributeUI:RefreshAllAttributesInfo()
  local ui, level
  level = self:LevelNum()
  if not Refreshpaneljia then
    if level then
      ui = UIManager.GetUiByName(UIID.Role_AllAttrPanelUI)
    else
      UIManager.Hide(UIID.Role_AllAttrPanelUI)
      if self.FristPanelUI then
        UIManager.Show(UIID.Role_AllAttFristPanelUI)
        self.FristPanelUI = false
      end
      ui = UIManager.GetUiByName(UIID.Role_AllAttFristPanelUI)
    end
  end
  if ui then
    ui:RefreshAllAttributeInfo(self.previewAttrMap, self.previewAttrMapUpFlagMap)
  end
end

function Role_AttributeUI:GetAllAttributeParameters()
  return self.previewAttrMap, self.previewAttrMapUpFlagMap
end

function Role_AttributeUI:UpdateRoleLvInfo()
  local tbl = ClientTable.cfg_Character_levelManager:TryGetValue(QuickFind.LuaMainPlayerViewAttrData().level)
  if tbl ~= nil then
    self.lab_level:SetText(tbl.name)
  else
    self.lab_level:SetText(tostring(QuickFind.LuaMainPlayerViewAttrData().level))
  end
  self.lab_levelupPoint:SetText(tostring(QuickFind.LuaMainPlayerViewAttrData().validAttributePoint - self.usedPreviewAttrPoint))
  self.lab_exp:SetText(string.format("%s/%s", ClientTable.cfg_Character_levelManager:GetExpDes(QuickFind.LuaMainPlayerViewAttrData().level, QuickFind.LuaMainPlayerViewAttrData().exp), ClientTable.cfg_Character_levelManager:GetExpDes(QuickFind.LuaMainPlayerViewAttrData().level)))
end

function Role_AttributeUI:RefreshValidAttributePointInfo()
  if stcbol then
    self.btn_plusStrength:SetActive(false)
    self.btn_plusAgility:SetActive(false)
    self.btn_plusVitality:SetActive(false)
    self.btn_plusEnergy:SetActive(false)
    self.btn_recommend:SetActive(false)
    self.btn_comfirm:SetActive(true)
    return
  end
  self:SetValidAttrPoint(QuickFind.LuaMainPlayerViewAttrData().validAttributePoint - self.usedPreviewAttrPoint)
  local hasValidPoints = self.validAttributePoint > 0
  self.btn_recommend:SetActive(hasValidPoints)
  local activeLevel = GlobalConfig.GetGlobalConfig(1100006) or 500
  activeLevel = tonumber(activeLevel) or 500
  if activeLevel < RoleManager.me.data.attributeMap[EAttributeType.level] then
    self.btn_recommend:SetActive(false)
  end
  self.btn_plusStrength:SetActive(hasValidPoints)
  self.btn_plusAgility:SetActive(hasValidPoints)
  self.btn_plusVitality:SetActive(hasValidPoints)
  self.btn_plusEnergy:SetActive(hasValidPoints)
  if self.recommendAdd then
    self:recommendAddShow()
  end
end

function Role_AttributeUI:CalcPreviewAttrMap()
  self.previewAttrMap = AttributeConfig.GetPreviewAttrMap(QuickFind.LuaMainPlayerViewAttrData().career, self.preAddMap)
  if self.previewAttrMap ~= nil and table.count(self.previewAttrMap) > 0 then
    for k, v in pairs(self.previewAttrMap) do
      self.previewAttrMapUpFlagMap[k] = 1 <= v
    end
  end
end

function Role_AttributeUI:UpdateRoleBasicAttrInfo()
  local attr, attr1, attrInit, attrInit2, attr2, textColor
  attr = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.strength)
  self.lab_strength:SetText(tostring(attr))
  attrInit = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.minimumPhysBaseDmg)
  attrInit2 = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumPhysBaseDmg)
  attr = self.previewAttrMap[EAttributeType.minimumPhysBaseDmg] or 0
  attr1 = self.previewAttrMap[EAttributeType.maximumPhysBaseDmg] or 0
  local str
  if attr <= 0 and attr1 <= 0 then
    str = string.format("%d~%d", attrInit, attrInit2)
  else
    str = string.format("%d~%d", attrInit, attrInit2) .. string.GetColorText(string.format("   + %d~%d", attr, attr1), ItemQuality2ColorDic[EItemColorEnum.blue])
  end
  self.lab_damage:SetText(str)
  if self.previewAttrMapUpFlagMap[EAttributeType.minimumPhysBaseDmg] or self.previewAttrMapUpFlagMap[EAttributeType.maximumPhysBaseDmg] then
    self:ChangeTextColor(self.lab_damage)
  end
  attrInit = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.attackRatePvm)
  attr = self.previewAttrMap[EAttributeType.attackRatePvm] or 0
  self:ColorText(attr, str, attrInit, self.lab_attackRatePvm)
  if self.previewAttrMapUpFlagMap[EAttributeType.attackRatePvm] then
    self:ChangeTextColor(self.lab_attackRatePvm)
  end
  attr = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.agility)
  self.lab_agility:SetText(tostring(attr))
  attrInit = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.defenseBase)
  attr = self.previewAttrMap[EAttributeType.defenseBase] or 0
  self:ColorText(attr, str, attrInit, self.lab_defense)
  if self.previewAttrMapUpFlagMap[EAttributeType.defenseBase] then
    self:ChangeTextColor(self.lab_defense)
  end
  attrInit = (QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.attackSpeedIncrease) - 10000) / 10000
  attr = self.previewAttrMap[EAttributeType.attackSpeedIncrease] and (self.previewAttrMap[EAttributeType.attackSpeedIncrease] - 10000) / 10000 or 0
  attrInit = attrInit * 100
  attr = attr * 100
  if 0 >= tonumber(attr) then
    str = tostring(attrInit) .. "%"
  else
    str = tostring(attrInit) .. "%" .. string.GetColorText(string.format("   +%s", tostring(attr)) .. "%", ItemQuality2ColorDic[EItemColorEnum.blue])
  end
  self.lab_attackSpeed:SetText(str)
  if self.previewAttrMapUpFlagMap[EAttributeType.attackSpeedIncrease] then
    self:ChangeTextColor(self.lab_attackSpeed)
  end
  attrInit = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.defenseRatePvm)
  attr = self.previewAttrMap[EAttributeType.defenseRatePvm] or 0
  self:ColorText(attr, str, attrInit, self.lab_defenseRatePvm)
  if self.previewAttrMapUpFlagMap[EAttributeType.defenseRatePvm] then
    self:ChangeTextColor(self.lab_defenseRatePvm)
  end
  attr = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.vitality)
  self.lab_vitality:SetText(tostring(attr))
  attr = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.energy)
  self.lab_energy:SetText(tostring(attr))
  local basicCareer = RoleUtility.GetBasicCareer(QuickFind.LuaMainPlayerViewAttrData().career)
  if basicCareer == ERoleCareer.SwordMan or basicCareer == ERoleCareer.HolyMaster or basicCareer == ERoleCareer.Archer then
    self:Physicaldamage(EAttributeType.extraDamage)
  elseif basicCareer == ERoleCareer.Magic or basicCareer == ERoleCareer.SpellSword or basicCareer == ERoleCareer.SummonMagician then
    self:Magicdamage(EAttributeType.extraDamage2)
    if basicCareer == ERoleCareer.SpellSword then
      self:Physicaldamage(EAttributeType.extraDamage)
    end
    self.magicDamage:SetActive(true)
    self.magicExtraDamage:SetActive(true)
  end
  if basicCareer == ERoleCareer.SummonMagician then
    self:CurseDamage()
  end
end

function Role_AttributeUI:CurseDamage()
  local attr, attr1, attrInit, attrInit2, str
  self.skillMultiplier:SetActive(false)
  self.extraDamage:SetActive(false)
  attrInit = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.minimumCurseBaseDmg)
  attrInit2 = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumCurseBaseDmg)
  attr = self.previewAttrMap[EAttributeType.minimumCurseBaseDmg] or 0
  attr1 = self.previewAttrMap[EAttributeType.maximumCurseBaseDmg] or 0
  if attr <= 0 and attr1 <= 0 then
    str = string.format("%d~%d", attrInit, attrInit2)
  else
    str = string.format("%d~%d", attrInit, attrInit2) .. string.GetColorText(string.format("   + %d~%d", attr, attr1), ItemQuality2ColorDic[EItemColorEnum.blue])
  end
  if not self.lab_curseDamage then
    self.lab_curseDamage = self.curseDamage:GetChild("lab_magicDamage")
  end
  self.lab_curseDamage:SetText(str)
  if self.previewAttrMapUpFlagMap[EAttributeType.minimumCurseBaseDmg] or self.previewAttrMapUpFlagMap[EAttributeType.maximumCurseBaseDmg] then
    self:ChangeTextColor(self.lab_curseDamage)
  end
  self.magicDamage:SetActive(true)
  self.magicExtraDamage:SetActive(true)
  self.curseDamage:SetActive(true)
end

function Role_AttributeUI:Physicaldamage(type)
  local attr
  self.magicDamage:SetActive(false)
  self.magicExtraDamage:SetActive(false)
  self.curseDamage:SetActive(false)
  attr = self.previewAttrMap[EAttributeType.skillMultiplier] or 0
  self.lab_skillMultiplier:SetText(tostring(attr) .. "%")
  if self.previewAttrMapUpFlagMap[EAttributeType.skillMultiplier] then
    self:ChangeTextColor(self.lab_skillMultiplier)
  end
  local attrInit, str
  attrInit = QuickFind.LuaMainPlayerData():TryGetAttrValue(type) / 100
  attr = self.previewAttrMap[type] or 0
  attr = math.floor(attr * 100 + 0.5) / 10000
  if attr <= 0 then
    str = tostring(attrInit) .. "%"
  else
    str = tostring(attrInit) .. "%" .. string.GetColorText(string.format("   +%s", tostring(attr)) .. "%", ItemQuality2ColorDic[EItemColorEnum.blue])
  end
  self.lab_extraDamage:SetText(str)
  if self.previewAttrMapUpFlagMap[type] then
    self:ChangeTextColor(self.lab_extraDamage)
  end
  self.extraDamage:SetActive(true)
end

function Role_AttributeUI:Magicdamage(type)
  local attr, attr1, attrInit, attrInit2, str
  self.skillMultiplier:SetActive(false)
  self.extraDamage:SetActive(false)
  self.curseDamage:SetActive(false)
  attrInit = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.minimumWizBaseDmg)
  attrInit2 = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumWizBaseDmg)
  attr = self.previewAttrMap[EAttributeType.minimumWizBaseDmg] or 0
  attr1 = self.previewAttrMap[EAttributeType.maximumWizBaseDmg] or 0
  if attr <= 0 and attr1 <= 0 then
    str = string.format("%d~%d", attrInit, attrInit2)
  else
    str = string.format("%d~%d", attrInit, attrInit2) .. string.GetColorText(string.format("   + %d~%d", attr, attr1), ItemQuality2ColorDic[EItemColorEnum.blue])
  end
  self.lab_magicDamage:SetText(str)
  if self.previewAttrMapUpFlagMap[EAttributeType.minimumWizBaseDmg] or self.previewAttrMapUpFlagMap[EAttributeType.maximumWizBaseDmg] then
    self:ChangeTextColor(self.lab_magicDamage)
  end
  attrInit = QuickFind.LuaMainPlayerData():TryGetAttrValue(type) / 100
  attr = self.previewAttrMap[type] or 0
  attr = math.floor(attr * 100 + 0.5) / 10000
  if attr <= 0 then
    str = tostring(attrInit) .. "%"
  else
    str = tostring(attrInit) .. "%" .. string.GetColorText(string.format("   + %s", tostring(attr)) .. "%", ItemQuality2ColorDic[EItemColorEnum.blue])
  end
  self.lab_magicExtraDamage:SetText(str)
  if self.previewAttrMapUpFlagMap[type] then
    self:ChangeTextColor(self.lab_magicExtraDamage)
  end
  self.magicDamage:SetActive(true)
  self.magicExtraDamage:SetActive(true)
end

function Role_AttributeUI:ColorText(attr, str, attrInit, libtext)
  if attr <= 0 then
    str = attrInit
  else
    str = attrInit .. string.GetColorText(string.format("   + %d", attr), ItemQuality2ColorDic[EItemColorEnum.blue])
  end
  libtext:SetText(tostring(str))
end

function Role_AttributeUI:UpdateAttributeChangeTips()
  if not UIManager.IsVisible(UIID.Fruit_FruitAddUI) then
    return
  end
  if QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.strength) ~= FruitData.FruitAttributeData.strength then
    self:UpdateUIShow(tonumber(QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.strength)), tonumber(FruitData.FruitAttributeData.strength), self.lab_strengthChangeNum)
  end
  if QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.agility) ~= FruitData.FruitAttributeData.agility then
    self:UpdateUIShow(tonumber(QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.agility)), tonumber(FruitData.FruitAttributeData.agility), self.lab_agilityChangeNum)
  end
  if QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.vitality) ~= FruitData.FruitAttributeData.vitality then
    self:UpdateUIShow(tonumber(QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.vitality)), tonumber(FruitData.FruitAttributeData.vitality), self.lab_physicalChangeNum)
  end
  if QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.energy) ~= FruitData.FruitAttributeData.energy then
    self:UpdateUIShow(tonumber(QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.energy)), tonumber(FruitData.FruitAttributeData.energy), self.lab_mentalityChangeNum)
  end
  self:UpdateFruitAttributeData()
end

function Role_AttributeUI:UpdateUIShow(NewAttribute, OldAttribute, UICtr)
  UICtr:SetActive(false)
end

function Role_AttributeUI:UpdateFruitAttributeData()
  FruitData.FruitAttributeData.strength = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.strength)
  FruitData.FruitAttributeData.agility = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.agility)
  FruitData.FruitAttributeData.vitality = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.vitality)
  FruitData.FruitAttributeData.energy = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.energy)
end

function Role_AttributeUI:CloseAttributeChange()
  for i = 1, #self.AttributeChangeTab do
    self.AttributeChangeTab[i]:SetActive(false)
  end
end

function Role_AttributeUI:UpdateHPInfo()
  local attr, attr1, attrInit, attrInit2
  attrInit = QuickFind.LuaMainPlayerViewAttrData().hp
  attrInit2 = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumHealth)
  attr = QuickFind.LuaMainPlayerViewAttrData().hp
  attr1 = self.previewAttrMap[EAttributeType.maximumHealth] or 0
  local str
  if attr1 <= 0 then
    str = string.format("%d/%d", attrInit, attrInit2)
  else
    str = string.format("%d/%d", attrInit, attrInit2) .. string.GetColorText(string.format("   + %d", attr1), ItemQuality2ColorDic[EItemColorEnum.blue])
  end
  self.lab_maximumHealth:SetText(str)
  if self.previewAttrMapUpFlagMap[EAttributeType.maximumHealth] then
    self:ChangeTextColor(self.lab_maximumHealth)
  end
end

function Role_AttributeUI:UpdateMPInfo()
  local attr, attr1, attrInit, attrInit2
  attrInit = QuickFind.LuaMainPlayerViewAttrData().mp
  attrInit2 = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumMana)
  attr = QuickFind.LuaMainPlayerViewAttrData().mp
  attr1 = self.previewAttrMap[EAttributeType.maximumMana] or 0
  local str
  if attr1 <= 0 then
    str = string.format("%d/%d", attrInit, attrInit2)
  else
    str = string.format("%d/%d", attrInit, attrInit2) .. string.GetColorText(string.format("   + %d", attr1), ItemQuality2ColorDic[EItemColorEnum.blue])
  end
  self.lab_maximumMana:SetText(str)
  if self.previewAttrMapUpFlagMap[EAttributeType.maximumMana] then
    self:ChangeTextColor(self.lab_maximumMana)
  end
end

function Role_AttributeUI:ResetPreAddPoints()
  self:SetUsedPreviewAttrPoint(0)
  if 0 < self.usedPreviewAttrPoint then
    self:SetValidAttrPoint(QuickFind.LuaMainPlayerViewAttrData().validAttributePoint)
  end
  self.preAddMap = {}
  self.preAddMap.strength = 0
  self.preAddMap.agility = 0
  self.preAddMap.vitality = 0
  self.preAddMap.energy = 0
  self.usedPreviewAttrPoint = 0
end

function Role_AttributeUI:SetValidAttrPoint(num)
  self.validAttributePoint = num
  self.lab_levelupPoint:SetText(tostring(self.validAttributePoint))
end

function Role_AttributeUI:SetUsedPreviewAttrPoint(point)
  if point > QuickFind.LuaMainPlayerViewAttrData().validAttributePoint then
    point = QuickFind.LuaMainPlayerViewAttrData().validAttributePoint
  end
  self.usedPreviewAttrPoint = point
  if self.recommendAdd == true then
    self.btn_comfirm:SetActive(self.usedPreviewAttrPoint > 0)
  elseif 0 < point then
    self:ConfirmAddPoint()
  end
end

function Role_AttributeUI:recommendAddShow()
  self.btn_minusStrength:SetActive(self.preAddMap.strength > 0)
  self.btn_minusAgility:SetActive(0 < self.preAddMap.agility)
  self.btn_minusVitality:SetActive(0 < self.preAddMap.vitality)
  self.btn_minusEnergy:SetActive(0 < self.preAddMap.energy)
  self:SetChangeNum()
  self:SetAttributeNumPos(self.lab_strength, self.btn_plusStrength:GetActive())
  self:SetAttributeNumPos(self.lab_agility, self.btn_plusAgility:GetActive())
  self:SetAttributeNumPos(self.lab_vitality, self.btn_plusVitality:GetActive())
  self:SetAttributeNumPos(self.lab_energy, self.btn_plusEnergy:GetActive())
  self:SetAddAttributeNumPos(self.input_preValueStrength, self.lbl_addStrengthSign, self.btn_plusStrength:GetActive())
  self:SetAddAttributeNumPos(self.input_preValueAgility, self.lbl_addAgilitySign, self.btn_plusAgility:GetActive())
  self:SetAddAttributeNumPos(self.input_preValueVitality, self.lbl_addVitalitySign, self.btn_plusVitality:GetActive())
  self:SetAddAttributeNumPos(self.input_preValueEnergy, self.lbl_addEnergySign, self.btn_plusEnergy:GetActive())
end

function Role_AttributeUI:SetChangeNum()
  local val = self.preAddMap.strength
  self.lbl_addStrengthSign:SetActive(0 < val)
  local strVal = 0 < val and tostring(val) or ""
  self.input_preValueStrength:SetText(strVal)
  val = self.preAddMap.agility
  self.lbl_addAgilitySign:SetActive(0 < val)
  strVal = 0 < val and tostring(val) or ""
  self.input_preValueAgility:SetText(strVal)
  val = self.preAddMap.vitality
  self.lbl_addVitalitySign:SetActive(0 < val)
  strVal = 0 < val and tostring(val) or ""
  self.input_preValueVitality:SetText(strVal)
  val = self.preAddMap.energy
  self.lbl_addEnergySign:SetActive(0 < val)
  strVal = 0 < val and tostring(val) or ""
  self.input_preValueEnergy:SetText(strVal)
  self.input_preValueStrength:SetActive(0 < QuickFind.LuaMainPlayerViewAttrData().validAttributePoint)
  self.input_preValueAgility:SetActive(0 < QuickFind.LuaMainPlayerViewAttrData().validAttributePoint)
  self.input_preValueVitality:SetActive(0 < QuickFind.LuaMainPlayerViewAttrData().validAttributePoint)
  self.input_preValueEnergy:SetActive(0 < QuickFind.LuaMainPlayerViewAttrData().validAttributePoint)
end

function Role_AttributeUI:SetActiveFalse(state)
  self.btn_minusStrength:SetActive(state)
  self.btn_minusAgility:SetActive(state)
  self.btn_minusVitality:SetActive(state)
  self.btn_minusEnergy:SetActive(state)
  self.lbl_addStrengthSign:SetActive(state)
  self.lbl_addAgilitySign:SetActive(state)
  self.lbl_addVitalitySign:SetActive(state)
  self.lbl_addEnergySign:SetActive(state)
  self.input_preValueStrength:SetActive(state)
  self.input_preValueAgility:SetActive(state)
  self.input_preValueVitality:SetActive(state)
  self.input_preValueEnergy:SetActive(state)
end

function Role_AttributeUI:SetAttributeNumPos(go, state)
  if state then
    go.transform.localPosition = Vector3(60, go.transform.localPosition.y, go.transform.localPosition.z)
  else
    go.transform.localPosition = Vector3(80, go.transform.localPosition.y, go.transform.localPosition.z)
  end
end

function Role_AttributeUI:SetAddAttributeNumPos(go, goAdd, state)
  local textLength = #go.gameObject.transform:GetComponent("Text").text
  if state then
    if textLength < 3 then
      goAdd.transform.localPosition = Vector3(90, go.transform.localPosition.y, go.transform.localPosition.z)
    else
      local needNumber = textLength - 2
      goAdd.transform.localPosition = Vector3(90 - needNumber * 3, go.transform.localPosition.y, go.transform.localPosition.z)
    end
    go.transform.localPosition = Vector3(110, go.transform.localPosition.y, go.transform.localPosition.z)
  else
    goAdd.transform.localPosition = Vector3(110, go.transform.localPosition.y, go.transform.localPosition.z)
    go.transform.localPosition = Vector3(140, go.transform.localPosition.y, go.transform.localPosition.z)
  end
end

local character_attribute_metaTbl

function Role_AttributeUI:CalculateRecommendPoint()
  local careerID = tonumber(string.sub(tostring(QuickFind.LuaMainPlayerViewAttrData().career), -1))
  if self.recommendPoint == nil then
    return
  end
  local lvCfg
  if careerID == 6 then
    lvCfg = ClientTable.cfg_Global_globalManager:TryGetValue(self.recommendPoint[5][1]).effect
  else
    lvCfg = ClientTable.cfg_Global_globalManager:TryGetValue(self.recommendPoint[careerID][1]).effect
  end
  local ArcherJobType = self.careerDirection
  if ArcherJobType == 2 then
    if self.recommendPoint[careerID][2] == nil then
      return
    end
    lvCfg = ClientTable.cfg_Global_globalManager:TryGetValue(self.recommendPoint[careerID][2]).effect
  end
  local careerCfg = string.split(lvCfg, "&")
  local attributeProportion = string.split(careerCfg[2], "#")
  self.Proportion[attributeProportion[1]] = tonumber(attributeProportion[2])
  self.Proportion[attributeProportion[3]] = tonumber(attributeProportion[4])
  local attributeCfg = ClientTable.cfg_Character_attributeManager:TryGetValue(QuickFind.LuaMainPlayerViewAttrData().career)
  if character_attribute_metaTbl == nil then
    character_attribute_metaTbl = getmetatable(attributeCfg)
  end
  for k, v in pairs(self.Proportion) do
    for kk, vv in pairs(character_attribute_metaTbl.__index) do
      if k == kk then
        self.HavePoint[kk] = QuickFind.LuaMainPlayerViewAttrData():GetHasChooseAttr(kk)
      end
    end
    for kk, vv in pairs(attributeCfg) do
      if k == kk then
        self.HavePoint[kk] = QuickFind.LuaMainPlayerViewAttrData():GetHasChooseAttr(kk)
      end
    end
  end
  local alreadyPoint = 0
  local AllPoint = 0
  local validAttributePoint = 0
  for k, v in pairs(self.HavePoint) do
    alreadyPoint = alreadyPoint + v
  end
  local pointBase = 0
  for i, v in pairs(self.Proportion) do
    if type(v) == "number" then
      pointBase = pointBase + v
    end
  end
  AllPoint = alreadyPoint + QuickFind.LuaMainPlayerViewAttrData().validAttributePoint
  for k, v in pairs(self.Proportion) do
    local point
    if self.HavePoint[k] == nil then
      if math.floor(AllPoint * (v / pointBase)) > QuickFind.LuaMainPlayerViewAttrData().validAttributePoint then
        point = QuickFind.LuaMainPlayerViewAttrData().validAttributePoint
      else
        point = math.floor(AllPoint * (v / pointBase))
      end
      validAttributePoint = validAttributePoint + point
      self.recommendAddPoint[k] = point
    else
      if math.floor(AllPoint * (v / pointBase) - self.HavePoint[k]) > QuickFind.LuaMainPlayerViewAttrData().validAttributePoint then
        point = QuickFind.LuaMainPlayerViewAttrData().validAttributePoint
      elseif 0 > math.floor(AllPoint * (v / pointBase) - self.HavePoint[k]) then
        point = 0
      else
        point = math.floor(AllPoint * (v / pointBase) - self.HavePoint[k])
      end
      validAttributePoint = validAttributePoint + point
      self.recommendAddPoint[k] = point
    end
  end
  if validAttributePoint ~= QuickFind.LuaMainPlayerViewAttrData().validAttributePoint then
    local surplusPoint = QuickFind.LuaMainPlayerViewAttrData().validAttributePoint - validAttributePoint
    for k, v in pairs(self.recommendAddPoint) do
      self.recommendAddPoint[k] = v + surplusPoint
      break
    end
  end
end

local FadeTime = 0.3

function Role_AttributeUI:ChangeTextColor(lab)
  if self.isChange == true and self.isOnPress == false then
    return
  end
  local parent = lab.transform.parent.gameObject
  local parentText = parent.transform:GetComponent("Text")
  local recTimer
  parentText:DOColor(Color.green, FadeTime)
  lab.text:DOColor(Color.green, FadeTime)
  
  local function SetFadeColorText()
    parentText:DOColor(Color(0.80078125, 0.80078125, 0.80078125), FadeTime)
    lab.text:DOColor(Color(0.86328125, 0.875, 0.8984375), FadeTime)
    Timer.Stop(recTimer)
    recTimer = nil
  end
  
  recTimer = Timer.StartLoopForever(FadeTime, SetFadeColorText)
end

function Role_AttributeUI:RoleAddAttributeChanged(_, data)
  if data == nil then
    return
  end
  if data.state == CAttributeAddPointState.AddAttribute then
    self:Role_CalculatorAddPoint(data.control, data.pointNumber)
  elseif data.state == CAttributeAddPointState.ReduceAttribute then
    self:Role_CalculatorReducePoint(data.control, data.pointNumber)
  end
  EventManager.Dispatch(Event.RolePreAddMapChanged, {
    preAddMapData = self.preAddMap
  })
end

function Role_AttributeUI:Role_CalculatorAddPoint(control, pointNumber)
  if not self.recommendAdd then
    self:btn_recommendOnClick(control.attrType, pointNumber)
  else
    self.isChange = false
    if self.usedPreviewAttrPoint >= QuickFind.LuaMainPlayerViewAttrData().validAttributePoint then
      return
    end
    self.preAddMap[control.attrType] = self.preAddMap[control.attrType] + pointNumber
    self:SetUsedPreviewAttrPoint(self.usedPreviewAttrPoint + pointNumber)
    self:CalcPreviewAttrMap()
    self:RefreshAttributesInfo()
    self:CloseAttributeChange()
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.btnFunc,
      state = true
    })
  end
end

function Role_AttributeUI:Role_CalculatorReducePoint(control, pointNumber)
  if self.usedPreviewAttrPoint <= 0 then
    return
  end
  self.preAddMap[control.attrType] = self.preAddMap[control.attrType] - pointNumber
  self:SetUsedPreviewAttrPoint(self.usedPreviewAttrPoint - pointNumber)
  self:CalcPreviewAttrMap()
  self:RefreshAttributesInfo()
end

function Role_AttributeUI:ConfirmAddPoint()
  local req = {}
  for k, v in pairs(self.preAddMap) do
    if v ~= 0 then
      req[EAttributeType[k]] = v
    end
  end
  MeController.ReqAttributeModify(req)
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {2380001, 2430002})
  self:ResetPreAddPoints()
end
