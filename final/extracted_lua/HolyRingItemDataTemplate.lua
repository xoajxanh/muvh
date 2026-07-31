local HolyRingItemDataTemplate = {}

function HolyRingItemDataTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
end

function HolyRingItemDataTemplate:InitControls()
  self.HolyRing_Item = self:GetControl("HolyRing_Item")
  self.lab_ringType = self:GetControl("lab_ringType")
  self.lab_ringLevel = self:GetControl("lab_ringLevel")
  self.lab_num = self:GetControl("img_ringNum/lab_num")
  self.img_choose = self:GetControl("img_choose")
end

function HolyRingItemDataTemplate:BindUIEvent()
  self:GetControl():SetOnClick(self, self.btn_3DItemOnClick)
end

function HolyRingItemDataTemplate:btn_3DItemOnClick(control)
  self.data.OnClick()
end

function HolyRingItemDataTemplate:Refresh(data)
  self.data = data
  if self.data == {} then
    return
  end
  if self.data ~= nil then
    self:RefreshAttribute(self.data)
  end
end

function HolyRingItemDataTemplate:RefreshAttribute(data)
  self.img_choose:SetActive(false)
  if self.itemCellData then
    self.itemCellData:RecycleRes()
  end
  self.HolyRing_Item:SetActive(true)
  self.lab_ringType:SetText(data.RingTypeName)
  self.lab_num:SetText(data.Count)
  self.lab_ringLevel:SetText(data.RingYear)
  if not data.ItemInfo then
    return
  end
  local item = ItemUtility.GenerateItemData(tonumber(data.ItemInfo.itemId))
  if not self.itemCellData then
    self.itemCellData = ItemCellData()
  end
  self.itemCellData:RefreshData(item)
  ItemUtility.ShowItemCell(self.HolyRing_Item, self.itemCellData, nil, false)
  
  local function HolyRing_ItemOnClick(_, _)
    UIManager.Show(UIID.ItemTipUI, {
      item = item,
      rightOperate = EItemOperateType.Wear,
      ctrl = self.HolyRing_Item
    })
    gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr().ItemInfoId = data.ItemInfo.id
  end
  
  if data.AuctionUIHolyRingItemClick then
    self.HolyRing_Item:SetOnClick(self, data.AuctionUIHolyRingItemClick)
  else
    self.HolyRing_Item:SetOnClick(self, HolyRing_ItemOnClick)
  end
end

function HolyRingItemDataTemplate:RefreshSrecct(bool)
  self.img_choose:SetActive(bool)
end

return HolyRingItemDataTemplate
