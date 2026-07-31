local HolyRingCombineBagTemplate = {}

function HolyRingCombineBagTemplate:Init(data)
  self.clickBtnCallBack = data.clickCallBack
  self:InitControls()
  self:BindUIEvent()
end

function HolyRingCombineBagTemplate:InitControls()
  self.HolyRing_Item = self:GetControl("HolyRing_Item")
  self.lab_ringLevel = self:GetControl("lab_ringLevel")
  self.lab_ringType = self:GetControl("lab_ringType")
  self.lab_num = self:GetControl("img_ringNum/lab_num")
  self.img_select = self:GetControl("img_select")
end

function HolyRingCombineBagTemplate:BindUIEvent()
  self:UIControl():SetOnClick(self, self.BagItemOnClick)
end

function HolyRingCombineBagTemplate:BagItemOnClick()
  if self.clickBtnCallBack then
    self.clickBtnCallBack(self)
  end
end

function HolyRingCombineBagTemplate:Refresh(data, ui)
  if data == nil then
    self:UIControl():SetActive(false)
    return
  end
  self.data = data
  self.parent = ui
  self:RefreshModelView()
  self:RefreshUIView()
end

function HolyRingCombineBagTemplate:RefreshModelView()
  if self.HolyRing_Item.itemCellData then
    self.HolyRing_Item.itemCellData:RecycleRes()
  end
  ItemUtility.ShowItemCellByItemId(self.data.ItemId, 1, self.HolyRing_Item, self.parent, true, nil, nil, 2, 3)
end

function HolyRingCombineBagTemplate:RefreshUIView()
  self.img_select:SetActive(false)
  self.lab_ringLevel:SetText(tostring(self.data.RingYear or 0))
  self.lab_ringType:SetText(tostring(self.data.RingTypeName) or "")
  self.lab_num:SetText(tostring(self.data.Count or 0))
end

return HolyRingCombineBagTemplate
