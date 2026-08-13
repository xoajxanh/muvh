Enchant_NavUI = class(BaseUI)
Enchant_NavUI.layer = UILayer.Panel
Enchant_NavUI.orderInLayer = 0
Enchant_NavUI.hideType = UIHideType.WaitDestroy
Enchant_NavUI.hideFunc = UIHideFunc.MoveOutOfScreen
Enchant_NavUI.escClose = UIEscClose.DontClose

function Enchant_NavUI:InitControls()
  self.tog_information = self:GetControl("go_JH_Group/tog_information")
  self.tog_upgrade = self:GetControl("go_JH_Group/tog_upgrade")
  self.tog_enchant = self:GetControl("go_JH_Group/tog_enchant")
  self.tog_smelt = self:GetControl("go_JH_Group/tog_smelt")
end

function Enchant_NavUI:Init()
end

function Enchant_NavUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Enchant_NavUI:InitUI()
  self.TogObjTab = {
    [UIID.Equip_EnchantInformationUI] = self.tog_information,
    [UIID.Equip_EnchantUpgradeUI] = self.tog_upgrade,
    [UIID.Equip_EnchantInlayUI] = self.tog_enchant,
    [UIID.Equip_EnchantSmelt] = self.tog_smelt
  }
  self.TogSort = {
    [1] = UIID.Equip_EnchantInformationUI,
    [2] = UIID.Equip_EnchantUpgradeUI,
    [3] = UIID.Equip_EnchantInlayUI,
    [4] = UIID.Equip_EnchantSmelt
  }
  self.CurUI = UIID.Equip_EnchantInformationUI
end

function Enchant_NavUI:RegistUIEvents()
  self.tog_information:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_upgrade:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_enchant:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_smelt:SetOnToggleChanged(self, self.OnToggleChanged)
end

function Enchant_NavUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Enchant_NavUI:RegistEvents()
  self:RegistEvent(Event.EnchantEquipNavChange, self.EnchantEquipNavChange, self)
end

function Enchant_NavUI:EnchantEquipNavChange(_eventId, _data)
  if _data == nil or string.isNullOrEmpty(_data.panelName) or self.TogObjTab[_data.panelName] == nil then
    return
  end
  self.CurUI = _data.panelName
  self:ToggleInit(_data.equipIndex)
end

function Enchant_NavUI:Refresh()
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {
    3000903,
    3000904,
    3000905,
    3000906
  })
  if self.args and self.args.uiID then
    self.CurUI = self.args.uiID
    if self.TogObjTab[self.CurUI] then
      UIManager.Show(self.args.uiID, {resetLogic = 1})
    end
  else
    self:SetFirstUIID()
  end
  self:ToggleInit()
end

function Enchant_NavUI:SetFirstUIID()
  local toggleControl, targetUIID
  local isFirst = true
  for i, v in ipairs(self.TogSort) do
    toggleControl = self.TogObjTab[v]
    if toggleControl:GetActive() and not IsNil(toggleControl.gameObject) then
      if isFirst then
        targetUIID = v
        isFirst = false
      end
      if RedPointManager:GetCacheStateByPath("Enchant_NavUI#" .. toggleControl.transform.name) then
        targetUIID = v
        break
      end
    end
  end
  self.CurUI = targetUIID
end

function Enchant_NavUI:ToggleInit(_equipIndex)
  for i, v in pairs(self.TogObjTab) do
    if i == self.CurUI then
      v.toggle.isOn = true
    end
  end
  self:OnToggleChanged(nil, nil, _equipIndex)
end

function Enchant_NavUI:OnToggleChanged(_, _, _equipIndex)
  local equipIndex = _equipIndex and type(_equipIndex) == "number" and _equipIndex or nil
  if self.tog_information.toggle.isOn then
    self:tog_informationOnToggleChanged(equipIndex)
  elseif self.tog_upgrade.toggle.isOn then
    self:tog_upgradeOnToggleChanged(equipIndex)
  elseif self.tog_enchant.toggle.isOn then
    self:tog_enchantOnToggleChanged(equipIndex)
  elseif self.tog_smelt.toggle.isOn then
    self:btn_tog_smeltOnToggleChanged()
  end
  EquipeInfoData.curView = self.CurUI
end

function Enchant_NavUI:tog_informationOnToggleChanged(_equipIndex)
  self.CurUI = UIID.Equip_EnchantInformationUI
  UIManager.Show(UIID.Equip_EnchantInformationUI, {resetLogic = 1})
  EventManager.Dispatch(Event.SuitEquipChange, {
    cellType = EquipCellType.HONGZHUANG,
    from = UIID.Equip_EnchantInformationUI,
    equipIndex = _equipIndex
  })
end

function Enchant_NavUI:tog_upgradeOnToggleChanged(_equipIndex)
  self.CurUI = UIID.Equip_EnchantUpgradeUI
  UIManager.Show(UIID.Equip_EnchantUpgradeUI, {resetLogic = 1})
  EventManager.Dispatch(Event.SuitEquipChange, {
    cellType = EquipCellType.HONGZHUANG,
    from = UIID.Equip_EnchantUpgradeUI,
    equipIndex = _equipIndex
  })
end

function Enchant_NavUI:tog_enchantOnToggleChanged(_equipIndex)
  self.CurUI = UIID.Equip_EnchantInlayUI
  UIManager.Show(UIID.Equip_EnchantInlayUI, {resetLogic = 1})
  EventManager.Dispatch(Event.SuitEquipChange, {
    cellType = EquipCellType.HONGZHUANG,
    from = UIID.Equip_EnchantInlayUI,
    equipIndex = _equipIndex
  })
end

function Enchant_NavUI:btn_tog_smeltOnToggleChanged()
  UIManager.Show(UIID.Equip_EnchantSmelt, {resetLogic = 1})
end

function Enchant_NavUI:OnHide()
  EquipeInfoData.curView = nil
end

function Enchant_NavUI:OnDestroy()
end
