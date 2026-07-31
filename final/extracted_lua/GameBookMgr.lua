local GameBookMgr = {}

function GameBookMgr:Init()
  self:InitData()
  self:RegistEvents()
end

function GameBookMgr:InitData()
end

function GameBookMgr:RegistEvents()
end

function GameBookMgr:ParseRaidersDes(_des)
  local inputData = {
    itemDatas = {},
    iconDatas = {}
  }
  local placeholderDic = {}
  local index = 1
  for k, v in string.gmatch(_des, "(%w+)=(%w+_%w+_%w+)") do
    local key = k .. index
    local tab = {key = key, value = v}
    placeholderDic[index] = tab
    index = index + 1
  end
  local info = {}
  local indexItem = 1
  local indexIcon = 1
  local panelData = {
    allItems = {},
    inputData = {},
    info = {},
    desTextStr = ""
  }
  for k, v in pairs(placeholderDic) do
    local i, j = string.find(v.key, "%a+")
    local type = string.sub(v.key, i, j)
    if type == HyperlinkType.item then
      local keyItem = string.format("[item%d]", tostring(indexItem))
      local itemInfoArray = string.split(v.value, "_")
      local itemId = tonumber(itemInfoArray[1])
      local cfg_Item = ClientTable.cfg_Item_itemManager:TryGetValue(itemId)
      local data = {}
      data.cfg_Item = cfg_Item
      local qualityColor = ItemQuality2ColorDic[cfg_Item.colorShow]
      data.des = string.format("<color=%s><a href=%s>[%s]</a></color>", qualityColor, keyItem, cfg_Item.name)
      data.itemId = cfg_Item.id
      inputData.itemDatas[keyItem] = data
      table.insert(info, {key = type, value = itemId})
      table.insert(panelData.allItems, cfg_Item.id)
      indexItem = indexItem + 1
    elseif type == HyperlinkType.image then
      local keyIcon = string.format("[image%d]", tostring(indexIcon))
      local data = {}
      local qualityColor = ItemQuality2ColorDic[1]
      data.des = string.format("<color=%s><a href=%s>[%s]</a></color>", qualityColor, keyIcon, "Bi\225\187\131u T\198\176\225\187\163ng xx")
      data.imageName = v.value
      data.itemId = 1000010
      inputData.iconDatas[keyIcon] = data
      table.insert(info, {
        key = type,
        value = v.value
      })
      table.insert(panelData.allItems, 1000010)
      indexIcon = indexIcon + 1
    end
  end
  panelData.desTextStr = _des
  panelData.inputData = inputData
  panelData.info = info
  return panelData
end

function GameBookMgr:SetRedPointState(_state)
  self.redPointState = _state
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.gamebook
  })
end

function GameBookMgr:IsShowGameBookRedPoint()
  local isShow = (self.redPointState or 0) == 1
  return isShow
end

return GameBookMgr
