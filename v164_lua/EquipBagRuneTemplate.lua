local EquipBagRuneTemplate = {}

function EquipBagRuneTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
end

local intervalTime = 0.3

function EquipBagRuneTemplate:InitControls()
  self.img_select = self:GetControl("img_select")
  self.img_Arrow = self:GetControl("img_grrow")
  self.equipRuneCellData = ItemCellData()
end

function EquipBagRuneTemplate:BindUIEvent()
  self:GetControl():SetOnClick(self, self.btn_3DItemOnClick)
end

function EquipBagRuneTemplate:btn_3DItemOnLongPress(control, eventData)
  if not self:GetTimeDown() then
    return
  end
  UIManager.Show(UIID.ItemTipUI, {
    item = self.data,
    rightOperate = EItemOperateType.Show,
    ctrl = control,
    contrast = control.contrast
  })
end

function EquipBagRuneTemplate:btn_3DItemOnPress(control)
  intervalTime = 0.3
end

function EquipBagRuneTemplate:GetTimeDown()
  intervalTime = intervalTime - Time.deltaTime
  if intervalTime <= 0 then
    intervalTime = 0.3
    return true
  end
  return false
end

function EquipBagRuneTemplate:btn_3DItemOnClick(control)
  local selectRune = MeRunneController:GetSelectRuneData()
  if selectRune and selectRune.itemId == self.data.itemId then
    UIManager.Show(UIID.ItemTipUI, {
      item = self.data,
      rightOperate = EItemOperateType.Show,
      ctrl = control,
      contrast = control.contrast
    })
  else
    MeRunneController:SetSelectRuneData(self.data)
  end
end

function EquipBagRuneTemplate:Refresh(data, ui)
  if data == nil then
    self:GetControl():SetActive(false)
    return
  end
  self.data = data
  self.parent = ui
  self:RefreshModel()
  self:ResetUIShow()
end

function EquipBagRuneTemplate:RefreshModel()
  local itemData = ItemUtility.GenerateItemData(self.data.itemId)
  if itemData then
    itemData.count = self.data.count
    self.equipRuneCellData:RefreshData(itemData)
    ItemUtility.ShowItemCell(self:GetControl(), self.equipRuneCellData, self.parent, false)
  end
end

function EquipBagRuneTemplate:ResetUIShow()
  self.img_select:SetActive(false)
  local selectRuneData = MeRunneController:GetSelectRuneData()
  if selectRuneData then
    self.img_select:SetActive(self.data.id == selectRuneData.id)
  end
  local state = MeRunneController:CheckRuneCanSetOrHigh(self.data.tblItem.id, self.data.serverInfo.runesLevel)
  if state then
    self.parent:SetSprite("Atlas_Common", "ty_bag_green", self.img_Arrow)
  else
    self.img_Arrow:SetActive(false)
  end
end

return EquipBagRuneTemplate
