Rank_HolyRingLookUI = class(BaseUI)
Rank_HolyRingLookUI.layer = UILayer.Panel
Rank_HolyRingLookUI.orderInLayer = 0
Rank_HolyRingLookUI.hideType = UIHideType.WaitDestroy
Rank_HolyRingLookUI.hideFunc = UIHideFunc.MoveOutOfScreen
Rank_HolyRingLookUI.escClose = UIEscClose.DontClose

function Rank_HolyRingLookUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Button_CloseBag = self:GetControl("Button_CloseBag")
  self.go_model = self:GetControl("HolyRingLook/go_model")
  self.RingItem = self:GetControl("sw_RingItem/Viewport/Content/RingItem")
end

function Rank_HolyRingLookUI:Init()
end

function Rank_HolyRingLookUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnCreateItem(ctr)
  ctr.HolyRing_Item = UIControl(ctr.transform, "HolyRing_Item")
  ctr.lab_ringhole = UIControl(ctr.transform, "lab_ringhole")
  ctr.img_lock = UIControl(ctr.transform, "img_lock")
  ctr.img_choose = UIControl(ctr.transform, "img_choose")
  ctr.itemCellData = ItemCellData()
end

local function OnRefreshItem(ctr, _, data, ui)
  if not data then
    return
  end
  ctr.data = data
  ctr.lab_ringhole:SetText("Th\195\161nh Ho\195\160n" .. data.HoleIndex .. "V\225\187\139 tr\195\173")
  ctr.HolyRing_Item:SetOnClick(ctr, function()
  end)
  ctr.img_choose:SetActive(false)
  ctr.img_lock:SetActive(false)
  if ctr.itemCellData == nil then
    ctr.itemCellData = ItemCellData()
  end
  if data.HolyRingHoleItemData and data.HolyRingHoleItemData.ItemId then
    local itemData = ItemUtility.GenerateItemData(tonumber(data.HolyRingHoleItemData.ItemId))
    ctr.itemCellData:RefreshData(itemData)
    ItemUtility.ShowItemCell(ctr.HolyRing_Item, ctr.itemCellData, nil, true)
  else
    ctr.itemCellData:RecycleRes()
    ItemUtility.HideItemCell(ctr.HolyRing_Item, ctr.itemCellData)
  end
end

function Rank_HolyRingLookUI:InitUI()
  self.holyRing_ItemDataCon = UIContainer(self.RingItem, self, OnCreateItem, OnRefreshItem)
end

function Rank_HolyRingLookUI:RegistUIEvents()
  self.Button_CloseBag:SetOnClick(self, self.btn_closeBgOnClick)
end

function Rank_HolyRingLookUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Rank_HolyRingLookUI)
end

function Rank_HolyRingLookUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Rank_HolyRingLookUI:RegistEvents()
end

function Rank_HolyRingLookUI:Refresh()
  self:RefreshHolyRingItems()
end

function Rank_HolyRingLookUI:RefreshHolyRingItems()
  if holyRingHoleData ~= nil and holyRingHoleData ~= {} then
    self.holyRing_ItemData:SetData(holyRingHoleData)
  end
  local holyRingHoleData
  if self.args and self.args.HolyRingData then
    holyRingHoleData = self.args.HolyRingData
  else
    holyRingHoleData = gameMgr:GetAvatarManager():GetOtherPlayer():GetHolyRingDataMgr():GetHolyRingHoleData()
  end
  local noRings = true
  for i = 1, ClientTable.cfg_Ring_levelManager:GetHolyRingHoleCount() do
    if holyRingHoleData[i] and holyRingHoleData[i].HolyRingHoleItemData then
      noRings = false
      break
    end
  end
  if noRings then
    self:btn_closeBgOnClick()
    return
  end
  self.holyRing_ItemDataCon:SetData(holyRingHoleData)
  self:OnShowModel()
end

function Rank_HolyRingLookUI:OnShowModel()
  local viewRoleData = {}
  local holyRingInfo = {}
  local holyRingHoleData = gameMgr:GetAvatarManager():GetOtherPlayer():GetHolyRingDataMgr():GetHolyRingHoleData()
  for i, v in ipairs(holyRingHoleData) do
    if v.HolyRingHoleItemData then
      local HolyRingTable = {}
      HolyRingTable.itemId = v.HolyRingHoleItemData.ItemId
      HolyRingTable.point = v.HolyRingHoleItemData.Quality
      table.insert(holyRingInfo, HolyRingTable)
    end
  end
  local equipData = gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetEquipData()
  viewRoleData.equipsData = equipData
  viewRoleData.career = gameMgr:GetAvatarManager():GetOtherPlayer():GetInfo():GetData().career
  viewRoleData.modelType = EModelType.Charactor
  viewRoleData.model = 1003
  viewRoleData.id = gameMgr:GetAvatarManager():GetOtherPlayer():GetInfo():GetData().lid or gameMgr:GetAvatarManager():GetOtherPlayer():GetInfo():GetData().roleId
  viewRoleData.parent = self.go_model.transform
  viewRoleData.serverCoord = Vector2Int()
  viewRoleData.roleType = ERoleType.Player
  viewRoleData.holyRingInfo = holyRingInfo
  viewRoleData.animationName = "showstand"
  viewRoleData.circleRotation = Vector3:CircleRotation_UI()
  viewRoleData.parent = self.go_model.transform
  if self.modelViewer then
    self.modelViewer:Destroy()
    self.modelViewer = ViewRole(viewRoleData)
  else
    self.modelViewer = ViewRole(viewRoleData)
  end
  self.modelViewer:SetPosition(0, -120, -150)
  self.modelViewer:SetRotation(0, -180, 0)
end

function Rank_HolyRingLookUI:OnHide()
end

function Rank_HolyRingLookUI:OnDestroy()
end
