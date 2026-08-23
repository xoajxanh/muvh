Equip_GemUI = class(BaseUI)
Equip_GemUI.layer = UILayer.Panel
Equip_GemUI.orderInLayer = 1
Equip_GemUI.hideType = UIHideType.WaitDestroy
Equip_GemUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_GemUI.escClose = UIEscClose.DontClose

function Equip_GemUI:InitControls()
  self.bg_equip = self:GetControl("bg_equip")
  self.btn_close = self:GetControl("bg_equip/btn_close")
  self.lab_equip = self:GetControl("bg_equip/lab_equip")
  self.btn_weapen = self:GetControl("bg_equip/go_weapen/btn_weapen")
  self.img_add_weapen = self:GetControl("bg_equip/go_weapen/img_add_weapen")
  self.btn_3DItem = self:GetControl("bg_equip/go_weapen/btn_3DItem")
  self.txt_add_weapen = self:GetControl("bg_equip/go_weapen/txt_add_weapen")
  self.btn_ItemOne = self:GetControl("bg_equip/go_stoneCell/btn_ItemOne")
  self.btn_ItemTwo = self:GetControl("bg_equip/go_stoneCell/btn_ItemTwo")
  self.btn_ItemThree = self:GetControl("bg_equip/go_stoneCell/btn_ItemThree")
  self.img_Signetlevel = self:GetControl("bg_equip/LevelUp/img_Signetlevel")
  self.img_Signetlevelnext = self:GetControl("bg_equip/LevelUp/img_Signetlevelnext")
  self.img_attributeArrow = self:GetControl("bg_equip/LevelUp/img_attributeArrow")
  self.lab_attributegrow = self:GetControl("bg_equip/levelAttribute/lab_attributegrow")
  self.lab = self:GetControl("bg_equip/levelAttribute/lab_attributegrow/img_titleico/lab_attributegrow/lab")
  self.text_atk = self:GetControl("bg_equip/levelAttribute/lab_attributegrow/img_titleico/lab_attributegrow/lab/lab_atk/text_atk")
  self.text_atkArrow = self:GetControl("bg_equip/levelAttribute/lab_attributegrow/img_titleico/lab_attributegrow/lab/lab_atk/text_atkArrow")
  self.text_atknext = self:GetControl("bg_equip/levelAttribute/lab_attributegrow/img_titleico/lab_attributegrow/lab/lab_atk/text_atknext")
  self.frame_item = self:GetControl("bg_equip/needMaterial/materialParent/frame_item")
  self.Model = self:GetControl("bg_equip/needMaterial/materialParent/frame_item/Model")
  self.btn_lvUp = self:GetControl("bg_equip/btn_lvUp")
  self.text_lvUp = self:GetControl("bg_equip/btn_lvUp/text_lvUp")
  self.btn_gem_combination = self:GetControl("bg_equip/btn_gem_combination")
  self.Scroll_Gem = self:GetControl("bg_equip/btn_gem_combination/Scroll_Gem")
  self.lab_stone = self:GetControl("bg_equip/btn_gem_combination/Scroll_Gem/Viewport/Content/three_stone/three_content/lab_stone")
  self.all_content = self:GetControl("bg_equip/btn_gem_combination/Scroll_Gem/Viewport/Content/all_stone/all_content")
  self.lab_stoneAdd = self:GetControl("bg_equip/btn_gem_combination/Scroll_Gem/Viewport/Content/all_stone/all_content/lab_stoneAdd")
  self.Img_maxlevel = self:GetControl("bg_equip/Img_maxlevel")
  self.unlockSlotPanel = self:GetControl("bg_equip/unlockSlotPanel")
  self.resetPointPanelClose = self:GetControl("bg_equip/unlockSlotPanel/resetPointPanelClose")
  self.btn_resetPointPanelClose = self:GetControl("bg_equip/unlockSlotPanel/btn_resetPointPanelClose")
  self.btn_get = self:GetControl("bg_equip/unlockSlotPanel/lab_price/btn_get")
  self.consumeItem = self:GetControl("bg_equip/unlockSlotPanel/lab_price/consumeItem")
  self.lab_priceValue = self:GetControl("bg_equip/unlockSlotPanel/lab_price/lab_priceValue")
  self.btn_confirm = self:GetControl("bg_equip/unlockSlotPanel/btn_confirm")
  self.Img_noWearEquip = self:GetControl("Img_noWearEquip")
  self.SubPanelRoot = self:GetControl("SubPanelRoot")
  self.descBtn = self:GetControl("descBtn")
  self.needMaterial = self:GetControl("bg_equip/needMaterial")
