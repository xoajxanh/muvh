local UIItemTemplate = {}

function UIItemTemplate:Init(costomData)
  self.data = costomData
  self:InitParams()
end

function UIItemTemplate:InitParams()
  self.go_modelData = ItemCellData()
end

function UIItemTemplate:InitControls()
end

function UIItemTemplate:BindUIEvent()
end

function UIItemTemplate:Refresh(costomData, ui)
  self.customData = costomData
  local isShowTips = self.data and self.data.isShowTips or false
  local isServerItemData = self.data and self.data.isServerItemData or false
  if costomData and costomData.itemId then
    local itemData = isServerItemData and costomData or ItemUtility.GenerateItemData(costomData.itemId)
    itemData.count = costomData.count == nil or costomData.count == 0 and 1 or costomData.count
    if type(costomData.param) == "table" then
      itemData.id = type(costomData.param.lid) == "number" and costomData.param.lid or 0
      itemData.bagGridIndex = type(costomData.param.bagGridIndex) == "number" and costomData.param.bagGridIndex or 0
    end
    if self.go_modelData then
      self.go_modelData:RecycleRes()
    end
    self.go_modelData:RefreshData(itemData, costomData)
    ItemUtility.ShowItemCell(self:UIControl(), self.go_modelData, ui, isShowTips, self.data and self.data.isContrast or nil, self.data and self.data.stencil or nil, self.data and self.data.maskType or nil, nil, {
      go_effectModel = function(go)
        if itemData.tblItem.subType == 502 then
          go.transform.localScale = Vector3(0.5, 0.5, 0.5)
        end
      end
    })
  end
end

function UIItemTemplate:RefreshName(name)
  if type(name) ~= "string" then
    return
  end
  ItemUtility.ShowName(self:UIControl(), {
    customData = {name = name}
  })
end

function UIItemTemplate:SetSelect(select)
  if type(select) ~= "boolean" then
    return
  end
  ItemUtility.DoShowSelectImg(self:UIControl(), {selected = select})
end

return UIItemTemplate
