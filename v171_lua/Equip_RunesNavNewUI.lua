Equip_RunesNavNewUI = class(BaseUI)
Equip_RunesNavNewUI.layer = UILayer.Tip
Equip_RunesNavNewUI.orderInLayer = 0
Equip_RunesNavNewUI.hideType = UIHideType.WaitDestroy
Equip_RunesNavNewUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_RunesNavNewUI.escClose = UIEscClose.DontClose

function Equip_RunesNavNewUI:InitControls()
  self.tog_1 = self:GetControl("go_runesNavGroup/tog_1")
  self.tog_2 = self:GetControl("go_runesNavGroup/tog_2")
  self.tog_3 = self:GetControl("go_runesNavGroup/tog_3")
end

function Equip_RunesNavNewUI:Init()
  self.UITab = {
    UIID.Equip_RunesUpgradeNewUI,
    UIID.Equip_RunesInlayNewUI,
    UIID.Equip_RunesPanelUI
  }
  self.CurUI = UIID.Equip_RunesUpgradeNewUI
end

function Equip_RunesNavNewUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_RunesNavNewUI:InitUI()
  self.TogObjTab = {
    [UIID.Equip_RunesUpgradeNewUI] = self.tog_1,
    [UIID.Equip_RunesInlayNewUI] = self.tog_2,
    [UIID.Equip_RunesPanelUI] = self.tog_3
  }
  self.TogSort = {
    [1] = UIID.Equip_RunesUpgradeNewUI,
    [2] = UIID.Equip_RunesInlayNewUI,
    [3] = UIID.Equip_RunesPanelUI
  }
end

function Equip_RunesNavNewUI:RegistUIEvents()
  self.tog_1:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_2:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_3:SetOnToggleChanged(self, self.OnToggleChanged)
end

function Equip_RunesNavNewUI:OnToggleChanged()
  if self.IsTogInit then
    return
  end
  if self.tog_1:GetIsOn() then
    self:RunesUpgradeOnToggleChanged()
  elseif self.tog_2:GetIsOn() then
    self:RunesInlayOnToggleChanged()
  elseif self.tog_3:GetIsOn() then
    self:RunesCombineOnToggleChanged()
  end
end

function Equip_RunesNavNewUI:RunesUpgradeOnToggleChanged()
  if not UIManager.IsVisible(UIID.Equip_RunesUpgradeNewUI) then
    UIManager.Show(UIID.Equip_RunesUpgradeNewUI, {resetLogic = 1})
  end
end

function Equip_RunesNavNewUI:RunesInlayOnToggleChanged()
  if not UIManager.IsVisible(UIID.Equip_RunesInlayNewUI) then
    UIManager.Show(UIID.Equip_RunesInlayNewUI, {resetLogic = 1})
  end
end

function Equip_RunesNavNewUI:RunesCombineOnToggleChanged()
  if not UIManager.IsVisible(UIID.Equip_RunesPanelUI) then
    UIManager.Show(UIID.Equip_RunesPanelUI, {resetLogic = 1})
  end
end

function Equip_RunesNavNewUI:OnShow()
  self.IsTogInit = true
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

function Equip_RunesNavNewUI:RegistEvents()
end

function Equip_RunesNavNewUI:Refresh()
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {
    3000703,
    3000704,
    3000705,
    3000706
  })
end

function Equip_RunesNavNewUI:SetFirstUIID()
  local toggleControl, targetUIID
  local isFirst = true
  for i, v in ipairs(self.TogSort) do
    toggleControl = self.TogObjTab[v]
    if toggleControl:GetActive() and not IsNil(toggleControl.gameObject) then
      if isFirst then
        targetUIID = v
        isFirst = false
      end
      if RedPointManager:GetCacheStateByPath("Equip_RunesNavNewUI#" .. toggleControl.transform.name) then
        targetUIID = v
        break
      end
    end
  end
  self.CurUI = targetUIID
  UIManager.Show(self.CurUI, {resetLogic = 1})
end

function Equip_RunesNavNewUI:ToggleInit()
  for i, v in pairs(self.TogObjTab) do
    if i == self.CurUI then
      v.toggle.isOn = true
    else
      v.toggle.isOn = false
    end
  end
  self.IsTogInit = false
end

function Equip_RunesNavNewUI:OnHide()
end
