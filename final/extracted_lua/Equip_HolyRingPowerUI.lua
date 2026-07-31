Equip_HolyRingPowerUI = class(BaseUI)
Equip_HolyRingPowerUI.layer = UILayer.Panel
Equip_HolyRingPowerUI.orderInLayer = 0
Equip_HolyRingPowerUI.hideType = UIHideType.WaitDestroy
Equip_HolyRingPowerUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_HolyRingPowerUI.escClose = UIEscClose.DontClose

function Equip_HolyRingPowerUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.go_alphaFilled = self:GetControl("bg_equip/PowerLevel/img_slider/go_alpha/go_alphaFilled")
  self.go_progress = self:GetControl("bg_equip/PowerLevel/img_slider/go_progress")
  self.HolyRing_Item = self:GetControl("bg_equip/PowerLevel/RingItem/HolyRing_Item")
  self.tog_unlockRate = self:GetControl("bg_equip/PowerLevel/UnlockRate/tog_unlockRate")
  self.lab = self:GetControl("bg_equip/AllAttribute/sw_attributegrow/img_titleico/content/lab")
  self.text_atk = self:GetControl("bg_equip/AllAttribute/sw_attributegrow/img_titleico/content/lab/lab_atk/text_atk")
  self.text_atkArrow = self:GetControl("bg_equip/AllAttribute/sw_attributegrow/img_titleico/content/lab/lab_atk/text_atkArrow")
  self.text_atknext = self:GetControl("bg_equip/AllAttribute/sw_attributegrow/img_titleico/content/lab/lab_atk/text_atknext")
  self.text_atkimg = self:GetControl("bg_equip/AllAttribute/sw_attributegrow/img_titleico/content/lab/lab_atk/text_atkimg")
  self.btn_update = self:GetControl("bg_equip/btn_update")
  self.text_update = self:GetControl("bg_equip/btn_update/text_update")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
  self.img_bg_xu = self:GetControl("bg_equip/PowerLevel/img_bg_hei/img_bg_xu")
  self.lab_ringType = self:GetControl("bg_equip/PowerLevel/RingItem/lab_ringType")
  self.lab_ringLevel = self:GetControl("bg_equip/PowerLevel/RingItem/lab_ringLevel")
  self.tab = self:GetControl("bg_equip/PowerLevel/UnlockRate/lab_unlockRate/tab")
  self.lab_num = self:GetControl("bg_equip/PowerLevel/UnlockRate/lab_unlockRate/tab/lab_num")
  self.btn_add = self:GetControl("bg_equip/PowerLevel/btn_add")
  self.RingItem = self:GetControl("bg_equip/PowerLevel/RingItem")
  self.UnlockRate = self:GetControl("bg_equip/PowerLevel/UnlockRate")
  self.img_holeMax = self:GetControl("img_holeMax")
end

function Equip_HolyRingPowerUI:Init()
end

function Equip_HolyRingPowerUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_HolyRingPowerUI:InitUI()
  self.attributeTemp = UIUtility.BindUIContainerTemp(self.lab, LuaComponentTemplates.HolyRingPowerAttributeTemp, self)
  self.propCellData = ItemCellData()
  self:InitAttribute()
end

function Equip_HolyRingPowerUI:InitAttribute()
  self.HolyRingAttribute = {}
  for attrType, index in pairs(HolyRingPowerAttributeMap) do
    local itemAttribute = {}
    itemAttribute.attributeName = attrType
    itemAttribute.sort = index
    itemAttribute.type = HolyRingAttributeType.BasicAttributes
    table.insert(self.HolyRingAttribute, itemAttribute)
  end
  table.sort(self.HolyRingAttribute, function(a, b)
    return a.sort < b.sort
  end)
  local holeCount = ClientTable.cfg_Ring_levelManager:GetHolyRingHoleCount()
  for i = 1, holeCount do
    local itemAttribute = {}
    itemAttribute.attributeName = i
    itemAttribute.type = HolyRingAttributeType.HoleAddition
    table.insert(self.HolyRingAttribute, itemAttribute)
  end
end

