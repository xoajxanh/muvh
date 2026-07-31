local SmallHolySkeletonIntensifyTemp = {}

function SmallHolySkeletonIntensifyTemp:Init()
  self:InitControls()
  self:BindUIEvent()
end

function SmallHolySkeletonIntensifyTemp:InitControls()
  self.btn_add = self:GetControl("btn_add")
  self.img_lock = self:GetControl("img_lock")
  self.lab_condition = self:GetControl("lab_condition")
  self.holySkeletonCellData = ItemCellData()
end

function SmallHolySkeletonIntensifyTemp:BindUIEvent()
  self.btn_add:SetOnClick(self, self.btn_addOnClick)
end

function SmallHolySkeletonIntensifyTemp:btn_addOnClick(control)
  EventManager.Dispatch(Event.SetHolySkeletonNav, {
    UIName = "Equip_HolySkeletonInlayUI",
    equipIndex = self.data.Place
  })
end

function SmallHolySkeletonIntensifyTemp:Refresh(data, ui)
  if data == nil then
    return
  end
  self.data = data
  self.parent = ui
  self:RefreshModel()
  self:RefreshUI()
end

function SmallHolySkeletonIntensifyTemp:RefreshModel()
  if self.holySkeletonCellData then
    ItemUtility.HideItemCell(self:GetControl(), self.holySkeletonCellData)
  end
  if self.data.Items ~= nil then
    local itemData = ItemUtility.GenerateItemData(self.data.Items.itemId)
    if itemData then
      self.holySkeletonCellData:RefreshData(itemData)
      ItemUtility.ShowItemCell(self:GetControl(), self.holySkeletonCellData, self.parent, false)
    end
  end
end

function SmallHolySkeletonIntensifyTemp:RefreshUI()
  self.lab_condition:SetActive(false)
  self.img_lock:SetActive(false)
  self.btn_add:SetActive(false)
  if self.data.IsUnlock then
    self.btn_add:SetActive(self.data.Items == nil)
  else
    self.img_lock:SetActive(true)
    self.lab_condition:SetActive(self.data.IsShowUI)
    self.lab_condition:SetText(string.format("Lv%d m\225\187\159 kh\195\179a", self.data.UnlockGrade))
  end
end

return SmallHolySkeletonIntensifyTemp