end

local this = Equip_GemUI

function Equip_GemUI:Init()
  self.recTimer = {}
end

function Equip_GemUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_GemUI:InitUI()
  self.chooseItemCellData = ItemCellData()
  self.gemTemplateList = {
    luaTemplateManager.GetNewTemplate(self.btn_ItemOne, LuaComponentTemplates.UIItemTemplate, {isShowTips = true}),
    luaTemplateManager.GetNewTemplate(self.btn_ItemTwo, LuaComponentTemplates.UIItemTemplate, {isShowTips = true}),
    luaTemplateManager.GetNewTemplate(self.btn_ItemThree, LuaComponentTemplates.UIItemTemplate, {isShowTips = true})
  }
  self.attributesTemplate = UIUtility.BindUIContainerTemp(self.lab, LuaComponentTemplates.AttributeUnitTemplate, self)
  self.costItemsTemplate = UIUtility.BindUIContainerTemp(self.frame_item, LuaComponentTemplates.ConsumableUnitTemplate, self)
  self.gemCombinesTemplate = UIUtility.BindUIContainerTemp(self.lab_stoneAdd, LuaComponentTemplates.GemCombineEffectTemplate, self)
end

function Equip_GemUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_lvUp:SetOnClick(self, self.btn_lvUpOnClick)
  self.btn_gem_combination:SetOnClick(self, self.btn_gem_combinationOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Equip_GemUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_GemUI)
end

function Equip_GemUI:btn_lvUpOnClick(control)
  local lackCostItemInfo = self.chooseGem:GetUpLackCostItemId()
  if lackCostItemInfo ~= nil then
    TipUtility.ShowQuickGetTipPanel(lackCostItemInfo.itemId)
    return
  end
  if self.chooseGem ~= nil then
    networkRequest.ReqLightStoneLevelUp(self.chooseGem.stoneCellInfo.inlayIndex)
  end
end

function Equip_GemUI:btn_gem_combinationOnClick(control)
  UIManager.Show(UIID.Tip_CommonTipsUI, {
    showType = CommonTipsEnum.Gem
  })
end

function Equip_GemUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_StoneUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Equip_GemUI:OnShow()
  self:RegistEvents()
  self:ResetData()
  self:RefreshEffect()
  self.Scroll_Gem:SetActive(false)
  EquipeInfoData.curView = UIID.Equip_GemUI
  EventManager.Dispatch(Event.EquipForgeUIChange)
end

function Equip_GemUI:ResetData()
  self.chooseEquipIndexInfo = nil
  self.equipIndexInfo = nil
  self.equipData = nil
end

function Equip_GemUI:RegistEvents()
  self:RegistEvent(Event.SelectedGemEquip, self.OnSelectedGemEquip, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBag_ResBagChange, self)
  self:RegistEvent(Event.GemCalculateResultChange, self.OnGemCalculateResultChange, self)
  self:RegistEvent(Event.GemIndexDataChangeEffect, self.OnGemIndexDataChangeEffect, self)
end

function Equip_GemUI:OnSelectedGemEquip(id, msg)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.Equip_GemUI
  })
  self:RefreshChooseData(msg)
  self:RefreshPanel()
end

function Equip_GemUI:OnBag_ResBagChange(id, msg)
  self:RefreshCost()
end

function Equip_GemUI:OnGemCalculateResultChange()
  self:RefreshGemInfoPanel()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.Equip_GemUI
  })
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.Bag_EquipInfoUI
  })
end

function Equip_GemUI:OnGemIndexDataChange(id, msg)
  if msg == nil or msg.gemIndex == nil then
    return
  end
  local gemIndex = msg.gemIndex
  if gemIndex == self.chooseGem.stoneCellInfo.inlayIndex then
    local gemData = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():GetEquipIndexData(self.chooseGem.stoneCellInfo.equipIndex):GetGemListData():GetGemDataByIndex(gemIndex)
    self:RefreshSingleGem(gemData)
    self:GemClickCallBack(gemData)
  end
end

function Equip_GemUI:RefreshChooseData(msg)
  self.chooseEquipIndexInfo = msg
  if self.chooseEquipIndexInfo ~= nil then
    self.equipIndexInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():GetEquipIndexData(self.chooseEquipIndexInfo.modelIndex)
    self.equipData = self:EquipIndexHaveEquip() and self.equipIndexInfo:GetEquipItemData():GetEquipData()
    self.chooseItemCellData:RefreshData(self.equipData)
    GemUtility.CallGemRedPoint(self.chooseEquipIndexInfo.modelIndex)
  end