function Equip_HolyRingPowerUI:RegistUIEvents()
  self.HolyRing_Item:SetOnClick(self, self.HolyRing_ItemOnClick)
  self.btn_update:SetOnClick(self, self.btn_updateOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.tog_unlockRate:SetOnToggleChanged(self, self.tog_unlockRateOnToggleChanged)
  self.btn_add:SetOnClick(self, self.btn_addOnClick)
end

function Equip_HolyRingPowerUI:HolyRing_ItemOnClick(control)
end

function Equip_HolyRingPowerUI:btn_updateOnClick(control)
  local selectIndex, itemId, count
  if self.tog_unlockRate:GetIsOn() and not self:JudgeAllHoleUnlockState() then
    selectIndex = self:GetNowHoleIndex()
    itemId, count = self:GetPropItemIdAndCountByHole(selectIndex)
    if count > BagInfoData.GetItemTotalCountByItemId(itemId) then
      FloatingTipUtility.QuickMsg("\196\144\225\186\161o c\225\187\165 kh\195\180ng \196\145\225\187\167")
      return
    end
  end
  local level = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingLevel()
  local exp = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingExp()
  networkRequest.ReqUpgradeHolyRing(itemId, exp, level, count)
end

function Equip_HolyRingPowerUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_HolyRingPowerUI")
  if lvCfg and table.count(lvCfg) > 0 then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Equip_HolyRingPowerUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_HolyRingPowerUI)
end

function Equip_HolyRingPowerUI:tog_unlockRateOnToggleChanged(control)
  self:RefreshUnlockHolyRing()
end

function Equip_HolyRingPowerUI:btn_addOnClick()
  local level = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingLevel()
  local experienceId = ClientTable.cfg_Ring_levelManager:GetExperienceIdByLevel(level)
  local itemData = ItemUtility.GenerateItemData(experienceId)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  self.btn_add.itemData = itemData
  self.btn_add.OpenTipsType = EOpenTipsType.FastBuy
  ItemUtility.ClickObtainItemBtn(_, self.btn_add)
end

function Equip_HolyRingPowerUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_HolyRingPowerUI:RegistEvents()
  self:RegistEvent(Event.HolyRingPowerChange, self.HolyRingPowerChange, self)
end

function Equip_HolyRingPowerUI:Refresh()
  self:HolyRingPowerChange()
end

function Equip_HolyRingPowerUI:HolyRingPowerChange(_, msg)
  self:RefreshAttribute(msg)
  self:RefreshLevelAndExp()
  self:RefreshUnlockHolyRing()
  self:RefreshProp()
  self:RefreshHoleUI(msg)
end

function Equip_HolyRingPowerUI:RefreshAttribute(msg)
  if self.HolyRingAttribute == nil or table.count(self.HolyRingAttribute) == 0 then
    return
  end
  self:ResetHolyRingAttribute()
  if msg then
    if msg.attribute then
      for msgNameItem, msgValueItem in pairs(msg.attribute) do
        for index, attributeDataItem in pairs(self.HolyRingAttribute) do
          if msgNameItem == attributeDataItem.attributeName then
            attributeDataItem.lastAttribute = msgValueItem
          end
        end
      end
    end
    if msg.probability then
      for msgNameItem, msgValueItem in pairs(msg.probability) do
        for index, attributeDataItem in pairs(self.HolyRingAttribute) do
          if msgNameItem == attributeDataItem.attributeName then
            attributeDataItem.lastAttribute = msgValueItem
          end
        end
      end
    end
  end
  self.attributeTemp:SetData(self.HolyRingAttribute)
end

function Equip_HolyRingPowerUI:RefreshLevelAndExp()
  local level = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingLevel()
  local exp = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingExp()
  local totalExp = ClientTable.cfg_Ring_levelManager:GetTotalExpByLevel(level)
  if exp and totalExp then
    self.img_bg_xu:SetText(string.format("C\225\186\165p Th\195\161nh L\225\187\177c %d", level))
    self.go_progress:SetText(string.format("%d/%d", exp, totalExp))
    self.go_alphaFilled:SetFillAmount(exp / totalExp)
  end
end

