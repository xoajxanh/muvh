local Tip_BagItemTipTemplate = {}

function Tip_BagItemTipTemplate:Init()
  self.go_modelData = ItemCellData()
  self.nowControl = self:UIControl()
  self.img_select = self:GetControl("img_select")
  self.nowControl:SetOnClick(self, self.btn_3DItemOnClick)
end

function Tip_BagItemTipTemplate:OnEnable()
end

function Tip_BagItemTipTemplate:OnDisable()
end

function Tip_BagItemTipTemplate:Refresh(params, ui)
  if params == nil then
    return
  end
  self.InfoItem = params
  local itemid = params.itemId
  if params.guardStrengthen then
    itemid = params.nowtable.strengthenModel
  end
  local itemData = ItemUtility.GenerateItemData(itemid)
  self.go_modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self:UIControl(), self.go_modelData, ui)
  if self.go_modelData.model.modelObject == nil then
    return
  end
  ItemUtility.SetModelTransform(self.go_modelData.model.modelObject, self.go, itemData, 0.3, 1)
  self:SetNowSelect()
end

function Tip_BagItemTipTemplate:SetNowSelect()
  local isShowSelectEffect = false
  if self.InfoItem ~= nil then
    local nowSelectTable = BagInfoController:GetCurSelectWingInfo(self.InfoItem)
    if nowSelectTable ~= nil then
      isShowSelectEffect = nowSelectTable.id == self.InfoItem.id
    end
  end
  self.img_select:SetActive(isShowSelectEffect)
end

function Tip_BagItemTipTemplate:btn_3DItemOnClick()
  if self.InfoItem == nil then
    return
  end
  BagInfoController:SetCurSelectWingInfo(self.InfoItem)
  EventManager.Dispatch(Event.Tip_SelectChange)
end

return Tip_BagItemTipTemplate
