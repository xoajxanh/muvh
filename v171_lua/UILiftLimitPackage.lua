local UILiftLimitPackage = {}

function UILiftLimitPackage:Init()
  self:InitComponent()
end

function UILiftLimitPackage:InitComponent()
  self.singlePackage = self:GetControl("PrizeOne_Limit/price_one_limit/Viewport/PrizeOneContent/bg_buyPrize_limit")
end

function UILiftLimitPackage:InitListControl(ui)
  if self.packageListControl == nil then
    self.packageListControl = UIUtility.BindUIContainerTemp(self.singlePackage, LuaComponentTemplates.LiftLimitBuyTemps, ui)
  end
end

function UILiftLimitPackage:Refresh(ui)
  self:InitListControl(ui)
  local tabLimitBuyInfo = CommercializeData:GetTabLimitBuyInfo()
  self.packageListControl:SetData(tabLimitBuyInfo)
  local shopIndex
  if ui.args ~= nil and ui.args.shopID ~= nil then
    for index, data in ipairs(tabLimitBuyInfo) do
      if data.rechargeTbl.id == tonumber(ui.args.shopID) and data.isBuy == false then
        shopIndex = index
        break
      end
    end
  end
  if shopIndex ~= nil then
    local target_OnlyOne = self:GetScrollViewNormalizedPositionOnlyOne(ui.price_one_limit.scrollRect, shopIndex - 2, false, 0)
    ui.price_one_limit:SetNormalizedPosition(target_OnlyOne, 1)
  end
  ui.args = nil
end

function UILiftLimitPackage:GetScrollViewNormalizedPositionOnlyOne(scrollRect, currentChildIndex, inverse, pixelOffset)
  local childTrans = scrollRect.content:GetChild(0)
  local viewportRect = scrollRect.viewport.rect
  local contentRect = scrollRect.content.rect
  local childrenRect = childTrans.rect
  local diff = contentRect.width - viewportRect.width
  local elementLength = childrenRect.width + 5
  return Mathf.Clamp01((currentChildIndex * elementLength + pixelOffset) / diff)
end

return UILiftLimitPackage
