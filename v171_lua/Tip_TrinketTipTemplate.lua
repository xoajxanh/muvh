local Tip_TrinketTipTemplate = {}

function Tip_TrinketTipTemplate:Init(data)
  self.dataInfo = data.dataInfo
  self.plyerType = data.plyerType
  self.go_modelData = ItemCellData()
  self.nowControl = self:UIControl()
  self.go_model = self:GetControl("go_model")
  self.nowControl:SetOnClick(self, self.btn_3DItemOnClick)
end

function Tip_TrinketTipTemplate:OnEnable()
end

function Tip_TrinketTipTemplate:OnDisable()
end

function Tip_TrinketTipTemplate:Refresh(index, ui)
  if index == nil or self.dataInfo == nil then
    return
  end
  self:RecycleRes()
  local data = self.dataInfo:GetJewelryDataInfoDic(index)
  self.go_model:SetActive(data ~= nil)
  if data == nil then
    return
  else
    self.itemData = data:GetEquipData()
    self.go_modelData:RefreshData(self.itemData)
  end
  ItemUtility.ShowItemCell(self:UIControl(), self.go_modelData, ui, false)
end

function Tip_TrinketTipTemplate:RecycleRes()
  if self.go_modelData ~= nil then
    ItemUtility.ReleaseItemCell(self:UIControl(), self.go_modelData)
    self.itemData = nil
  end
end

function Tip_TrinketTipTemplate:btn_3DItemOnClick(control)
  if self.itemData == nil then
    return
  end
  local rightOperate = EItemOperateType.Show
  if self.plyerType == EUIPlyerType.MainPlayer then
    rightOperate = EItemOperateType.Disboard
  end
  local openSource = UIID.Tip_TrinketTipUI
  if EquipeInfoData.curView == UIID.Equip_IntensifyUI or EquipeInfoData.curView == UIID.Equip_ZhuijiaUI then
    openSource = UIID.Equip_IntensifyUI
  end
  UIManager.Show(UIID.ItemTipUI, {
    item = self.itemData,
    rightOperate = rightOperate,
    ctrl = control,
    openType = TipsOpenType.RoleEquipOpen,
    otherType = TipsOtherType.RoleEquipOpen_jewelry,
    OpenSourceUI = openSource
  })
end

return Tip_TrinketTipTemplate
