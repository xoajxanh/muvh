local GameBook_CombineWaySecondTemplates = {}

function GameBook_CombineWaySecondTemplates:Init()
  self:InitControls()
end

function GameBook_CombineWaySecondTemplates:InitControls()
  self.btn_3DItem = self:GetControl("btn_3DItem")
  self.btn_3DGridItem = self:GetControl("Viewport/content/btn_3DItem")
  self.content_Container = self:GetControl("Viewport/content_Container")
end

function GameBook_CombineWaySecondTemplates:Refresh(_templateData)
  self.templateData = _templateData
  local itemIdArray = string.split(self.templateData.itemIdStr, "#")
  local firstItemId = tonumber(itemIdArray[1])
  local itemData = ItemUtility.GenerateItemData(firstItemId)
  itemData.count = 1
  self.firstitemCellData = ItemCellData()
  self.firstitemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.firstitemCellData, self.templateData.ui, true)
  local count = table.count(itemIdArray) - 1
  self.content_Container:SetTopGridMaxCount(count)
  for i = 1, count do
    local go = self.content_Container:GetTopGridObjectList()[i - 1].transform
    local img_add = UIControl(go, "img_add")
    img_add:SetActive(i ~= count)
    local itemData = ItemUtility.GenerateItemData(tonumber(itemIdArray[i + 1]))
    itemData.count = 1
    local itemCellData = ItemCellData()
    itemCellData:RefreshData(itemData)
    ItemUtility.ShowItemCell(UIControl(go), itemCellData, self.templateData.ui, true)
  end
end

return GameBook_CombineWaySecondTemplates
