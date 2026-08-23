Equip_RunesNavUI = class(BaseUI)
Equip_RunesNavUI.layer = UILayer.Tip
Equip_RunesNavUI.orderInLayer = 0
Equip_RunesNavUI.hideType = UIHideType.WaitDestroy
Equip_RunesNavUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_RunesNavUI.escClose = UIEscClose.DontClose

function Equip_RunesNavUI:InitControls()
  self.tog_1 = self:GetControl("go_runesNavGroup/tog_1")
  self.tog_2 = self:GetControl("go_runesNavGroup/tog_2")
  self.tog_3 = self:GetControl("go_runesNavGroup/tog_3")
end

function Equip_RunesNavUI:Init()
  self.UITab = {
    UIID.Equip_RunesInlayUI,
    UIID.Equip_RunesFusionUI,
    UIID.Equip_RunesDecomposeUI
  }
  self.CurUI = UIID.Equip_RunesInlayUI
end

function Equip_RunesNavUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_RunesNavUI:InitUI()
  self.TogObjTab = {
    [UIID.Equip_RunesInlayUI] = self.tog_1,
    [UIID.Equip_RunesFusionUI] = self.tog_2,
    [UIID.Equip_RunesDecomposeUI] = self.tog_3
  }
  self.TogSort = {
    [1] = UIID.Equip_RunesInlayUI,
    [2] = UIID.Equip_RunesFusionUI,
    [3] = UIID.Equip_RunesDecomposeUI
  }
end

function Equip_RunesNavUI:RegistUIEvents()
  self.tog_1:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_2:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_3:SetOnToggleChanged(self, self.OnToggleChanged)
end

function Equip_RunesNavUI:OnToggleChanged()
  if self.IsTogInit then
    return
  end
  if self.tog_1:GetIsOn() then
    self:RunesInlayOnToggleChanged()
  elseif self.tog_2:GetIsOn() then
    self:RunesFusionOnToggleChanged()
  elseif self.tog_3:GetIsOn() then
    self:RunesDecomposeOnToggleChanged()
  end
end

function Equip_RunesNavUI:RunesInlayOnToggleChanged()
  if not UIManager.IsVisible(UIID.Equip_RunesInlayUI) then
    EquipeInfoData.curView = UIID.Equip_RunesInlayUI
    MeRunneController:SetShowEquipType(EquipCellType.HONGZHUANG)
    UIManager.Show(UIID.Equip_RunesInlayUI, {resetLogic = 1})
    EventManager.Dispatch(Event.RefreshBagEquip, UIID.Equip_RunesInlayUI)
  end
end

function Equip_RunesNavUI:RunesFusionOnToggleChanged()
  if not UIManager.IsVisible(UIID.Equip_RunesFusionUI) then
    UIManager.Show(UIID.Equip_RunesFusionUI, {resetLogic = 1})
  end
end

function Equip_RunesNavUI:RunesDecomposeOnToggleChanged()
  if not UIManager.IsVisible(UIID.Equip_RunesDecomposeUI) then
    UIManager.Show(UIID.Equip_RunesDecomposeUI, {resetLogic = 1})
  end
end

function Equip_RunesNavUI:OnShow()
  self.IsTogInit = true
  MeRunneController:SetShowEquipType(EquipCellType.HONGZHUANG)
  self:RegistEvents()
  self:Refresh()
  if self.args then
    if self.args.uiID then
      self.CurUI = self.args.uiID
      EquipeInfoData.curView = self.args.uiID
      if self.args.openType then
        UIManager.Show(self.CurUI, {
          resetLogic = 1,
          openType = self.args.openType,
          itemData = self.args.itemData
        })
      else
        UIManager.Show(self.CurUI, {resetLogic = 1})
      end
    end
    if self.args.openFirstTab and self.args.openSecondTab then
      self.CurUI = self.UITab[self.args.openFirstTab]
      EquipeInfoData.curView = self.UITab[self.args.openFirstTab]
      UIManager.Show(self.CurUI, {
        openSecondTab = self.args.openSecondTab,
        resetLogic = 1
      })
    end
  else
    self:SetFirstUIID()
  end
  self:ToggleInit()
end

function Equip_RunesNavUI:RegistEvents()
  self:RegistEvent(Event.ObtainToJumpRunesNavUI, self.ShowViewByIndex, self)
end

function Equip_RunesNavUI:ShowViewByIndex(_, index)
  if index == 1 then
    self.tog_1:SetIsOn(true)
  elseif index == 2 then
    self.tog_2:SetIsOn(true)
  elseif index == 3 then
    self.tog_3:SetIsOn(true)
  end
  self:OnToggleChanged()
end

function Equip_RunesNavUI:Refresh()
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {
    3000105,
    3000106,
    3000107
  })
end

function Equip_RunesNavUI:SetFirstUIID()
  local toggleControl, targetUIID
  local isFirst = true
  for i, v in ipairs(self.TogSort) do
    toggleControl = self.TogObjTab[v]
    if toggleControl:GetActive() and not IsNil(toggleControl.gameObject) then
      if isFirst then
        targetUIID = v
        isFirst = false
      end
      if RedPointManager:GetCacheStateByPath("Equip_RunesNavUI#" .. toggleControl.transform.name) then
        targetUIID = v
        break
      end
    end
  end
  self.CurUI = targetUIID
  EquipeInfoData.curView = targetUIID
  UIManager.Show(self.CurUI, {resetLogic = 1})
end

function Equip_RunesNavUI:ToggleInit()
  for i, v in pairs(self.TogObjTab) do
    if i == self.CurUI then
      v.toggle.isOn = true
    else
      v.toggle.isOn = false
    end
  end
  self.IsTogInit = false
end

function Equip_RunesNavUI:OnHide()
  EquipeInfoData.curView = nil
end

function Equip_RunesNavUI:OnDestroy()
end
