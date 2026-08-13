local EquipBagNewRuneTemplate = {}

function EquipBagNewRuneTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
end

function EquipBagNewRuneTemplate:InitControls()
  self.img_select = self:GetControl("img_select")
  self.img_arrow = self:GetControl("img_arrow")
end

function EquipBagNewRuneTemplate:BindUIEvent()
  self:UIControl():SetOnClick(self, self.btn_3DItemOnClick)
end

function EquipBagNewRuneTemplate:btn_3DItemOnClick(control)
  if self.root.chooseBagRuneData and self.root.chooseBagRuneData.itemId == self.data.itemId then
    UIManager.Show(UIID.ItemTipUI, {
      item = self.data,
      rightOperate = EItemOperateType.Show,
      ctrl = control,
      contrast = control.contrast
    })
  else
    EventManager.Dispatch(Event.ChooseNewRuneBagRuneData, self.data)
  end
end

function EquipBagNewRuneTemplate:Refresh(data, ui)
  if table.isNullOrEmpty(data) then
    self:GetControl():SetActive(false)
    return
  end
  self:GetControl():SetActive(true)
  self.data = data
  self.root = ui
  self:RefreshModel()
  self:RefreshUI()
end

function EquipBagNewRuneTemplate:RefreshModel()
  ItemUtility.ShowItemCellByItemId(self.data.itemId, self.data.count, self:UIControl(), self.root, false, nil, nil, 2, 3)
end

function EquipBagNewRuneTemplate:RefreshUI()
  self.img_select:SetActive(false)
  if self.root.chooseBagRuneData then
    self.img_select:SetActive(self.data.id == self.root.chooseBagRuneData.id)
  end
  local state = QuickFind.GetNewRuneDataManager():CheckRuneCanSetOrHigh(self.root.chooseHoleRuneData, self.data)
  self.img_arrow:SetActive(state)
end

function EquipBagNewRuneTemplate:RefreshChooseState()
  if self.root.chooseBagRuneData then
    self.img_select:SetActive(self.root.chooseBagRuneData and self.data.id == self.root.chooseBagRuneData.id or false)
  end
end

return EquipBagNewRuneTemplate
