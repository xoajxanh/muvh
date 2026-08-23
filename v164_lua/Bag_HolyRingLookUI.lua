Bag_HolyRingLookUI = class(BaseUI)
Bag_HolyRingLookUI.layer = UILayer.Panel
Bag_HolyRingLookUI.orderInLayer = 0
Bag_HolyRingLookUI.hideType = UIHideType.WaitDestroy
Bag_HolyRingLookUI.hideFunc = UIHideFunc.MoveOutOfScreen
Bag_HolyRingLookUI.escClose = UIEscClose.DontClose

function Bag_HolyRingLookUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Button_CloseBag = self:GetControl("Button_CloseBag")
  self.go_model = self:GetControl("HolyRingLook/go_model")
  self.RingItem = self:GetControl("sw_RingItem/Viewport/Content/RingItem")
end

function Bag_HolyRingLookUI:Init()
end

function Bag_HolyRingLookUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Bag_HolyRingLookUI:InitUI()
  self.holyRing_ItemData = UIUtility.BindUIContainerTemp(self.RingItem, LuaComponentTemplates.HolyRingHoleDataTemplate, self)
end

function Bag_HolyRingLookUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.Button_CloseBag:SetOnClick(self, self.Button_CloseBagOnClick)
end

function Bag_HolyRingLookUI:RefreshHolyRingItem()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.Holyring_1
  })
  local holyRingHoleData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingHoleData()
  if not holyRingHoleData then
    return
  end
  for i, v in ipairs(holyRingHoleData) do
    function v.OnClick()
      self:OnClick()
    end
  end
  if holyRingHoleData ~= nil and holyRingHoleData ~= {} then
    self.holyRing_ItemData:SetData(holyRingHoleData)
  end
end

function Bag_HolyRingLookUI:OnClick()
  local HolyRingIndex = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr().HolyRingIndex
  for i, v in pairs(self.holyRing_ItemData.items) do
    if v.itemTemp then
      v.itemTemp:RefreshSrecct(i == HolyRingIndex)
    end
  end
end

function Bag_HolyRingLookUI:RefreshLockType(_, msg)
  local holyIndex = msg.holyIndex
  local isSuccess = msg.isSuccess
  local holyRingHoleData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingHoleData()
  if holyIndex <= table.count(holyRingHoleData) and isSuccess then
    if self.Eff then
      self.Eff:Destroy()
      self.Eff = nil
    end
    if self.Eff == nil then
      self.Eff = UIEffectUtility.SetUIEffect("Eff_UI_suoposui", self.holyRing_ItemData.items[holyIndex].itemTemp.HolyRing_Item, true)
    end
    self.Eff:SetActive(true)
    self.holyRing_ItemData.items[holyIndex].itemTemp:RefreshLock(isSuccess)
  end
end

function Bag_HolyRingLookUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Bag_HolyRingLookUI:RegistEvents()
  self:RegistEvent(Event.HolyRingPowerChange, self.RefreshLockType, self)
  self:RegistEvent(Event.HolyRingWearChange, self.RefreshHolyRingItem, self)
  self:RegistEvent(Event.HolyRingDisboardEquip, self.HolyRingDisboardEquip, self)
  self:RegistEvent(Event.RefreshHolyRingPlayerModel, self.OnShowModel, self)
end

function Bag_HolyRingLookUI:HolyRingDisboardEquip()
  local index = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr().HolyRingIndex
  if index then
    networkRequest.ReqTakeOffHolyRing(index)
  end
end

function Bag_HolyRingLookUI:Refresh()
  self:RefreshHolyRingItem()
  self:OnShowModel()
  if self.Eff then
    self.Eff:Destroy()
    self.Eff = nil
  end
end

function Bag_HolyRingLookUI:OnShowModel()
  local viewRoleData = {}
  local holyRingInfo = {}
  local holyRingHoleData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingHoleData()
  for i, v in ipairs(holyRingHoleData) do
    if v.HolyRingHoleItemData then
      local HolyRingTable = {}
      HolyRingTable.itemId = v.HolyRingHoleItemData.ItemId
      HolyRingTable.point = v.HolyRingHoleItemData.Quality
      table.insert(holyRingInfo, HolyRingTable)
    end
  end
  if table.count(holyRingInfo) <= 0 then
    self:OnHide()
  end
  local equipData = RoleEquipData(ViewData.meData.equipsData.Data)
  viewRoleData.equipsData = equipData
  viewRoleData.career = ViewData.meData.career
  viewRoleData.modelType = EModelType.Charactor
  viewRoleData.model = 1003
  viewRoleData.id = ViewData.meData.id
  viewRoleData.parent = self.go_model.transform
  viewRoleData.serverCoord = Vector2Int()
  viewRoleData.roleType = ERoleType.Player
  viewRoleData.holyRingInfo = holyRingInfo
  viewRoleData.circleRotation = Vector3:CircleRotation_UI()
  viewRoleData.circleScale = Vector3:CircleScale_UI()
  if not self.modelViewer then
    self.modelViewer = ViewRole(viewRoleData)
  else
    self.modelViewer:RefreshModel(viewRoleData)
  end
  self.modelViewer:SetPosition(0, -120, -150)
  self.modelViewer:SetRotation(0, -180, 0)
end

function Bag_HolyRingLookUI:OnHide()
  if self.modelViewer then
    self.modelViewer:Destroy()
    self.modelViewer = nil
  end
end

function Bag_HolyRingLookUI:OnDestroy()
end