end

function Equip_GemUI:RefreshPanel()
  self:RefreshNoEquipIndex()
  if self:IsChooseEquipIndex() == false then
    return
  end
  self:RefreshEquip()
  self:RefreshGem()
  self:RefreshGemCombine()
  self:RefreshGemInfoPanel()
  self:RefreshEffect()
end

function Equip_GemUI:RefreshNoEquipIndex()
  self.Img_noWearEquip:SetActive(not self:IsChooseEquipIndex())
end

function Equip_GemUI:RefreshEquip()
  local haveEquip = self:EquipIndexHaveEquip()
  local equipName = haveEquip and self.equipIndexInfo:GetEquipItemData():GetItemTbl().name or ""
  self.lab_equip:SetText(equipName)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.chooseItemCellData, self)
  self.img_add_weapen:SetActive(haveEquip == false)
end

function Equip_GemUI:RefreshGem()
  local haveGemList = self:EquipIndexHaveGemList()
  self.btn_ItemOne:SetActive(haveGemList)
  self.btn_ItemTwo:SetActive(haveGemList)
  self.btn_ItemThree:SetActive(haveGemList)
  if haveGemList == false then
    return
  end
  local gemList = self.equipIndexInfo:GetGemListData():GetGemList()
  self.recommendGemData = self:GetDefaultChoose(gemList)
  local index = 1
  for k, v in pairs(gemList) do
    local isDefaultChoose = self:IsDefaultChoose(v)
    local customData = {}
    customData.itemId = v.stoneTbl.itemid
    customData.count = 1
    customData.name = string.format("Lv.%d", v.stoneLevel)
    customData.gemData = v
    customData.selected = isDefaultChoose
    
    function customData.clickCallBack(itemCellData, gemData)
      self:GemClickCallBack(gemData, true)
    end
    
    customData.clickCallBackParams = v
    local effect = UIControl(self.gemTemplateList[index].go.transform, "Eff_yingshi_hui")
    local go_model = UIControl(self.gemTemplateList[index].go.transform, "go_model")
    UIEffectUtility:SetUIBtnEffectLayer(self, effect)
    effect:SetActive(v.stoneLevel == 0)
    go_model:SetActive(v.stoneLevel ~= 0)
    self.gemTemplateList[index]:Refresh(customData, self)
    index = index + 1
    if isDefaultChoose then
      self:GemClickCallBack(v)
    end
  end
end

function Equip_GemUI:RefreshGemCombine()
  self.btn_gem_combination:SetActive(self:IsShowGemCombine())
end

function Equip_GemUI:RefreshGemInfoPanel()
  local gemCombineEffectList = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():GetGemCombineTblList()
  self.gemCombinesTemplate:SetData(gemCombineEffectList)
end

function Equip_GemUI:GemClickCallBack(gemData, changeSelect)
  self.chooseGem = gemData
  if changeSelect then
    for k, v in pairs(self.gemTemplateList) do
      local isSelfClick = v.customData.gemData.stoneCellInfo.inlayIndex == gemData.stoneCellInfo.inlayIndex
      v:SetSelect(isSelfClick)
    end
  end
  self:RefreshGemLevel()
  self:RefreshAttribute()
  self:RefreshCost()
  self:RefreshMaxLevelState()
end

function Equip_GemUI:RefreshSingleGem(gemData)
  if gemData == nil then
    return
  end
  for k, v in pairs(self.gemTemplateList) do
    if v.customData ~= nil and v.customData.gemData.stoneCellInfo.inlayIndex == gemData.stoneCellInfo.inlayIndex then
      local name = string.format("Lv.%d", gemData.stoneLevel)
      v:RefreshName(name)
      local effect = UIControl(self.gemTemplateList[k].go.transform, "Eff_yingshi_hui")
      local go_model = UIControl(self.gemTemplateList[k].go.transform, "go_model")
      UIEffectUtility:SetUIBtnEffectLayer(self, effect)
      effect:SetActive(v.stoneLevel == 0)
      go_model:SetActive(v.stoneLevel ~= 0)
    end
  end
end

function Equip_GemUI:RefreshGemLevel()
  if self.chooseGem == nil then
    return
  end
  local isMaxLevel = self.chooseGem:CheckIsMaxLevel()
  self.img_attributeArrow:SetActive(not isMaxLevel)
  self.img_Signetlevelnext:SetActive(not isMaxLevel)
  if isMaxLevel == false then
    self.img_Signetlevel:SetText(tostring(self.chooseGem.stoneTbl.level))
    self.img_Signetlevelnext:SetText(tostring(self.chooseGem.nextStoneTbl.level))
  else
    self.img_Signetlevel:SetText(tostring(self.chooseGem.stoneLevel))
  end
