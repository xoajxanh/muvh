Role_AllAttFristPanelUI = class(BaseUI)
Role_AllAttFristPanelUI.layer = UILayer.Panel
Role_AllAttFristPanelUI.orderInLayer = 0
Role_AllAttFristPanelUI.hideType = UIHideType.Hide
Role_AllAttFristPanelUI.hideFunc = UIHideFunc.MoveOutOfScreen
Role_AllAttFristPanelUI.escClose = UIEscClose.DontClose

function Role_AllAttFristPanelUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.lab_attr = self:GetControl("Bg/sv_attrView/ViewPort/Content/lab_attr")
  self.lab_attrValue = self:GetControl("Bg/sv_attrView/ViewPort/Content/lab_attr/lab_attrValue")
  self.btn_closeAllAttrPanel = self:GetControl("btn_closeAllAttrPanel")
end

function Role_AllAttFristPanelUI:Init()
  self.attrItemMap = {}
  self.otherAttr = {}
end

function Role_AllAttFristPanelUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Role_AllAttFristPanelUI:InitUI()
  self:InitAttrMap()
end

function Role_AllAttFristPanelUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_closeAllAttrPanel:SetOnClick(self, self.btn_closeAllAttrPanelOnClick)
end

function Role_AllAttFristPanelUI:btn_closeBgOnClick(control)
end

function Role_AllAttFristPanelUI:btn_closeAllAttrPanelOnClick(control)
  UIManager.Hide(UIID.Role_AllAttFristPanelUI)
end

function Role_AllAttFristPanelUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Role_AllAttFristPanelUI:RegistEvents()
  self:RegistEvent(Event.Role_RefreshShield, self.OnRole_MyShieldChanged, self)
end

function Role_AllAttFristPanelUI:Refresh()
end

function Role_AllAttFristPanelUI:OnHide()
end

function Role_AllAttFristPanelUI:OnDestroy()
end

function Role_AllAttFristPanelUI:RefreshAllAttributeInfo(previewAttrMap, previewAttrMapUpFlagMap)
  local baseUI = UIManager.GetUiByName(UIID.Role_AttributeUI)
  if baseUI == nil then
    return
  end
  local attrCnt = table.count(self.attrItemMap)
  local val, valStr, textColor, attrType, multiplier
  for i = 1, attrCnt do
    attrType = self.attrItemMap[i].attrType
    val = QuickFind.LuaMainPlayerData():TryGetAttrValue(attrType) or 0
    if attrType == EAttributeType.healthAfterMonsterKillAbsolute then
      multiplier = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.healthAfterMonsterKillMultiplier) or 0
      val = multiplier * QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumHealth) * 1.0E-4 + val
      self.attrItemMap[i].lab_attrValue.transform.parent.gameObject:SetActive(true)
    elseif attrType == EAttributeType.manaAfterMonsterKillAbsolute then
      multiplier = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.manaAfterMonsterKillMultiplier) or 0
      val = multiplier * QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumMana) * 1.0E-4 + val
      self.attrItemMap[i].lab_attrValue.transform.parent.gameObject:SetActive(true)
    end
    valStr = 0 < val and (self.attrItemMap[i].isRate and string.format("%.2f%s", val / 100.0, "%") or tostring(val)) or "-"
    if attrType == EAttributeType.maximumShield then
      self.ShieldID = i
      if RoleManager.me.data.hasShield then
        local shield = gameMgr:GetAvatarManager():GetMainPlayer():GetMe().data.shield
        local maxShield = gameMgr:GetAvatarManager():GetMainPlayer():GetInfo():TryGetAttrValue(EAttributeType.maximumShield)
        valStr = string.format("%d/%d", shield, maxShield)
      else
        valStr = "-"
      end
    elseif attrType == EAttributeType.shieldRecoveryMultiplier then
      if not RoleManager.me.data.hasShield then
        valStr = "-"
      end
    elseif attrType == EAttributeType.comboRecovery then
      if not SkillUtility.GetMeComboSkill() then
        valStr = "-"
      end
    elseif attrType == EAttributeType.reductionMonsterAttackSpeed then
      if 0 >= QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.reductionMonsterAttackSpeed) then
        valStr = "-"
      end
    elseif attrType == EAttributeType.monsterAttackPlayerDamageAbsorption then
      if 0 >= QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.monsterAttackPlayerDamageAbsorption) then
        valStr = "-"
      end
    elseif attrType == EAttributeType.monsterDamageAbsorptionShow and 0 >= QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.monsterDamageAbsorptionShow) then
      valStr = "-"
    end
    if valStr == "-" and self.attrItemMap[i].localizationKey == "healthRecoveryAbsolute" then
      self.attrItemMap[i].lab_attrValue.transform.parent.gameObject:SetActive(false)
    end
    if valStr == "-" and self.attrItemMap[i].localizationKey == "manaRecoveryAbsolute" then
      self.attrItemMap[i].lab_attrValue.transform.parent.gameObject:SetActive(false)
    end
    if valStr == "-" and self.attrItemMap[i].localizationKey == "finalDamageIncreasePvp" then
      self.attrItemMap[i].lab_attrValue.transform.parent.gameObject:SetActive(false)
    end
    if valStr == "-" and self.attrItemMap[i].localizationKey == "healthAfterMonsterKillAbsolute" then
      self.attrItemMap[i].lab_attrValue.transform.parent.gameObject:SetActive(false)
    end
    if valStr == "-" and self.attrItemMap[i].localizationKey == "manaAfterMonsterKillAbsolute" then
      self.attrItemMap[i].lab_attrValue.transform.parent.gameObject:SetActive(false)
    end
    if self.attrItemMap[i].localizationKey == "maximumShield" then
      self.attrItemMap[i].lab_attrValue.transform.parent.gameObject:SetActive(valStr ~= "-")
    end
    if self.attrItemMap[i].localizationKey == "shieldRecoveryMultiplier" then
      self.attrItemMap[i].lab_attrValue.transform.parent.gameObject:SetActive(valStr ~= "-")
    end
    if self.attrItemMap[i].localizationKey == "comboRecovery" then
      self.attrItemMap[i].lab_attrValue.transform.parent.gameObject:SetActive(valStr ~= "-")
    end
    self.attrItemMap[i].lab_attrValue.text = valStr
    textColor = previewAttrMapUpFlagMap[self.attrItemMap[i].attrType] and Color.green or Color.white
    self.attrItemMap[i].lab_attrValue.color = textColor
  end