function Equip_HolyRingPowerUI:RefreshUnlockHolyRing()
  local level = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingLevel()
  local selectHole = self:GetNowHoleIndex()
  local itemId, count, propProbability = self:GetPropItemIdAndCountByHole(selectHole)
  self.lab_ringType:SetText(string.format("\195\148 %d", selectHole))
  local propUnlockFormat = ""
  if self.tog_unlockRate:GetIsOn() and propProbability then
    local strDer = string.format(" +%s%s", propProbability, "%")
    propUnlockFormat = string.GetColorText(strDer, ItemQuality2ColorDic[5])
  end
  local UnlockProbability = MathUtility.FormatNum(ClientTable.cfg_Ring_levelManager:GetUnlockProbability(level, selectHole))
  local UnlockProbabilityFormat = string.GetColorText(string.format("%s%s", UnlockProbability, "%"), ItemQuality2ColorDic[6])
  self.lab_ringLevel:SetText(string.format("T\196\131ng x\195\161c su\225\186\165t m\225\187\159 kh\195\179a %s %s", UnlockProbabilityFormat, propUnlockFormat))
end

function Equip_HolyRingPowerUI:RefreshProp()
  local selectHole = self:GetNowHoleIndex()
  local itemId, count, propProbability = self:GetPropItemIdAndCountByHole(selectHole)
  if itemId then
    if self.propCellData then
      ItemUtility.HideItemCell(self.tab, self.propCellData)
    end
    local itemData = ItemUtility.GenerateItemData(itemId)
    if itemData then
      self.propCellData:RefreshData(itemData)
      ItemUtility.ShowItemCell(self.tab, self.propCellData, self, false)
    end
    local color = ItemQuality2ColorDic[12]
    if count <= BagInfoData.GetItemTotalCountByItemId(itemId) then
      color = ItemQuality2ColorDic[5]
    end
    self.lab_num:SetText(string.GetColorText(count, color))
  end
end

function Equip_HolyRingPowerUI:RefreshHoleUI(msg)
  if msg then
    local effectName = msg.isSuccess and "Eff_UI_hr_kongweijiesuochenggong" or "Eff_UI_hr_dengjitisheng"
    if UIManager.IsVisible(UIID.EffectTipUI) then
      EventManager.Dispatch(Event.TipEffect, {name = effectName, time = 1})
    else
      UIManager.Show(UIID.EffectTipUI, {name = effectName, effectTime = 1})
    end
  end
  local state = self:JudgeAllHoleUnlockState()
  self.img_holeMax:SetActive(state)
  self.RingItem:SetActive(not state)
  self.UnlockRate:SetActive(not state)
end

function Equip_HolyRingPowerUI:GetPropItemIdAndCountByHole(holeIndex)
  local effect = GlobalConfig.GetGlobalConfig(60000031)
  if not string.isNullOrEmpty(effect) and holeIndex ~= nil then
    local propTab = string.split(effect, "&")
    if propTab[holeIndex] then
      local item = string.split(propTab[holeIndex], "#")
      return tonumber(item[1]), tonumber(item[2]), MathUtility.FormatNum(tonumber(item[3]) / 100)
    end
  end
  return nil
end

function Equip_HolyRingPowerUI:GetNowHoleIndex()
  local selectHole = ClientTable.cfg_Ring_levelManager:GetHolyRingHoleCount()
  local holyRingHoleData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingHoleData()
  for holeIndex, holeData in ipairs(holyRingHoleData) do
    if holeData:GetHolyRingHoleUnlockState() == false then
      selectHole = holeIndex
      break
    end
  end
  return selectHole
end

function Equip_HolyRingPowerUI:JudgeAllHoleUnlockState()
  local holyRingHoleData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingHoleData()
  local state = true
  for i, v in pairs(holyRingHoleData) do
    if v:GetHolyRingHoleUnlockState() == false then
      state = false
      break
    end
  end
  return state
end

function Equip_HolyRingPowerUI:ResetHolyRingAttribute()
  if self.HolyRingAttribute and table.count(self.HolyRingAttribute) > 0 then
    for i, v in pairs(self.HolyRingAttribute) do
      v.lastAttribute = nil
    end
  end
end

function Equip_HolyRingPowerUI:OnHide()
  self:ResetHolyRingAttribute()
  self.tog_unlockRate:SetIsOn(false)
end

function Equip_HolyRingPowerUI:OnDestroy()
end