end

function Equip_GemUI:RefreshAttribute()
  local attributeList = self.chooseGem:GetAttributeList()
  self.attributesTemplate:SetData(attributeList)
end

function Equip_GemUI:RefreshCost()
  local costItemList = self.chooseGem:GetCostItemList()
  self.costItemsTemplate:SetData(costItemList)
end

function Equip_GemUI:RefreshMaxLevelState()
  local isMaxLevel = self.chooseGem:CheckIsMaxLevel()
  self.needMaterial:SetActive(not isMaxLevel)
  self.btn_lvUp:SetActive(not isMaxLevel)
  self.Img_maxlevel:SetActive(isMaxLevel)
end

function Equip_GemUI:OnHide()
  EquipeInfoData.curView = nil
  GemUtility.EquipGemPanelChooseEquipIndex = nil
  self:DestroyAllTimer()
end

function Equip_GemUI:OnDestroy()
end

function Equip_GemUI:GetDefaultChoose(gemList)
  local cellIndex = next(gemList)
  if gemList == nil or cellIndex == nil then
    return
  end
  local firstGemData = gemList[cellIndex]
  local recommendGemData = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():GetRecommendGemData()
  if recommendGemData ~= nil and recommendGemData.stoneCellInfo.equipIndex == firstGemData.stoneCellInfo.equipIndex then
    return recommendGemData
  end
  local lowGemData
  for k, v in pairs(gemList) do
    lowGemData = lowGemData == nil and v or gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():GemDataCompare(lowGemData, v)
  end
  return lowGemData
end

function Equip_GemUI:IsChooseEquipIndex()
  return self.equipIndexInfo ~= nil
end

function Equip_GemUI:EquipIndexHaveEquip()
  return self.equipIndexInfo ~= nil and self.equipIndexInfo:GetEquipItemData() ~= nil
end

function Equip_GemUI:EquipIndexHaveGemList()
  return self.equipIndexInfo ~= nil and self.equipIndexInfo:GetGemListData():CheckHaveGemData()
end

function Equip_GemUI:IsDefaultChoose(gemData)
  if self.recommendGemData == nil then
    return false
  end
  return self.recommendGemData.stoneCellInfo.inlayIndex == gemData.stoneCellInfo.inlayIndex
end

function Equip_GemUI:IsShowGemCombine()
  return FucShowOrHideController.FuncSystemIsOpen(FunctionSystemEnumId.GemCombine)
end

function Equip_GemUI:ShowEffectLifeTimer(upgradeTemp, surplusTime, index)
  local function UpdateTimer()
    if surplusTime <= 1 then
      if self.recTimer[index] then
        Timer.Stop(self.recTimer[index])
        
        self.recTimer[index] = nil
        EventManager.Dispatch(Event.GemIndexDataChange, upgradeTemp)
      end
    else
      surplusTime = surplusTime - 1
    end
  end
  
  self.recTimer[index] = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function Equip_GemUI:DestroyAllTimer()
  for k, v in pairs(self.recTimer) do
    Timer.Stop(v)
    self.recTimer[k] = nil
  end
  self.recTimer = {}
end

function Equip_GemUI:RefreshEffect()
  local surplusTime = 1
  local upgradeData = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():GemServerUpgradeData(IndexerEnum.get)
  local upgradeTemp = {
    gemIndex = upgradeData.gemIndex,
    stonetype = upgradeData.stonetype,
    success = false
  }
  for key, value in pairs(self.gemTemplateList) do
    local trans = value.go.transform
    local effect_tupo = UIControl(trans, "Eff_yingshi_tupo")
    effect_tupo:SetActive(false)
    if upgradeData and upgradeData.success then
      local index = upgradeData.stonetype % 10
      if index == key then
        UIEffectUtility:EffectOrderLayerSet(self, effect_tupo)
        effect_tupo:SetActive(true)
        self:ShowEffectLifeTimer(upgradeTemp, surplusTime, index)
        break
      end
    end
  end
  gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():GemServerUpgradeData(IndexerEnum.set, upgradeTemp)
end

function Equip_GemUI:OnGemIndexDataChangeEffect(id, msg)
  self:RefreshEffect()
  self:OnGemIndexDataChange(nil, msg)
end
