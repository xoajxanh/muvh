local Tips_GuardAttributesTemplate = {}

function Tips_GuardAttributesTemplate:Init()
  self.Model = self:GetControl("Model")
  self.lab_TipSuitAdditional = self:GetControl("lab_TipSuitAdditional")
  self.ModelData = ItemCellData()
end

function Tips_GuardAttributesTemplate:OnEnable()
  print("\230\152\190\231\164\186" .. self.go.name)
end

function Tips_GuardAttributesTemplate:OnDisable()
  print("\233\154\144\232\151\143" .. self.go.name)
end

function Tips_GuardAttributesTemplate:Refresh(params, ui)
  if params == nil then
    return
  end
  if params.IsStart == true and params.GuardInfoItem ~= nil and params.GuardInfoItem.nowtable ~= nil then
    local itemID = params.GuardInfoItem.nowtable.model
    if params.GuardInfoItem.guardStrengthen then
      itemID = params.GuardInfoItem.nowtable.strengthenModel
    end
    local itemData = ItemUtility.GenerateItemData(itemID)
    self.ModelData:RefreshData(itemData)
    ItemUtility.ShowItemCell(self.Model, self.ModelData, ui, false)
  end
  self.lab_TipSuitAdditional:SetText(params.des)
end

return Tips_GuardAttributesTemplate
