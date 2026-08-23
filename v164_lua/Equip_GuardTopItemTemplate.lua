local Equip_GuardTopItemTemplate = {}

function Equip_GuardTopItemTemplate:Init()
  self.go_modelData = ItemCellData()
  self.nowControl = self:UIControl()
  self.img_choose = self:GetControl("img_choose")
  self.img_redPoint = self:GetControl("img_redPoint")
  self.nowControl:SetOnClick(self, self.btn_3DItemOnClick)
end

function Equip_GuardTopItemTemplate:OnEnable()
end

function Equip_GuardTopItemTemplate:OnDisable()
end

function Equip_GuardTopItemTemplate:Refresh(params, ui)
  if params == nil then
    return
  end
  self.GuardInfoItem = params
  local itemid = params.nowtable.model
  if params.guardStrengthen then
    itemid = params.nowtable.strengthenModel
  end
  local itemData = ItemUtility.GenerateItemData(itemid)
  self.go_modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self:UIControl(), self.go_modelData, ui, false)
  self:SetNowSelect()
  self:RefreshRed()
end

function Equip_GuardTopItemTemplate:RefreshRed()
  local isShowRed = false
  if self.GuardInfoItem == nil or self.GuardInfoItem.nowtable == nil then
    isShowRed = false
  else
    isShowRed = gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():IsNeedUpLevel(self.GuardInfoItem.nowtable.petType)
  end
  self.img_redPoint:SetActive(isShowRed)
end

function Equip_GuardTopItemTemplate:SetNowSelect()
  local isShowSelectEffect = false
  if self.GuardInfoItem.nowtable ~= nil then
    local nowSelectTable = gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():GetNowSelectGuarItem()
    if nowSelectTable ~= nil and nowSelectTable.nowtable ~= nil then
      isShowSelectEffect = nowSelectTable.nowtable.petType == self.GuardInfoItem.nowtable.petType
    end
  end
  self.img_choose:SetActive(isShowSelectEffect)
end

function Equip_GuardTopItemTemplate:btn_3DItemOnClick()
  if self.GuardInfoItem == nil then
    return
  end
  if self.GuardInfoItem.nowtable ~= nil then
    gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():SelectGuarItem(self.GuardInfoItem.nowtable.petType)
  end
  EventManager.Dispatch(Event.Guard_SelectChange)
end

return Equip_GuardTopItemTemplate
