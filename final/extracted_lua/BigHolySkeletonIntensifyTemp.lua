local BigHolySkeletonIntensifyTemp = {}

function BigHolySkeletonIntensifyTemp:Init()
  self:InitControls()
  self:BindUIEvent()
end

function BigHolySkeletonIntensifyTemp:InitControls()
  self.btn_add = self:GetControl("btn_add")
  self.holySkeletonCellData = ItemCellData()
end

function BigHolySkeletonIntensifyTemp:BindUIEvent()
  self.btn_add:SetOnClick(self, self.btn_addOnClick)
end

function BigHolySkeletonIntensifyTemp:btn_addOnClick(control)
  gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneEquipInfoType = true
  EventManager.Dispatch(Event.SetHolySkeletonNav, {
    UIName = "Equip_HolySkeletonInlayUI",
    equipIndex = self.data.Place
  })
end

function BigHolySkeletonIntensifyTemp:Refresh(data, ui)
  if data == nil then
    return
  end
  self.data = data
  self.parent = ui
  self:RefreshModel()
  self:RefreshUI()
end

function BigHolySkeletonIntensifyTemp:RefreshModel()
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

function BigHolySkeletonIntensifyTemp:RefreshUI()
  self.btn_add:SetActive(self.data.Items == nil)
end

return BigHolySkeletonIntensifyTemp
