local RuneHoleTemplate = {}

function RuneHoleTemplate:Init(root)
  self.root = root
  self:InitControls()
  self:BindUIEvent()
end

function RuneHoleTemplate:InitControls()
  self.img_itembg = self:GetControl("img_itembg")
  self.img_choose = self:GetControl("img_choose")
  self.Runes_Item = self:GetControl("Runes_Item")
  self.img_lock = self:GetControl("img_lock")
end

function RuneHoleTemplate:BindUIEvent()
  self.img_itembg:SetOnClick(self, self.HoleOnClick)
end

function RuneHoleTemplate:HoleOnClick(control)
  local curChooseHoleIndex = QuickFind.GetNewRuneDataManager():GetCurChooseHoleIndex()
  local curChooseHoleRuneData = QuickFind.GetNewRuneDataManager():GetServerRuneDataByHoleIndex(curChooseHoleIndex)
  if curChooseHoleIndex and curChooseHoleIndex == self.index and curChooseHoleRuneData and curChooseHoleRuneData.runeItem then
    UIManager.Show(UIID.ItemTipUI, {
      item = ItemUtility.GenerateItemDataByServerData(curChooseHoleRuneData.runeItem),
      rightOperate = EItemOperateType.Show,
      ctrl = control,
      contrast = control.contrast
    })
  else
    QuickFind.GetNewRuneDataManager():SetCurChooseHoleIndex(self.index)
    self.root:RefreshHoleChooseState()
    EventManager.Dispatch(Event.ChooseNewRuneHole)
  end
end

function RuneHoleTemplate:Refresh(index, ui)
  self.index = index
  self.data = QuickFind.GetNewRuneDataManager():GetServerRuneDataByHoleIndex(index)
  self.root = ui
  self:RefreshModel()
  self:RefreshUI()
end

function RuneHoleTemplate:RefreshModel()
  if table.isNullOrEmpty(self.data) or self.data.runeItem == nil or self.data.runeItem.itemId == nil or self.data.runeItem.itemId == 0 then
    ItemUtility.ResetItemCell(self.Runes_Item)
    return
  end
  ItemUtility.ShowItemCellByItemId(self.data.runeItem.itemId, 1, self.Runes_Item, self.root, true, false, nil)
end

function RuneHoleTemplate:RefreshUI()
  self:RefreshChooseState()
  self:RefreshLockState()
end

function RuneHoleTemplate:RefreshChooseState()
  local curChooseHoleIndex = QuickFind.GetNewRuneDataManager():GetCurChooseHoleIndex()
  self.img_choose:SetActive(curChooseHoleIndex and curChooseHoleIndex == self.index or false)
end

function RuneHoleTemplate:RefreshLockState()
  self.img_lock:SetActive(self.data == nil or self.data.level < ClientTable.cfg_Item_equip_NewRunesCellManager:GetNextCanInlayRuneLevelNeedHoleLevel(self.data.index, 1))
end

return RuneHoleTemplate
