local HolyRingHoleDataTemplate = {}

function HolyRingHoleDataTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
end

function HolyRingHoleDataTemplate:InitControls()
  self.HolyRing_Item = self:GetControl("HolyRing_Item")
  self.img_choose = self:GetControl("img_choose")
  self.lab_ringhole = self:GetControl("lab_ringhole")
  self.img_lock = self:GetControl("img_lock")
  self.img_redPoint = self:GetControl("img_redPoint")
  self.itemCellData = ItemCellData()
end

function HolyRingHoleDataTemplate:BindUIEvent()
  self:GetControl():SetOnClick(self, self.btn_3DItemOnClick)
end

function HolyRingHoleDataTemplate:btn_3DItemOnClick(control)
  gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr().HolyRingIndex = self.data.HoleIndex
  self.data.OnClick()
end

function HolyRingHoleDataTemplate:Refresh(data)
  if not data then
    return
  end
  self.data = data
  self:RefreshAttribute(self.data)
end

function HolyRingHoleDataTemplate:RefreshAttribute(data)
  self.lab_ringhole:SetText("H\225\186\161ng" .. data.HoleIndex .. "Th\195\161nh Ho\195\160n")
  self:RefreshRedPoint(data)
  self:RefreshLockType(data)
  self:RefreshChooseType(data)
  
  local function LockOnClick()
    if self.img_lock:GetActive() == true then
      FloatingTipUtility.QuickMsg("X\195\161c su\225\186\165t m\225\187\159 kh\195\179a \195\180 sau khi t\196\131ng c\225\186\165p Th\195\161nh L\225\187\177c")
    end
  end
  
  self.img_lock:SetOnClick(self, LockOnClick)
  if self.itemCellData then
    ItemUtility.HideItemCell(self.HolyRing_Item, self.itemCellData)
    if self.itemCellData.itemData then
      self.itemCellData.itemData = nil
    end
  end
  if data.HolyRingHoleItemData then
    local item = ItemUtility.GenerateItemData(tonumber(data.HolyRingHoleItemData.ItemId))
    if not self.itemCellData then
      self.itemCellData = ItemCellData()
    end
    self.itemCellData:RefreshData(item)
    ItemUtility.ShowItemCell(self.HolyRing_Item, self.itemCellData, nil, false)
    
    local function HolyRing_ItemOnClick(control)
      gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr().HolyRingIndex = data.HoleIndex
      if control.itemCellData.itemData == nil then
        return
      end
      UIManager.Show(UIID.ItemTipUI, {
        item = item,
        rightOperate = EItemOperateType.Disboard,
        ctrl = control,
        openType = UIManager.IsVisible(UIID.Equip_HolyRingCombineUI) and TipsOpenType.HolyRingCombineOpen
      })
    end
    
    self.HolyRing_Item:SetOnClick(self, HolyRing_ItemOnClick)
  end
end

function HolyRingHoleDataTemplate:RefreshRedPoint(data)
  local holyRingBagData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr().HolyRingBagData
  if data.HolyRingHoleItemData == nil and data:GetHolyRingHoleUnlockState() then
    self.img_redPoint:SetActive(0 < #holyRingBagData)
  else
    self.img_redPoint:SetActive(false)
  end
end

function HolyRingHoleDataTemplate:RefreshLockType(data)
  if data:GetHolyRingHoleUnlockState() then
    self.img_lock:SetActive(false)
  else
    self.img_lock:SetActive(true)
  end
end

function HolyRingHoleDataTemplate:RefreshChooseType(data)
  local HolyRingIndex = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr().HolyRingIndex
  local holyRingHoleData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingHoleData()
  if data:GetHolyRingHoleUnlockState() then
    if data == holyRingHoleData[HolyRingIndex] then
      self.img_choose:SetActive(true)
    else
      self.img_choose:SetActive(false)
    end
  else
    self.img_choose:SetActive(false)
  end
  if HolyRingIndex == 1 and data == holyRingHoleData[HolyRingIndex] and data:GetHolyRingHoleUnlockState() then
    self.img_choose:SetActive(true)
  end
end

function HolyRingHoleDataTemplate:RefreshSrecct(bool)
  self.img_choose:SetActive(bool)
end

function HolyRingHoleDataTemplate:RefreshLock(bool)
  self.img_lock:SetActive(not bool)
  self:RefreshRedPoint(self.data)
end

return HolyRingHoleDataTemplate
