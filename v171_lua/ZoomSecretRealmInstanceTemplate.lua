local ZoomSecretRealmInstanceTemplate = {}

function ZoomSecretRealmInstanceTemplate:Init(_rootUI)
  self.rootUI = _rootUI
  self:InitControl()
  self:InitUI()
end

function ZoomSecretRealmInstanceTemplate:InitControl()
  self.btn_3DItem = self:GetControl("Image/Scroll View/Viewport/Content/btn_3DItem")
end

local function OnEntranceTicketItemCreate(_control)
  _control.itemCtr = ItemUtility.InitItemCell(UIControl(_control.transform))
  _control.modelData = ItemCellData()
  _control.lab_Num = UIControl(_control.transform, "lab_num")
end

local function OnEntranceTicketItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    _control:SetActive(false)
    return
  end
  local itemId, bossId = _data[1], _data[2]
  _control:SetActive(true)
  local bagCount, itemData = BagInfoData.GetItemTotalCountByItemId(itemId), ItemUtility.GenerateItemData(itemId)
  _control.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(_control.itemCtr, _control.modelData, _ui.rootUI, true)
  local numDes, color = string.format("%s", bagCount), 0 < bagCount and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]
  _control.lab_Num:SetText(string.GetColorText(numDes, color))
  _control.data = _data
  _control:SetOnClick(_ui, _ui.EntranceTicketItemOnClick)
end

function ZoomSecretRealmInstanceTemplate:InitUI()
  self.entranceTicketContainer = UIContainer(self.btn_3DItem, self, OnEntranceTicketItemCreate, OnEntranceTicketItemRefresh)
end

function ZoomSecretRealmInstanceTemplate:EntranceTicketItemOnClick(_control)
  if _control == nil or _control.data == nil or _control.data[1] == nil or _control.data[2] == nil then
    return
  end
  local itemId, bossId = _control.data[1], _control.data[2]
  local isBuy, okOnClick
  if BagInfoData.GetItemTotalCountByItemId(itemId) == 0 then
    isBuy = true
    
    function okOnClick()
      NetManager.Send(ItemBuyMessage.ReqBuy, {goodId = itemId, buyCount = 1})
      UIManager.Hide(UIID.PromptTipUI)
    end
  else
    isBuy = false
    
    function okOnClick()
      networkRequest.ReqAscendSecretRealmMonster(itemId)
      UIManager.Hide(UIID.PromptTipUI)
    end
  end
  if isBuy == nil or okOnClick == nil then
    return
  end
  local promptId = ZoomSecretRealmManager:GetCanCallPropPromptId(itemId, isBuy)
  if string.isNullOrEmpty(promptId) then
    return
  end
  TipUtility.QuickShowPrompt({
    id = promptId,
    cancelAction = function()
      UIManager.Hide(UIID.PromptTipUI)
    end,
    okAction = okOnClick
  })
end

function ZoomSecretRealmInstanceTemplate:Refresh()
  self.entranceTicketContainer:SetActiveTable()
  local canCallBossPropDataTab = ZoomSecretRealmManager:GetCanCallBossPropDataTab()
  if table.count(canCallBossPropDataTab) == 0 then
    return
  end
  local bagHaveTab, notBagHaveTab = {}, {}
  for i, v in pairs(canCallBossPropDataTab) do
    if 0 < BagInfoData.GetItemTotalCountByItemId(v[1]) then
      table.insert(bagHaveTab, v)
    else
      table.insert(notBagHaveTab, v)
    end
  end
  table.sort(bagHaveTab, function(a, b)
    return a[1] > b[1]
  end)
  table.sort(notBagHaveTab, function(a, b)
    return a[1] > b[1]
  end)
  self.entranceTicketContainer:SetData(table.combine(bagHaveTab, notBagHaveTab))
end

return ZoomSecretRealmInstanceTemplate