end

function Role_AllAttFristPanelUI:CreateAttributeItem(attrTypeKey, isRate, ii)
  local attrItem = {}
  local item = self.lab_attr:Instantiate()
  item:SetActive(true)
  local attrDesc = item:GetComponent(typeof(CS.UnityEngine.UI.Graphic))
  attrDesc.text = AttributeWordUtil.GetUIWord(attrTypeKey, CAttributeWordType.Role_AttributeUI)
  item = item.transform:Find("lab_attrValue")
  attrItem.attrType = EAttributeType[attrTypeKey]
  attrItem.lab_attrValue = item:GetComponent(typeof(CS.UnityEngine.UI.Graphic))
  attrItem.localizationKey = attrTypeKey
  attrItem.isRate = isRate
  table.insert(self.attrItemMap, attrItem)
end

function Role_AllAttFristPanelUI:AttrTable()
  local T1 = {}
  local len1 = 0
  local tab1 = ClientTable.cfg_Global_enumManager:TryGetValue(4)
  for i, v in pairs(tab1.effect) do
    len1 = len1 + 1
  end
  for a = 1, len1 do
    for i, v in pairs(tab1.effect) do
      if v == a then
        table.insert(T1, i)
      end
    end
  end
  return T1
end

local T1 = {}

function Role_AllAttFristPanelUI:InitAttrMap()
  self.attrItemMap = {}
  if T1 then
    T1 = self:AttrTable()
  end
  local ii = 0
  local tab = ClientTable.cfg_Global_enumManager:TryGetValue(1)
  if tab ~= nil and tab.effect ~= nil then
    for x, y in ipairs(T1) do
      for i, v in pairs(tab.effect) do
        if y == i then
          ii = ii + 1
          self:CreateAttributeItem(i, v ~= nil and v == 1, ii)
        end
      end
    end
  end
end

function Role_AllAttFristPanelUI:OnRole_MyShieldChanged()
  if self.ShieldID == nil then
    return
  end
  local shield = gameMgr:GetAvatarManager():GetMainPlayer():GetMe().data.shield
  local maxShield = gameMgr:GetAvatarManager():GetMainPlayer():GetInfo():TryGetAttrValue(EAttributeType.maximumShield)
  if not RoleManager.me.data.hasShield then
    shield = 0
    maxShield = 0
  end
  self.attrItemMap[self.ShieldID].lab_attrValue.text = string.format("%d/%d", shield, maxShield)
end
