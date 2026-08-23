local HolySkeletonBagUITemplates = {}

function HolySkeletonBagUITemplates:Init()
  self:InitControls()
  self:BindUIEvent()
end

function HolySkeletonBagUITemplates:InitControls()
  self.btn_item = self:GetControl("btn_item")
  self.lab_num = self:GetControl("btn_item/lab_num")
  self.lab_name = self:GetControl("lab_name")
  self.img_choose = self:GetControl("img_choose")
  self.lab_attr = self:GetControl("lab_attr")
end

function HolySkeletonBagUITemplates:BindUIEvent()
  self:GetControl():SetOnClick(self, self.btn_3DItemOnClick)
end

function HolySkeletonBagUITemplates:btn_3DItemOnClick()
  self.data.OnClick()
end

function HolySkeletonBagUITemplates:SetChooseChange(bool)
  self.img_choose:SetActive(bool)
end

function HolySkeletonBagUITemplates:Refresh(data)
  if not data then
    return
  end
  self.data = data
  self.img_choose:SetActive(false)
  self:RefreshAttribute(self.data)
end

function HolySkeletonBagUITemplates:RefreshAttribute(data)
  if self.itemCellData then
    self.itemCellData:RecycleRes()
  end
  if not data.ItemInfo and not data then
    return
  end
  self.lab_name:SetText(string.GetColorText(data.Name, ItemQuality2ColorDic[data.ColorShow]))
  self.lab_attr:SetText(string.GetColorText(data.SacredBoneAttribute, "#51C4FF"))
  local item = ItemUtility.GenerateItemDataByServerData(data.ItemInfo)
  if not self.itemCellData then
    self.itemCellData = ItemCellData()
  end
  self.itemCellData:RefreshData(item)
  ItemUtility.ShowItemCell(self.btn_item, self.itemCellData, nil, true)
  self.lab_num:SetText(data.ItemCount)
  if data.ItemCount <= 0 then
    self.lab_num:SetActive(false)
  else
    self.lab_num:SetActive(true)
  end
end

function HolySkeletonBagUITemplates:ItemOnClick(control)
  local itemData = ItemUtility.GenerateItemData(tonumber(control.param.ItemId))
  itemData.tblItem.serverInfo = control.param.ItemInfo
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = self.btn_item
  })
end

return HolySkeletonBagUITemplates
