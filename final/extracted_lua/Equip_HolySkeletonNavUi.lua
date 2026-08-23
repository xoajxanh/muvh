Equip_HolySkeletonNavUi = class(BaseUI)
Equip_HolySkeletonNavUi.layer = UILayer.Panel
Equip_HolySkeletonNavUi.orderInLayer = 0
Equip_HolySkeletonNavUi.hideType = UIHideType.WaitDestroy
Equip_HolySkeletonNavUi.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_HolySkeletonNavUi.escClose = UIEscClose.DontClose

function Equip_HolySkeletonNavUi:InitControls()
  self.tog_holySkeleton = self:GetControl("go_skeletonNavGroup/tog_holySkeleton")
  self.tog_holySkeletonInlay = self:GetControl("go_skeletonNavGroup/tog_holySkeletonInlay")
  self.tog_holySkeletonFusion = self:GetControl("go_skeletonNavGroup/tog_holySkeletonFusion")
  self.SubPanelRoot = self:GetControl("SubPanelRoot")
  self.SubPanelRootTwo = self:GetControl("SubPanelRootTwo")
end

function Equip_HolySkeletonNavUi:Init()
  self.UITab = {
    UIID.Equip_HolySkeletonUI,
    UIID.Equip_HolySkeletonInlayUI,
    UIID.Equip_HolySkeletonCombineUI
  }
  self.CurUI = UIID.Equip_HolySkeletonUI
end

function Equip_HolySkeletonNavUi:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_HolySkeletonNavUi:InitUI()
  self.TogObjTab = {
    [UIID.Equip_HolySkeletonUI] = self.tog_holySkeleton,
    [UIID.Equip_HolySkeletonInlayUI] = self.tog_holySkeletonInlay,
    [UIID.Equip_HolySkeletonCombineUI] = self.tog_holySkeletonFusion
  }
  self.TogSort = {
    [1] = UIID.Equip_HolySkeletonUI,
    [2] = UIID.Equip_HolySkeletonInlayUI,
    [3] = UIID.Equip_HolySkeletonCombineUI
  }
end

function Equip_HolySkeletonNavUi:RegistUIEvents()
  self.tog_holySkeleton:SetOnToggleChanged(self, self.tog_holySkeletonOnToggleChanged)
  self.tog_holySkeletonInlay:SetOnToggleChanged(self, self.tog_holySkeletonInlayOnToggleChanged)
  self.tog_holySkeletonFusion:SetOnToggleChanged(self, self.tog_holySkeletonFusionOnToggleChanged)
end

function Equip_HolySkeletonNavUi:OnToggleChanged()
  if self.tog_holySkeleton:GetIsOn() then
    self:tog_holySkeletonOnToggleChanged()
  elseif self.tog_holySkeletonInlay:GetIsOn() then
    self:tog_holySkeletonInlayOnToggleChanged()
  elseif self.tog_holySkeletonFusion:GetIsOn() then
    self:tog_holySkeletonFusionOnToggleChanged()
  end
end

function Equip_HolySkeletonNavUi:tog_holySkeletonOnToggleChanged()
  if self.tog_holySkeleton:GetIsOn() then
    if not UIManager.IsVisible(UIID.Equip_HolySkeletonUI) then
      UIManager.Show(UIID.Equip_HolySkeletonUI, {resetLogic = 1})
    end
    EventManager.Dispatch(Event.HolySkeletonNavChange, {
      from = UIID.Equip_HolySkeletonUI
    })
  end
end

function Equip_HolySkeletonNavUi:tog_holySkeletonInlayOnToggleChanged()
  if self.tog_holySkeletonInlay:GetIsOn() then
    if not UIManager.IsVisible(UIID.Equip_HolySkeletonInlayUI) then
      UIManager.Show(UIID.Equip_HolySkeletonInlayUI, {resetLogic = 1})
      NetManager.Send(BagMessage.ReqBagInfoByType, {storageType = 4})
    end
    EventManager.Dispatch(Event.HolySkeletonNavChange, {
      from = UIID.Equip_HolySkeletonInlayUI
    })
  end
end

function Equip_HolySkeletonNavUi:tog_holySkeletonFusionOnToggleChanged()
  if self.tog_holySkeletonFusion:GetIsOn() and not UIManager.IsVisible(UIID.Equip_HolySkeletonCombineUI) then
    UIManager.Show(UIID.Equip_HolySkeletonCombineUI, {resetLogic = 1})
  end
end

function Equip_HolySkeletonNavUi:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_HolySkeletonNavUi:RegistEvents()
  self:RegistEvent(Event.SetHolySkeletonNav, self.SetHolySkeletonNav, self)
end

function Equip_HolySkeletonNavUi:Refresh()
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {
    3000403,
    3000404,
    3000405
  })
  if self.args then
    if self.args.uiID then
      self.CurUI = self.args.uiID
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

function Equip_HolySkeletonNavUi:SetFirstUIID()
  local toggleControl, targetUIID
  local isFirst = true
  for i, v in ipairs(self.TogSort) do
    toggleControl = self.TogObjTab[v]
    if toggleControl:GetActive() and not IsNil(toggleControl.gameObject) then
      if isFirst then
        targetUIID = v
        isFirst = false
      end
      if RedPointManager:GetCacheStateByPath("Equip_HolySkeletonNavUi#" .. toggleControl.transform.name) then
        targetUIID = v
        break
      end
    end
  end
  self.CurUI = targetUIID
  UIManager.Show(self.CurUI, {resetLogic = 1})
end

function Equip_HolySkeletonNavUi:ToggleInit()
  for i, v in pairs(self.TogObjTab) do
    if i == self.CurUI then
      v.toggle.isOn = true
    else
      v.toggle.isOn = false
    end
  end
  self:OnToggleChanged()
end

function Equip_HolySkeletonNavUi:SetHolySkeletonNav(_, data)
  gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneEquipSelectIndex = data.equipIndex
  gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneEquipInfoType = true
  if data == nil then
    return
  end
  if self.TogObjTab[data.UIName] ~= nil then
    self.TogObjTab[data.UIName]:SetIsOn(true)
  end
end

function Equip_HolySkeletonNavUi:OnHide()
end

function Equip_HolySkeletonNavUi:OnDestroy()
end
