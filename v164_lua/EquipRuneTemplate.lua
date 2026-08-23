local EquipRuneTemplate = {}

function EquipRuneTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
end

function EquipRuneTemplate:InitControls()
  self.runes_Item = self:GetControl("Runes_Item")
  self.img_lock = self:GetControl("img_lock")
  self.img_choose = self:GetControl("img_choose")
  self.btn_del = self:GetControl("btn_del")
  self.effect_runes = self:GetControl("Effect_runes")
  self.ima_redPoint = self:GetControl("img_redPoint")
  self.equipRuneCellData = ItemCellData()
end

function EquipRuneTemplate:BindUIEvent()
  self:GetControl():SetOnClick(self, self.OnClickFun)
  self.btn_del:SetOnClick(self, self.DelRuneOnClick)
  self.runes_Item:SetOnClick(self, self.Runes_ItemOnClick)
end

function EquipRuneTemplate:OnClickFun()
  MeRunneController:SetSelectRuneType(self.data.point)
end

function EquipRuneTemplate:DelRuneOnClick()
  if self.data.equipIndex and self.data.point then
    networkRequest.ReqTakeOffRune(self.data.equipIndex, self.data.point)
  end
end

function EquipRuneTemplate:Runes_ItemOnClick(control)
  if self.data and table.count(self.data) > 1 then
    local data = ItemUtility.GenerateItemDataByServerData(self.data)
    UIManager.Show(UIID.ItemTipUI, {
      item = data,
      rightOperate = EItemOperateType.Show,
      ctrl = control
    })
  end
end

function EquipRuneTemplate:Refresh(data, ui)
  self.data = data
  self.parent = ui
  self:RefreshRedPoint()
  if data == nil or table.count(data) <= 1 then
    if self.equipRuneCellData then
      ItemUtility.HideItemCell(self.runes_Item, self.equipRuneCellData)
    end
    self.btn_del:SetActive(false)
    self.img_choose:SetActive(false)
    return
  end
  self:RefreshModel()
  self:RefreshUIShow()
end

function EquipRuneTemplate:RefreshModel()
  local itemData = ItemUtility.GenerateItemData(self.data.cfgTab.id)
  if itemData then
    self.equipRuneCellData:RefreshData(itemData)
    ItemUtility.ShowItemCell(self.runes_Item, self.equipRuneCellData, self.parent, false)
  end
end

function EquipRuneTemplate:RefreshUIShow()
  local runeHoleType = MeRunneController:GetSelectRuneHoleType()
  local equipRuneData = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetItemRuneInfoDataByEquipIndex(self.data.equipIndex)
  if runeHoleType then
    self.img_choose:SetActive(self.data.point == runeHoleType)
  end
  self.btn_del:SetActive(equipRuneData ~= nil and equipRuneData[runeHoleType] ~= nil or false)
end

function EquipRuneTemplate:RefreshRedPoint()
  local equipIndex = MeRunneController:GetSelectEquipIndex()
  local state = MeRunneController:CheckEquipHoleCanSetRune(equipIndex, self.data.point)
  self.ima_redPoint:SetActive(state)
end

return EquipRuneTemplate
